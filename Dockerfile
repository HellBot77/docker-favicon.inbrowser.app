FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/favicon.inbrowser.app.git && \
    cd favicon.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /favicon.inbrowser.app
COPY --from=base /git/favicon.inbrowser.app .
RUN npm install --global pnpm && \
    export COREPACK_ENABLE_STRICT=0 && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /favicon.inbrowser.app/dist .

