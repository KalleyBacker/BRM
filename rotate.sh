#!/bin/env bash 

#@author juan carlos
#@red social linkedin www.linkedin.com/in/juan-carlos-morla-reyes-6410a91b3
#@description rotador de backup en raid 

#salida estandar 
#/var/log/RAID-BACKUP/rotate.log 

#configuracion
#/etc/RAID-BACKUP/Status-Backup.tpr

#directorio de raid RAID_DEFAULT
#etc/RAID-BACKUP/BRM.conf 
#limithard  = null = var 80 defaul.



#################
CONF='/etc/RAID-BACKUP/BRM.conf'
RAID=$1
PROCESOBACKUP=1

if [[ -z $LIMITHARD ]]
then  
	
	LIMITHARD=$(cat $CONF|\
		grep LIMITHARD|\
			cut -d"=" -f 2)				
	
	if [[ -z $LIMITHARD ]];then 
		
		LIMITHARD=85	

	fi
				
fi

#si variable raid nula busca en brm.conf
if [[ -z $RAID ]]
then  
	
	RAID=$(cat $CONF|\
		grep RAID_DEFAULT|\
			cut -d"=" -f 2|\
				xargs -i grep ^"{}" $CONF| cut -c 4-)
	
	if [[ -z $RAID ]];then exit 1 ;fi
				
fi
#

AVI_LIMITHARD(){
	
	echo -e "LIMITHARD = [$(( $LIMITHARD - ${NAME[3]} ))%] $BACKUP_DES\nBloques usados [${NAME[1]}]\nHARD = [$LIMITHARD%]\nRAID = [$RAID]"\
		&> /var/log/RAID-BACKUP/rotate.log 
}

SLE_1(){
	
	sleep 0.1 &&\
		clear
}

 	
while [ $PROCESOBACKUP -lt 2 ]
do

	NAME[1]=$(df  $RAID |\
		tail -n1 |\
			awk '{ print $3 }')

	NAME[2]=$(df -h $RAID |\
		tail -n1 |\
			awk '{ print $4 }')

	NAME[3]=$(df -h $RAID |\
			tail -n1 |\
				awk '{ print $5 }'|\
					tr '\045' '\012')

#Elimina si limite mayor que $LIMITHARD
	if [[ ${NAME[3]} -ge $LIMITHARD ]];then
 
 		AVI_LIMITHARD
 		cd $RAID &&\
		 	ls -lt|\
	 			awk '{ print $9 }'|\
	 				grep ^[^l]|\
	 					tail -n1|\
	 						xargs -i rm -rf {}
		SLE_1				
	else 
		AVI_LIMITHARD
		SLE_1 				

	fi 
	
	PROCESOBACKUP=$(cat /etc/RAID-BACKUP/Status-Backup.tpr)	
 	
done				
exit 0	
	
