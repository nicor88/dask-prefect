FROM python:3.6-slim
LABEL version="1.0"
LABEL maintainer="nicor88"

RUN apt-get update

RUN apt-get install -y \
        build-essential \
        libgflags-dev \
        libsnappy-dev \
        zlib1g-dev \
        libbz2-dev \
        liblz4-dev \
        librocksdb-dev \
        libzstd-dev

RUN apt-get clean && apt-get autoclean

COPY ./requirements.txt /tmp/pip_requirements.txt

RUN pip install -r /tmp/pip_requirements.txt

WORKDIR /app/workflows

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
