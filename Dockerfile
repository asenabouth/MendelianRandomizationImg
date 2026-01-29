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
    unzip \
    && dnf clean all && \
    rm -rf /var/cache/dnf


# Install common R packages for Mendelian Randomization
RUN R -e "install.packages(c('remotes', 'devtools', 'data.table', 'tidyverse'), repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('TwoSampleMR', repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))"

# Install PLINK 1.9
RUN wget --tries=3 --timeout=30 https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20231211.zip && \
    unzip plink_linux_x86_64_20231211.zip -d /usr/local/bin/ && \
    rm plink_linux_x86_64_20231211.zip && \
    chmod +x /usr/local/bin/plink

# Install SMR (Summary-data-based Mendelian Randomization)
RUN wget --tries=3 --timeout=30 https://yanglab.westlake.edu.cn/software/smr/download/smr_linux_x86_64.zip && \
    unzip smr_linux_x86_64.zip && \
    mv smr_linux_x86_64/smr /usr/local/bin/ && \
    chmod +x /usr/local/bin/smr && \
    rm -rf smr_linux_x86_64.zip smr_linux_x86_64

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
