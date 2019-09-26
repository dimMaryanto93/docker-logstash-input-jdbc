FROM docker.elastic.co/logstash/logstash:7.3.2
MAINTAINER <software.dimas_m@icloud.com> Dimas Maryanto

# install dependency
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-jdbc
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-aggregate
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-jdbc_streaming
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-mutate

# copy lib database jdbc jars
COPY ./compose/mysql/mysql-connector-java-8.0.11.jar /usr/share/logstash/logstash-core/lib/jars/mysql-connector-java.jar
COPY ./mssql-jdbc-7.2.2.jre8.jar /usr/share/logstash/logstash-core/lib/jars/mssql-jdbc.jar
COPY ./ojdbc6-11.2.0.4.jar /usr/share/logstash/logstash-core/lib/jars/ojdbc6.jar
COPY ./postgresql-9.4.1212.jre7.jar /usr/share/logstash-core/lib/jars/logstash/postgresql.jar