
## Deploy

```sh
cp .env.sample .env
```

Edit `.env`, filling the variables:

- `MODE`: `master`, `staging`, ...
- `DO_AUTH_TOKEN`: your Digital Ocean authentication token


```sh
ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/setup-docker.yml

ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/config.yml
```

<!-- ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/app.yml -->

Select the desired Docker context. e.g.
```sh
docker context use staging.kindelia.org
```

```sh
docker-compose up -d
```

## How to setup the Docker context

```sh
docker context create --docker host=ssh://root@kindelia.org kindelia.org

docker context create --docker host=ssh://root@staging.kindelia.org staging.kindelia.org
```
