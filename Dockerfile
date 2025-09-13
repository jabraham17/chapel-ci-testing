FROM ubuntu:24.04

ARG PARALLEL=1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y gcc g++ m4 perl python3 python3-dev bash make mawk git pkg-config cmake && \
    apt-get install -y llvm-dev llvm clang libclang-dev libclang-cpp-dev libedit-dev

WORKDIR /opt
RUN git clone https://github.com/chapel-lang/chapel.git --depth 1 --branch main
WORKDIR /opt/chapel
ENV CHPL_HOME=/opt/chapel
RUN make all test-venv -j$PARALLEL
RUN make check

WORKDIR /opt/chapel
ENTRYPOINT [ "/bin/bash" ]
