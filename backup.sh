#  @file backup.sh
#	 @brief REALIZA BACKUPS AGENDADOS
#  @date 17/03/2016
#  @version 1.0
#  @author LETICIA BRUNA
#


# REALIZA COPIA DE ARQUIVOS 
blnVerificaHD = lshusb -v # verifica se ha hd Ext
FILE_LOG = /logs/error.log # ARQUIVO FILE LOG 
DIRETORIO_BACKUP = /backup/compartilhamentos # DIRETORIO DE BACKUP 
datSistema = $(date "+%a , dia %d de %b de %Y")  # DATA DO SISTEMA 
if [blnVerificaHD]; # COND VERIFICA SE HA HD EXT 
	then
		MensagemArquivo = "SUCESSO " #MENSAGEM DE SUCESSO
		nomArquivo = "Backup_" # PREFIXO NOME ARQUIVO
		extArquivo = ".tar.bz2"
		datCompacta = $(date "%d%b%Y")  # DATA DO SISTEMA 
		Arquivo = $nomArquivo$datCompacta$extArquivo
		tar -zcf $Arquivo /compartilhamentos # COMPACTA DIRETORIO COMPARTILHAMENTO
		mv 	-u /compartilhamentos/$Arquivo $DIRETORIO_BACKUP# MOVE PARA PASTA DE BACKUP
	else 
		MensagemArquivo = "Erro No Dispositivo de Armazenamento "  #MENSAGEM DE ERRO 
		
		
fi	

if [ -e FILE_LOG] # VERIFICA SE HA ARQUIVO DE LOG DE ERRO 
	then
		
		Mensagem = $MensagemArquivo$datSistema
		echo "HD Não Encontrado" >> FILE_LOG #ESCREVE NO ARQUIVO
	else
		Mensagem = $MensagemArquivo$datSistema
		touch /logs/error.log # CRIA ARQUIVO
		echo "HD Não Encontrado" >> FILE_LOG #ESCREVE NO ARQUIVO
fi	

for arq in `ls $DIRETORIO_BACKUP` # FOR NO DIRETORIO DE BACKUP 
	do
		datArquivo = debugfs -R ‘stat <2920513>’ $DIRETORIO_BACKUP/$arq # PEGA DATA DO ARQUIVO
		datArquivo =  $(datArquivo "+%a , dia %d de %b de %Y") # FORMATA DATA ARQUIVO
		subDate = datArquivo --datSistema='1 day' #SUBTRAIR DATAS
		if [ subDate > 30]
			then
				rm -rvf $DIRETORIO_BACKUP/$arq # APAGA ARQUIVO MAIOR DE 30 DIAS
		fi 
	done
	