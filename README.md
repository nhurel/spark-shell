# Spark-shell
This Dockerfile builds an image that can run a spark shell.
To be really useful, you will need to mount a directory containing your data files, that's why the container exposes a volume in /spark-data.

# Usage
## Build and tag the image
```bash
docker build -t spark-shell
```

## Run container
```bash
docker run --rm -it -v `pwd`:/spark-data spark-shell
```

## And start to play
In your container, you can run spark command :
```java
val people = sqlContext.jsonFile("people.json")
people.printSchema()
people.registerTempTable("people")
sqlContext.sql("SELECT name FROM people WHERE age >= 13 AND age <= 19").show()
```

# Alias
For convenience, you can define the following alias in your `/etc/bash_aliases` file :
```bash
alias spark-shell='docker run --rm -it -v `pwd`:/spark-data spark-shell'
```
