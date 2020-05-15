FROM python:3.6-slim

WORKDIR /servo

ADD  https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl /usr/local/bin/

# Install dependencies
RUN apt update && apt -y install procps tcpdump curl wget
RUN pip3 install requests PyYAML python-dateutil

# add prom driver
ADD https://raw.githubusercontent.com/opsani/servo-prom/master/measure /servo/measure.d/prom-opsani
ADD https://raw.githubusercontent.com/opsani/servo-prom/master/measure /servo/measure.d/prom-ethos

# add magg driver
RUN mkdir -p measure.d
ADD https://raw.githubusercontent.com/opsani/servo-magg/master/measure /servo/
ADD https://raw.githubusercontent.com/opsani/servo/master/measure.py measure.d/

# add agg driver
RUN mkdir -p adjust.d
ADD https://raw.githubusercontent.com/opsani/servo-agg/demo/adjust \
    https://raw.githubusercontent.com/opsani/servo-agg/demo/adjust.py \
    https://raw.githubusercontent.com/opsani/servo-agg/demo/util.py \
    /servo/

# add k8s driver under different names
ADD https://raw.githubusercontent.com/opsani/servo/master/adjust.py  /servo/adjust.d/
ADD https://raw.githubusercontent.com/opsani/servo-k8s/master/adjust /servo/adjust.d/k8s-adjust-canary
ADD https://raw.githubusercontent.com/opsani/servo-k8s/master/adjust /servo/adjust.d/k8s-adjust-main


# Install servo
ADD https://raw.githubusercontent.com/opsani/servo/master/servo \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    /servo/

RUN chmod a+rwx /servo/adjust /servo/measure /servo/servo /usr/local/bin/kubectl
RUN chmod a+rwx /servo/measure.d/prom-opsani /servo/measure.d/prom-ethos
RUN chmod a+r /servo/adjust.py /servo/measure.py
RUN chmod a+rx /servo/adjust.d/k8s-adjust-canary
RUN chmod a+rx /servo/adjust.d/k8s-adjust-main
RUN chmod 644  /servo/adjust.d/adjust.py

ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]
