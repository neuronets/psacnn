FROM ubuntu:16.04
ARG DEBIAN_FRONTEND="noninteractive"
WORKDIR /opt
# Install MRI processing dependencies.
RUN apt-get update -qq \
    && apt-get install --no-install-recommends --yes --quiet \
        ca-certificates \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Download and install N4BiasFieldCorrection from ANTs.
    && curl -fL https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz \
    | tar xz ants/N4BiasFieldCorrection \
    # Download and install ROBEX
    && curl -fL 'https://www.nitrc.org/frs/download.php/5994/ROBEXv12.linux64.tar.gz//?i_agree=1&download_now=1' \
    | tar xz

COPY [".", "psacnn"]
ENV PATH="/opt/ants:/opt/ROBEX:/opt/psacnn/freesurfer/bin:$PATH"

RUN apt-get update -qq \
    && apt-get install --no-install-recommends --yes --quiet \
        gcc \
        python3 \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3 - \
    && ln -s $(which python3) /usr/local/bin/python \
    && pip install --no-cache-dir keras nipype scikit-image scikit-learn scipy tables tensorflow \
    && pip install --no-cache-dir --editable ./psacnn \
    && apt-get autoremove --yes --purge gcc python3-dev
