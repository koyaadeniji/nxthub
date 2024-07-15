FROM ubuntu:latest

RUN apt update && apt install nginx -y

RUN echo 'HELLO, WORLD ! !!' > /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]