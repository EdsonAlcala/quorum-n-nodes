FROM edsonalcala/quorum-tessera-alpine:latest

RUN mkdir -p /qdata

WORKDIR /qdata

COPY ./entrypoint.sh .

CMD [ "ls" ]
