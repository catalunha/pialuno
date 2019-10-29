~~~
catalunha@nb:~/projetos-flutter/pi_aluno$ keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
Nome do alias: androiddebugkey
Data de criação: 05/08/2019
Tipo de entrada: PrivateKeyEntry
Comprimento da cadeia de certificados: 1
Certificado[1]:
Proprietário: C=US, O=Android, CN=Android Debug
Emissor: C=US, O=Android, CN=Android Debug
Número de série: 1
Válido de Mon Aug 05 15:18:10 BRT 2019 até Wed Jul 28 15:18:10 BRT 2049
Fingerprints do certificado:
	 MD5:  11:A3:9D:AD:A8:13:33:3C:81:74:F2:2D:EA:79:DC:A1
	 SHA1: 99:B6:F5:76:68:C1:F5:A5:C8:72:AE:5D:66:61:F1:45:08:1D:96:C0
	 SHA256: 82:73:C9:39:1E:AB:0B:C8:2D:51:D9:C2:4E:FE:F5:85:17:37:F7:1A:D6:A9:89:00:CF:87:A2:98:CD:6E:19:C5
Nome do algoritmo de assinatura: SHA1withRSA
Algoritmo de Chave Pública do Assunto: Chave RSA de 1024 bits
Versão: 1

Warning:
O armazenamento de chaves JKS usa um formato proprietário. É recomendada a migração para PKCS12, que é um formato de padrão industrial que usa "keytool -importkeystore -srckeystore /home/catalunha/.android/debug.keystore -destkeystore /home/catalunha/.android/debug.keystore -deststoretype pkcs12".
catalunha@nb:~/projetos-flutter/pi_aluno$ 
~~~