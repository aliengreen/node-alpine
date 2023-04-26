# node-alpine

[![Docker Hub Link][docker-img]][docker-url]

Alpine-Linux-based, tiny Docker-container for NodeJS. This is really small image compare around [60MB](https://hub.docker.com/r/aliengreenllc/node-alpine/tags/) of this container with typical 500MB to 800MB sizes you get with Ubuntu- or CentOS-based images.



## Using

Insert at the top of your Dockerfile:

```
FROM aliengreenllc/node-alpine:20-alpine3.17
```

To see all supported versions: <https://hub.docker.com/r/aliengreen/node-alpine/tags/>



## Adding More Packages (if needed)

If you need more packages installed (e.g. make, gcc for compiling some native Node modules, or imagemagick etc.) base your new container on this one and you can use `apk` package manager that Alpine provides. For instance:

```shell
RUN apk search --update imagemagick
```

or:

```shell
RUN add --update make gcc g++ python linux-header
```



## New Release

Container needs periodic maintenance to update Alpine Linux or NodeJS. For that we need to make changes in the Dockerfile for a specific version of Alpine Linux or NodeJS. The script also builds Docker image by given tag. So, follow the `release.sh` script steps.

 - Alpine Linux-NodeJS update - We are using `release.sh` script by invoking termninal command:

 ```shell
 $ ./release.sh --tag 20-alpine3.17
 ```

> Where `20-alpine3.17` is a NodeJS Docker official image tag name.

If command execution is done without errors you can see new tag: `20-alpine3.17`, by running command `git tag`

> Note: The `release.sh` script first removes old tag from GitHub and then recreates new one. So, if the tag with above name already exist it will be removed, but it OK, don't panic.

If you need fast search for official NodeJS tag you can invoke `release.sh` script with specific argument:

```shell
$ ./release.sh --tag 20-
```

Tag names organised as follows: first number `20` is a NodeJS version number and last `3.17` is Alpine-Linux version number.

### Useful commands

```shell
$ docker build -t aliengreenllc/node-alpine:20-alpine3.17 .
$ docker run -t aliengreenllc/node-alpine:20-alpine3.17
$ docker push aliengreenllc/node-alpine:20-alpine3.17

$ docker compose up -d --force-recreate --no-deps name
$ docker exec -it name sh

$ docker compose logs -f name
$ docker history name
```





## License

[MIT](LICENSE)

[docker-img]: https://img.shields.io/badge/docker-ready-blue.svg
[docker-url]: https://hub.docker.com/r/aliengreenllc/node-alpine