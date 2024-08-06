FROM golang:1.22.5-bullseye

RUN apt-get update && apt-get install -y git make curl perl jq netcat gcc ca-certificates build-essential libusb-1.0-0-dev musl-gcc

WORKDIR /code
COPY . /code/

RUN set -eux; \
  export ARCH=$(uname -m); \
  WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm/v2 | awk '{print $2}'); \
  if [ ! -z "${WASM_VERSION}" ]; then \
  mkdir -p /code/downloads; \
  wget -O /code/downloads/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.${ARCH}.a; \
  fi; \
  cp /code/downloads/libwasmvm_muslc.a /usr/lib/libwasmvm_muslc.${ARCH}.a; \
  cp /code/downloads/libwasmvm_muslc.a /usr/lib/libwasmvm_muslc.a;

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LINK_STATICALLY=true CGO_ENABLED=1 CC=musl-gcc GOOS=linux GOARCH=arm64 make build \
    && cp /code/build/lazychaind /usr/bin/lazychaind

WORKDIR /opt

COPY init.sh .

EXPOSE 1317
EXPOSE 26656
EXPOSE 26657 