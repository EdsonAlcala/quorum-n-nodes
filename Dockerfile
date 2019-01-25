FROM edsonalcala/quorum-tessera-alpine:latest

RUN mkdir -p /qdata

WORKDIR /qdata

EXPOSE 22001-22004

EXPOSE 9001-9004

COPY . .

RUN chmod -R 777 ./

ENTRYPOINT [ "./setup.sh" ]