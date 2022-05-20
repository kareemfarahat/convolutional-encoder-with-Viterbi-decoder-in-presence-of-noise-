function sample = Get_sample(code,K)
sample=zeros(1,length(code)*K);
j=1;
for i=1 : 3: 3*length(code)
    sample(i)=code(j);
    j=j+1;
end