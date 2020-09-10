#!/bin/bash

carrega_arquivo()
{
	arq=`zenity --file-selection --title="Selecione o arquivo base"`
case $? in
	0) echo "OK";;
	1) echo "Arquivo nao foi carregado";;
	-1) echo "Erro ao abrir o arquivo";;
esac
}

carrega_array()
{	
	i=0
	declare -a dados=()
	while read line
		do
		dados[$i]="$line"
		i=$((i+1))
	done < "$arq"
	array_size=${#dados[@]}
	echo "TAMANHO ARRAY: " $array_size
			
for((i=0 ; i<$array_size ; i++))
do
	date_ymd[$i]=`echo "${dados[$i]}" | cut -f1 -d,`
	brand[$i]=`echo "${dados[$i]}" | cut -f2 -d,`
	laptop_name[$i]=`echo "${dados[$i]}" |  cut -f3 -d,`
	display_size[$i]=`echo "${dados[$i]}" | cut -f4 -d,`
	processor_type[$i]=`echo "${dados[$i]}" | cut -f5 -d,`
	graphics_card[$i]=`echo "${dados[$i]}" | cut -f6 -d,`
	disk_space[$i]=`echo "${dados[$i]}" | cut -f7 -d,`
	discount_price[$i]=`echo "${dados[$i]}" | cut -f8 -d,`
	list_price[$i]=`echo "${dados[$i]}" | cut -f9 -d,`
	rating[$i]=`echo "${dados[$i]}" | cut -f10 -d,`
done

}

#for i in "${laptop_name[@]}"
find_laptop_name()
{	
	lpname=$(zenity --text "Digite o nome do notebook: " --entry)

for((i=1 ; i<$array_size ; i++))
do
if [[ "${laptop_name[$i],,}" == *"${lpname,,}"* ]] 
then 
	echo "NAME: " ${laptop_name[$i]} "PRECO: " ${list_price[$i]}
fi
done		

}

carrega_arquivo
carrega_array

x=""

while true $x!=""
do
	echo "MENU"
	echo "1 - Localizar por laptop_name:"
	echo "2 - Localizar por disk_space"
	echo "3 - Localizar por date_ymd e brand"
	echo "4 - Aplicar desconto"
	echo "5 - Contagem por rating"
read a
case $a in
	1) find_laptop_name;;
	2) carrega_array;;
	3) echo "teste";;
	4) echo "teste";;
	5) echo "teste";;
	*) echo "Opcao invalida"
esac
done


