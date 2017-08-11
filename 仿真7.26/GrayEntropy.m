%**************************************************************************
%                图像检索——纹理特征
%T        : 返回图像灰度熵
%**************************************************************************
function G = GrayEntropy(Image)
  Gray = Image;
  [M,N,O] = size(Gray);
P=zeros(1,256); 
Pj=zeros(1,256); 
for i=0:255
    for j=1:M
        for k=1:N
            if(Image(j,k)==i)
                P(i+1)=P(i+1)+1;
            end
        end
    end
end
SUM = sum(P);
h=zeros(1,256);
for i=1:256
    Pj(i)=P(i)/SUM;
    if(Pj(i)~=0)
    %  h=Pj(i)*log2(Pj(i));  % 此处好像写错
      h(i)=Pj(i)*log2(Pj(i));
    end    
end
G = -sum(h);


