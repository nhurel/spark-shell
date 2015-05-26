FROM ubuntu:14.04

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu/ precise main" > /etc/apt/sources.list.d/java.list && \
    echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    apt-get update && \
    apt-get install -y oracle-java8-installer curl maven

RUN mkdir /opt/spark 
WORKDIR /opt/spark
ENV SPARK_VERSION 1.3.1
RUN curl -L http://apache.websitebeheerjd.nl/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz > spark.tgz && tar -xvzf spark.tgz
WORKDIR /opt/spark/spark-$SPARK_VERSION
RUN mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -Phive -Phive-thriftserver -DskipTests clean package

RUN cp /opt/spark/spark-$SPARK_VERSION/conf/log4j.properties.template /opt/spark/spark-$SPARK_VERSION/conf/log4j.properties && \
    sed -i 's/rootCategory=INFO/rootCategory=WARN/' /opt/spark/spark-$SPARK_VERSION/conf/log4j.properties

VOLUME /spark-data
WORKDIR /spark-data
ENTRYPOINT /opt/spark/spark-$SPARK_VERSION/bin/spark-shell
