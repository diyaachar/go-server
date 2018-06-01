FROM ubuntu:16.04
RUN apt-get update && apt-get install -y apt-transport-https && apt-get install curl -y
RUN echo "deb https://download.gocd.org /" | tee /etc/apt/sources.list.d/gocd.list
RUN curl https://download.gocd.org/GOCD-GPG-KEY.asc | apt-key add - 
RUN apt-get update && apt-get install -y default-jre openssl apache2-utils
RUN apt-get install go-server
COPY resources /resources/
COPY /resources/entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
#COPY cruise-config.xml /etc/go/

ENV GOCD_HTTP_PORT=8153 \
    GOCD_HTTPS_PORT=8154 \
    GOCD_BASE_URL='' \
    LDAP_BIND_DN=""  \
    LDAP_BIND_PASSWORD=""  \
    LDAP_AUTH_PROTOCOL=ldap \
    LDAP_ENABLED=true \
    LDAP_URL="" \
    LDAP_PORT=389 \
    LDAP_USER_BASE_DN=ou=people,dc=ldap,dc=example,dc=com
    
EXPOSE $GOCD_HTTP_PORT $GOCD_HTTPS_PORT
ENTRYPOINT ["/resources/entrypoint.sh", "run"]


