for i = 1: 6
    filename = strcat(num2str(i), '.png');
    f=imread(filename);
    f=rgb2gray(f);
    %转化成灰度图 
    f=im2double(f);
    %函数im2double 
    %使用垂直Sobcl箅子．自动选择阈值 
    [VSFAT Threshold]=edge(f, 'sobel','vertical');
    %边缘探测 
    %figure,imshow(f),title('origin');
    %显示原始图像 
    %figure,imshow(VSFAT),title( 'vertical');
    %显示边缘探测图像 
    %使用水平和垂直Sobel算子，自动选择阈值 

    r=edge(f,'sobel',Threshold/2);
    r = r(400:1000, :);
    figure,imshow(r),title(filename);
    imwrite(r, strcat('samples\', filename))
end
% %显示边缘探测图像 
% %使用指定45度角Sobel算子滤波器，指定阂值 
% s45=[-2 -1 0;
%     -1 0 1;
%     0 1 2];
% 
% SFST45=imfilter(f,s45,'replicate');
% %功能：对任意类型数组或多维图像进行滤波。 
% 
% SFST45=SFST45>=Threshold;
% figure,imshow(SFST45),title('45') ;
%显示边缘探测图像