## Starting logstash 

Starting logstash input jdbc for mysql database plugin is super simple. with this command

```docker
docker run --name logstash-name -p 9600:9600 -p 5044:5044 dimmaryanto93/logstash-input-jdbc-mysql:tag
```

## Customize configuration

Customize configuration for logstash

- modify file `logstash.conf` in docker container

```yml
input {
    jdbc {
        jdbc_driver_library => "${LOGSTASH_JDBC_DRIVER_JAR_LOCATION}"
        jdbc_driver_class => "${LOGSTASH_JDBC_DRIVER}"
        jdbc_connection_string => "${LOGSTASH_JDBC_URL}"
        jdbc_user => "${LOGSTASH_JDBC_USERNAME}"
        jdbc_password => "${LOGSTASH_JDBC_PASSWORD}"
        schedule => "* * * * *"
        statement => "select ... from table_name"
    }
}

output {
    stdout { codec => json_lines }
}
```

Environtment example

- LOGSTASH_JDBC_DRIVER_JAR_LOCATION: `mysql-connector-java.jar`
- LOGSTASH_JDBC_DRIVER: `com.mysql.jdbc.Driver`
- LOGSTASH_JDBC_URL: `jdbc:mysql://[host]:[port]/[database-name]`
- LOGSTASH_JDBC_USERNAME: `database_user`
- LOGSTASH_JDBC_PASSWORD: `database_user_password`

Starting with this configuration, create file `docker-compose.yml` then run `docker-compose up`

```docker
version: '3.6'
services:
  mysql:
    image: mysql:5.7
    ports: 
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=example
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=admin
    volumes:
      - mysql_data:/var/lib/mysql
    networks: 
      - logstash_network
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.6.0
    ports:
      - 9300:9300
      - 9200:9200
    environment:
      - transport.host=127.0.0.1
      - cluster.name=docker-cluster
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - logstash_network
  kibana:
    image: docker.elastic.co/kibana/kibana:6.6.0
    ports:
      - 5601:5601
    networks:
      - logstash_network
    depends_on: 
      - elasticsearch
  logstash:
    image: dimmaryanto93/logstash-input-jdbc-plugin:6.6.0
    environment:
      - LOGSTASH_JDBC_URL=jdbc:mysql://mysql:3306/example?useSSL=false
      - LOGSTASH_JDBC_DRIVER=com.mysql.jdbc.Driver
      - LOGSTASH_JDBC_DRIVER_JAR_LOCATION=mysql-connector-java.jar
      - LOGSTASH_JDBC_USERNAME=admin
      - LOGSTASH_JDBC_PASSWORD=admin
    ports: 
      - 9600:9600
      - 5044:5044
    networks:
      - logstash_network
    volumes: 
      - ./logstash-input-jdbc.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on: 
      - elasticsearch
      - kibana
      - mysql
volumes:
  elasticsearch_data:
  mysql_data:
networks:
  logstash_network:
```