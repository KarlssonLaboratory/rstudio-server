[![Build & Deploy Docker Image](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml/badge.svg)](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml)

This repo holds a Docker container with Rstudio server for scRNA-seq analysis. 

> [!NOTE ]
> HPCs do not allow Docker containers, however, they are able to generate a singularity/apptainer image on the fly. Github only hosts Docker containers. Hence this workflow.

## Running interactively

> [!IMPORTANT]
> The steps below are setup for running on the HPC [UPPMAX Pelle](https://docs.uppmax.uu.se/cluster_guides/pelle/).

The container are ran inside an interactive shell and forwarded from a login shell. When the container is running a password will be generated. Use it in step 6.

1. login to HPC
2. allocate a compute node

```sh
interactive -A "$PROJECT" -n 1 -t 1:00:00
salloc: Pending job allocation 4968700
salloc: job 4968700 queued and waiting for resources
salloc: job 4968700 has been allocated resources
salloc: Granted job allocation 4968700
salloc: Waiting for resource configuration
salloc: Nodes p115 are ready for job
```

3. start the conainer:

```sh
# On the HPC (from an interactive job or within a SLURM submission)
apptainer run \
  --cleanenv \
  --env RSTUDIO_PORT=8080 \
  --env RSTUDIO_ADDRESS=0.0.0.0 \
  docker://ghcr.io/karlssonlaboratory/rstudio-server:35b5461
```

4. open second terminal and ssh tunnel

```sh
#ssh -L <local_port>:<node_id>:<host_port>
ssh -L 8080:<compute-node-id>:8080 pelle

# for debug
#ssh -v -N -L 8080:<compute-node-id>:8080 pelle
```

5. Open a browser and run Rstudio

```sh
open http://localhost:8080
```

6. Use the generated password and your username



<!--

```sh
# On the HPC (from an interactive job or within a SLURM submission)
mkdir -p test_dir/marimo_test
cd test_dir/marimo_test

ml pixi-tools

pixi init -c conda-forge -c bioconda
pixi add python
pixi add --pypi marimo
pixi shell
marimo edit --headless --host 0.0.0.0 --port 8080
```

```sh
ssh -L 8080:p108:8080 pelle
```

```sh
http://0.0.0.0:8080
```


-->