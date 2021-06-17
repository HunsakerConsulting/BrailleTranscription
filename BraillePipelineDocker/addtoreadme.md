
## Run docker image as a container (gives  random funky names)

```zsh
docker run -ti --mount type=bind,source=c:/users/ryan/WORKDIR,destination=/home/foo -w /home/foo mrhunsaker/transcriptionpipeline20210601:latest
```

## Create a docker container with a name I like and will be consistent (also pulls any updates to the image every time it is opened)

```zsh
create -ti --name UEBpipeline --pull always --mount type=bind,source=c:/users/ryan/WORKDIR,destination=/home/foo -w /home/foo mrhunsaker/transcriptionpipeline20210601
```

## Start my docker container with the image

```zsh
docker start -ai UEBtranscriptionpipeline
```
## Start my docker container with the image with an active X-Server

```zsh
docker start -ai UEBtranscriptionpipeline
```

## Open another terminal prompt and type this to stop the container

```zsh 
docker stop UEBtranscriptionpipeline
```