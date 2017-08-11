clc;clear;close all;
image = 3;              %  选择输入二维图像   
tic;

%重叠分块，8*8的块，每两块重叠两个像素，分4类
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
figure(1)
imagesc(X);    % 绘制原图
colormap(gray);

%对X分成8*8的块，每个块之间偏移6个点，即重叠两个点
A=img2overblock(X,8,6);
B = var(A);         %每一块转成列向量后，算出各列方差矩阵B为1*7225
[C,ind] = sort(B);  %把方差从小到大排列，C为排列之后的顺序，ind为排序后元素在原序列中的顺序
[m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %方差从小到大排列好后，把原矩阵A按同样的顺序排列得到D
end

%测量矩阵Phi为高斯矩阵
M = 64;
N = 64;
Phi = randn(M,N);

Sort_4 = ceil(n/4);

%======================字典1==============================
Dictionary1 = DictionaryTrain(D(:,1:Sort_4),16,10);
Psi1 = Dictionary1;
A_PP1 = Phi * Psi1;
y1 = Phi * D(:,1:Sort_4);
 for csi=1:Sort_4
            G1 = y1(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta1(:,csi)=CS_OMP(G1,A_PP1,16);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x1 = Dictionary1 * Final_theta1;

%======================字典2==============================
Dictionary2 = DictionaryTrain(D(:,Sort_4+1:2*Sort_4),32,10);
Psi2 = Dictionary2;
A_PP2 = Phi * Psi2;
y2 = Phi * D(:,Sort_4+1:2*Sort_4);
 for csi=1:Sort_4
            G2 = y2(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta2(:,csi)=CS_OMP(G2,A_PP2,32);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x2 = Dictionary2 * Final_theta2;

%======================字典3==============================
Dictionary3 = DictionaryTrain(D(:,2*Sort_4+1:3*Sort_4),48,10);
Psi3 = Dictionary3;
A_PP3 = Phi * Psi3;
y3 = Phi * D(:,2*Sort_4+1:3*Sort_4);
 for csi=1:Sort_4
            G3 = y3(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta3(:,csi)=CS_OMP(G3,A_PP3,48);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x3 = Dictionary3 * Final_theta3;

%======================字典4==============================
Dictionary4 = DictionaryTrain(D(:,3*Sort_4+1:4*Sort_4-3),64,10);
Psi4 = Dictionary4;
A_PP4 = Phi * Psi4;
y4 = Phi * D(:,3*Sort_4+1:4*Sort_4-3);
 for csi=1:Sort_4-3
            G4 = y4(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta4(:,csi)=CS_OMP(G4,A_PP4,64);
 end
%         Final_theta(:,1:64) = hat_x;           %得出theta 
Final_x4 = Dictionary4 * Final_theta4;
Final_X = [Final_x1,Final_x2,Final_x3,Final_x4];

for i = 1 : n
    H (:,ind(i)) = Final_X(:,i);
end

K=overblock2img(H,8,6);

figure(2)
imagesc(K);    % 绘制重构图
colormap(gray);
 
ps = psnr(X,K);
time = toc;