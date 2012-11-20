# jmock-packaging

Maven packaging for JMock

## Release Instructions (Maven 2)

The parent pom supports two profiles; `jmock1` and `jmock2`. The profile determines which artifacts are part of the release.

### Snapshot Build

    mvn -Pprofile install

where `profile` is either `jmock1` or `jmock2`

### Release Proper

    mvn -Pprofile release:prepare

The maven release plugin will interactively ask to replace the snapshot version with the appropriate version and create an SCM tag with the snapshots resolved.

    mvn -Pprofile release:perform


### Distribution Management

We're using Codehaus as the target for the deployment, it should periodically get [picked up by Maven Central](https://maven.apache.org/guides/mini/guide-central-repository-upload.html#Publishing_your_artifacts_to_the_Central_Repository). The physical upload is facilitates with the Wagon plugin and we're using WebDAV.

See [this article](http://docs.codehaus.org/display/MAVENUSER/Deploying+3rd+Party+Jars+With+WebDAV).