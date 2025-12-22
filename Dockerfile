FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/favicon.inbrowser.app.git && \
    cd favicon.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /favicon.inbrowser.app
COPY --from=base /git/favicon.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /favicon.inbrowser.app/dist ./public
