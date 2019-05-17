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
   - password: <the-password-you-picked>

Take a look around to see what is going on.

#### References

   - [github repo](https://github.com/rocker-org/rocker-versioned) with these & similar docker images
   - [readme](https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/README.md) on using Rstudio images
   - [rocker.org wiki](https://github.com/rocker-org/rocker/wiki) with more info

## Practical considerations

1. Mounting disks to your container
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

## Using docker-compose

## Customize your image

See an example Dockerfile in this repo 

