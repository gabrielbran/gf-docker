 
FROM        ubuntu:20.04

ENV         JAVA_HOME=/usr/share/jdk7.0.332
ENV         GLASSFISH_HOME=/usr/share/glassfish4 
ENV         PATH=$PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
ENV         DOMAIN_NAME=production
ENV         DEFAULT_PASSWORD=/usr/share/admin-password

COPY        glassfish-4.1.tar.gz jdk7.0.332.tar.gz admin-password /usr/share/

RUN         tar -xzf /usr/share/jdk7.0.332.tar.gz -C /usr/share && \
            tar -xzf /usr/share/glassfish-4.1.tar.gz -C /usr/share && \
            rm -rf /usr/share/jdk7.0.332.tar.gz && \
            rm -rf /usr/share/glassfish-4.1.tar.gz

EXPOSE      4848 8009 8080 8181

WORKDIR     /usr/share/glassfish4

RUN         asadmin create-domain --user admin --passwordfile ${DEFAULT_PASSWORD} ${DOMAIN_NAME} && \
            asadmin start-domain && \
            echo "Habilitando secure admin..." &&\
            asadmin --user admin --passwordfile ${DEFAULT_PASSWORD} enable-secure-admin && \
            asadmin stop-domain && \
            rm -rf ${DEFAULT_PASSWORD}

#           url jdk https://cdn.azul.com/zulu/bin/zulu7.52.0.11-ca-jdk7.0.332-linux_x64.tar.gz
#           url gf4 http://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip
#
#           parche nucleus-grizzly-all http.
#           creacion de password aliases.
#           creacion de recursos jndi, jdbc, mail.
#           tunning jvm, thread pool, jdbc connection pool.

# verbose causes the process to remain in the foreground so that docker can track it
CMD         asadmin start-domain --verbose

# docker run -d -p 4848:4848 -p 8080:8080 --name genesys genesys-ui:4.0