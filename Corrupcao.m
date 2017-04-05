	clc
    clear all

    [FileName, PatchName] = uigetfile('*', 'Selecione o arquivo');
    diretorio = strcat(PatchName, FileName);

    IDarquivo = fopen(diretorio);
    BitsComChecksum = uint8(fread(IDarquivo, [1, inf], 'ubit1'));
    Tam = length(BitsComChecksum);
    
    BitsComChecksum

    for i = 1:32:Tam
    	BitAcomrromper = round(31*rand(1,1)+1) 

		if BitsComChecksum(BitAcomrromper) == 0
			BitsComChecksum(BitAcomrromper) = 1;
		else
			BitsComChecksum(BitAcomrromper) = 0;
		end
	end

	Filecodif = fopen('BitsCorrompidosComChecksum.bin', 'wb')
	fwrite(Filecodif, BitsComChecksum, 'ubit1')

