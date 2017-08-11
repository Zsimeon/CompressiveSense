%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   DictionaryTrain            
%   author:ben zhang 
%   data:2014.11.18
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Dictionary ] = DictionaryTrain(Image,K,numIteration)
% ���� K-SVD �㷨�ֿ�ѵ���ֵ�

block_size = 16;
% ��ͼ����зֿ�
%blkMatrix = im2col(Image,[block_size,block_size],'distinct');
%��ʼ��K-SVD�㷨�Ĳ���
param.numIteration = numIteration ;
param.K =K; %�ֵ�Ԫ�صĸ���
param.L=64;
param.errorFlag = 0;
%param.errorGoal = sigma*C;
param.preserveDCAtom = 0;
param.displayProgress = 1;    
param.InitializationMethod ='DataElements';
[Dictionary,output] = KSVD(Image,param);
end