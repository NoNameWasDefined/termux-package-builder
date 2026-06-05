# check=error=true

ARG SOURCE_IMAGE_NAME=termux/termux-docker
ARG TARGET_IMAGE_NAME=ghcr.io/nonamewasdefined/termux-package-builder
ARG IMAGE_BUILD_DATE=unknown

FROM ${SOURCE_IMAGE_NAME}

RUN --mount=source=setup.sh,target=/setup.sh \
    --mount=type=cache,target=/data/data/com.termux/cache/apt,uid=1000,gid=1000 \
    --mount=type=cache,target=/source,uid=1000,gid=1000 \
    ["/entrypoint.sh", "login", "-c", "/setup.sh"]

COPY --chown=1000:1000 motd.sh /data/data/com.termux/files/home/.termux/motd.sh

ARG SOURCE_IMAGE_NAME
ARG TARGET_IMAGE_NAME
ARG IMAGE_BUILD_DATE
ENV TERMUX__ORIGIN_IMAGE=${SOURCE_IMAGE_NAME}
ENV TERMUX__CURRENT_IMAGE=${TARGET_IMAGE_NAME}
ENV TERMUX__IMAGE_BUILD_DATE=${IMAGE_BUILD_DATE}
