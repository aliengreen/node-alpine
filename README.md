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

```shell
apk search --update imagemagick
```

or:

```shell
apk add --update make gcc g++ python linux-header
```



## New Release

Container needs periodic maintenance to update Alpine Linux or update NodeJS. For that we need to make changes in the Dockerfile for a specific version of Alpine Linux or NodeJS. 

 - Alpine Linux update - you should make manual change in the Dockerfile. e.g. `FROM alpine:3.6` can be replaced with a newer version `FROM alpine:3.17`
 - NodeJS update - For that we can use `release.sh` script by invoking termninal command:

 ```shell
 $ ./release.sh v18.16.0
 ```

> Where `v18.16.0` is a NodeJS version number

If command execution is done without errors you can see 4 new tags: `18.16.0`, `18.16.0-runit`, `18.16` and `18.16-runit`. 

> Note: The `release.sh` script first removes old tags from GitHub and then recreates new ones. So, if the tags with above names already exist it will be removed, but it OK, don't panic.



## License

[MIT](LICENSE)

