function  A=img2overblock(img,N,L)
% 对图像 img 进行重叠块划分，块与块之间的重叠列(行)数为N-L，基本块大小为 N*N
% 这里仅限 N 为偶数，L为小于N的偶数(2的幂次)，图像行（列）数为2的幂次
% 矩阵A是将图像块按行优先顺序列向量化后的向量组
% 当N=L时表明块与块之间无重叠列(行)

[m n]=size(img);
% 每个分块内的像素总数
block_pixelnum=N^2
% 图像在行方向上的分块数目(与在列方向的分块数目相同)

row_blocks=1+(n-N)/L;

% if ((n-N)/L)>uint8((n-N)/L)
%       row_blocks=2+uint8((n-N)/L);
% else  row_blocks=1+(n-N)/L;
% end
      
% 总分块数目
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

