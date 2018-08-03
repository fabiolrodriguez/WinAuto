$relatorio = $null
$tabela = $null
$data = Get-Date -format "dd/MM/yyyy"   # Data no formato DIA/MÃŠS/ANO
$arquivo = "AD_USER_DATA.html"          # Arquivo gerado em HTML
$total = (Get-ADUser -filter *).count   # Total de UsuÃ¡rios no Active Directory
$dominio = (Get-ADDomain).Forest        # Nome do DomÃ­nio
$analista = "Rohan Scanavez"            # Nome do Analista
$empresa = " "                          # Nome da Empresa

Import-Module ActiveDirectory

#--LISTA DE USUÃRIOS------------------------------------------------#
$tabela += "<center><h3><b>TOTAL DE USU&Aacute;RIOS - <font color=red>$total</font></b></h3></center>"

$usuarios = @(Get-ADUser -filter * -Properties Company, SamAccountName, Name, Mail, Department, Title, PasswordNeverExpires, Enabled, Created)

# Lista todas as Propriedades do UsuÃ¡rio
#PS C:\AD> Get-ADUser rohan.scanavez -Properties *

$resultado = @($usuarios | Select-Object Company, SamAccountName, Name, Mail, Department, Title, PasswordNeverExpires, Enabled, Created)

# Ordenar pela Empresa (Company) A-Z
$resultado = $resultado | Sort "Company" 

# Comente esta linha para nÃ£o exibir o resultado durante a execuÃ§Ã£o do script.
$resultado | ft -auto 

$tabela += $resultado | ConvertTo-Html -Fragment
 
$formatacao=
		"
		<html>
		<body>
		<style>
		BODY{font-family: Calibri; font-size: 12pt;}
		TABLE{border: 1px solid black; border-collapse: collapse; font-size: 12pt; text-align:center;margin-left:auto;margin-right:auto; width='1000px';}
		TH{border: 1px solid black; background: #F9F9F9; padding: 5px;}
		TD{border: 1px solid black; padding: 5px;}
		H3{font-family: Calibri; font-size: 12pt;}
		</style> 
		"
$titulo=
		"
		<table width='100%' border='0' cellpadding='0' cellspacing='0'>
		<tr>
		<td bgcolor='#F9F9F9'>
		<font face='Calibri' size='10px'>Active Directory - Lista de Usu&aacute;rios</font>
		<H3 align='center'>Empresa: $empresa - Dom&iacute;nio: $dominio - Relat&oacute;rio: $data - Respons&aacute;vel: $analista</H3>
		</td>
		</tr>
		</table>
		</body>
		</html>
		"

$mensagem = "</table><style>"
$mensagem = $mensagem + "BODY{font-family: Calibri;font-size:20;font-color: #000000}"
$mensagem = $mensagem + "TABLE{margin-left:auto;margin-right:auto;width: 800px;border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$mensagem = $mensagem + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: #F9F9F9;text-align:center;}"
$mensagem = $mensagem + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;text-align:center;}"
$mensagem = $mensagem + "</style>"
$mensagem = $mensagem + "<table width='349px'  heigth='400px' align='center'>"
$mensagem = $mensagem + "<tr><td bgcolor='#DDEBF7' height='40'>AUDITORIA</td></tr>"
$mensagem = $mensagem + "<tr><td height='80'>Lista completa de todos os <b>usu&aacute;rios</b> do Active Directory</td></tr>"
$mensagem = $mensagem + "<tr><td bgcolor='#DDEBF7' height='40'>SEGURAN&#199;A DA INFORMA&#199;&#195;O</td></tr>"
$mensagem = $mensagem + "</table>"

$relatorio = $formatacao + $titulo + $tabela

#--GERAR O HTML-----------------------------------------------------#
$relatorio | Out-File $arquivo -Encoding Utf8

# Exportar para o formato CSV (ad-lista.csv)
$resultado | Sort Company | Export-Csv AD_USER_DATA.csv -NoTypeInformation -Encoding Utf8
