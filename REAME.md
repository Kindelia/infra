
## Deploy

```sh
cp .env.sample .env
```

Edit `.env`, filling the variables:

- `DO_AUTH_TOKEN`: your Digital Ocean authentication token


```sh
ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/setup.yml

ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/config.yml

ansible-playbook -i inventory/common.ini -i inventory/staging.ini playbooks/app.yml
```
