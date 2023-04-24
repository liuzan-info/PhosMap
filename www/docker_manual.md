We provide a docker image with PhosMap: https://hub.docker.com/r/liuzandh/phosmap

Pull the docker image of PhosMap:
```linux
docker pull liuzandh/phosmap:0.1
```
Create a docker container containing PhosMap:

```linux
docker run -p HostPort:8787 -e PASSWORD=123456 liuzandh/phosmap:0.1
```
Then, you can enter PhosMap by visiting HostIP:HostPort. Username is "rstudio", Password is "123456". For example: HostPort could be set to 5907. This parameter can be changed according to user needs. 
such as,
```linux
docker run -p 5907:8787 -e PASSWORD=123456 liuzandh/phosmap:0.1
```
Next, open 127.0.0.1:5907 in the local browser or remotely access ip:5907 (you should ensure that the machine can be accessed remotely).