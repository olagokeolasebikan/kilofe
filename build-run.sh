docker build -t kilofe-web .
docker run -d -p 9500:80 kilofe-web