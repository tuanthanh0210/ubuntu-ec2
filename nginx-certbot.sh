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
" > /etc/nginx/conf.d/$DOMAIN.conf

IFS='.' read -r -a array <<< "$DOMAIN"
SUBDOMAIN=${array[0]}
DOMAIN=${array[1]}.${array[2]}
echo "Subdomain: $SUBDOMAIN"
certbot --nginx -d $SUBDOMAIN --agree-tos --no-eff-email

// Chạy lệnh sau để cài đặt crontab tự động gia hạn chứng chỉ SSL
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

service nginx -s reload


docker run -d -p 80:80 -p 443:443 --name=nginx nginx && \n
docker exec -it nginx bash -c "curl https://raw.githubusercontent.com/tuanthanh021094/ubuntu-ec2/main/nginx-certbot.sh --output nginx-certbot.sh && bash nginx-certbot.sh domain=xbot-db.justinle.pro service_name=xbot-db port_service=3000"
