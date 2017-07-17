%**************************************************************************
%                   图像分块、计算各块方差
%                                                           2017-07-12
%**************************************************************************
clc;clear
image = 1;              %  选择输入二维图像   
tic;
%************************************************************************
%****                    加载原始图像  
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
size_kuai=16*16;

 figure(1)
 imagesc(X);    % 绘制原图
 colormap(gray);

 
 disp('方差');
 VAR=var(X(:))          %整幅图像的方差
 
 %=====================图像分块、计算每一块的方差=======================
%        自适应采样率计算
% i= 0; 
% for i_x=1:ceil(a/size_kuai)
%     for i_y=1:ceil(b/size_kuai)
%         
%         XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);  
%          C(i_x,i_y) = var(XX(:));        %每一块的方差
%         i = i+1;         
%      end
% end


%========================把每一块按方差从小到大排列====================
A = im2col(X,[16,16],'distinct');%分成16*16的块,成256*1的列，共256个
% [m,n] = size(A);
B = var(A);         %每一块转成列向量后，算出各列方差矩阵B为1*256
[C,ind] = sort(B);  %把方差从小到大排列，C为排列之后的顺序，ind为排序后元素在原序列中的顺序
[m,n] = size(ind);
for i = 1:n
    D(:,i) = A(:,ind(i));       %方差从小到大排列好后，把原矩阵A按同样的顺序排列得到D
end

%===========================D中的列向量变为16*16的块
for i = 1:n
E(1:16,(i-1)*16+1:i*16) = col2im(D(:,i),[16 16],[16,16],'distinct');
end

h = ceil(16*n/4);        %分成4类

% [ Dictionary ] = DictionaryTrain(E(:,1:16),16,5);

M = 16;
N = 16;
Phi = randn(M,N);%测量矩阵为高斯矩阵

% Dictionary =  DictionaryTrain(E(:,1:16),16,10,5);
%==========================训练得到字典
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
        Final_theta(:,j:j+15) = hat_x;           %得出theta 
%         temp(1:16,j:j+15) = CS_OMP( y(1:16,j:j+15), F(1:16,j:j+15),50 ) ;
%         y(1:16,j:j+15) = Phi * Dictionary(1:16,j:j+15) * E(1:16,j:j+15).'*Dictionary(1:16,j:j+15)';
%         G(:,j) = im2col(y(1:16,j:j+15),[16,16],'distinct');
%         H = im2col(F(1:16,j:j+15),[16,16],'distinct');
%         temp(:,j) = CS_OMP( y(1:16,j:j+15), F(1:16,j:j+15),50 ) ;
     end
 end
 
 %========psi*theta得出重构的x
for i = 1 : 4
     for j = (i-1)*h+1 : 16 : i*h
          hat_x2(1:16,j:j+15) = Dictionary(1:16,j:j+15) * Final_theta(:,j:j+15);
     end
end

%=======对重构的x排序，成原顺序
hat_x3 = im2col(hat_x2,[16 16],'distinct');     %应该是能成为一个256*256的块
for i = 1 : 256
    H (:,ind(i)) = hat_x3(:,i);
end

K = col2im(H,[16 16],[256 256],'distinct');

figure(2)
 imagesc(K);    % 绘制重构图
 colormap(gray);
 
 psnr_XK = psnr(X,K) ;
clock = toc;
 
 
    
 
 
 




