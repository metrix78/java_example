
Start a container and look around:
--rm == rm after complete
-it == interactive terminal
docker run -it --rm -p 8080:8080 java_example

Look around a running container:
docker exec -it {containerID} bash

