# sbt-cli-taskkeys-mwe

This repository demonstrates a bug in the CLI behavior of SBT 1.x

## TL/DR

SBT 2.x introduces a new semicolon-delimited syntax for multi-task invocations;
however, whitespace-delimited invocations should still work in 1.x.
This reproducer shows that a freshly installed SBT 1.x fails on whitespace-delimited invocations.

## Steps

First, build the Docker image:

```shell
docker build -f Dockerfile -t sbt-cli-taskkeys-mwe .
```

Then run the image:

```shell
$ docker run -it -u 1000 -v .:/workspace/sbt-cli-taskkeys-cli --entrypoint='' sbt-cli-taskkeys-mwe:latest bash

ubuntu# eval "$(cs setup --yes --env --apps sbt)"
ubuntu# cd /workspace/sbt-cli-taskkeys-cli
ubuntu# sbt clean compile
```

## Expected behavior

SBT compiles (producing no output because there are no classes to compile)

## Actual behavior

```shell
ubuntu@4f7036d381e1:/workspace/sbt-cli-taskkeys-mwe$ sbt clean compile 
[info] server was not detected. starting an instance
[info] welcome to sbt 1.12.12 (Eclipse Adoptium Java 21.0.8)
[info] loading project definition from /workspace/sbt-cli-taskkeys-mwe/project
[info] loading settings for project root from build.sbt...
[info] set current project to sbt-cli-taskkeys-mwe (in build file:/workspace/sbt-cli-taskkeys-mwe/)
[info] sbt server started at local:///home/ubuntu/.sbt/1.0/server/a42ba94863397e9122da/sock
[info] started sbt server
[error] Expected whitespace character
[error] Expected '/'
[error] clean compile
[error]       ^
[error] elapsed time: 0 s
```

## Notes
The `sbt` binary is actually a shell script provided by Coursier:
```shell
ubuntu@4f7036d381e1:/workspace/sbt-cli-taskkeys-mwe$ sbt --version
sbt runner version: 2.0.0

[info] sbt runner (sbt-the-shell-script) is a runner to run any declared version of sbt.
[info] Actual version of the sbt is declared using project/build.properties for each build.

ubuntu@4f7036d381e1:/workspace/sbt-cli-taskkeys-mwe$ readlink -f $(which sbt)
/home/ubuntu/.local/share/coursier/bin/sbt
```
