# check=error=true

ARG SOURCE_IMAGE_TAG=termux/termux-docker
FROM ${SOURCE_IMAGE_TAG}

COPY --chown=1000:1000 motd.sh /data/data/com.termux/files/home/.termux/motd.sh

ARG SOURCE_IMAGE_TAG
ARG TARGET_IMAGE_TAG=ghcr.io/NoNameWasDefined/termux-package-builder

RUN --mount=source=setup.sh,target=/setup.sh \
    --mount=type=cache,target=/data/data/com.termux/cache/apt,uid=1000,gid=1000 \
    --mount=type=cache,target=/source,uid=1000,gid=1000 \
    ["/entrypoint.sh", "login", "-c", "/setup.sh \"${SOURCE_IMAGE_TAG}\" \"${TARGET_IMAGE_TAG}\""]

RUN ["/system/bin/rm", "-r", "-f", "/source"]
