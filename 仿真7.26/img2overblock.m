function  A=img2overblock(img,N,L)
% ��ͼ�� img �����ص��黮�֣������֮����ص���(��)��ΪN-L���������СΪ N*N
% ������� N Ϊż����LΪС��N��ż��(2���ݴ�)��ͼ���У��У���Ϊ2���ݴ�
% ����A�ǽ�ͼ��鰴������˳�������������������
% ��N=Lʱ���������֮�����ص���(��)

[m n]=size(img);
% ÿ���ֿ��ڵ���������
block_pixelnum=N^2
% ͼ�����з����ϵķֿ���Ŀ(�����з���ķֿ���Ŀ��ͬ)

row_blocks=1+(n-N)/L;

% if ((n-N)/L)>uint8((n-N)/L)
%       row_blocks=2+uint8((n-N)/L);
% else  row_blocks=1+(n-N)/L;
% end
      
% �ֿܷ���Ŀ
block_size=row_blocks*row_blocks

A=zeros(block_pixelnum,block_size);

k=1;
for i=1:row_blocks
    temp=zeros(N,N);
    for j=1:row_blocks
        temp=img((1+L*(i-1)):(N-L+L*i),(1+L*(j-1)):(N-L+L*j));
        A(:,k)=reshape(temp',[block_pixelnum,1]);
        k=k+1;
    end
end

