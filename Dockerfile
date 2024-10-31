FROM bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8

# Copiar el script de Word Count (si es necesario)
COPY ./wordcount.sh /usr/local/bin/wordcount.sh
RUN chmod +x /usr/local/bin/wordcount.sh

# Comando por defecto
CMD ["bash"]
