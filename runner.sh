./cleanup.sh
docker build -t quorum-n .
docker container stop quorum-n
docker run -t -d --rm --name quorum-n -p 24001:22001 -v `pwd`/qdata:/qdata quorum-n
docker exec -it quorum-n sh