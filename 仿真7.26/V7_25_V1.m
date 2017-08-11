clc;clear;close all;
image = 3;              %  ѡ�������άͼ��   
tic;

%�ص��ֿ飬8*8�Ŀ飬ÿ�����ص��������أ���4��
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
figure(1)
imagesc(X);    % ����ԭͼ
colormap(gray);

%��X�ֳ�8*8�Ŀ飬ÿ����֮��ƫ��6���㣬���ص�������
A=img2overblock(X,8,6);
B = var(A);         %ÿһ��ת����������������з������BΪ1*7225
[C,ind] = sort(B);  %�ѷ����С�������У�CΪ����֮���˳��indΪ�����Ԫ����ԭ�����е�˳��
[m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %�����С�������кú󣬰�ԭ����A��ͬ����˳�����еõ�D
end

%��������PhiΪ��˹����
M = 64;
N = 64;
Phi = randn(M,N);

Sort_4 = ceil(n/4);

%======================�ֵ�1==============================
Dictionary1 = DictionaryTrain(D(:,1:Sort_4),16,10);
Psi1 = Dictionary1;
A_PP1 = Phi * Psi1;
y1 = Phi * D(:,1:Sort_4);
 for csi=1:Sort_4
            G1 = y1(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta1(:,csi)=CS_OMP(G1,A_PP1,16);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x1 = Dictionary1 * Final_theta1;

%======================�ֵ�2==============================
Dictionary2 = DictionaryTrain(D(:,Sort_4+1:2*Sort_4),32,10);
Psi2 = Dictionary2;
A_PP2 = Phi * Psi2;
y2 = Phi * D(:,Sort_4+1:2*Sort_4);
 for csi=1:Sort_4
            G2 = y2(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta2(:,csi)=CS_OMP(G2,A_PP2,32);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x2 = Dictionary2 * Final_theta2;

%======================�ֵ�3==============================
Dictionary3 = DictionaryTrain(D(:,2*Sort_4+1:3*Sort_4),48,10);
Psi3 = Dictionary3;
A_PP3 = Phi * Psi3;
y3 = Phi * D(:,2*Sort_4+1:3*Sort_4);
 for csi=1:Sort_4
            G3 = y3(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta3(:,csi)=CS_OMP(G3,A_PP3,48);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x3 = Dictionary3 * Final_theta3;

%======================�ֵ�4==============================
Dictionary4 = DictionaryTrain(D(:,3*Sort_4+1:4*Sort_4-3),64,10);
Psi4 = Dictionary4;
A_PP4 = Phi * Psi4;
y4 = Phi * D(:,3*Sort_4+1:4*Sort_4-3);
 for csi=1:Sort_4-3
            G4 = y4(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta4(:,csi)=CS_OMP(G4,A_PP4,64);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x4 = Dictionary4 * Final_theta4;
Final_X = [Final_x1,Final_x2,Final_x3,Final_x4];

for i = 1 : n
    H (:,ind(i)) = Final_X(:,i);
end

K=overblock2img(H,8,6);

figure(2)
imagesc(K);    % �����ع�ͼ
colormap(gray);
 
ps = psnr(X,K);
time = toc;