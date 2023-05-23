We provide a docker image with PhosMap: https://hub.docker.com/r/liuzandh/phosmap

Pull the docker image of PhosMap:
```linux
docker pull liuzandh/phosmap:1.0.0
```
Create a docker container containing PhosMap:

```linux
docker run  -p HostPort:3838 liuzandh/phosmap:1.0.0
```
Then, you can enter PhosMap by visiting `HostIP:HostPort/PhosMap`.

For example: HostPort could be set to 8083. This parameter can be changed according to user needs. 
such as,
```linux
docker run -p 8083:3838 liuzandh/phosmap:1.0.0
```
Next, open `127.0.0.1:8083/PhosMap` in the local browser or `remotely access ip:8083/PhosMap` (you should ensure that the machine can be accessed remotely).