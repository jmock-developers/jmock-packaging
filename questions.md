# Questions / Discussion Points

1. Looks like the `jmock-library` is geared up to manually build and tag a release (using the scripts files). Interestingly, this is still geared up for Subversion on Codehaus and not Github. _Are these to be moved over to Git?_

1. _How do we get the artifacts onto `jmock.org/dist` folder?_ As part of the step above? In the Groovy script / `download-jars.sh`, we attempt to download artifacts from here.

1. We push artifacts to `https://dav.codehaus.org/repository/jmock/` authenticated using WebDAV. _Would you prefer to publish to Github / remove all dependencies to Codehaus?_

1. There are dependencies on valid SSH credentials and WebDAV credentials, how do you want to handle this?

1. Hhow do you want to handle to current two-stage process? Would you prefer to take care of the build and publish from `jmock-library` and leave the Maven packaging in this project? Or redo the lot and aim for a single process?

1. The `jmock-packaging` project is separate from the `jmock-library`, so we don't get much from the Maven deploy process other than literally packaging and pushing to somewhere that Maven central can pick up. Not sure why `jmock-library` itself doesn't use Maven to be a more straight forward release / deploy process_.

1. Publishing to Codehaus is facilitating with the Wagon Maven plugin, its pretty old and last time I tried it was all kinds of crazy. It'll need some testing to see if it still works. Worst case, moving away from Codehaus to say OSS Sonatype is pretty straight forward. It's picked up by Maven central but does add some manual steps to the process (basically approval and promotion within their web interface). Might be worth considering at some point.