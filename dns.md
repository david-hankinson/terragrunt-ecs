route 53 - DNS records for ECS services
certificate manager - creates and deploys certs

create domain and attach to ALb

1. create domain and add it to hosted zone
2. add name servers (NOT REQUIRED IF GETTING DOMAIN FROM ROUTE 53)
3. alias targets set to load balancer
4. service should use load balancer

##

1. Request certificate for the domain
2. domain names should be domain.com and *.domain.com - your normal site and the wildcard domain
3. add listener to load balancer with acm cert that forwards to tg
4. might need a https sg

route53 >>>> ALB
ACM >>>>> 53

provision in this order:
1. ALB 2. route 53 3. ACM 4. lb listener with acm cert that forwards to ecs tg

30 MINS MAX

first test: 
deploy infra with manual DNS

second test: 
write IAC with DNS and deploy
passing test = dns and cert on jupyter notebook

-----------------------

## container insights should be enabled

container insights should be enabled in ecs - done
view container insights




