# jmock-packaging

Maven packaging for JMock

## Release Overview

JMock is organised into two modules, [jmock-library](https://github.com/jmock-developers/jmock-library) and [jmock-packaging](https://github.com/jmock-developers/jmock-packaging) (this project). The main module is responsible for building deployment artifacts. The packaging project is just responsible for collecting these, packaging them (and creating `pom`s) and publishing to a Maven repository. It doesn't actually "build" any source or execute any tests.

The general process for deploying new versions is

1. Tag release version in Subversion
1. Run the `release.sh` script from [jmock-library](https://github.com/jmock-developers/jmock-library), it will export the tag from Subversion, build it (using the `build.xml` Ant script) and SCP artifacts to a remote location (www.jmock.org:/home/jmock/public_dist)
1. You need to somehow make these artifacts available at `http://jmock.org/dist` (subsequent packaging steps require this).
1. Package and publish the artifacts created above using this project.

### Terminology

Just so that we're all talking the same language, some definitions of terms we use when talking about releasing.

   * __build__ : building a set of binary artifacts (.jar, javadoc etc) for deployment
   * __release__ : tagging a baseline in source control.
   * __deploy__ : distributing the _build artifacts_ to the internet
   * __packaging__ : specifically referring to creating the Maven packages for subsequent deployment (upload) to Maven central
   * __publishing__ : Maven equivalent of __deploy__; distribute the build artifacts to Maven central (indirectly)

Currently, __build__ and __release__ are the responsibility of the `jmock-library` project. The __deploy__ step is currently done by the `jmock-library` to make artifacts available for manual download via `jmock.org`. The __packaging__ and __publishing__ steps are the responsibility of the `jmock-packaging` project.


## Packaging and Publishing Procedure

### Prerequisites

Because the source projects aren't part of this packaging project, the source has to be retrieved before we can package it. Currently, this is done by an embedded Groovy script which attempts to download artifacts as part of the Maven build. It attempts to download artifacts from [http://jmock.org/downloads](http://jmock.org/dist). It seems to be platform specific as it has problems on Windows.

When it executes, it runs the `src/script/download-jars.sh` script, with options making it equivalent to

``` sh
./download-jars.sh http://jmock.org/downloads jmock-2.6.0-jars.zip target jmock-2.6.0
```

Make sure you change the following line in the `jmock2` profile of the parent `pom.xml` to reflect the release.

``` xml
<release.version>2.6.0</release.version>
```

### Maven Profiles

The parent pom supports two profiles; `jmock1` and `jmock2`. The profile determines which artifacts are part of the release.

### Snapshot Build

    mvn -Pprofile install

where `profile` is either `jmock1` or `jmock2`


### Release

Perform a sanity check

    mvn -Pprofile release:prepare -DdryRun=true

If it looks good, clean up after yourself

    mvn release:clean
    rm *.log

Then move onto the release proper

    mvn -Pprofile release:prepare

The maven release plugin will interactively ask to replace the snapshot version with the appropriate version and create an SCM tag with the snapshots resolved.

    mvn -Pprofile release:perform


### Distribution Management

We're using OSS Sonatype as the target for deployment, it should periodically get [picked up by Maven Central](https://maven.apache.org/guides/mini/guide-central-repository-upload.html#Publishing_your_artifacts_to_the_Central_Repository).

We're no longer using Codehaus and the nasty Wagon/WebDAV nonsense.