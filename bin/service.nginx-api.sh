#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )

if [[ -z "$1" ]]; then
    echo "usage $0 [start|stop]"
    exit 1
fi

case $1 in
pre-start)
    /bin/rm -f ${SNAP_COMMON}/api.socket
    ${DIR}/nginx/sbin/nginx -t -c ${SNAP_COMMON}/config/nginx/api.conf -g 'error_log '${SNAP_COMMON}'/log/nginx_api_error.log warn;'
    ;;
start)
    ${DIR}/nginx/sbin/nginx -c ${SNAP_COMMON}/config/nginx/api.conf -g 'error_log '${SNAP_COMMON}'/log/nginx_api_error.log warn;'
    ;;
post-start)
    /usr/bin/timeout 5 /bin/bash -c 'until [ -S '${SNAP_COMMON}'/api.socket ]; do echo "waiting for api socket"; sleep 1; done'
    ;;
reload)
    ${DIR}/nginx/sbin/nginx -c ${SNAP_COMMON}/config/nginx/api.conf -s reload -g 'error_log '${SNAP_COMMON}'/log/nginx_api_error.log warn;'
    ;;
stop)
    ${DIR}/nginx/sbin/nginx -c ${SNAP_COMMON}/config/nginx/api.conf -s stop -g 'error_log '${SNAP_COMMON}'/log/nginx_api_error.log warn;'
    ;;
*)
    echo "not valid command"
    exit 1
    ;;
esac


