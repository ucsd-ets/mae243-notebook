# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:2023.2-stable

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

RUN apt-get -y install htop

# 3) install packages using notebook user
USER jovyan

# Configure default Julia package environment
ENV JULIA_DEPOT_PATH=/opt/julia JULIA_PKGDIR=/opt/julia
RUN chmod 1777 /opt/julia/logs

# Add a package (and force compilation if not already done)
RUN julia -e 'using Pkg; Pkg.add("HTTP"); Pkg.instantiate();'

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
