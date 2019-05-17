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
  Test this by typing: `which docker-compose`
2. Edit the `.env` file to include your userid & a unique port
  ```sh
  vim .env
  ```
  Test this by typing: `docker-compose config`
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

There are, generally, two ways to customize an image depending on your needs & save those customizations for posterity.

1. Launch a container (ie tidyverse), install packages and/or modify the container, & snapshot.
2. Edit the Dockerfile & re-build the image with your edits. (then re-launch the container & proceed with analysis).

I have set up an example of the second scenario here for you to play with, in the Dudleylab/rstudio-docker-tutorial@custom-dockerfile branch. Type `git checkout custom-dockerfile` to change to this branch.

Take a look at this [example Dockerfile](https://github.com/DudleyLab/rstudio-docker-tutorial/blob/custom-dockerfile/Dockerfile). Note that this is a Dockerfile from an actual project, to illustrate how to do common things when building on the rocker.org images.

