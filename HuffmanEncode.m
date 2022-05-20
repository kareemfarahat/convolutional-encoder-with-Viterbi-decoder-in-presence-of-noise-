function encoded_message = HuffmanEncode(message, dictionary)
chars =  num2cell(char(message)); %split the message into an array of charachters
dictionary_length = length(dictionary.code);
encoded_message = '';
while( ~isempty(chars) ) % Loop for each character.
    transition_code = '';
     for j = 1 : dictionary_length
         if( strcmp(chars(1),dictionary.symbol(j)))
                 transition_code = dictionary.code{j};
                 break;
                 
         end
     end
     encoded_message = strcat( encoded_message,transition_code );
     chars = chars(2: end );
end
end