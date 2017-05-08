    clc % Limpa os comandos
    clear all % Limpa a memoria

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio); % Abre o arquivo a ser cifrado e atribui a IDarquivo
    BitsCorrompidosComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1')); % Le o conteudo, bit a bit, do arquivo selecionado
    Tam = length(BitsCorrompidosComChecksum); % Le o tamanho do arquivo e salva na variavel Tam
    
    Checksum = zeros(1,4);
    VetorTemporario = BitsCorrompidosComChecksum;
    Carry = 0;
    Var_soma = 0;
    
    for i = 1:8:Tam

        if (i > 1)
            for j = i:i+7
                VetorTemporario(j+4) = BitsCorrompidosComChecksum(j);
            end            
        end
        
        Checksum(4) = xor(BitsCorrompidosComChecksum(i+3), BitsCorrompidosComChecksum(i+7));
        Opand = and(BitsCorrompidosComChecksum(i+3), BitsCorrompidosComChecksum(i+7));
        if (Opand == 1)
            Carry = 1;
        else
            Carry = 0;
        end
        
        Checksum(3) = xor(BitsCorrompidosComChecksum(i+2), BitsCorrompidosComChecksum(i+6));
        Checksum(3) = xor(Checksum(3), Carry);
        Var_soma = (BitsCorrompidosComChecksum(i+2) + BitsCorrompidosComChecksum(i+6) + Carry);
        if (Var_soma >= 2)
            Carry = 1;
            Var_soma = 0;
        else 
            Carry = 0;
            Var_soma = 0;
        end
        
        Checksum(2) = xor(BitsCorrompidosComChecksum(i+1), BitsCorrompidosComChecksum(i+5));
        Checksum(2) = xor(Checksum(2), Carry);
        Var_soma = (BitsCorrompidosComChecksum(i+1) + BitsCorrompidosComChecksum(i+5) + Carry);
        if (Var_soma >= 2)
            Carry = 1;
            Var_soma = 0;
        else 
            Carry = 0;
            Var_soma = 0;
        end

        Checksum(1) = xor(BitsCorrompidosComChecksum(i), BitsCorrompidosComChecksum(i+4));
        Checksum(1) = xor(Checksum(1), Carry);
        Var_soma = (BitsCorrompidosComChecksum(i) + BitsCorrompidosComChecksum(i+4) + Carry);
        if (Var_soma >= 2)
            Carry = 1;
            Var_soma = 0;
        else 
            Carry = 0;
            Var_soma = 0;
        end
        
        if (Carry == 1)
            if (Checksum(4) == 0)
                Checksum(4) = 1;
            else
                Checksum(4) = 0;
            end
        end

        if (i > 1)
            i = i + 4;
        end
        
        VetorTemporario(i+8) = Checksum(1);
        VetorTemporario(i+9) = Checksum(2);
        VetorTemporario(i+10) = Checksum(3);
        VetorTemporario(i+11) = Checksum(4);
    end
        
    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio); 
    BitsComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    
    Validacao = logical(sum(BitsCorrompidosComChecksum, BitsComChecksum));