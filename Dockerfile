# Dockerfile for Mendelian Randomization Analysis
# Using Rocky Linux as the base image from Docker Hub

FROM rockylinux/rockylinux:9

# Set metadata
LABEL maintainer="MendelianRandomizationImg"
LABEL description="Docker image for Mendelian Randomization analysis based on Rocky Linux"
LABEL version="1.0"

# Update the system and install essential packages
RUN dnf -y update && \
    dnf -y install \
    epel-release \
    && dnf clean all

# Install R and required dependencies
RUN dnf -y install \
    R \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    make \
    openssl-devel \
    libcurl-devel \
    libxml2-devel \
    git \
    wget \
    which \
    && dnf clean all

# Install common R packages for Mendelian Randomization
RUN R -e "install.packages(c('remotes', 'devtools'), repos='https://cloud.r-project.org/')"

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
