function average_codeword = GetAvreageCodeWord(probability, dictionary)
average_codeword = 0;
for n = 1 : length(probability)
    average_codeword = average_codeword + (probability(n) * strlength(dictionary.code(n)));
end

end