function bits_per_symbol = GetBitsPerSymbol(message)
bits_per_symbol = ceil(log2(length(message)));
end