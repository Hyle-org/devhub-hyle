# Run a node

<!-- TODO: Review entirely-->

We currently don't have a deployment file available.

Follow these instructions to run a node, keeping in mind that this is unstable and can break with upcoming updates.

Download the Docker image:

```bash
docker pull europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

Then run the image:

```bash
docker run --name [container_name] -d [options] europe-west3-docker.pkg.dev/hyle-413414/hyle-docker/hyle:main
```

And rebuild the node from the source:

```bash
docker build -t Hyle-org/hyle . && docker run -dit Hyle-org/hyle
```