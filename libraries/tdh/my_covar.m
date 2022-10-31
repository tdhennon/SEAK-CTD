function [coeff,timeLR] = my_covar(A,B,time)


varA = var(A)*(length(A)-1);
varB = var(B)*(length(B)-1);

for i = 1:length(A)
    varsum(i) = sum(A(1:end-i+1).*B(i:end));
end
for i = 1:length(A)-1
    varsum2(i) = sum(B(1:end-(i+1)+1).*A((i+1):end));
end
coeff1 = varsum/sqrt((varA*varB));
coeff2 = varsum2/sqrt((varA*varB));
    coeff = [fliplr(coeff2),coeff1];

tt = time-time(1);
timeLR = [-fliplr(tt(2:end)),tt];


