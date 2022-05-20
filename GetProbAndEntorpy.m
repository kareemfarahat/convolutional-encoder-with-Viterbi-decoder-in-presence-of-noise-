function [entropy, probability, chars] = GetProbAndEntorpy(message)
s_length= strlength(message); % Get the total length of the string 
chars = unique(message);   % get all the charrachters without reptetions
lenChar=length(chars);    % number of uniqe symbols
c_frequency = zeros(1,lenChar);     % intalize a vector with zeroes to fill it with the frequency of each char
for i=1:lenChar
    c_frequency(i)=length(strfind(message,chars(i)));  % Count the occurence of unique characters 
end
probability=zeros(1,lenChar); % intalize a vector with zeroes to fill it with the prob of each char
for i=1:lenChar
    probability(i)=c_frequency(i)/s_length;       %  Probabilities for each unique character 
end
entropy=0;
for  i=1:lenChar
    entropy = entropy + (-probability(i)*log2(probability(i)));  % Calculating the Entropy
end 
end