# node-alpine

[![Docker Hub Link][docker-img]][docker-url]

Alpine-Linux-based, tiny Docker-container for Node, striving for perfection. The original version is developed by Irakli Nadareishvili, but it no longer maintenanced. You can see original version [here](https://github.com/inadarei/node-alpine)

Compare [25MB](https://hub.docker.com/r/irakli/node-alpine/tags/) of this container with typical 500MB to 800MB sizes you get with Ubuntu- or CentOS-based images.

### Runit Support

In most production deployments we would like a process monitor to restart our node service if it ever shuts down. On Alpine Linux such lightweight process monitor is: [runit](http://smarden.org/runit/), which you can install by using one of the *-runit tagged builds.



## Using

Insert at the top of your Dockerfile:

```
FROM aliengreen/node-alpine:node18.6.0-alpine3.17-runit
```

To see all supported versions: <https://hub.docker.com/r/aliengreen/node-alpine/tags/>



## Adding More Packages (if needed)

If you need more packages installed (e.g. make, gcc for compiling some native Node modules, or imagemagick etc.) base your new container on this one and you can use `apk` package manager that Alpine provides. For instance:

```
apk search --update imagemagick
```

or:

```
apk add --update make gcc g++ python linux-header
```



## License

[MIT](LICENSE)

[docker-img]: https://img.shields.io/badge/docker-ready-blue.svg
[docker-url]: https://hub.docker.com/r/aliengreen/node-alpine/
