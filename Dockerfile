# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/julia-notebook:main

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

RUN apt-cache search openblas
RUN apt-get upgrade && \
    apt-get -y install htop 
# libopenblas-dev libopenblas

# 3) install packages using notebook user
USER jovyan

# Configure default Julia package environment
ENV JULIA_DEPOT_PATH=/opt/julia JULIA_PKGDIR=/opt/julia
RUN chmod 1777 /opt/julia/logs

# Add packages (and force compilation if not already done)
# Note the line-continuation backslash ("\") at the end of each line so that
# all packages are installed in one Julia invocation.
RUN julia -e 'using Pkg; Pkg.add("CSV"); Pkg.add("DataFrames"); \
        Pkg.add("FileIO"); Pkg.add("Clp"); \
        Pkg.add("HiGHS"); Pkg.add("JuMP"); Pkg.add("Plots"); \
        Pkg.add("PrettyTables"); Pkg.add("Random"); \
        Pkg.add("Statistics"); Pkg.add("VegaLite"); \
        Pkg.add("IJulia"); \
        Pkg.instantiate();'
#        using JuMP; \
#        using Plots;'
        
RUN chmod -R o+w /opt/julia

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
