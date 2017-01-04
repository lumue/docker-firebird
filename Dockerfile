FROM anapsix/alpine-java:8_server-jre
MAINTAINER Lutz Mueller <mueller.lutz@gmail.com>

ENV         GLASSFISH_HOME  /usr/local/glassfish4
ENV         PATH                $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin

RUN         wget -O /tmp/glassfish-4.1.1.zip http://download.java.net/glassfish/4.1.1/release/glassfish-4.1.1.zip && \
            unzip /tmp/glassfish-4.1.1.zip -d /usr/local && \
            rm -f /tmp/glassfish-4.1.1.zip && \
            mkdir /webapp

EXPOSE      8080 4848 8181 9009

WORKDIR     /usr/local/glassfish4

CMD asadmin start-domain --verbose
