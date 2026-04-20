[![Build & Deploy Docker Image](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml/badge.svg)](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml)


1. login to HPC
2. allocate a compute node
3. generate a port
4. open second terminal and ssh tunnel
5. Open a browser and run Rstudio


```
# On the HPC (from an interactive job or within a SLURM submission)
#PORT=$(shuf -i 10000-20000 -n 1)
PORT=13337
echo "RStudio on $(hostname):$PORT"

apptainer run \
  --cleanenv \
  --env RSTUDIO_PORT=$PORT \
  --env RSTUDIO_ADDRESS=0.0.0.0 \
  docker://ghcr.io/karlssonlaboratory/rstudio-server:latest
```

```
#ssh -N -L 8787:<compute-node>:$PORT <remote-host>
# open http://localhost:8787
```


```
 ghcr.io/karlssonlaboratory/rstudio-server:latest
```
