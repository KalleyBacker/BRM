#!/bin/bash

#@author juan Carlos Morla Reyes
#linkedin www.linkedin.com/in/juan-carlos-morla-reyes-6410a91b3
sleep 60
etcRAIDBACKUP=/etc/RAID-BACKUP
logRAIDBACKUP=/var/log/RAID-BACKUP
OK="[""\e[92mOK\e[0m""]"
FAILE="[""\e[0m""\e[91mFaile\e[0m""]"
ruta_conf=/etc/RAID-BACKUP/BRM.conf
HOME2=/home/jcarlos/BRM


snat_old=$(find $etcRAIDBACKUP/ -maxdepth 1 -type f -iname "$(cat $etcRAIDBACKUP/RUTAsnap.tpm)" |\
	nl -s= |\
		cut -d "=" -f  1 |\
			unexpand | sed "s/ //g")

if [[ $snat_old = 1 ]];then 
  mv $etcRAIDBACKUP/$(cat $etcRAIDBACKUP/RUTAsnap.tpm) $logRAIDBACKUP/snap.old/
fi

lockfile="/var/lock/backup-raidFULL.lock"


 
if [[ ! -e $lockfile ]]; then
    
  echo -e "Ejecucion Backup-RAID [PID=$$]... $OK"
  touch $lockfile 2>/dev/null && echo -e "Archivo lock generado... $OK" || echo -e "Archivo lock no generado... $FAILE"

    
  echo -e "Iniciando rotate.sh... $OK" 
  echo "0" 1> $etcRAIDBACKUP/Status-Backup.tpr
  sleep 3s
  #nohup $HOME2/rotate.sh &


  MEMBER=$(cat $ruta_conf|\
    grep MEMBER|\
      cut -d"=" -f 2)
   		
  BACKUP_DIR=$(cat $ruta_conf|\
    grep BACKUP_DIR|\
      cut -d"=" -f 2)

  BACKUP_DES=$(cat $ruta_conf|\
    grep RAID_DEFAULT|\
      cut -d"=" -f 2|\
        xargs -i grep ^"{}" $ruta_conf| cut -c 4-)  
     
     
  if [[ -z $BACKUP_DES ]];then exit 1 ;fi

    	
  DATE=$(date +%d-%m-%Y-%I-%M-%S)
      #DATE=$(date +%d-%m-%Y)
  echo -e  "Creando archivo snapshot nuevo... $OK"
  touch $etcRAIDBACKUP/$DATE.Incremental-snapshot.snat
      #config
  echo "$DATE.Incremental-snapshot.snat" 1> $etcRAIDBACKUP/RUTAsnap.tpm
      #log      
  echo "$etcRAIDBACKUP/$DATE.Incremental-snapshot.snat" 1>> /var/log/RAID-BACKUP/RUTAsnap.tpm
      

  SNAPSHOT="$etcRAIDBACKUP/$(cat $etcRAIDBACKUP/RUTAsnap.tpm)"	
   		
  cd $BACKUP_DES/ && mkdir -p "$MEMBER.$DATE" && cd "$MEMBER.$DATE"
  BACKUP_DES=$(pwd)
   	
		#config 
  echo "$BACKUP_DES" 1> $etcRAIDBACKUP/Dir-backupRaid.conf
   		#log
  echo "$BACKUP_DES" 1>> $logRAIDBACKUP/Dir-backupRaid.log
	
  touch $etcRAIDBACKUP/$DATE.Incremental-snapshot.snat
  tar -cpzvf $BACKUP_DES/$DATE.$MEMBER.FULL.tar.gz -g $SNAPSHOT $BACKUP_DIR  && sleep 5s && declare -x DISPLAY=:0 &&xmessage -timeout 20 "BackupFull terminado... $BACKUP_DIR:[$(du -sh $BACKUP_DES/$DATE.$MEMBER.FULL.tar.gz)]" "$(date +FECHA=%D_HORA=%I-%M-%S)"		
  sleep  4s
       #declare -x LC_ALL=C 

 		#config 
  echo "$DATE.Incremental-snapshot.snat" 1> $etcRAIDBACKUP/RUTAsnap.tpm
		#log   		
  #echo "$etcRAIDBACKUP/$DATE.Incremental-snapshot.snat" 1>> $etcRAIDBACKUP/RUTAsnap.tpm
     
  echo -e "Deteniendo Rotate.sh... [""\e[92mOK\e[0m""]"&& echo "3" 1> $etcRAIDBACKUP/Status-Backup.tpr  
          
  echo -e "Archivo lock borrado... [""\e[92mOK\e[0m""]" &&  rm $lockfile 
  sleep 5s
  exit

else 
  rm $lockfile  && echo -e "Archivo lock borrado... $OK" || echo -e "Archivo lock no borrado... $FAILE" 

fi


sleep 5s
echo "3" 1> $etcRAIDBACKUP/Status-Backup.tpr



#log .conf .tpm 

#/var/log/RAID-BACKUP/FullBackupRAID_$DATE.log
#muestra los log del backup full

#/etc/RAID-BACKUP/$DATE.Incremental-snapshot.snat
#es el archvo que utilizaran los futuros backup Incrementales 

#/var/log/RAID-BACKUP/Dir-backupRaid.log
#aqui se guardan los directorios que se van creando en la raid ahi se almacenan los backup full y Incrementales

#/etc/RAID-BACKUP/Dir-backupRaid.conf
#contiene la ruta de la carpeta donde esta el backup full
#archivo que toman de referencia los backup Incrementales para poder saber donde se situaran 


#/etc/RAID-BACKUP/RUTAsnap.tpm
#contiene el ultimo archivos snap que utilizaran los backup incrementales para poder saber donde guardar los cambios 

#/var/log/RAID-BACKUP/RUTAsnap.tpm

#log de todas las rutas de snapshot que se an creado hasta el primer backup full

#/var/log/RAID-BACKUP/snap.old
#directorios donde se guardaran todos los archivos snap que se han creado hasta la fecha

#/var/log/RAID-BACKUP/xmessager.log
#log de xmessage