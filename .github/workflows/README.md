# CI/CD

Since we're hosting our source code on GitHub, we'll leverage GitHub Actions to automate our CI/CD pipeline.

GitHub's pipelines are written in YAML files and located within a special directory called `.github`. This directory
contains two subdirectories, [workflows and actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions).
Which are used to define the CI/CD pipeline and to create custom actions, respectively.

## Workflows

### [check-docker-build.yaml](./workflows/check-docker-build.yaml)

This workflow runs on every pull request and checks if the Docker image can be built successfully. It's a good practice
to check if the Docker image can be built before merging the pull request to the `main` branch.

We'll leverage the following reusable actions from GitHub's marketplace to build the image.

- [docker/build-push-action](https://github.com/docker/build-push-action): Builds and pushes the Docker image.

### [publish-docker-image.yaml](./workflows/publish-docker-image.yaml)

This workflow is triggered when a new commit is pushed to the `main` branch. It builds the Docker image and pushes it
to the Container Registry. In our case, we'll use the [GitHub Container Registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
and the [Docker Hub Container Registry](https://www.docker.com/products/docker-hub/) as examples.

We'll leverage the following reusable actions from GitHub's marketplace to build and push the image.

- [docker/login-action](https://github.com/docker/login-action): For authenticating with the Docker Hub and the GitHub Container Registry.
  Make sure to provide the right credentials to authenticate with your registry.
- [docker/metadata-action](https://github.com/docker/metadata-action): Extracts metadata from the Docker image.
- [docker/build-push-action](https://github.com/docker/build-push-action): Builds and pushes the Docker image.

