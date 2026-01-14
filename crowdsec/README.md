Once the crowdsec docker service has been brought up for the first time,
the bouncer key will need to be generated.
Check if any bouncers currently exist:
```
docker exec crowdsec cscli bouncers list
```
If you see one already e.g. `TRAEFIK`, delete it first and then create it:
```
docker exec crowdsec cscli bouncers delete TRAEFIK
docker exec crowdsec cscli bouncers add TRAEFIK
```
Make a note of the api key which is generated and update it in both
`.env` and `docker.env`. 
Restart the traefik and crowdsec containers.

Once they are back up, add the following using the cscli (they
will probably already be installed.
- Install the cdn-whitelist postoverflow (includes Cloudflare)
```
docker exec crowdsec cscli postoverflows install crowdsecurity/cdn-whitelist
```
- Install the dependency (reverse DNS enrichment)
```
docker exec crowdsec cscli postoverflows install crowdsecurity/rdns
```
