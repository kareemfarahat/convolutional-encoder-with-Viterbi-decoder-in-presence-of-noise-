function dictionary = GetHufmanCodes(chars ,probabilitys )
probability = probabilitys; % get a copy of the probabilitys to work with to keep the original one unchanged
    for i = 1:length( probability )   
        codewords{i} = '' ; % empty codeword.
        character{i} = i;   % Indexing the codeword.
    end
    while ( probability ~= 1 )
        [~, arranged] = sort(probability); % sort the probabilities.
        last = arranged(1); % indexing the lowest two sets to be merged.
        next = arranged(2);
        
        
        right = character{last};
        left  = character{next};
        
        
        right_probability = probability(last); % Get their probabilities.
        left_probability  = probability(next); 
        
        merged_set = [right, left];  % merging them in a new set.
        
        new_prob   = right_probability + left_probability; % Update probability
        
        character(arranged(1:2)) = '';  % Update symbol sets
        probability(arranged(1:2))   = '';
        character = [character merged_set];
        probability   = [probability new_prob];     
        % Get the updated codeword.
        codewords = UpdateCodeWord(codewords,right,'1');
        codewords = UpdateCodeWord(codewords,left,'0');
    end
    dictionary.symbol = chars ; dictionary.code = codewords;
    
end
function codewords = UpdateCodeWord(codewords,character,input_code)
    for i = 1:length(character)
        codewords{character(i)} = strcat(input_code,codewords{character(i)});      
    end
end