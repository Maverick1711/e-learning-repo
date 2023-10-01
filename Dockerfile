FROM nginx:1.12-alpine
COPY ./e-learning-app/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
