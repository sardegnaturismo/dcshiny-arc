FROM nginx:1.10



COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf


EXPOSE 80

STOPSIGNAL SIGTERM


CMD ["nginx", "-g", "daemon off;"]