path1 = getenv('PATH');             %获得系统路径的字符串
path1 = [path1 ';C:\Program Files (x86)\adb'];   %字符串中加入自己要的路径
setenv('PATH', path1);                %设置系统路径
clear;

for lp = 1 : 100
    filename = strcat(num2str(lp), '.png'); 
    system(['capture.bat', ' ', filename]);

    %filename = 'ori_2.png';
    ori=imread(filename);
    imwrite(ori, strcat('result\ori_', filename)) %original file
    ori = specialcase(ori);
    ori=rgb2gray(ori);
    %转化成灰度图 
    ori=im2double(ori);
    %函数im2double 
    %使用垂直Sobcl箅子．自动选择阈值 
    [VSFAT Threshold]=edge(ori, 'sobel','vertical');
    %边缘探测 
    f=edge(ori,'sobel',Threshold/6);
    %imwrite(f, strcat('result\ori2_', filename)) %original file
    f = f(400:1000, :);
    imwrite(f, strcat('result\edge_cut', filename)) %original file
    [a, b] = find( f == 1); %find the edge
    %f = f(max(min(a)-15, 1) :min(max(a)+5, size(f,1)), max(min(b)-15, 1): min(max(b)+5,size(f,2)));
    [M, N] = size(f);

    %使用多个模板进行匹配，直到有一个匹配成功
    res_i = 0;
    res_j = 0;
    finish = 0;
    for sample = 1:4
        if finish == 1
            break 
        end
        %template person
        t = imread(['samples\persons\', num2str(sample), '.bmp']);
        [a, b] = find( t == 0); %find the edge
        t = t(min(a):max(a), min(b):max(b));
        [m,n] = size(t);
        [row, col] = find(t==0);

        for i = 100:M-m
            if finish == 1
                break 
            end
            for j = 1:N-n
                if finish == 1
                    break 
                end
                total = length(row);
                cur = 0;
                for k = 1:total
                    if f(i+row(k), j+col(k)) == 1
                        cur = cur + 1;
                    end
                end
                ratio = cur * 1.0/total;
                if(ratio > 0.5)
                    fprintf('ratio=%.2f, i=%d, j=%d, filename=%s', cur * 1.0 / total, i, j, filename)
                    res_i = i;
                    res_j = j;
                    finish = 1;
                end
            end
        end
    end
    
    if finish == 0
        i = randi(3000000);
        fprintf('I can not find the little person, please refer the hardpics directory to check %d.png\n', i)
        figure(3), imshow(f), title('f.png')
        imwrite(f, strcat('hardpics\', filename));
        return
    end

    %remove the little person, in case it made some mistakes
    remove_f = f;
    remove_f(res_i:res_i+m, res_j:res_j+n) = 0;
    
    % get top i
    [x, y] = find(remove_f == 1);
    top_i = min(x); 
    top_j = round(mean(find(remove_f(top_i, :) == 1)));

    %from top_i to down, it is x axis. 
    wids = zeros(1,top_i+200);
    center = -1;
    for i = top_i : top_i + 200
        index = find(remove_f(i,:) == 1);
        width = max(index)-min(index);
        if isempty(width)
            width = wids(i-1);
        end
        wids(i) = width;
        if i-top_i > 0 && width < wids(i-1)
            last = i-1;
            start = 0;
            for j = i-1:-1:top_i
                if not(wids(j) == wids(i-1))
                    start = j+1;
                    break
                end
            end
            if last-start>8
                last = start + 4;
            end
            center = round((start+last)/2)-top_i;
            break;
        end
    end
    
    if center < 18
        center = 18;
    end
    if center > 50
        center = 50;
    end
       
    %calculate distance
    target_i = top_i + center;
    target_j = top_j; %最上方的那个点，向下平移50个像素，认为是center。


    source_i = res_i + m - 15;
    source_j = res_j+round(n/2); %脚跟距离脚的中心，需要向上提15个像素

    %在图中标记处center和脚中心，用一个半径为4的白色点，像素值位0
    f=circle(f, target_i, target_j, 5, 1);
    f=circle(f, source_i, source_j, 5, 1);
    %figure(2),imshow(f),title('res');
    imwrite(f, strcat('result\', filename))
    

    %计算距离
    dis = sqrt( (target_i-source_i)^2 + (target_j-source_j)^2 ) ;
    fprintf(' dis = %.2f\n', dis)

    %根据距离，以及拟合的直线，得到相应的毫秒数 y
    dict = [
        [163,350], [197.04, 420], [207, 430], [270, 550], [287, 570], [310, 640], [321, 670], [348.63, 730], [367.27, 769],[374, 780],[393.61, 800], [409.93, 841] 
    ];

    x = dict(1:2:end);
    y = dict(2:2:end);

    p = polyfit(x,y,1);
    y1=polyval(p,x);  %计算出拟合的y值
    %figure(3),plot(x,y,'k*',x,y1,'r-');  %画出数据对比图，黑点是原始数据，红线是拟合曲线
    y = polyval(p, dis);
    
    %向手机发送触摸屏幕指定时间y的命令，并停顿1s
    command = ['adb shell input swipe 100 500 100 500', ' ', num2str(round(y))];
    fprintf('%s\n', command);
    system(command);
    pause(1)
end