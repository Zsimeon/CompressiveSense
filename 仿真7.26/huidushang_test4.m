clc;clear;close all;
image = 3;              %  选择输入二维图像   
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
 
 [m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %方差从小到大排列好后，把原矩阵A按同样的顺序排列得到D
end

%测量矩阵Phi为高斯矩阵
M = 64;
N = 64;
Phi = randn(M,N);

Sort_3 = ceil(n/3);

% % for i = 1 : 4
% %      L = i * 16;
% %      Dictionary(:,(i-1)*L+1:i*L) =  DictionaryTrain(D(:,(i-1)*Sort_4+1:i*Sort_4),L,10);
% % end
% % 
%  Dictionary1 = DictionaryTrain(D(:,1:Sort_3),16,10);
%  Dictionary2 = DictionaryTrain(D(:,Sort_3+1:2*Sort_3),32,10);
%  Dictionary3 = DictionaryTrain(D(:,2*Sort_3+1:3*Sort_3),48,10);
%  Dictionary4 = DictionaryTrain(D(:,3*Sort_3+1:4*Sort_3),64,10);
%  Dictionary5 = DictionaryTrain(D(:,4*Sort_3+1:end),80,10);

% %修改，针对每一个块进行重构

%======================字典1==============================
Dictionary1 = DictionaryTrain(D(:,1:Sort_3),16,5);
Psi1 = Dictionary1;
A_PP1 = Phi * Psi1;
y1 = Phi * D(:,1:Sort_3);
 for csi=1:Sort_3
            G1 = y1(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta1(:,csi)=CS_OMP(G1,A_PP1,5);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x1 = Dictionary1 * Final_theta1;


% % %======================字典2==============================
Dictionary2 = DictionaryTrain(D(:,Sort_3+1:2*Sort_3),32,5);
Psi2 = Dictionary2;
A_PP2 = Phi * Psi2;
y2 = Phi * D(:,Sort_3+1:2*Sort_3);
 for csi=1:Sort_3
            G2 = y2(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta2(:,csi)=CS_OMP(G2,A_PP2,5);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x2 = Dictionary2 * Final_theta2;
% 
% %======================字典3==============================
 Dictionary3 = DictionaryTrain(D(:,2*Sort_3+1:end),48,5);
Psi3 = Dictionary3;
A_PP3 = Phi * Psi3;
y3 = Phi * D(:,2*Sort_3+1:end);
 for csi=1:Sort_3-2
            G3 = y3(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta3(:,csi)=CS_OMP(G3,A_PP3,5);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x3 = Dictionary3 * Final_theta3;




Final_X = [Final_x1,Final_x2,Final_x3];
%=======对重构的x排序，成原顺序

for i = 1 : n
    H (:,ind(i)) = Final_X(:,i);
end

K = col2im(H,[8 8],[512 512],'distinct');

figure(2)
 imagesc(K);    % 绘制重构图
 colormap(gray);
 
 ps = psnr(X,K);
 time = toc;