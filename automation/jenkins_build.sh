#!/bin/bash

# Jenkins build steps

for ARCH in $ARCHS
do
	case "$ARCH" in
		'armv6hf')
			sed -e s~#{FROM}~resin/rpi-raspbian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'armv7hf')
			sed -e s~#{FROM}~resin/armv7hf-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'armel')
			sed -e s~#{FROM}~resin/armel-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'aarch64')
			sed -e s~#{FROM}~resin/aarch64-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'i386')
			sed -e s~#{FROM}~resin/i386-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'amd64')
			sed -e s~#{FROM}~resin/amd64-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
	esac
	docker build -t tini-$ARCH-builder .

	docker run --rm -e ARCH=$ARCH \
					-e ACCESS_KEY=$ACCESS_KEY \
					-e SECRET_KEY=$SECRET_KEY \
					-e BUCKET_NAME=$BUCKET_NAME \
					-e TINI_VERSION=$TINI_VERSION \
					-e TINI_COMMIT=$TINI_COMMIT --entrypoint /bin/bash tini-$ARCH-builder /usr/src/tini/build.sh
done

# Clean up builder image after every run
docker rmi -f tini-$ARCH-builder
