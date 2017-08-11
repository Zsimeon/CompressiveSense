%**************************************************************************
%                   ���ڻҶȹ��������ͼ��ѹ����֪
%                                                           2016-02-16
%**************************************************************************

clc;clear
image = 1;              %  ѡ�������άͼ��   

u = 0.6;                %  �Ҷȹ�����������Ӧ������ƥ������
Xi = 0.5;               %  ϡ���K

XiShu = 0.3;            %  ������M/N
Grr_SR = XiShu;
Grr_sr = 16*4;
Xii =1.5;
kuaikuai = 7;
%************************************************************************
%****                    ����ԭʼͼ��  
switch (image)
    case 1
       img = imread('lena.bmp');      % 1. -- Ů�� 
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
%****                 ͼ�������Ӷȷ��� 
 figure(1)
 imagesc(X);    % ����ԭͼ
 colormap(gray);
 set(gca,'position',[0,0,1,1]);
 disp('���ڻҶȹ����������');
 Texture1(X);
 disp('����');
 VAR=var(X(:))
 Ph = randn(size_kuai,size_kuai);
%**************************************************************************
%****                 ��ͳͼ��ֿ�ѹ����֪(BCS)
Psi=dctmtx(size_kuai);
Phi = [Ph(1:round(size_kuai*XiShu),:);Ph(1:size_kuai,:)]; %Ϊ�����ӶԱȶȣ��ӿ������ͬ�Ĳ�������
X2=zeros(size_kuai);  %  �ָ�����
ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        sparse=Psi*XX.'*Psi';  %  �ź�ϡ��
        A=Phi;
        ii = ii+1;
        for csi=1:size_kuai
            y=Phi*sparse(csi,:)';
            rec=CS_OMP(y,A,round(size_kuai*XiShu*Xi));  %  OMP�㷨ͼ���ع�
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
disp('BCS-SPL�㷨ȫ��PSNRֵ��')
psnr = 20*log10(255/sqrt(mean((X(:)-X3(:)).^2)))

ii = 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        ii=ii+1;
        XX1=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        XX2=X3((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
         psnr_chuantong(ii) = 20*log10(255/sqrt(mean((XX1(:)-XX2(:)).^2)));
          if(ii==kuaikuai)
           disp('BCS-SPL�㷨�ֲ�PSNRֵ��')
           psnr_chuantong(ii) 
          end          
    end
end


%**************************************************************************
%****                 ���ڻҶȹ��������ͼ��ѹ����֪(BCS)
%       ����Ӧ�����ʼ���
i= 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        tex = Texture1(XX);
        i = i+1;
        TEXT(i) = tex;
    end
end
TEXT_MEAN = mean(TEXT)    % ������ӿ��صľ�ֵ
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
        sparse=Psi*XX.'*Psi';                 % �ź�ϡ��  
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

K1=wiener2(X3,[3 3]); %�Լ���ͼ����ж�ά����Ӧά���˲�
K5= medfilt2(X3);%���ö�ά��ֵ�˲�����medfilt2���ܽ����������ŵ�ͼ���˲�
disp('���ķ���ȫ��PSNRֵ��')
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
           disp('���ķ����ֲ�PSNRֵ��')
           psnr_gongshen1(1,ii)      
             figure(5);
            imagesc(uint8(XX2)); 
            colormap(gray);
            set(gca,'position',[0,0,1,1]);
       
        end 
    end
end


% % %**************************************************************************
% % %****                 ���ڻҶ��ص�ͼ��ѹ����֪(BCS)
i= 0;
for i_x=1:ceil(a/size_kuai)
    for i_y=1:ceil(b/size_kuai)
        XX=X((i_x-1)*size_kuai+1:i_x*size_kuai,(i_y-1)*size_kuai+1:i_y*size_kuai);
        i = i+1;
        Grr(i) = GrayEntropy(XX);%�Ҷ���   
    end
end
Grr_MEAN = mean(Grr)    % ������ӿ��صľ�ֵ

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
        sparse=Psi*XX.'*Psi';                 % �ź�ϡ��  
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



disp('�Ҷ����㷨ȫ��PSNRֵ��')
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
           disp('�Ҷ����㷨�ֲ�PSNRֵ��')
           psnr_huidushang1(ii)     
             figure(7);
            imagesc(uint8(XX2)); 
            colormap(gray);
            set(gca,'position',[0,0,1,1]);
        end 
    end
end


