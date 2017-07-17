%**************************************************************************
%                   ͼ��ֿ顢������鷽��
%                                                           2017-07-12
%**************************************************************************
clc;clear
image = 1;              %  ѡ�������άͼ��   
tic;
%************************************************************************
%****                    ����ԭʼͼ��  
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
size_kuai=16*16;

 figure(1)
 imagesc(X);    % ����ԭͼ
 colormap(gray);

 
 disp('����');
 VAR=var(X(:))          %����ͼ��ķ���
 
 %=====================ͼ��ֿ顢����ÿһ��ķ���=======================
%        ����Ӧ�����ʼ���
% i= 0; 
% for i_x=1:ceil(a/size_kuai)
%     for i_y=1:ceil(b/size_kuai)
%         
%         XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);  
%          C(i_x,i_y) = var(XX(:));        %ÿһ��ķ���
%         i = i+1;         
%      end
% end


%========================��ÿһ�鰴�����С��������====================
A = im2col(X,[16,16],'distinct');%�ֳ�16*16�Ŀ�,��256*1���У���256��
% [m,n] = size(A);
B = var(A);         %ÿһ��ת����������������з������BΪ1*256
[C,ind] = sort(B);  %�ѷ����С�������У�CΪ����֮���˳��indΪ�����Ԫ����ԭ�����е�˳��
[m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %�����С�������кú󣬰�ԭ����A��ͬ����˳�����еõ�D
end

%===========================D�е���������Ϊ16*16�Ŀ�
for i = 1:n
E(1:16,(i-1)*16+1:i*16) = col2im(D(:,i),[16 16],[16,16],'distinct');
end

h = ceil(16*n/4);        %�ֳ�4��

% [ Dictionary ] = DictionaryTrain(E(:,1:16),16,5);

M = 16;
N = 16;
Phi = randn(M,N);%��������Ϊ��˹����

% Dictionary =  DictionaryTrain(E(:,1:16),16,10,5);
%==========================ѵ���õ��ֵ�
 for i = 1 : 4
     L = i * 256;
     for j = (i-1)*h+1 : 16 : i*h
        Dictionary(1:16,j:j+15) =  DictionaryTrain(E(:,j:j+15),16,10,L);
             
        F(1:16,j:j+15) = Phi * Dictionary(1:16,j:j+15);
        y(1:16,j:j+15) = Phi * E(1:16,j:j+15);
        
        Psi = Dictionary(1:16,j:j+15);
        A = Phi * Psi;
%         sparse=Psi*E(:,j:j+15).'*Psi';
        %sparse=Psi*E(:,j:j+15);
        for csi=1:16
            G = y(1:16,csi+j-1);
             %G=Phi*sparse(csi,:)';
             hat_x(:,csi)=CS_OMP(G,A,16);
        end
        Final_theta(:,j:j+15) = hat_x;           %�ó�theta 
%         temp(1:16,j:j+15) = CS_OMP( y(1:16,j:j+15), F(1:16,j:j+15),50 ) ;
%         y(1:16,j:j+15) = Phi * Dictionary(1:16,j:j+15) * E(1:16,j:j+15).'*Dictionary(1:16,j:j+15)';
%         G(:,j) = im2col(y(1:16,j:j+15),[16,16],'distinct');
%         H = im2col(F(1:16,j:j+15),[16,16],'distinct');
%         temp(:,j) = CS_OMP( y(1:16,j:j+15), F(1:16,j:j+15),50 ) ;
     end
 end
 
 %========psi*theta�ó��ع���x
for i = 1 : 4
     for j = (i-1)*h+1 : 16 : i*h
          hat_x2(1:16,j:j+15) = Dictionary(1:16,j:j+15) * Final_theta(:,j:j+15);
     end
end

%=======���ع���x���򣬳�ԭ˳��
hat_x3 = im2col(hat_x2,[16 16],'distinct');     %Ӧ�����ܳ�Ϊһ��256*256�Ŀ�
for i = 1 : 256
    H (:,ind(i)) = hat_x3(:,i);
end

K = col2im(H,[16 16],[256 256],'distinct');

figure(2)
 imagesc(K);    % �����ع�ͼ
 colormap(gray);
 
 psnr_XK = psnr(X,K) ;
clock = toc;
 
 
    
 
 
 




