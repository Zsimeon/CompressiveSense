clc;clear;close all;
image = 2;              %  ѡ�������άͼ��   
tic;

%256��ͼ��6�࣬���ص�,8*8
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
 
 A = im2col(X,[8,8],'distinct');%�ֳ�16*16�Ŀ�,��256*1���У���256��
 B = var(A);         %ÿһ��ת����������������з������BΪ1*256
[C,ind] = sort(B);  %�ѷ����С�������У�CΪ����֮���˳��indΪ�����Ԫ����ԭ�����е�˳��
[m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %�����С�������кú󣬰�ԭ����A��ͬ����˳�����еõ�D
end

%��������PhiΪ��˹����
M = 64;
N = 64;
Phi = randn(M,N);

Sort_6 = ceil(n/6);

% for i = 1 : 4
%      L = i * 16;
%      Dictionary(:,(i-1)*L+1:i*L) =  DictionaryTrain(D(:,(i-1)*Sort_4+1:i*Sort_4),L,10);
% end

%  Dictionary1 = DictionaryTrain(D(:,1:Sort_4),16,10);
%  Dictionary2 = DictionaryTrain(D(:,Sort_4+1:2*Sort_4),32,10);
%  Dictionary3 = DictionaryTrain(D(:,2*Sort_4+1:3*Sort_4),48,10);
%  Dictionary4 = DictionaryTrain(D(:,3*Sort_4+1:4*Sort_4),64,10);

%�޸ģ����ÿһ��������ع�

%======================�ֵ�1==============================
Dictionary1 = DictionaryTrain(D(:,1:Sort_6),16,5);
Psi1 = Dictionary1;
A_PP1 = Phi * Psi1;
y1 = Phi * D(:,1:Sort_6);
 for csi=1:Sort_6
            G1 = y1(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta1(:,csi)=CS_OMP(G1,A_PP1,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x1 = Dictionary1 * Final_theta1;


%======================�ֵ�2==============================
Dictionary2 = DictionaryTrain(D(:,Sort_6+1:2*Sort_6),32,5);
Psi2 = Dictionary2;
A_PP2 = Phi * Psi2;
y2 = Phi * D(:,Sort_6+1:2*Sort_6);
 for csi=1:Sort_6
            G2 = y2(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta2(:,csi)=CS_OMP(G2,A_PP2,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x2 = Dictionary2 * Final_theta2;

%======================�ֵ�3==============================
Dictionary3 = DictionaryTrain(D(:,2*Sort_6+1:3*Sort_6),48,5);
Psi3 = Dictionary3;
A_PP3 = Phi * Psi3;
y3 = Phi * D(:,2*Sort_6+1:3*Sort_6);
 for csi=1:Sort_6
            G3 = y3(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta3(:,csi)=CS_OMP(G3,A_PP3,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x3 = Dictionary3 * Final_theta3;

%======================�ֵ�4==============================
Dictionary4 = DictionaryTrain(D(:,3*Sort_6+1:4*Sort_6),64,5);
Psi4 = Dictionary4;
A_PP4 = Phi * Psi4;
y4 = Phi * D(:,3*Sort_6+1:4*Sort_6);
 for csi=1:Sort_6       %�˴�Ҫ��
            G4 = y4(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta4(:,csi)=CS_OMP(G4,A_PP4,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x4 = Dictionary4 * Final_theta4;

%======================�ֵ�5==============================
Dictionary5 = DictionaryTrain(D(:,4*Sort_6+1:5*Sort_6),80,5);
Psi5 = Dictionary5;
A_PP5 = Phi * Psi5;
y5 = Phi * D(:,4*Sort_6+1:5*Sort_6);
 for csi=1:Sort_6       %�˴�Ҫ��
            G5 = y5(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta5(:,csi)=CS_OMP(G5,A_PP5,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x5 = Dictionary5 * Final_theta5;


%======================�ֵ�6==============================
Dictionary6 = DictionaryTrain(D(:,5*Sort_6+1:end),96,5);
Psi6 = Dictionary6;
A_PP6 = Phi * Psi6;
y6 = Phi * D(:,4*Sort_6+1:5*Sort_6);
 for csi=1:Sort_6-2       %�˴�Ҫ��
            G6 = y6(:,csi);
             %G=Phi*sparse(csi,:)';
             Final_theta6(:,csi)=CS_OMP(G6,A_PP6,5);
 end
%         Final_theta(:,1:64) = hat_x;           %�ó�theta 
Final_x6 = Dictionary6 * Final_theta6;

Final_X = [Final_x1,Final_x2,Final_x3,Final_x4,Final_x5,Final_x6];

%=======���ع���x���򣬳�ԭ˳��

for i = 1 : n
    H (:,ind(i)) = Final_X(:,i);
end

K = col2im(H,[8 8],[256 256],'distinct');

figure(2)
 imagesc(K);    % �����ع�ͼ
 colormap(gray);
 
 ps = psnr(X,K);
 time = toc;