FROM golang:1.14 AS builder
WORKDIR /go/src/tester
COPY /go/src/tester /go/src/tester 
RUN go build tester

FROM python:3.6-slim

WORKDIR /servo

COPY --from=builder /go/src/tester/tester .

# Install required packages
RUN pip3 install requests PyYAML

RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
        procps \
	&& rm -rf /var/lib/apt/lists/*

ADD https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ADD https://raw.githubusercontent.com/opsani/servo-k8s/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-magg/master/measure \
    https://raw.githubusercontent.com/opsani/servo/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo/master/servo \
    /servo/

ADD https://raw.githubusercontent.com/opsani/servo-prom/master/measure /servo/measure.d/measure-prometheus
ADD https://raw.githubusercontent.com/opsani/servo-exec/master/measure /servo/measure.d/measure-exec
ADD https://raw.githubusercontent.com/opsani/servo/master/measure.py /servo/measure.d/

RUN chmod a+rx /servo/adjust /servo/measure /servo/servo /usr/local/bin/kubectl && \
    chmod a+r /servo/adjust.py /servo/measure.py && \
    chmod a+rx /servo/measure.d/measure-prometheus /servo/measure.d/measure-exec && \
    chmod a+r /servo/measure.d/measure.py && \
    chmod a+rx /servo/tester
 	
ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]
