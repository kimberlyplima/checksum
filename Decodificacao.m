	clc
    clear all

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio);
    BitsCorrompidosComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    Tam = length(BitsCorrompidosComChecksum);

    Checksum = zeros(1,4);
    VetorTemporario = cell(0);
    Carry = 0;
    Var_soma = 0;

    for p = 7:-1:0
        x = (Tam - p)/12;
        
        if (round(x) == x)
            Contador = 8*x;
            Padding = p;
            BitsCorrompidosComChecksum = not(BitsCorrompidosComChecksum(1:Tam-p));
            break
        end
    end

    BitsCorrompidosComChecksum
    
    for i = 1:12:Contador

        if (i == 1)
            VetorTemporario = BitsCorrompidosComChecksum(i:i+7);
        else
            VetorTemporario = cat(2,VetorTemporario,BitsCorrompidosComChecksum(i:i+7));
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
        
        while (Carry == 1)
            if (Checksum(4) == 0)
                Checksum(4) = 1;
                Carry = 0;
            else
                Checksum(4) = 0;
                Carry = 1;
                
                if (Checksum(3) == 0)
                    Checksum(3) = 1;
                    Carry = 0;
                else
                    Checksum(3) = 0;
                    Carry = 1;
                    
                    if (Checksum(2) == 0)
                        Checksum(2) = 1;
                        Carry = 0;
                    else
                        Checksum(2) = 0;
                        Carry = 1;
                        
                        if (Checksum(1) == 0)
                            Checksum(1) = 1;
                            Carry = 0;
                        else
                            Checksum(1) = 0;
                            Carry = 1;
                        end
                    end
                end
            end
        end

        VetorTemporario = cat(2, VetorTemporario, Checksum);
    end
    
if (Padding ~= 0)
    if (Padding > 1)
        Padding = zeros(1,Padding);
        VetorTemporario = cat(2,VetorTemporario,Padding);
    else
        VetorTemporario = cat(2,VetorTemporario,Padding);
    end
end

VetorTemporario

BitsCorrompidos = numel(find(xor(BitsCorrompidosComChecksum, VetorTemporario) == 1));
BitsCorrompidos
        