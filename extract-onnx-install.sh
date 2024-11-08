#!/bin/bash
source ONNX_VERSION.env
mkdir onnx-install && tar -xvf onnx-install.tar -C onnx-install
mv onnx-install/workspace/onnx/onnx-${ONNX_VERSION}.tar.gz ./
rm -rf onnx-install