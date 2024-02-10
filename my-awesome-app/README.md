# My Awesome App

My Awesome App is an **_Astro Starter Kit: Basics_** project that we'll use as our base app to deploy and build.

It was created using the following command:
```sh
pnpm create astro@latest
```

## Docker

We'll use Docker to containerize our app and deploy it to a container registry, a Kubernetes cluster or in a local
environment using Docker Compose.

The file that Docker uses to build the image is called a [Dockerfile](https://docs.docker.com/engine/reference/builder/#dockerfile-reference). 
This file contains a set of instructions that Docker will use to build the image.

In our case, we'll use the following [Dockerfile](./Dockerfile) to build our image. This file uses a multi-stage build 
approach that uses the official Node.js image to build the Astro app, i.e. `pnpm build` and then copies the output to
a lightweight [Nginx](https://hub.docker.com/_/nginx) image for hosting the static files.

To build the image, we'll use the following command:
```sh
docker build -t my-awesome-app .
```

If you want to run the container locally, you can use the following command:
```sh
docker run -p 8080:80 my-awesome-app
```
And then visit http://localhost:8080 in your browser to see the app running.

### Docker Compose

We can also use Docker Compose to run our app and its dependencies, like a database or a cache server. Making it easier
to manage and run multiple containers at once, and configuring a simple infrastructure for running it locally.

The file that Docker Compose uses to define the services is called a [docker-compose.yml](https://docs.docker.com/compose/compose-file/).

In our case, we'll use the following [docker-compose.yml](./docker-compose.yaml) to define our app and its dependencies.

To run the app using Docker Compose, we'll use the following command:
```sh
docker compose up
```

And for stopping the app, you can use the following command:
```sh
docker compose down
```

As with Docker, you can visit http://localhost:8080 in your browser to see the app running.
