#!/bin/bash

#
# Autor: Clayton Teixeira
#

#
# VARIAVEIS #############################################################################

NICNAME="$NICNAME"
TIPOREG="$TIPOREG"
IP_NOME="$IP_NOME"
DOMINIO="exemplo.com.br"
LOCAL_MAPA="/var/lib/named/master"  ## caminho que se encontra as configs do DNS
MAPA="exemplo.com.br"

# FUNCOES E PROCEDIMENTOS ###############################################################

atualiza_serial(){
SERIAL=`cat $LOCAL_MAPA/$MAPA |grep serial|awk -F" " '{ print $1 }'`
NOVO_SERIAL=`expr $SERIAL + 1`
echo ""
echo "SERIAL.....: $SERIAL"
echo "NOVO SERIAL: $NOVO_SERIAL"
echo ""
cat $LOCAL_MAPA/$MAPA|sed -e "s/${SERIAL}/${NOVO_SERIAL}/g" > $LOCAL_MAPA/$MAPA.tmp
cp $LOCAL_MAPA/$MAPA.tmp $LOCAL_MAPA/$MAPA
DATA=`date +'%d-%m-%Y_%H-%M-%S'`
cp $LOCAL_MAPA/$MAPA $LOCAL_MAPA/$MAPA.${DATA}.bkp
rm $LOCAL_MAPA/$MAPA.tmp
echo "Serial atualizado com sucesso..."
}

# CORPO PRINCIPAL #######################################################################

clear

case "$TIPOREG" in
"A") echo "Verificando Endereco IP: $IP_NOME"
     FORMATO="\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
     if [[ $IP_NOME =~ $FORMATO ]]
         then
             SINTAXE="OK"
         else
             SINTAXE="NOK"
     fi
     if [[ "$SINTAXE" == "OK" ]]
     then
         REG_A="$NICNAME IN $TIPOREG $IP_NOME"
         echo "Registro a incluir --> $REG_A"
         VERIFICA_REG_A=`cat $LOCAL_MAPA/$MAPA |grep "$NICNAME"|grep "$IP_NOME"|grep "IN"|grep "A"`
         echo " "
         echo -n "Fazendo busca = $VERIFICA_REG_A"
         if [[ "$VERIFICA_REG_A" != "" ]]
         then
             echo ""
             echo "Registro IN A já existe no DNS"
             echo " "
         else
             echo "Registro IN A não encontrado no DNS "
             echo " "
             echo "Incluindo registro IN A"
             echo "$REG_A" >> $LOCAL_MAPA/$MAPA
             echo ""
             echo "Atualizando Serial number no mapa de dns..."
             atualiza_serial
         fi
     else
         echo " "
         echo "Endereço IP com sintaxe invalida..."
     fi
     ;;
"CNAME") echo " "
     FORMATO_CNAME="^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$"
     if [[ $NICNAME =~ $FORMATO_CNAME ]] && [[ $IP_NOME =~ $FORMATO_CNAME ]]
         then
             SINTAXE="OK"
         else
             SINTAXE="NOK"
     fi
     if [[ "$SINTAXE" == "OK" ]]
     then
         REG_CNAME="$NICNAME $TIPOREG $IP_NOME"
         echo "Registro a incluir --> $REG_CNAME"
         VERIFICA_REG_CNAME=`cat $LOCAL_MAPA/$MAPA |grep "$NICNAME"|grep "$IP_NOME"|grep "CNAME"`
         echo " "
         echo -n "Fazendo busca = $VERIFICA_REG_CNAME"
         if [[ "$VERIFICA_REG_CNAME" != "" ]]
         then
             echo ""
             echo "Registro CNAME já existe no DNS"
             echo " "
         else
             echo "Registro CNAME não encontrado no DNS "
             echo " "
             echo "Incluindo registro CNAME"
             echo " "
             echo "$REG_CNAME" >> $LOCAL_MAPA/$MAPA
             atualiza_serial
         fi
     else
         echo " "
         echo "Endereco FQDN ou hostname com sintaxe invalida..."
     fi
     ;;
*)      echo "Erro: dns-chk-ins.sh <nicname ou FQDN> <A ou CNAME> <IP ou hostname>"
        echo "      Comando exige passagem dos tres parametros mensionados acima."
     ;;
esac
