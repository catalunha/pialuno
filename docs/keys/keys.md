
http://www.androiddocs.com/tools/publishing/app-signing.html#release-mode


Esta chave e senha atende apenas ao pialuno
keytool -genkey -v -keystore pibrintec.keystore -alias pibrintec -keyalg RSA -keysize 2048 -validity 10000
senha: pibrintecappkey
alias: pibrintec



~~~
catalunha@nb:~/projetos-flutter/pialuno$ keytool -genkey -v -keystore pibrintec.keystore -aliaslg RSA -keysize 2048 -validity 10000
Informe a senha da área de armazenamento de chaves:  
Informe novamente a nova senha: 
Qual é o seu nome e o seu sobrenome?
  [Unknown]:  brintec
Qual é o nome da sua unidade organizacional?
  [Unknown]:  brintec
Qual é o nome da sua empresa?
  [Unknown]:  brintec
Qual é o nome da sua Cidade ou Localidade?
  [Unknown]:  palmas
Qual é o nome do seu Estado ou Município?
  [Unknown]:  to
Quais são as duas letras do código do país desta unidade?
  [Unknown]:  br
CN=brintec, OU=brintec, O=brintec, L=palmas, ST=to, C=br Está correto?
  [não]:  sim

Gerando o par de chaves RSA de 2.048 bit e o certificado autoassinado (SHA256withRSA) com uma validade de 10.000 dias
        para: CN=brintec, OU=brintec, O=brintec, L=palmas, ST=to, C=br
Informar a senha da chave de <pibrintec>
        (RETURN se for igual à senha da área do armazenamento de chaves):  
[Armazenando pibrintec.keystore]

Warning:
O armazenamento de chaves JKS usa um formato proprietário. É recomendada a migração para PKCS12, que é um formato de padrão industrial que usa "keytool -importkeystore -srckeystore pibrintec.keystore -destkeystore pibrintec.keystore -deststoretype pkcs12".
~~~

https://developers.google.com/android/guides/client-auth

keytool -exportcert -list -v -alias pibrintec -keystore ./pibrintec.keystore