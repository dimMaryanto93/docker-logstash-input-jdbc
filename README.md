## Starting logstash 

Starting logstash input jdbc

```bash
docker-compose -f compose/db-platform/docker-compose.version.yaml -p project_name up --build
```

Stoping all service

```bash
docker-compose -f compose/db-platform/docker-compose.version.yaml -p project_name down --rmi local
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

- LOGSTASH_JDBC_DRIVER_JAR_LOCATION: 
    - for MySQL 5.7+ Database: `/usr/share/logstash/logstash-core/lib/jars/mysql-connector-java.jar`
    - for MS-SQL Server 2017 linux+ Database: `/usr/share/logstash/logstash-core/lib/jars/mssql-jdbc.jar`
    - for Oracle 11g XE Database: `/usr/share/logstash/logstash-core/lib/jars/ojdbc6.jar`
    - for PostgreSQL 9.6+ Database: `/usr/share/logstash-core/lib/jars/logstash/postgresql.jar`
- LOGSTASH_JDBC_DRIVER: `com.mysql.jdbc.Driver`
- LOGSTASH_JDBC_URL: `jdbc:mysql://[host]:[port]/[database-name]`
- LOGSTASH_JDBC_USERNAME: `database_user`
- LOGSTASH_JDBC_PASSWORD: `database_user_password`