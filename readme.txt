# Tutorial: Levantar un Clúster de Hadoop con YARN y Realizar un Word Count

Este tutorial te guiará a través del proceso de levantar un clúster de Hadoop usando Docker, configurar YARN, ejecutar un ejemplo de Word Count y documentar tu imagen en GitHub.

## Requisitos Previos

- Tener instalado Docker y Docker Compose en tu máquina.
- Tener conocimientos básicos sobre Docker y Git.

## Parte 1: Levantar el Clúster de Hadoop

### Paso 1: Crear el archivo `docker-compose.yml`

Crea un archivo llamado `docker-compose.yml` con el siguiente contenido:

```yaml
version: '3.8'

services:
  namenode:
    image: bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8
    container_name: namenode
    environment:
      - CLUSTER_NAME=test
      - CORE_CONF_fs_defaultFS=hdfs://namenode:8020
    ports:
      - "9870:9870"  # Puerto para la interfaz web del NameNode
    volumes:
      - namenode_data:/hadoop/dfs/name

  datanode:
    image: bde2020/hadoop-datanode:2.0.0-hadoop2.7.4-java8
    container_name: datanode
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:8020
      - YARN_CONF_yarn_resourcemanager_hostname=resourcemanager
    volumes:
      - datanode_data:/hadoop/dfs/data
    depends_on:
      - namenode

  resourcemanager:
    image: bde2020/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8
    container_name: resourcemanager
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:8020

  nodemanager:
    image: bde2020/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8
    container_name: nodemanager
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:8020
    depends_on:
      - resourcemanager

volumes:
  namenode_data:
  datanode_data:

### Paso 2: Levantar el Clúster de Hadoop

docker-compose up -d

### Paso 3: Comprobar el estado de el Clúster de Hadoop

docker ps

## Parte 2: Ejecutar el Ejemplo de Word Count

### Paso 4: Preparar el Archivo wordcount.sh

- Crear el archivo y añadir este contenido:

#!/bin/bash
echo -e "Hola mundo\nHola Hadoop\nAdiós mundo" > /hadoop/dfs/name/test.txt
hdfs dfs -mkdir -p /user/root
hdfs dfs -put /hadoop/dfs/name/test.txt /user/root/
yarn jar /opt/hadoop-2.7.4/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.4.jar wordcount /user/root/test.txt /user/root/output

### Paso 5: Copiar el script al Contenedor

docker cp wordcount.sh namenode:/usr/local/bin/wordcount.sh
docker exec -it namenode bash -c "chmod +x /usr/local/bin/wordcount.sh"

### Paso 6: Ejecutar el Script de Word Count

docker exec -it namenode bash -c "/usr/local/bin/wordcount.sh"

### paso 7: Verificar el resultado

docker exec -it namenode hdfs dfs -ls /user/root/output
docker exec -it namenode hdfs dfs -cat /user/root/output/part-r-00000
