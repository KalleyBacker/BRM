#!/bin/env bash 

#env de brm.service 
#z/home/jcarlos/BRM

mkdir /etc/RAID-BACKUP && cd /etc/RAID-BACKUP/ && touch Dir-backupRaid.conf Status-Backup.tpr RUTAsnap.tpm

echo '#configuracion Backup Raid Morla aqui estaran todos los archivos de configuracion
#LA RAID TIENE QUE LLAMARSE IGUAL QUE EL DIRECTORIO DONDE SE MONTARA Y TIENE QUE SER EN /MEDIA/***
#ruta BMR.SERVICE NO SE!!!! XD
#################################################################################################

#limite de almacenamiento de raid. En este campo se delimitara el alcance maximo que puede tener la raid de almacenamiento ejemp 40% 70% utilize el comando df para saber mas! en el apartado (disponibles)
LIMITHARD=30


#############################################################################################################
#campo viene en version 2.0 :D
#ID DE LOS DISPOSITIVOS SINCRONIZADOS EN RAID [1-4] OBLIGATORIO TENER ESTEN CAMPO LLENO (el ID se toma del comando lsusb)
#ID1=090c:1000
#ID2=05dc:c75c
#ID3=0781:5567
#ID4=0781:5567 
##############################################################################################################


##horario de backup formato 24 horas con minutos ejemp. 07-30
HR='19-31'
#dias backup diferencial SOLO SE PERMITEN VALORES (1-7) #1L 2M 3I 4J 5V 6S 7D 
BD='4,5,3,2,1'
#dias backup FULL SOLO SE PERMITEN VALORES (1-7) #1L 2M 3I 4J 5V 6S 7D (no se pueden cruzar los dias de full y diferencial)
BF='5,1,6'

#[2]directorio de raid por defecto 
RAID_DEFAULT=R1
#[3]directorios de raid para usar este cambo tienes que agregar el por DEFAULT que esta en el cambo 2 en un futuro ;)

R1=/media/md0
R2=/media/sdb1
R3=
R4=iasdasndsjkdnadnasjdnajdmalms

##############################################
#Tiempo_de_espera_comprobacion_raid          #  
##############################################
#tiempo de espera para que el servicio verifique si la raid esta montada, tiempo por default (30m)
# la variable se mide en ciclos x segundo [en este caso  5 segundo es el default y 360 son los ciclos por default]
#[ "360 ciclos" x "5 segundos de espera"  = "1800 segundo" ( 1800/60 =30m) ] 
#la raid verifica cada 359 que es igual a 29m este calculo es automatico. 
#solo se puede modificar la variable ciclos, la variable segundo ya viene por defecto en 5s!  
CICLOsTECR=360' 1>/etc/RAID-BACKUP/BRM.conf1 


mkdir /var/log/RAID-BACKUP &&  cd /var/log/RAID-BACKUP && mkdir INCREMENTALBackupRAID.Dlog && mkdir FullBackupRAID.Dlog && mkdir snap.old
touch RUTAsnap.tpm Dir-backupRaid.log xmessager.log rotate.log
echo final!