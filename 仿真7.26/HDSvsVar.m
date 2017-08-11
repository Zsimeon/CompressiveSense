clc;clear;close all;
image = 2;              %  选择输入二维图像   
tic;

%非重叠分块，256图像，分成8*8，灰度熵分类
%**************************加载原始图像**********************  
switch (image)
    case 1
       img = imread('lena.bmp');      % 1. -- 女人 
    case 2
       img = imread('boat256.bmp');     % 2. -- boat256
    case 3
       img = imread('boat512.bmp');       % 3. -- boat512
    case 4
       img = imread('CS-002.bmp');       % 4. -- 地图
        otherwise
       img = imread('lena.bmp');  
end  

X=img;
X=double(X);
[a,b]=size(X);
size_kuai=8*8;    %块的尺寸

 figure(1)
 imagesc(X);    % 绘制原图
 colormap(gray);
 
 A = im2col(X,[8,8],'distinct');%分成16*16的块,成256*1的列，共1024个
 %B = var(A);        
[a,b] = size(A);
 for i = 1:b
 B(i) = GrayEntropy(A(:,i));%灰度熵   
 end
 [C,ind] = sort(B);
 
  D = var(A);         %每一块转成列向量后，算出各列方差矩阵B为1*256
[E,ind1] = sort(D);  %把方差从小到大排列，C为排列之后的顺序，ind为排序后元素在原序列中的顺序
[m,n] = size(ind1);
