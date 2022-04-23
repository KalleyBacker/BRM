objetivo del proyecto: 
#####################

Este proyecto tiene la finalidad seguir desarollando la herramienta BRM(BACKUP RAID MORLA) de código abierto. 
Actualmente desarrollada en bashscript esta en su version 1.0 

funcion de BRM:
##############
La funcionalidad de BRM es crear backups de respaldo en una raid,
implementando las diferentes técnicas de compresión para poder realizar su objetivo de crear respaldo y guardarlo en una raid de forma efectiva, 
BRM se compone de varios servicios y scripts para mantenimiento de espacio en raid y ejecucion de los respaldos.

funcion services y script
#########################
1)BRM.service :Encargado de gestionar todos los procesos de BRM. Desde comprobar el estado de la raid, comprobar que dia toca backup. 
2)rotate.sh : script esclavo de BI.sh BF.sh, se encarga de gestionar el espacio en raid. 
3)BI.sh : script encargado de realizar backup diferencial. 
4)BF.sh : script encargado de realizar backup full.
5)BRM-init.service : servicio encargado de ejecutar BRM.sevice.  (descontinuado BRM.service ya es independiente y realiza sus tarea de iniciacion solo).
6)envBRM.sh : encargado de crear el entorno donde trabajara BRM.service 


lista de update BRM version 1.0
###############################

1) No depender de cron OK
2) Ser un servicio independiente:  OK
3) Añadir más seguridad para ser más robusto: OK
4) Que funcione en diferentes distros actualmente solo fedora33 y más o menos.. ubuntu groovy20.04: EN PROCESO
5) Añadir comprobación de hash a los backup full y incrementales: EN PROCESO
6) Añadir script de instalación: OK
7) No obligatorio... instalación sea personalizable: EN PROCESO

guia de instalacion!
###################
alternativa 1
cd ~ || cd $HOME && git clone git@gitlab.com:linux-raid/project-backup-raid_2.0.git && ls -1 | egrep ".sh$|.service$" |xargs -i chmod 755 {} && ./envBRM.sh && echo -e "\nTERMINADO\n" 

alternativa 2
cd ~ 
git clone git@gitlab.com:linux-raid/project-backup-raid_2.0.git
chmod 755 *.sh *.service 
./envBRM.sh 
bash envBRM.sh 


conctato ;D
#linkedin www.linkedin.com/in/juan-carlos-morla-reyes-6410a91b3
https://gitlab.com/juancarlosmorlareyes


