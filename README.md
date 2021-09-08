# Cadastro DNS - inserção de registros A e CNAME

- Autor: Clayton Teixeira


## Descrição:

Script em BashShell, utilizando comandos básicos do Linux o que o torna multiplataforma entre distribuições Linux e Unix (AIX e Solaris).  Este script tem a finalidade de inserir entradas do tipo A e CNAME no mapa principal de domínio de um cliente.

## Pré-requisitos:
BashSell 

## Configurações:

É importante configurar dentro do script dns.sh duas variáveis: LOCAL_MAPA e  MAPA

A variável LOCAL_MAPA aponta para o local onde o mapa principal do dominio se encontra, exemplo:
LOCAL_MAPA="/var/lib/named/master"

A variável MAPA indica o nome do mapa de dominios DNS do servidor de DNS, exemplo:
MAPA="csn.com.br"

Assim sendo durante a execução do script dns.sh passamos os três parâmetros obrigatórios e o script internamente irá fixar as variáveis LOCAL_MAPA e MAPA apontando para o arquivo desejado para a inserção do novo registro DNS.
- Exemplo:
  dns.sh  titan A 192.168.1.10
   
  Ele verificará se existe uma entrada do tipo:   titan  IN A 192.168.1.10
  Supondo não existir ele irá no caminho/arquivo --> /var/lib/named/master/csn.com.br e incluirá no final do mesmo o registro.


## Manual:

O script tem três parâmetros obrigatórios de entrada que passam respectivamente:

Hostname   Tipo_Registro  Endereço_IP_ou_Hostname
Param_1        Param_2           Param_3

- Para entrada de registro do tipo A:
  dns.sh  nicname  A  endereço_ip

- Para entrada de registro do tipo CNAME:
  dns.sh  hostname   CNAME   hostname_novo
  ou
  dns.sh  hostname_FQDN   CNAME   hostname_novo
  
  O script verifica a sintaxe dos hostnames, hostnames FQDN e endereço IP, a fim de evitar entradas com caracteres indevidos.
  Além disso ele verifica se o registro a ser criado já existe no mapa de dominios do DNS, porém possibilita criar um novo   registro tipo A, com hostname e tipo de registro igual mas endereço IP diferente e vice e versa, de modo análogo para registro do tipo CNAME.

  ### Exemplos:
  
  - Entrar um registro do tipo A:
  dns.sh  titan A 192.168.1.10
  
  Ele verificará se existe uma entrada do tipo:   titan  IN A 192.168.1.10

  Caso não exista ele irá inserir o registro no final do arquivo de mapa de domínios:
  titan IN A 192.168.1.10
  Se existir emitira uma mensagem dizendo que já existe e não insere o registro no mapa de domínios.

  - Entrar um registro do tipo CNAME:
  dns.sh  titan.com.br CNAME cracken 
  
  Ele verificará se existe uma entrada do tipo:   titan.com.br  IN CNAME cracken
  
  Caso não exista ele irá inserir o registro no final do arquivo de mapa de domínios:
  titan.com.br IN CNAME cracken
  Se existir emitirá uma mensagem dizendo que já existe e não insere o registro no mapa de domínios.

