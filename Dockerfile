FROM ssetong/jdk
MAINTAINER SSETong <ssetonggithub@163.com>

# Prepare environmen
ENV TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.0.50 \
    TOMCAT_WORKDIR=/tomcat \
    TOMCAT_BASE=/opt/tomcat \
    TOMCAT_OUT=/dev/null \
    CATALINA_HOME=/opt/tomcat/latest \
    ADMIN_PASS="" \
    CERT_PASS=""
# Add Tomcat Setting Files
ADD /src/ /tmp/
ADD run.sh /root/run.sh

# Install Tomcat
RUN cd tmp && yum -y install epel-release && yum -y install pwgen && \
    wget -O tomcat.tar.gz --no-check-certificate -c http://mirrors.hust.edu.cn/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mkdir -p ${TOMCAT_BASE} && cd ${TOMCAT_BASE} && \
    tar -zxvf /tmp/tomcat.tar.gz -C ./ && ln -sf apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    mkdir -p ${TOMCAT_WORKDIR}/conf && cp -rRv ${CATALINA_HOME}/conf ${TOMCAT_WORKDIR}/ && rm -rf ${CATALINA_HOME}/conf && ln -sf ${TOMCAT_WORKDIR}/conf ${CATALINA_HOME}/conf && \
    mkdir -p ${TOMCAT_WORKDIR}/logs && cp -rRv ${CATALINA_HOME}/logs ${TOMCAT_WORKDIR}/ && \
    mkdir -p ${TOMCAT_WORKDIR}/webapps && cp -rRv ${CATALINA_HOME}/webapps ${TOMCAT_WORKDIR}/ && rm -rf ${CATALINA_HOME}/webapps && ln -sf ${TOMCAT_WORKDIR}/webapps ${CATALINA_HOME}/webapps && \
    mkdir -p ${TOMCAT_WORKDIR}/temp && cp -rRv ${CATALINA_HOME}/temp ${TOMCAT_WORKDIR}/ && rm -rf ${CATALINA_HOME}/temp && ln -sf ${TOMCAT_WORKDIR}/temp ${CATALINA_HOME}/temp && \
    rm -rf ${CATALINA_HOME}/conf/tomcat-users.xml && \
    rm -rf ${CATALINA_HOME}/conf/logging.properties && cp /tmp/logging.properties ${CATALINA_HOME}/conf/logging.properties && \
    rm -rf ${CATALINA_HOME}/conf/server.xml && cp /tmp/server.xml ${CATALINA_HOME}/conf/server.xml && \
    yum clean all && rm -rf /tmp/* && \
    cd ~/ && chmod +x ~/run.sh && \
    cp -rRv ${TOMCAT_WORKDIR} ${TOMCAT_WORKDIR}bak


#COPY resolv.conf /resolv.conf
#RUN printf "cp -rf /resolv.conf /etc/resolv.conf" >> /etc/rc.local
#RUN chmod +x /etc/rc.local
#
#
#CMD ["/etc/rc.local"]
#EXPOSE 8080
#CMD ["catalina.sh", "run"]
WORKDIR ${TOMCAT_WORKDIR}
# VOLUME ["${TOMCAT_WORKDIR}/logs", "${TOMCAT_WORKDIR}/webapps", "${TOMCAT_WORKDIR}/temp", "${TOMCAT_WORKDIR}/conf"] 
VOLUME /tomcat/logs
VOLUME /tomcat/webapps
VOLUME /tomcat/temp
VOLUME /tomcat/conf
EXPOSE 8080 8443

CMD ["/bin/bash"]

ENTRYPOINT ["/bin/bash", "/root/run.sh"]
