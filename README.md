# fuseki-hdt-docker

Docker image using Apache Jena's [Fuseki](https://jena.apache.org/documentation/fuseki2/) triplestore 
to serve the contents of an [RDF HDT](https://www.rdfhdt.org) file.

## Deployment

To deploy the container and serve the default RDF HDT file the container includes, just use the following Docker command
and Fuseki will be available on port `3030`:

````shell
docker run -p 3030:3030 rogargon/fuseki-hdt-docker:latest
````

To serve a local file `swdf-2012-11-28.hdt`, which should be mounted instead of the default `/opt/fuseki/dataset.hdt`:

```shell
docker run -p 3030:3030 -v $(pwd)/swdf-2012-11-28.hdt:/opt/fuseki/dataset.hdt:ro rogargon/fuseki-hdt-docker:latest
```

Alternatively, you can also use docker-compose:

```shell
version: '3'
services:
    fuseki-hdt:
        image: 'rogargon/fuseki-hdt-docker:latest'
        ports:
            - '3030:3030'
        volumes:
            - './swdf-2012-11-28.hdt:/opt/fuseki/dataset.hdt:ro'
```

## Usage

After successful deployment, Fuseki will be available from port `3030` providing different endpoint. 
For instance, if deployed on `localhost`:

* http://localhost:3030/dataset/sparql for SPARQL Query
  * The RDF HDT data is available from the *default graph* and can be queried with any SPARQL client,
    or using `curl`:

```shell
curl -X POST localhost:3030/dataset/sparql \
     -d "query=SELECT DISTINCT ?class (COUNT(?i) AS ?count) WHERE { ?i a ?class } GROUP BY ?class ORDER BY DESC(?count)" 
````

* http://localhost:3030/dataset/get for Graph Store (read-only)
  * Browse that URL to retrieve all stored data, or using `curl`:
  
````shell
curl localhost:3030/dataset/get
````
