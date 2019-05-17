# rstudio-docker-tutorial

This is a repository for the May 2019 tutorial on using docker for rstudio at INGH.

## Launch a docker!

We will dive right in. On `la-forge` you can launch a docker like so:

```sh
docker run -d -e PASSWORD=<pick-a-password> -p 721x:8787 rocker/tidyverse
```

You will need to pick a port & password for your container.

Then go to that port on la-forge using your web-browser: http://la-forge.mssm.edu:721x 

& login with 

   - user: `rstudio`
   - password: (the-password-you-picked)

Take a look around to see what is going on. (Hint: install a package; look at the terminal)

#### What happened behind the scenes?

![diagram of docker operations](https://user-images.githubusercontent.com/923453/57944788-1264a200-78a6-11e9-8da2-807f5600d20e.png)

#### References

   - [github repo](https://github.com/rocker-org/rocker-versioned) with these & similar docker images
   - [readme](https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/README.md) on using Rstudio images
   - [rocker.org wiki](https://github.com/rocker-org/rocker/wiki) with more info

## Practical considerations

**Mounting disks to your container**

```sh
docker run -d -e PASSWORD=<pick-a-password> -p 721x:8787 \
  -v $(pwd):/home/${USER}/projects \
  -v /data2/projects:/data2/projects:ro \
  -e USER=${USER} \
  -e USERID=${UID} \
  -e GROUPID=${UID} \
  --name my-container \
  rocker/tidyverse
```

Gotchas:
   - permissions!
   
**manipulating containers**

1. `docker ps [-a]`: list running containers (-a: list all containers including stopped containers)
2. `docker start` & `docker stop`: start & stop a running container
3. `docker rm`: remove (ie delete) a container
4. `docker snapshot`: create an image from a container
5. `docker logs`: see logs for a (probably running) container
6. `docker stats [image(s)..]`: see stats (io, cpu, mem%, etc) for a container

## Using docker-compose

Docker-compose is a command-line tool that makes launching dockers more streamlined.

To use docker-compose:

1. [Install docker-compose](https://docs.docker.com/compose/install/) for your user account.
    ```sh
    curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o ~/bin/docker-compose
    chmod u+x ~/bin/docker-compose
    ```
   **Test** this: `which docker-compose`
2. Edit the `.env` file to include your userid & a unique port
    ```sh
    vim .env
    ```
    **Test** this: `docker-compose config`
3. Launch the docker(s) according to the yml settings
   ```sh
   docker-compose up
   ```

**An explanation:**

The containers for a project are described in a `docker-compose.yml` file. There is an [the example docker-compose.yml](docker-compose.yml) in this repo that mirrors the `docker run` command given above.

This file contains environment variables, provided as `${VARIABLE}`. Generally these are project-specific; they are defined in the `.env` file also included in this repo. For some reason, the `${UID}` variable available globally isn't reflected in this config.

To test a configuration, type:
```sh
docker-compose config
```

This will display & reformat the `docker-compose.yml` file according to your environment variables

## Customize your image

I have set up an example Dockerfile building on the `rocker/tidyverse` image here for you to play with, in the [custom-dockerfile branch](https://github.com/DudleyLab/rstudio-docker-tutorial/tree/custom-dockerfile) of this repo.

Let's change to this branch now so we can test it out

```sh
git checkout custom-dockerfile
``` 

Review the text of the [example Dockerfile](https://github.com/DudleyLab/rstudio-docker-tutorial/blob/custom-dockerfile/Dockerfile). 

This is a Dockerfile from an actual project, to illustrate how to do common things when building on the rocker.org images.

There are a couple of changes between this branch & the master branch. 

1. I have included a [`.dockerignore`](https://github.com/DudleyLab/rstudio-docker-tutorial/blob/7dd80c4be4888face3476397c0532660797ea8bf/.dockerignore) file. This tells docker that most files in the repo are irrelevant to the docker image, except `install.R`. 
    - If I didn't have this file, docker would build the image correctly, but it would not cache layers from earlier builds.
    - See [this reference](https://codefresh.io/docker-tutorial/not-ignore-dockerignore/) for more details 
2. I have included a skeleton [`install.R`](https://github.com/DudleyLab/rstudio-docker-tutorial/blob/7dd80c4be4888face3476397c0532660797ea8bf/install.R) file.
    - This could do anything you can code in R.
    - I use it to download data from GEO &/or to install a local package if I'm developing one.
    - Note also that this file is marked to not be ignored in the `.dockerignore` file. Editing the file will force the image to be rebuilt when you do `docker-compose up` or `docker build .`.
        ```
        !install.R
        ```
3. I have edited the `docker-compose.yml` file to include the following line:
    ```
    build: .
    ```
    - This tells the docker-compose to an image built from this Dockerfile rather than the `rocker/tidyverse` image.

#### Actually build the image

You can build the image whether you use docker-compose or not. 

Using docker-compose, any of the following:

```sh
docker-compose build         # _just_ build the image
docker-compose up            # build image if not exists & run container
docker-compose up --build    # force-build image & run container
```

Using docker, one of the following:

```sh
docker build .
docker built -t [image-name] .
```


