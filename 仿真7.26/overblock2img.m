function img=overblock2img(A,N,L)
% �����ص����ֺ��γɵ����� A �ع���ͼ�� img��
% �������С�� N*N�������֮�����(��)�ص���Ŀ�� N-L
% ��N=Lʱ���������֮�����ص���(��)

block_size=size(A,2);
% ͼ�����з����ϵķֿ���Ŀ(�����з���ķֿ���Ŀ��ͬ)
row_blocks=sqrt(block_size);
% ͼ������n(������m��ͬ)
n=N+L*(row_blocks-1);

img=zeros(n,n);
t=1;
%k=1;
flag=0;
i=1;

temp=zeros(N,N);
while i<=block_size
    
    
    if i==1
       temp=reshape(A(:,i),[N N]);
       temp=temp';
       img(1:N,1:N)=temp;
    else if i>1&&i<=row_blocks
            temp=reshape(A(:,i),[N N]);
            temp=temp';
            img(1:N,(N+1+(i-2)*L):(N+(i-1)*L))=temp(:,(N-L+1):N);
        else if i>row_blocks&&mod(i,row_blocks)==1
                %t=1;
                temp=reshape(A(:,i),[N N]);
                temp=temp';
                img((N+1+(t-1)*L):(N+t*L),1:N)=temp((N+1-L):N,:);
                %img((N+1+(i-2)*L):(N+(i-1)*L),1:N)=temp((N+1-L):N,:);
                t=t+1;
            else 
                for k=2:row_blocks
                temp=reshape(A(:,i),[N N]);
                temp=temp';
                img((N+1+(t-2)*L):(N+(t-1)*L),(N+1+(k-2)*L):(N+(k-1)*L))=temp((N+1-L):N,(N+1-L):N);
                %img((N+1+(k-1)*L):(N+k*L),(N+1+(k-1)*L):(N+k*L))=temp((N+1-L):N,(N+1-L):N);
                %img((N+1+(i-2)*L):(N+(i-1)*L),(N+1+(i-2)*L):(N+(i-1)*L))=temp((N+1-L):N,(N+1-L):N);
                %k=k+1;
                i=i+1;
                end
               flag=1;
                
            end
        end
    end
    
     if flag==1
        i=i;
        flag=0;
     else
         i=i+1;
     end

end

img=uint8(img);
       