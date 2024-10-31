#!/bin/bash
echo -e "Hola mundo\nHola Hadoop\nAdiós mundo" > /hadoop/dfs/name/test.txt
hdfs dfs -mkdir -p /user/root
hdfs dfs -put /hadoop/dfs/name/test.txt /user/root/
yarn jar /opt/hadoop-2.7.4/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.4.jar wordcount /user/root/test.txt /user/root/output
