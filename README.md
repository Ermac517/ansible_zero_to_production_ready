# ansible
contains Ansible ad-hoc commands and playbooks

## Azure environment file

Create and fill the local `.env` file with your Azure credentials:

```dotenv
AZURE_SUBSCRIPTION_ID=<your-subscription-id>
AZURE_CLIENT_ID=<your-client-id>
AZURE_SECRET=<your-client-secret>
AZURE_TENANT=<your-tenant-id>
```

The `.env` file is git-ignored and will not be tracked.

## Build the image

```bash
docker build -t ansible:latest .
```

## Run the container with env file

```bash
docker run --rm -it --volume "$(pwd)":/ansible --env-file .env ansible
```

## ad-hoc Ansible commands
```bash
ansible localhost -m azure_rm_resourcegroup -a "name=ansible location=eastus"
```
