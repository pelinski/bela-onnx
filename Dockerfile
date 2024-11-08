FROM debian:bullseye as downloader
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git 

WORKDIR /workspace

ARG ONNX_VERSION
RUN git clone --recursive --branch ${ONNX_VERSION} https://github.com/onnx/onnx.git

FROM python:3.13-bullseye as builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential cmake

COPY --from=downloader /workspace/onnx /workspace/onnx

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "running on $BUILDPLATFORM, building for $TARGETPLATFORM" 

ARG ONNX_VERSION
RUN echo "Building onnx version ${ONNX_VERSION}"
 

RUN mkdir -p /workspace/onnx/build && cd /workspace/onnx/build && \
    cmake .. 

RUN cd /workspace/onnx/build && cmake --build . -j4

RUN cd /workspace/onnx/build && cmake --install . --prefix /workspace/onnx/install --config Release

RUN cd /workspace/onnx/install && tar -czf /workspace/onnx/onnx-${ONNX_VERSION}.tar.gz .
