for i = 1: 6
    filename = strcat(num2str(i), '.png');
    f=imread(filename);
    f=rgb2gray(f);
    %ת���ɻҶ�ͼ 
    f=im2double(f);
    %����im2double 
    %ʹ�ô�ֱSobcl���ӣ��Զ�ѡ����ֵ 
    [VSFAT Threshold]=edge(f, 'sobel','vertical');
    %��Ե̽�� 
    %figure,imshow(f),title('origin');
    %��ʾԭʼͼ�� 
    %figure,imshow(VSFAT),title( 'vertical');
    %��ʾ��Ե̽��ͼ�� 
    %ʹ��ˮƽ�ʹ�ֱSobel���ӣ��Զ�ѡ����ֵ 

    r=edge(f,'sobel',Threshold/2);
    r = r(400:1000, :);
    figure,imshow(r),title(filename);
    imwrite(r, strcat('samples\', filename))
end
% %��ʾ��Ե̽��ͼ�� 
% %ʹ��ָ��45�Ƚ�Sobel�����˲�����ָ����ֵ 
% s45=[-2 -1 0;
%     -1 0 1;
%     0 1 2];
% 
% SFST45=imfilter(f,s45,'replicate');
% %���ܣ�����������������άͼ������˲��� 
% 
% SFST45=SFST45>=Threshold;
% figure,imshow(SFST45),title('45') ;
%��ʾ��Ե̽��ͼ��