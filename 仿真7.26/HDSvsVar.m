clc;clear;close all;
image = 2;              %  ѡ�������άͼ��   
tic;

%���ص��ֿ飬256ͼ�񣬷ֳ�8*8���Ҷ��ط���
%**************************����ԭʼͼ��**********************  
switch (image)
    case 1
       img = imread('lena.bmp');      % 1. -- Ů�� 
    case 2
       img = imread('boat256.bmp');     % 2. -- boat256
    case 3
       img = imread('boat512.bmp');       % 3. -- boat512
    case 4
       img = imread('CS-002.bmp');       % 4. -- ��ͼ
        otherwise
       img = imread('lena.bmp');  
end  

X=img;
X=double(X);
[a,b]=size(X);
size_kuai=8*8;    %��ĳߴ�

 figure(1)
 imagesc(X);    % ����ԭͼ
 colormap(gray);
 
 A = im2col(X,[8,8],'distinct');%�ֳ�16*16�Ŀ�,��256*1���У���1024��
 %B = var(A);        
[a,b] = size(A);
 for i = 1:b
 B(i) = GrayEntropy(A(:,i));%�Ҷ���   
 end
 [C,ind] = sort(B);
 
  D = var(A);         %ÿһ��ת����������������з������BΪ1*256
[E,ind1] = sort(D);  %�ѷ����С�������У�CΪ����֮���˳��indΪ�����Ԫ����ԭ�����е�˳��
[m,n] = size(ind1);
