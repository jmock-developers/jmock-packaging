# jmock-packaging

Maven packaging for JMock

## Release Overview

JMock is organised into two modules, [jmock-library](https://github.com/jmock-developers/jmock-library) and [jmock-packaging](https://github.com/jmock-developers/jmock-packaging) (this project). The main module is responsible for building deployment artifacts. The packaging project is just responsible for collecting these, packaging them (and creating `pom`s) and publishing  to a Maven repository. It doesn't actually "build" any source or execute any tests.

The general process for deploying new versions is

1. Tag release version in Subversion
1. Run the `release.sh` script from [jmock-library](https://github.com/jmock-developers/jmock-library), it will export the tag from Subversion, build it (using the `build.xml` Ant script) and SCP artifacts to a remote location (www.jmock.org:/home/jmock/public_dist)
1. You need to somehow make these artifacts available at `http://jmock.org/dist` (subsequent packaging steps require this).
1. Package and publish the artifacts created above using this project.


## Packaging and Publishing Procedure

### Prerequisites

Because the source projects aren't part of this packaging project, the source has to be retrieved before we can package it. Currently, this is done by an embedded Groovy script which attempts to download artifacts as part of the Maven build. It attempts to download artifacts from [http://jmock.org/dist](http://jmock.org/dist). It seems to be platform specific as it has problems on Windows.

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

We're using Codehaus as the target for the deployment, it should periodically get [picked up by Maven Central](https://maven.apache.org/guides/mini/guide-central-repository-upload.html#Publishing_your_artifacts_to_the_Central_Repository). The physical upload is facilitated by the Wagon plugin and we're using WebDAV.

See [this article](http://docs.codehaus.org/display/MAVENUSER/Deploying+3rd+Party+Jars+With+WebDAV).


### Misc

[Questions](jmock-packaging/blob/master/questions.md)