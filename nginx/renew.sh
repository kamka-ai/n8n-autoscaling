#!/bin/bash

# Script to renew SSL certificates
docker compose run --rm certbot renew
docker compose exec nginx nginx -s reload

