services:
  backend:
    restart: always
    image: ${docker_user}/testing:${image_tag}
    ports:
      - "5500:5500"
