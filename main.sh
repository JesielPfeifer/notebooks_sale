#!/bin/bash

carrega_arquivo()
{
	arq=`zenity --file-selection --title="Selecione o arquivo base" --file-filter="*.csv"`
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
	laptop_name[$i]=`echo "${dados[$i]}" | cut -f3 -d, | tr ' ' '_'`
	display_size[$i]=`echo "${dados[$i]}" | cut -f4 -d,`
	processor_type[$i]=`echo "${dados[$i]}" | cut -f5 -d,| tr ' ' '_'`
	graphics_card[$i]=`echo "${dados[$i]}" | cut -f6 -d, | tr ' ' '_'`
	disk_space[$i]=`echo "${dados[$i]}" | cut -f7 -d,| tr ' ' '_'`
	discount_price[$i]=`echo "${dados[$i]}" | cut -f8 -d,`
	list_price[$i]=`echo "${dados[$i]}" | cut -f9 -d,`
	rating[$i]=`echo "${dados[$i]}" | cut -f10 -d,`
        
done

echo "NOME: " ${laptop_name[3]}	

}

find_laptop_name()
{	
	lpname=$(zenity --text "Digite o nome do notebook: " --entry)
table=`for((i=1 ; i<$array_size ; i++))
do
if [[ "${laptop_name[$i],,}" == *"${lpname,,}"* ]] 
	then
	echo -e "${date_ymd[$i]} ${brand[$i]} ${laptop_name[$i]} ${display_size[$i]} ${processor_type[$i]} ${graphics_card[$i]} ${disk_space[$i]} ${discount_price[$i]} ${list_price[$i]} ${rating[$i]}\n"
fi
done`

zenity --list \
--width=800 \
--height=900 \
--print-column='ALL' \
--separator=$',' \
--text="Termo pesquisado: $lpname" \
--column="Data" \
--column="Marca" \
--column="Notebook" \
--column="Tela" \
--column="CPU" \
--column="GPU" \
--column="HD" \
--column="Desconto" \
--column="Lista de preco" \
--column="Avaliacao" \
$table

}
filter_disk_space()
{
	diskSpace=$(zenity --text "Digite o tamanho do disk space: " --entry)

for((i=1 ; i<$array_size ; i++))
do
if [[ "${disk_space[$i]}" == *"${diskSpace}"* ]] 
then
	discount_amount=$(echo "scale=2;${list_price[$i]} - ${discount_price[$i]}" | bc -l)
	echo ${brand[$i]}" - "${laptop_name[$i]}" - "${discount_price[$i]}" - "${list_price[$i]}" - "$discount_amount
fi
done
}

filter_date_brand()
{
	data=$(zenity --text "Digite a data desejada: " --entry)
	marca=$(zenity --text "Digite a fabricante desejada: " --entry)
c=0	
for((i=1 ; i<$array_size ; i++))
do
if [[ "${date_ymd[$i]}" == *"${data}"* && "${brand[$i]}" == *"${marca}"* ]] 
then
	aux[$c]=${laptop_name[$i]}' '${display_size[$i]}' '${disk_space[$i]}' '${discount_price[$i]}' '${rating[$i]}
	let c++
fi
done

IFS=$'\n' sorted=($(sort <<<"${aux[*]}")); unset IFS
printf "%s\n" "${sorted[@]}"
}

count_rating()
{
a=0
b=0
c=0
d=0
e=0
f=0

for((i=1 ; i<$array_size ; i++))
do

aux=`echo "${rating[$i]}" | egrep "[0-5]{,1}\.[0-9]{,1}|[0-9]{,1}" | tr -d '/'`

if [ $(echo "$aux>=0.0 && $aux<=1.0" | bc) -eq 1 ]
then
	um[$a]=${rating[$i]}
	let a++
	
	elif [ $(echo "$aux>=1.0 && $aux<=2.0" | bc) -eq 1 ] 
		then
			dois[$b]=${rating[$i]}
			let b++
			
			elif [ $(echo "$aux>=2.0 && $aux<=3.0" | bc) -eq 1 ] 
				then
					tres[$c]=${rating[$i]}
					let c++
					
					elif [ $(echo "$aux>=3.0 && $aux<=4.0" | bc) -eq 1 ] 
						then
							quatro[$d]=${rating[$i]}
							let d++
							
							elif [ $(echo "$aux>=4.0 && $aux<=5.0" | bc) -eq 1 ] 
								then
									cinco[$e]=${rating[$i]}
									let e++
									
									else
									seis[$f]=${rating[$i]}
									let f++
fi

done

for((i=0 ; i<$e ; i++))
do

aux=`echo "${cinco[$i]}" | egrep -o '[0]{,1}' | tr -d '/'`

	if [[ $aux == 0 ]]
		then
			um[$a]=${cinco[$i]}
			let a++
			unset -v 'cinco[$i]'
	fi
done

for((i=0 ; i<$f ; i++))
do

aux=`echo "${seis[$i]}" | egrep -o '[0-4]{,1}' | tr -d '/'`

	if [[ $aux == 1 ]]
		then
			dois[$b]=${seis[$i]}
			let b++
			unset -v 'seis[$i]'
			
			elif [[ $aux == 2 ]]
				then
					tres[$c]=${seis[$i]}
					let c++
					unset -v 'seis[$i]'
					
					elif [[ $aux == 3 ]]
						then
							quatro[$d]=${seis[$i]}
							let d++
							unset -v 'seis[$i]'
							
							elif [[ $aux == 4 ]]
								then
									cinco[$e]=${seis[$i]}
									let e++
									unset -v 'seis[$i]'
	fi
done

for((i=0 ; i<$a ; i++))
do
echo "A)"${um[$i]} 
done
echo
for((i=0 ; i<$b ; i++))
do 
echo "B)"${dois[$i]}
done
echo
for((i=0 ; i<$c ; i++))
do
echo "C)"${tres[$i]}
done
echo
for((i=0 ; i<$d ; i++))
do
echo "D)"${quatro[$i]}
done
echo
for((i=0 ; i<$e ; i++))
do

if [[ ${cinco[$i]} != ''  ]]
	then
		echo "E)"${cinco[$i]}
fi

done
echo
for((i=0 ; i<$f ; i++))
do

if [[ ${seis[$i]} != ''  ]]
	then
		echo "F)"${seis[$i]}
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
	2) filter_disk_space;;
	3) filter_date_brand;;
	4) echo "teste";;
	5) count_rating;;
	*) echo "Opcao invalida"
esac
done
