#!/bin/bash

read -ra SOCAT_ARGS <<<"${SOCAT_ARGS}"

FLATPAK_ID=${FLATPAK_ID:-"com.zoho.Cliq"}
OUR_SOCKET="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}/cliq-ipc-0"
CLIQ_SOCKET="${XDG_RUNTIME_DIR}/cliq-ipc-0"

invoke_socat=true
# Check if our socket already exists.
if [ -S "${OUR_SOCKET}" ]
then
    # Check if socat is listening on it.
    if socat "${SOCAT_ARGS[@]}" -u OPEN:/dev/null "UNIX-CONNECT:${OUR_SOCKET}"
    then
        # socat is still listening on it, make sure not not invoke it again.
        invoke_socat=false
    else
        # Socket exists but socat is not listening on it (for whatever reason), delete it so we can invoke socat again.
        rm -f "${OUR_SOCKET}"
    fi
fi

if [ "${invoke_socat}" = true ]
then
    socat "${SOCAT_ARGS[@]}" "UNIX-LISTEN:${OUR_SOCKET},forever,fork" "UNIX-CONNECT:${CLIQ_SOCKET}" &
    socat_pid=$!
fi

WAYLAND_SOCKET=${WAYLAND_DISPLAY:-"wayland-0"}

if [[ -e "$XDG_RUNTIME_DIR/${WAYLAND_SOCKET}" || -e "${WAYLAND_DISPLAY}" ]]
then
    FLAGS+=('--enable-features=WaylandWindowDecorations' '--ozone-platform-hint=auto')
fi

env TMPDIR="${XDG_CACHE_HOME}" zypak-wrapper /app/opt/Cliq/cliq --enable-speech-dispatcher "${FLAGS[@]}" "$@"

if [ "${invoke_socat}" = true ]
then
    kill -SIGTERM "${socat_pid}"
fi
