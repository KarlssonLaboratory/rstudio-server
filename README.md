[![Build & Deploy Docker Image](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml/badge.svg)](https://github.com/KarlssonLaboratory/rstudio-server/actions/workflows/build_deploy.yml)

```
# On the HPC (from an interactive job or within a SLURM submission)
PORT=$(shuf -i 10000-20000 -n 1)
echo "RStudio on $(hostname):$PORT"

apptainer run \
  --cleanenv \
  --env RSTUDIO_PORT=$PORT \
  --env RSTUDIO_ADDRESS=127.0.0.1 \
  --bind /scratch,/projects \
  ~/containers/my-rserver.sif
```

```
ssh -N -L 8787:<compute-node>:$PORT <remote-host>
# open http://localhost:8787
```
