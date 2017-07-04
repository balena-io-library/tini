FROM #{FROM}

RUN apt-get -q update \
		&& apt-get install -y git-core build-essential cmake make curl python python-dev python-pip --no-install-recommends \
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip install awscli

COPY . /usr/src/tini/