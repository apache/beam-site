---
layout: default
title: "Beam Quickstart"
permalink: /use/quickstart/
redirect_from: /getting-started/
---

# Apache Beam Java SDK Quickstart 

Run your first Beam pipeline to count words in a set of files. 

* TOC
{:toc}


## Set up your Development Environment
 
1. Download and install the [Java Development Kit (JDK)](http://www.oracle.com/technetwork/java/javase/downloads/index.html) version 1.7 or later. Verify that the [JAVA_HOME](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/envvars001.html) environment variable is set and points to your JDK installation.

1. Download and install [Apache Maven](http://maven.apache.org/download.cgi) by following Maven's [installation guide](http://maven.apache.org/install.html) for your specific operating system.


## Get the WordCount Code

The easiest way to get a copy of the WordCount pipeline is to use the following command to generate a simple maven project that contains Beam's WordCount examples and builds against the most recent Beam release: 

```
$ mvn archetype:generate \
      -DarchetypeArtifactId=beam-sdks-java-maven-archetypes-examples \
      -DarchetypeVersion=LATEST \
      -DarchetypeGroupId=org.apache.beam \
      -DgroupId=org.example \
      -DartifactId=word-count-beam \
      -Dversion="0.1" \
      -DinteractiveMode=false \
      -Dpackage=org.apache.beam.examples
```

This will create a directory `word-count-beam` that contains a simple pom file and series of example pipelines that count words in text files. 

```
$ cd beam-word-count/

$ ls
pom.xml	src

$ ls src/main/java/org/apache/beam/examples/
DebuggingWordCount.java	WindowedWordCount.java	common
MinimalWordCount.java	WordCount.java
```

For a detailed introduction to the Beam concepts used in these examples, see the [WordCount Example Walkthrough](/use/wordcount-example). 


## Run WordCount

A single Beam pipeline can run on multiple Beam [runners](/learn/runners), including [Spark](/learn/runners/spark), [Flink](/learn/runners/flink), or [Dataflow](/learn/runners/dataflow). The [DirectRunner](/learn/runners/direct) is a common runner for getting started, as it runs locally on your machine and requires no specific setup.

After you've chosen which runner you'd like to use:

1. Ensure you've done any runner-specific setup.
1. Build your commandline by:
   1. Specifying a specific runner with `--runner=<runner>` (defaults to the [DirectRunner](/learn/runners/direct))
   1. Adding any runner-specific required options 
   1. Choosing input files and an output location are accessible on the chosen runner. (For example, you can't access a local file if you are running the pipeline on an external cluster.)
1. Run your first WordCount pipeline.

_([BEAM-902](https://issues.apache.org/jira/browse/BEAM-902): Make these instructions toggle neatly instead of in long lists.)_

1.  Direct Runner

	```
	$ mvn compile exec:java -Dexec.mainClass=org.apache.beam.examples.WordCount \
	     -Dexec.args="--inputFile=pom.xml --output=counts"
	```

1.  Apache Flink Runner

	``` 
	TODO BEAM-899
	```

1.  Apache Spark Runner

	```
	TODO BEAM-900
	```

1.  Cloud Dataflow Runner

	```
	$ mvn compile exec:java -Dexec.mainClass=org.apache.beam.examples.WordCount \
		 -Dexec.args="--runner=DataflowRunner --gcpTempLocation=gs://<your-gcs-bucket>/tmp \
		              --inputFile=gs://apache-beam-samples/shakespeare/* --output=gs://<your-gcs-bucket>/counts"
	```


## Inspect the results

Once the pipeline has completed, you can view the output. You'll notice that there will be multiple output files prefixed by `count`. The exact number of these files is decided by the runner, giving it the flexibility to do efficient, distributed execution.

1.  Direct Runner

	```
	$ ls counts*
	```

1.  Apache Flink Runner

	``` 
	TODO BEAM-899
	```

1.  Apache Spark Runner

	```
	TODO BEAM-900
	```


1.  Cloud Dataflow Runner

	```
	$ gsutil ls gs://<your-gcs-bucket>/counts*
	```
	
When you look into the contents of the file, you'll see that they contain unique words and the number of occurrences of each word. The order of elements within the file may differ because the Beam model does not generally guarantee ordering, again to allow runners to optimize for efficiency.
	
1.  Direct Runner
 
	```
	$ more counts*
	api: 9
	bundled: 1
	old: 4
	Apache: 2
	The: 1
	limitations: 1
	Foundation: 1
	...
	```

1.  Apache Flink Runner

	``` 
	TODO BEAM-899
	```

1.  Apache Spark Runner

	```
	TODO BEAM-900
	```

1.  Cloud Dataflow Runner

	```
	$ gsutil cat gs://<your-gcs-bucket>/counts*
	feature: 15
	smother'st: 1
	revelry: 1
	bashfulness: 1
	Bashful: 1
	Below: 2
	deserves: 32
	barrenly: 1
	...
	```
	
## Next Steps

* Learn more about these WordCount examples in the [WordCount Example Walkthrough](/use/wordcount-example).
* Dive in to some of our favorite [articles and presentations](/learn/resources).
* Join the Beam [mailing lists](/use/mailing-lists).
	