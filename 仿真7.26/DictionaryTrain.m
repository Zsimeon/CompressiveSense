%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   DictionaryTrain            
%   author:ben zhang 
%   data:2014.11.18
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Dictionary ] = DictionaryTrain(Image,K,numIteration)
% 利用 K-SVD 算法分块训练字典

block_size = 16;
% 将图像进行分块
%blkMatrix = im2col(Image,[block_size,block_size],'distinct');
%初始化K-SVD算法的参数
param.numIteration = numIteration ;
param.K =K; %字典元素的个数
param.L=64;
param.errorFlag = 0;
%param.errorGoal = sigma*C;
param.preserveDCAtom = 0;
param.displayProgress = 1;    
param.InitializationMethod ='DataElements';
[Dictionary,output] = KSVD(Image,param);
end