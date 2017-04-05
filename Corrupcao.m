	clc
    clear all

    diretorio = strcat('/Users/macbookpro/Documents/MATLAB/BitsComChecksum.bin');

    IDarquivo = fopen(diretorio);
    BitsComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    Tam = length(BitsComChecksum);
    
    