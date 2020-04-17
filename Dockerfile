FROM python:3.6-slim

WORKDIR /servo

# Install required packages
RUN pip3 install requests PyYAML

ADD  https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ADD https://raw.githubusercontent.com/opsani/servo-k8s/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-prom/master/measure \
    https://raw.githubusercontent.com/opsani/servo/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo/master/servo \
    /servo/

RUN chmod a+rx /servo/adjust /servo/measure /servo/servo /usr/local/bin/kubectl && \
 	chmod a+r /servo/adjust.py /servo/measure.py

ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]