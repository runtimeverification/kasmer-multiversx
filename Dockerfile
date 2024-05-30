ARG K_DISTRO=jammy
ARG K_COMMIT
FROM runtimeverificationinc/kframework-k:ubuntu-${K_DISTRO}-${K_COMMIT}

RUN    apt-get update        \
    && apt-get upgrade --yes \
    && apt-get install --yes \
         autoconf            \
         cmake               \
         curl                \
         libprocps-dev       \
         libsecp256k1-dev    \
         libssl-dev          \
         libtool             \
         wabt

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr python3 - --version 1.3.2

ARG USER=user
ARG GROUP=$USER
ARG USER_ID=1000
ARG GROUP_ID=$USER_ID
RUN    groupadd -g $GROUP_ID $GROUP \
    && useradd -m -u $USER_ID -s /bin/sh -g $GROUP $USER

USER $USER:$GROUP
WORKDIR /home/$USER

RUN curl -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/${USER}/.cargo/bin:${PATH}"

RUN cargo install multiversx-sc-meta --version ~0.50 --locked

RUN    rustup target add wasm32-unknown-unknown \
    && rustup toolchain add nightly             \
    && rustup default nightly                   \
    && rustup target add wasm32-unknown-unknown
