# Kubernetes Workspace

Example of working with Kubernetes from a containerized environment.

Getting started is as easy as:
```sh
docker compose run --rm --build workspace bash
docker compose down --volumes
```

You might have to adjust these in the `docker-compose.yml`:
```sh
echo "USER_ID: $(id -u)"
echo "USER_GID: $(id -g)"
echo "DOCKER_GID: $(getent group docker | cut -d: -f3)"
```

Here's a list of included tools:

| Tool | Version |
| ---- | ------- |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) | 1.29.2 |
| [helm](https://helm.sh/docs/) | 3.14.2 |
| [helm-diff](https://github.com/databus23/helm-diff) | 3.8.1 |
| [helm-git](https://github.com/aslafy-z/helm-git) | 0.15.1 |
| [helmfile](https://helmfile.readthedocs.io/en/latest/) | 0.162.0 |
| [minikube](https://minikube.sigs.k8s.io/docs/) | 1.32.0 |
| [opentofu](https://opentofu.org/docs/intro/) | 1.6.2 |
| [gcloud](https://cloud.google.com/sdk/gcloud/) | 471.0.0 |
| [doctl](https://docs.digitalocean.com/reference/doctl/) | 1.104.0 |
