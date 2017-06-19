	clc
    clear all

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio);
    BitsComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    Tam = length(BitsComChecksum);

    for p = 7:-1:0
        x = (Tam - p)/12;
        
        if (round(x) == x)
            Contador = 8*x;
            break
        end
    end

    BitsCorrompidos = 0;
    
    for i = 1:32:Contador
    	BitACorromper = randi(i+31);
        
        while (BitACorromper > Contador)
            BitACorromper = randi(i+31);
        end

		if (rand(1) <= 0.5)
            BitsCorrompidos = BitsCorrompidos+1;
			BitsComChecksum(BitACorromper) = not(BitsComChecksum(BitACorromper));
		end
    end
    
    BitsCorrompidos

	Filecodif = fopen('BitsCorrompidosComChecksum.bin', 'wb');
	fwrite(Filecodif, BitsComChecksum, 'ubit1');
	fclose(Filecodif);

