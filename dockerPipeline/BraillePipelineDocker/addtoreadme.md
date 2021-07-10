# README.md for Docker Pipelines

## Run docker image as a container (gives  random funky names)

```zsh
docker run -ti --mount type=bind,source=c:/users/ryan/WORKDIR,destination=/home/foo -w /home/foo hunsakerconsultng/uebtranscriptionpiepline
```

## Create a docker container with a name I like and will be consistent (also pulls any updates to the image every time it is opened)

```zsh
create -ti --name UEBtranscriptionpipeline --pull always --mount type=bind,source=c:/users/ryan/WORKDIR,destination=/home/foo -w /home/foo hunsakerconsultng/uebtranscriptionpiepline
```

## Start my docker container with the image and an active X-Server for visualizations

```ps
# Requires an X-server such as VcXsrv to be running on the host computer 

# Powershell code to get ipv4 address into the variable $DISPLAY

$ipv4Address = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress

set-variable -name DISPLAY -value $ipv4Address

docker run --rm -e -ai DISPLAY=$DISPLAY uebtranscriptionpipeline
```

```zsh
docker start -ai UEBtranscriptionpipeline
```
## Start my docker container with the image 

```zsh
docker start -ai UEBtranscriptionpipeline
```

## Open another terminal prompt and type this to stop the container

```zsh 
docker stop UEBtranscriptionpipeline
```