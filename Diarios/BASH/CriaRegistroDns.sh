#!/bin/bash
# Script para criar registro A no DNS interno
# Empresa: BySeven
# Autor: Rohan Scanavez
# Data: 24/08/2018
# Versão 0.1
#---------------------------------------------
# Script para criar registro A no DNS interno
# Empresa: BySeven
# Autor: Fabio de Lima Rodriguez
# Data: 24/08/2018
# Release notes: Script revisado
# Versão 0.1

usage="USAGE: sh ./CriaRegistroA.sh [registro] [ip]"

case $1 in
"--help") 
	echo $usage
	exit 0
	;;
esac

registro=$1
ip=$2

if [ -z "$registro" ] || [ -z "$ip" ] ;
then 
  echo "Argumento nao especificado!"
  echo $usage
  exit 0

else
 registro="$registro.by7.corp"
 {
   echo "update add $registro 86400 A $ip"
   echo 
 } | nsupdate -v -d

 echo ""
 echo "REGISTRO "$registro " associado ao IP " $ip " com sucesso"
fi
