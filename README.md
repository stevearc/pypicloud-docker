Pypicloud Docker
================

This is a docker container for running pypicloud. To test pypicloud and see it
working, run this command:

```
docker run -it --rm -p 8080:8080 stevearc/pypicloud
```

This will start pypicloud with default settings inside the docker container.
You can visit the site by going to http://localhost:8080. The default settings
are sufficient to play with, but they should not be used in production.

You can access the `pypicloud-make-config` command from the docker image, which
will give you a decent starting template customized for your use.

```
docker run -it --rm stevearc/pypicloud make-config
```

The config file in the container is located at `/etc/pypicloud/config.ini`. To
use your own config file, mount it as a volume.

```
docker run -p 8080:8080
    -v /path/to/my/config.ini:/etc/pypicloud/config.ini:ro
    stevearc/pypicloud
```

See the [list of configuration
options](http://pypicloud.readthedocs.org/en/latest/topics/configuration.html)
for details about the config file.
