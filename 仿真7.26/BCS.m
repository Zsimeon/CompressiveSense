%  本程序实现图像LENA的压缩传感
%  程序作者：沙威，香港大学电气电子工程学系，wsha@eee.hku.hk
%  算法采用正交匹配法，参考文献 Joel A. Tropp and Anna C. Gilbert 
%  Signal Recovery From Random Measurements Via Orthogonal Matching
%  Pursuit，IEEE TRANSACTIONS ON INFORMATION THEORY, VOL. 53, NO. 12,
%  DECEMBER 2007.
%  该程序没有经过任何优化

%function Wavelet_OMP

clc
clear
%  读文件
X=imread('CS-008.bmp');
%X=imread('lena.bmp');
X=double(X);
[a,b]=size(X);
size_kuai=16*4;
X2=zeros(size_kuai);  %  恢复矩阵
X3=zeros(a,b);  %  恢复矩阵
%  小波变换矩阵生成
ww=DWT(size_kuai);
%  随机矩阵生成
M=12*4;
R=randn(M,size_kuai);

tic
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        %  小波变换让图像稀疏化（注意该步骤会耗费时间，但是会增大稀疏度）
        X1=ww*sparse(XX)*ww';
        X1=full(X1);
        %  测量
        Y=R*X1;
        %  OMP算法
        for i=1:size_kuai  %  列循环       
            rec=omp_fenkuai(Y(:,i),R,size_kuai);
            X2(:,i)=rec;
        end
        X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai)=ww'*sparse(X2)*ww;  %  小波反变换
    end
end
X3=full(X3);
use_time=toc

%  原始图像
figure(1);
%imshow(uint8(X));
 imagesc(uint8(X)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);
%title('原始图像');
%  压缩传感恢复的图像
figure(2);
%imshow(uint8(X3));
 imagesc(uint8(X3)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);
%title('分块恢复的图像');

%  误差(PSNR)
errorx=sum(sum(abs(X3-X).^2));        %  MSE误差
psnr=10*log10(255*255/(errorx/a/b))  %  PSNR