%clear all; close all;

function [timeLR,Coeff,lo_bnd,up_bnd] = my_covar2(T,A,B,alf)

%T = [10:.1:20];
%A = sin(T);%+randn(size(t));
%x2 = sin(t+pi/2);
%B = -sawtooth(T-pi/2,.6);%+randn(size(t));

C1 = NaN(size(A));
lb1 = NaN(size(A));
ub1 = NaN(size(A));
for i = 1:length(A)-1
    [bb a b c] = corrcoef([A(1:end-i+1);B(i:end)]','alpha',alf);
    C1(i) = bb(1,2);
    lb1(i) = b(1,2);
    ub1(i) = c(1,2);
    clear bb a b c
end
C2 = NaN(1,length(A)-1);
lb2 = NaN(1,length(A)-1);
ub2 = NaN(1,length(A)-1);
for i = 1:length(A)-2
    [bb a b c] = corrcoef([B(1:end-(i+1)+1);A((i+1):end)]','alpha',alf);
    C2(i) = bb(1,2);
    lb2(i) = b(1,2);
    ub2(i) = c(1,2);
end

    Coeff = [fliplr(C2),C1];
    up_bnd = [fliplr(ub2),ub1];
    lo_bnd = [fliplr(lb2),lb1];
    
tt = T-T(1);
timeLR = [-fliplr(tt(2:end)),tt];    
    
    



