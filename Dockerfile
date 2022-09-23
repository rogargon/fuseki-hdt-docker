FROM openjdk:11

LABEL author="https://orcid.org/0000-0003-2207-9605"
LABEL contributor="https://orcid.org/0000-0002-0991-5771"

ARG MAVEN_REPO=https://repo1.maven.org/maven2
ARG FUSEKI_VERSION=4.6.1
ARG RDFHDT_VERSION=3.0.3
ARG JLARGE_VERSION=1.6

ENV FUSEKI_JAR=${MAVEN_REPO}/org/apache/jena/jena-fuseki-server/${FUSEKI_VERSION}/jena-fuseki-server-${FUSEKI_VERSION}.jar
ENV HDTAPI_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-api/${RDFHDT_VERSION}/hdt-api-${RDFHDT_VERSION}.jar
ENV HDTCORE_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-java-core/${RDFHDT_VERSION}/hdt-java-core-${RDFHDT_VERSION}.jar
ENV HDTJENA_JAR=${MAVEN_REPO}/org/rdfhdt/hdt-jena/${RDFHDT_VERSION}/hdt-jena-${RDFHDT_VERSION}.jar
ENV JLARGE_JAR=${MAVEN_REPO}/pl/edu/icm/JLargeArrays/${JLARGE_VERSION}/JLargeArrays-${JLARGE_VERSION}-with-dependencies.jar

RUN mkdir -p /opt/fuseki
WORKDIR /opt/fuseki

RUN wget -O fuseki-server.jar $FUSEKI_JAR && \
    wget -O hdt-api.jar $HDTAPI_JAR && \
    wget -O hdt-java-core.jar $HDTCORE_JAR && \
    wget -O hdt-jena.jar $HDTJENA_JAR && \
    wget -O jlargearrays.jar $JLARGE_JAR

ADD config-hdt.ttl .
ADD dataset.hdt .

VOLUME /opt/fuseki/

EXPOSE 3030

ENTRYPOINT [ "java", "-cp", "fuseki-server.jar:hdt-api.jar:hdt-java-core.jar:hdt-jena.jar:jlargearrays.jar", "org.apache.jena.fuseki.main.cmds.FusekiMainCmd", "--config=config-hdt.ttl" ]
