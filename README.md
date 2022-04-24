# BRM

### Que es de BRM:

BRM, es una herramienta hecha con el fin de realizar copias de seguridad 

### descripción de servicios y scripts

- BRM se compone de varios servicios y scripts para mantenimiento de espacio en raid y ejecucion de los respaldos.
- 
- BRM.service :Encargado de gestionar todos los procesos de BRM. Desde comprobar el estado de la raid, comprobar que dia toca backup. 
- 
- rotate.sh : script esclavo de BI.sh BF.sh, se encarga de gestionar el espacio en raid. 
- 
- BI.sh : script encargado de realizar backup diferencial. 
- 
- BF.sh : script encargado de realizar backup full.
- 
- BRM-init.service : servicio encargado de ejecutar BRM.sevice.  (descontinuado BRM.service ya es independiente y realiza sus tarea de iniciacion solo).
- 
- envBRM.sh : encargado de crear el entorno donde trabajara BRM.service 


### Guia de instalacion!

```shell
cd ~ ||\
  cd $HOME && git clone git@github.com:KalleyBacker/BRM.git && ls -1 |\
    egrep ".sh$|.service$" |\
      xargs -i chmod 755 {} && ./envBRM.sh && echo -e "\nTERMINADO\n" 
```

O

```shell
cd ~ 
git clone git@github.com:KalleyBacker/BRM.git
chmod 755 *.sh *.service 
./envBRM.sh 
bash envBRM.sh 
```


# social 
www.linkedin.com/in/juan-carlos-morla-reyes-6410a91b3
https://github.com/KalleyBacker



