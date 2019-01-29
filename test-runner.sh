CONTAINER_NAME="quorum-n-nodes"
echo "$CONTAINER_NAME"
docker container stop ${CONTAINER_NAME}
docker container rm ${CONTAINER_NAME}
docker build -t final-quorum-1 .
docker run -t -d --name ${CONTAINER_NAME} -p 22001-22004:22001-22004 final-quorum-1
docker exec -it ${CONTAINER_NAME} bash setup.sh
docker exec -it ${CONTAINER_NAME} sh -c "ls qdata_1/tessera1"