FROM java:8-jre-alpine

MAINTAINER Roberto García <https://rhizomik.net/~roberto>

ARG MAVEN_REPO=http://insecure.repo1.maven.org/maven2
ARG FUSEKI_VERSION=3.17.0
ARG RDFHDT_VERSION=2.1.2

ENV FUSEKI_JAR=${MAVEN_REPO}/org/apache/jena/jena-fuseki-server/${FUSEKI_VERSION}/jena-fuseki-server-${FUSEKI_VERSION}.jar
ENV HDTAPI_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-api/${RDFHDT_VERSION}/hdt-api-${RDFHDT_VERSION}.jar
ENV HDTCORE_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-java-core/${RDFHDT_VERSION}/hdt-java-core-${RDFHDT_VERSION}.jar
ENV HDTJENA_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-jena/${RDFHDT_VERSION}/hdt-jena-${RDFHDT_VERSION}.jar

RUN mkdir -p /opt/fuseki
WORKDIR /opt/fuseki

RUN wget -O fuseki-server.jar $FUSEKI_JAR && \
    wget -O hdt-api.jar $HDTAPI_JAR && \
    wget -O hdt-java-core.jar $HDTCORE_JAR && \
    wget -O hdt-jena.jar $HDTJENA_JAR

ADD config-hdt.ttl .
ADD dataset.hdt .

VOLUME /opt/fuseki/

EXPOSE 3030

ENTRYPOINT [ "java", "-cp", "fuseki-server.jar:hdt-api.jar:hdt-java-core.jar:hdt-jena.jar", "org.apache.jena.fuseki.main.cmds.FusekiMainCmd", "--config=config-hdt.ttl" ]
