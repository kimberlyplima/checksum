	clc
    clear all

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio);
    BitsCorrompidosComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    TamComChecksum = length(BitsCorrompidosComChecksum);
    Tam = BitsCorrompidosComChecksum(TamComChecksum);


    Checksum = zeros(1,4);
    Carry = 0;
    Var_soma = 0;
    PosicaoAtual = 0;
    VetorChecksum = [];

    for i = 1:8:Tam
        
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

        VetorChecksum(i) = Checksum(1);
        VetorChecksum(i+1) = Checksum(2);
        VetorChecksum(i+2) = Checksum(3);
        VetorChecksum(i+3) = Checksum(4);
    end
    
        BitsCorrompidosComChecksum
        
        