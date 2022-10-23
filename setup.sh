docker run -it \
--rm \
--name frontend_server \
--platform=linux/amd64 \
-p 8000:8000 \
--mount type=bind,source="$(pwd)"/simple-vue-tensorflow,target=/workspace/flwebapp \
flwebapp:0.0.1