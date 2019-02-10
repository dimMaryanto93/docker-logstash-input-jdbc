FROM docker.elastic.co/logstash/logstash:6.6.0
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-jdbc
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-aggregate
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-jdbc_streaming
COPY ./mysql-connector-java-5.1.46.jar /usr/share/logstash/mysql-connector-java.jar