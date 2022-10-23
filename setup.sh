docker run -it \
--name vuetest3 \
--platform=linux/amd64 \
-p 8003:8003 \
--mount type=bind,source="$(pwd)"/simple-vue-tensorflow,target=/workspace2 \
vueworked:latest