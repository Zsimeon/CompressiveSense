%**************************************************************************
%                   基于灰度共生矩阵的图像压缩感知
%                                                           2016-02-16
%**************************************************************************

clc;clear
image = 1;              %  选择输入二维图像   

u = 0.6;                %  灰度共生矩阵自适应采样率匹配设置
Xi = 0.5;               %  稀疏度K

XiShu = 0.3;            %  采样率M/N
Grr_SR = XiShu;
Grr_sr = 16*4;
Xii =1.5;
kuaikuai = 7;
%************************************************************************
%****                    加载原始图像  
switch (image)
    case 1
       img = imread('lena.bmp');      % 1. -- 女人 
    case 2
       img = imread('house.bmp');     % 2. -- house
    case 3
       img = imread('CT1.bmp');       % 3. -- CT1
    case 4
       img = imread('CT2.bmp');       % 4. -- CT2
        otherwise
       img = imread('lena.bmp');  
end  
X=img;
X=double(X);
[a,b]=size(X);
size_kuai=16*4;
%**************************************************************************
%****                 图像纹理复杂度分析 
 figure(1)
 imagesc(X);    % 绘制原图
 colormap(gray);
 set(gca,'position',[0,0,1,1]);
 disp('基于灰度共生矩阵的熵');
 Texture1(X);
 disp('方差');
 VAR=var(X(:))
 Ph = randn(size_kuai,size_kuai);
%**************************************************************************
%****                 传统图像分块压缩感知(BCS)
Psi=dctmtx(size_kuai);
Phi = [Ph(1:round(size_kuai*XiShu),:);Ph(1:size_kuai,:)]; %为了增加对比度，子块采用相同的采样矩阵
X2=zeros(size_kuai);  %  恢复矩阵
ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        sparse=Psi*XX.'*Psi';  %  信号稀疏
        A=Phi;
        ii = ii+1;
        for csi=1:size_kuai
            y=Phi*sparse(csi,:)';
            rec=CS_OMP(y,A,round(size_kuai*XiShu*Xi));  %  OMP算法图像重构
            X2(csi,:)=rec;
        end
        if(ii==kuaikuai)
             figure(3);
            imagesc(uint8(Psi'*X2.'*Psi)); 
            colormap(gray);
            set(gca,'position',[0,0,1,1]);
        end
        X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai)=Psi'*X2.'*Psi;  
    end
end

figure(2);
imagesc(uint8(X3)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);
disp('BCS-SPL算法全局PSNR值：')
psnr = 20*log10(255/sqrt(mean((X(:)-X3(:)).^2)))

ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
         psnr_chuantong(ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
          if(ii==kuaikuai)
           disp('BCS-SPL算法局部PSNR值：')
           psnr_chuantong(ii) 
          end          
    end
end


%**************************************************************************
%****                 基于灰度共生矩阵的图像压缩感知(BCS)
%       自适应采样率计算
i= 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        tex = Texture1(XX);
        i = i+1;
        TEXT(i) = tex;
    end
end
TEXT_MEAN = mean(TEXT)    % 求各个子块熵的均值
SR = 256*XiShu;
sr = 16*4*XiShu;
 
ku=1;
u=0.1;
for i=1:length(TEXT)
 r(i) = ceil(u*sr+(1-u)*SR*4*(TEXT(i)/sum(TEXT)));
end



j=0;
Psi=dctmtx(size_kuai);
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        j=j+1;
        Phi = [Ph(1:r(j),:);Ph(1:size_kuai,:)];
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        sparse=Psi*XX.'*Psi';                 % 信号稀疏  
        A=Phi;
        for csi=1:size_kuai
            y=Phi*sparse(csi,:)';
            rec=CS_OMP(y,A,round(r(j)*Xi));
           % rec=CS_OMP(y,A,ceil(r(j)*Xi));
           % rec=CS_SAMP(y,A,1);
            X2(csi,:)=rec;
        end
        X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai)=Psi'*X2.'*Psi;; 
    end
end

ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        psnr_gongshen(ku,ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
    end
end

K1=wiener2(X3,[3 3]); %对加噪图像进行二维自适应维纳滤波
K5= medfilt2(X3);%采用二维中值滤波函数medfilt2对受椒盐噪声干扰的图像滤波
disp('本文方案全局PSNR值：')
psnr = 20*log10(255/sqrt(mean((X(:)-K1(:)).^2)))

figure(4);
imagesc(uint8(K1)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);

ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=K1((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
         psnr_gongshen1(ku,ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
         
 if(ii==kuaikuai)
           disp('本文方案局部PSNR值：')
           psnr_gongshen1(1,ii)      
             figure(5);
            imagesc(uint8(XX2)); 
            colormap(gray);
            set(gca,'position',[0,0,1,1]);
       
        end 
    end
end


% % %**************************************************************************
% % %****                 基于灰度熵的图像压缩感知(BCS)
i= 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        i = i+1;
        Grr(i) = GrayEntropy(XX);%灰度熵   
    end
end
Grr_MEAN = mean(Grr)    % 求各个子块熵的均值

for i=1:length(Grr)
 % r(i) = ceil(u*sr+(1-u)*SR*4*(TEXT(i)/sum(TEXT)));
   Grr_r(i) = ceil(Grr_sr*Grr_SR*(Grr_MEAN+(Grr(i)-Grr_MEAN)/((Grr_MEAN/(min(Grr)+0.1)*(2-Grr_SR)/4)))/Grr_MEAN);
  % Grr_r(i) = ceil(u*sr+(1-u)*SR*4*(Grr(i)/sum(Grr)));
end

for i=1:length(Grr)
    
if (Grr_r(i) >= 64)
     Grr_r(i) = 64;
 end
end

%end

j=0;
Psi=dctmtx(size_kuai);
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        j=j+1;
        Phi = [Ph(1:Grr_r(j),:);Ph(1:size_kuai,:)];
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        sparse=Psi*XX.'*Psi';                 % 信号稀疏  
        A=Phi;
        for csi=1:size_kuai
            y=Phi*sparse(csi,:)';
            rec=CS_OMP(y,A,round(Grr_r(j)*Xi));  
          %  rec=CS_SAMP(y,A,1);
            X2(csi,:)=rec;
        end
      %  psnr_huidushang(j) = 20*log10(255/sqrt(mean((XX(:)-X2(:)).^2)));
        X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai)=Psi'*X2.'*Psi;; 
    end
end

ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
         psnr_huidushang(ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
    end
end



disp('灰度熵算法全局PSNR值：')
psnr = 20*log10(255/sqrt(mean((X(:)-X3(:)).^2)))


figure(6);
 
imagesc(uint8(X3)); 
colormap(gray);
set(gca,'position',[0,0,1,1]);


ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
       % XX2=K1((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
         psnr_huidushang1(ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
          if(ii==kuaikuai)
           disp('灰度熵算法局部PSNR值：')
           psnr_huidushang1(ii)     
             figure(7);
            imagesc(uint8(XX2)); 
            colormap(gray);
            set(gca,'position',[0,0,1,1]);
        end 
    end
end


