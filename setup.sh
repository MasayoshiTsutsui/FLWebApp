docker run -it \
--rm \
--name frontend_server \
--platform=linux/amd64 \
--network host \
--mount type=bind,source="$(pwd)"/simple-vue-tensorflow,target=/workspace/flwebapp \
flwebapp:0.0.1