for arg in "$@"
do
  case $arg in
    domain=*)
    DOMAIN="${arg#*=}"
    shift
    ;;

    service_name=*)
    SERVICE_NAME="${arg#*=}"
    shift
    ;;
    
    port_service=*)
    PORT_SERVICE="${arg#*=}"
    shift
    ;;
    
    *)
    ;;
  esac
done


if [ -z "$DOMAIN" ] || [ -z "$SERVICE_NAME" ] || [ -z "$PORT_SERVICE" ]; then
  echo "Missing required parameters. Example: domain=example.com service_name=example port_service=80"
  exit 1
fi

# echo "Domain: $DOMAIN"
# echo "Service Name: $SERVICE_NAME"
# echo "Port Service: $PORT_SERVICE"

apt update; apt install -y vim && apt install -y certbot python3-certbot-nginx

IFS='.' read -r -a array <<< "$DOMAIN"
SUBDOMAIN=${array[0]}
ORIGIN_DOMAIN=${array[1]}.${array[2]}
echo "Subdomain: $SUBDOMAIN"

echo "
upstream $SERVICE_NAME {
    server $SERVICE_NAME:$PORT_SERVICE;
}

server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN;

    location / {
        proxy_pass http://$SERVICE_NAME;
    }
}
" > /etc/nginx/conf.d/$SUBDOMAIN.conf


certbot --nginx -d $DOMAIN --agree-tos --email tuanthanh021094@gmail.com


# echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

service nginx -s reload
