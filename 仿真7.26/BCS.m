%  ������ʵ��ͼ��LENA��ѹ������
%  �������ߣ�ɳ������۴�ѧ�������ӹ���ѧϵ��wsha@eee.hku.hk
%  �㷨��������ƥ�䷨���ο����� Joel A. Tropp and Anna C. Gilbert 
%  Signal Recovery From Random Measurements Via Orthogonal Matching
%  Pursuit��IEEE TRANSACTIONS ON INFORMATION THEORY, VOL. 53, NO. 12,
%  DECEMBER 2007.
%  �ó���û�о����κ��Ż�

%function Wavelet_OMP

clc
clear
%  ���ļ�
X=imread('CS-008.bmp');
%X=imread('lena.bmp');
X=double(X);
[a,b]=size(X);
size_kuai=16*4;
X2=zeros(size_kuai);  %  �ָ�����
X3=zeros(a,b);  %  �ָ�����
%  С���任��������
ww=DWT(size_kuai);
%  �����������
M=12*4;
R=randn(M,size_kuai);

tic
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        %  С���任��ͼ��ϡ�軯��ע��ò����ķ�ʱ�䣬���ǻ�����ϡ��ȣ�
        X1=ww*sparse(XX)*ww';
        X1=full(X1);
        %  ����
        Y=R*X1;
        %  OMP�㷨
        for i=1:size_kuai  %  ��ѭ��       
            rec=omp_fenkuai(Y(:,i),R,size_kuai);
            X2(:,i)=rec;
        end
        X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai)=ww'*sparse(X2)*ww;  %  С�����任
    end
end
X3=full(X3);
use_time=toc

%  ԭʼͼ��
figure(1);
%imshow(uint8(X));
 imagesc(uint8(X)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);
%title('ԭʼͼ��');
%  ѹ�����лָ���ͼ��
figure(2);
%imshow(uint8(X3));
 imagesc(uint8(X3)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);
%title('�ֿ�ָ���ͼ��');

%  ���(PSNR)
errorx=sum(sum(abs(X3-X).^2));        %  MSE���
psnr=10*log10(255*255/(errorx/a/b))  %  PSNR