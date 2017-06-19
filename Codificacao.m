    clc % Limpa os comandos
    clear all % Limpa a memoria

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio); % Abre o arquivo a ser cifrado e atribui a IDarquivo
    Conteudoarquivo = uint8(fread(IDarquivo, [1, inf], 'ubit1')); % Le o conteudo, bit a bit, do arquivo selecionado
    Tam = length(Conteudoarquivo); % Le o tamanho do arquivo e salva na variavel Tam
    
    Checksum = zeros(1,4);
    VetorTemporario = cell(0);
    Carry = 0;
    Var_soma = 0;
    
    for i = 1:8:Tam
        if (i == 1)
            VetorTemporario = Conteudoarquivo(i:i+7);
        else
            VetorTemporario = cat(2,VetorTemporario,Conteudoarquivo(i:i+7));
        end
        
        Checksum(4) = xor(Conteudoarquivo(i+3), Conteudoarquivo(i+7));
        Opand = and(Conteudoarquivo(i+3), Conteudoarquivo(i+7));
        if (Opand == 1)
            Carry = 1;
        else
            Carry = 0;
        end
        
        Checksum(3) = xor(Conteudoarquivo(i+2), Conteudoarquivo(i+6));
        Checksum(3) = xor(Checksum(3), Carry);
        Var_soma = (Conteudoarquivo(i+2) + Conteudoarquivo(i+6) + Carry);
        if (Var_soma >= 2)
            Carry = 1;
            Var_soma = 0;
        else 
            Carry = 0;
            Var_soma = 0;
        end
        
        Checksum(2) = xor(Conteudoarquivo(i+1), Conteudoarquivo(i+5));
        Checksum(2) = xor(Checksum(2), Carry);
        Var_soma = (Conteudoarquivo(i+1) + Conteudoarquivo(i+5) + Carry);
        if (Var_soma >= 2)
            Carry = 1;
            Var_soma = 0;
        else 
            Carry = 0;
            Var_soma = 0;
        end

        Checksum(1) = xor(Conteudoarquivo(i), Conteudoarquivo(i+4));
        Checksum(1) = xor(Checksum(1), Carry);
        Var_soma = (Conteudoarquivo(i) + Conteudoarquivo(i+4) + Carry);
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

        Conteudoarquivo = not(VetorTemporario);
    
    % Salvar conteudo no arquivo 'BitsComChecksum':
	Filecodif = fopen('BitsComChecksum.bin', 'wb');
	fwrite(Filecodif, Conteudoarquivo, 'ubit1');
    fclose(Filecodif);
