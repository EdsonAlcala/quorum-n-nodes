FROM edsonalcala/quorum-tessera-alpine:2.2.1-quorum

RUN mkdir -p /qdata

WORKDIR /qdata

EXPOSE 22001-22004

EXPOSE 9001-9004

COPY . .

RUN chmod -R 777 ./

RUN echo -e '#!/bin/sh \n /qdata/setup.sh ' > /usr/bin/start-nodes && \
    chmod +x /usr/bin/start-nodes 

CMD [ "sh" ]