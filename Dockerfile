FROM quorum-tessera-istanbul-with-bash

RUN mkdir -p /qdata

WORKDIR /qdata

COPY ./entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]