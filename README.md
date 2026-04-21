[![Build & Deploy Docker Image](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml/badge.svg)](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml)


1. login to HPC
2. allocate a compute node
3. generate a port
4. open second terminal and ssh tunnel
5. Open a browser and run Rstudio


```sh
# On the HPC (from an interactive job or within a SLURM submission)
apptainer run \
  --cleanenv \
  --env RSTUDIO_PORT=8080 \
  --env RSTUDIO_ADDRESS=0.0.0.0 \
  docker://ghcr.io/karlssonlaboratory/rstudio-server:c46e9ec > ~/rserver.log 2>&1
```

```
ssh -v -N -L 8080:p108:8080 pelle
# open http://localhost:9876
```


```
 ghcr.io/karlssonlaboratory/rstudio-server:c46e9ec
```

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
