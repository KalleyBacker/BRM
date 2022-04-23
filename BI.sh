#!/bin/bash

#@author juan carlos Morla reyes
#linkedin www.linkedin.com/in/juan-carlos-morla-reyes-6410a91b3
sleep 60
etcRAIDBACKUP=/etc/RAID-BACKUP
logRAIDBACKUP=/var/log/RAID-BACKUP
OK="[""\e[92mOK\e[0m""]"
FAILE="[""\e[0m""\e[91mFaile\e[0m""]"
ruta_conf=/etc/RAID-BACKUP/BRM.conf
HOME2=/home/jcarlos/BRM
lockfile="/var/lock/backup-raidINCREMENTALt.lock"

#functionTrap=$(rm $lockfile && echo -e "Archivo lock borrado... $OK" && cd $BACKUP_DES && $DATE.$MEMBER-INCREMENTAL.tar.gz |xargs -i rm {} && echo cierre forzado  &&exit 1)
 #trap rm $lockfile ;echo -e "Archivo lock borrado... $OK" ; cd $BACKUP_DES ; find . -type f -maxdepth -iname $DATE.$MEMBER-INCREMENTAL.tar.gz |xargs -i rm {} ; echo cierre forzado  ; exit SIGKILL



if [[ ! -e $lockfile ]]; then
 
	echo -e "Ejecucion Backup-RAID [PID=$$]... $OK"
	touch $lockfile 2>/dev/null && echo -e "Archivo lock generado... $OK" || echo -e "Archivo lock no generado... $FAILE"
    	
  echo -e "Comprobacion Raid montada... $OK" 
   		
  echo -e "Iniciando rotate.sh.. $OK" 
  echo "0" 1> $etcRAIDBACKUP/Status-Backup.tpr
  sleep 3
  nohup $HOME2/rotate.sh &
  

  MEMBER=$(cat $ruta_conf|\
    grep MEMBER|\
      cut -d"=" -f 2)
      
  BACKUP_DIR=$(cat $ruta_conf|\
    grep BACKUP_DIR|\
      cut -d"=" -f 2)

  BACKUP_DES="$(cat /etc/RAID-BACKUP/Dir-backupRaid.conf)"
  DATE=$(date +%d-%m-%Y-%I-%M-%S)
  #DATE=$(date +%d-%m-%Y)
  SNAPSHOT="$etcRAIDBACKUP/$(cat $etcRAIDBACKUP/RUTAsnap.tpm)"

  tar -czvf $BACKUP_DES/$DATE.$MEMBER-INCREMENTAL.tar.gz -g $SNAPSHOT $BACKUP_DIR  && sleep 5s && declare -x DISPLAY=:0 && xmessage -timeout 20 "BackupINCREMENRTAL terminado...[ $(du -sh $BACKUP_DES/$DATE.$MEMBER-INCREMENTAL.tar.gz) ]" "$(date +FECHA=%D_HORA=%I-%M-%S)"
  sleep 4s
		
	echo -e "Deteniendo Rotate.sh... $OK" && echo "3" 1> /etc/RAID-BACKUP/Status-Backup.tpr	
		
	echo -e "Archivo lock borrado... $OK"
 	rm $lockfile &&
 	sleep 5s
 	exit 
	
else 
   		
  rm $lockfile && echo -e "Archivo lock borrado... $OK" || echo -e "Archivo lock no borrado... $FAILE" 
	exit
    		  
fi

sleep 5s
echo "3" 1> /etc/RAID-BACKUP/Status-Backup.tpr

