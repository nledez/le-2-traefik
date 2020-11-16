#!/bin/bash

if [ -z "${2}" ]; then
	echo "Launch with:"
	echo "$0 file-to-generate path-in-container <real-path-in-traefik>"
	exit 1
fi

DEST=$1
IN_CONTAINER=$2
if [ -z "${3}" ]; then
	REAL_PATH=${IN_CONTAINER}
else
	REAL_PATH=$3
fi
TEMPFILENAME=$(mktemp)

cd "${IN_CONTAINER}" || exit 1
true > "${TEMPFILENAME}"

for cert in *; do
	PRIVKEY="${cert}/privkey.pem"
	CERT="${cert}/cert.pem"
	if [[ -f ${CERT} && -f ${PRIVKEY} ]]; then
		{
			echo "[[tls.certificates]]"
			echo "  certFile = \"${REAL_PATH}/${CERT}\""
			echo "  keyFile = \"${REAL_PATH}/${PRIVKEY}\""
		} >> "${TEMPFILENAME}"
	fi
done

if [ ! -f "${DEST}" ]; then
	mv "${TEMPFILENAME}" "${DEST}"
	exit 0
fi

if ! diff -u "${DEST}" "${TEMPFILENAME}"; then
	mv "${TEMPFILENAME}" "${DEST}"
fi
