# Dockerfile for Mendelian Randomization Analysis
# Using Rocky Linux as the base image from Docker Hub

FROM rockylinux/rockylinux:9

# Set metadata
LABEL maintainer="MendelianRandomizationImg"
LABEL description="Docker image for Mendelian Randomization analysis based on Rocky Linux"
LABEL version="1.0"

# Update system, install EPEL, R, and required dependencies in a single layer
RUN dnf -y update && \
    dnf -y install epel-release && \
    dnf -y install \
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
    && dnf clean all && \
    rm -rf /var/cache/dnf

# Install common R packages for Mendelian Randomization
RUN R -e "install.packages(c('remotes', 'devtools'), repos='https://cloud.r-project.org/')"

# Create a non-root user for running analysis work
RUN useradd -m -s /bin/bash mruser && \
    mkdir -p /workspace && \
    chown -R mruser:mruser /workspace

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER mruser

# Default command
CMD ["/bin/bash"]
