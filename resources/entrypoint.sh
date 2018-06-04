#! bin/bash
/etc/init.d/go-server start
if [[ ${LDAP_ENABLED} == "true" ]]; then
  GOCD_LDAP_CONFIG="   <security>
      <authConfigs>
        <authConfig id=\"ldap_authentication\" pluginId=\"cd.go.authentication.ldap\">
          <property>
            <key>Url</key>
            <value>${LDAP_AUTH_PROTOCOL}://${LDAP_URL}:${LDAP_PORT}</value>
          </property>
          <property>
            <key>ManagerDN</key>
            <value>${LDAP_BIND_DN}</value>
          </property>
          <property>
            <key>Password</key>
            <value>${LDAP_BIND_PASSWORD}</value>
          </property>
          <property>
            <key>SearchBases</key>
            <value>${LDAP_USER_BASE_DN}</value>
          </property>
          <property>
            <key>UserLoginFilter</key>
           <value>uid={0}</value>
	 </property>
          <property>
            <key>UserSearchFilter</key>
          <value /> 
	 </property>
          <property>
            <key>DisplayNameAttribute</key>
            <value>cn</value>
          </property>
          <property>
            <key>EmailAttribute</key>
            <value>mail</value>
          </property>
        </authConfig>
      </authConfigs>
    </security>"
fi

cat > /resources/cruise-config.xml << EOFM
<?xml version="1.0" encoding="utf-8"?>
<cruise xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="cruise-config.xsd" schemaVersion="108">
<server siteUrl="${GOCD_BASE_URL}">
${GOCD_LDAP_CONFIG}
</server>
</cruise>
EOFM

cp -arf /resources/cruise-config.xml /etc/go/cruise-config.xml
#/etc/init.d/go-server start
#htpasswd -b -B -c /etc/go/authentication admin admin
#htpasswd -b -B  /etc/go/authentication user1 user1 
#/etc/init.d/go-server restart



tail -f /var/log/go-server/go-server.log
