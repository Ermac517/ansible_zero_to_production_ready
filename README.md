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
ansible localhost -m file -a "path=/ansible state=directory"
ansible localhost -m ping
ansible localhost -m stat -a "path=/ansible"
```

## Run the sample playbook

The repository includes an `inventory` file for local container testing.

```bash
ansible-playbook ping.yml -i inventory
```

## Run the Windows WinRM sample

The `win_ping.yaml` playbook requires the WinRM Python client in the container image. Rebuild the image after pulling changes:

```bash
docker build -t ansible:latest .
```

When targeting a single host directly, pass the public IP as a host list with a trailing comma so Ansible does not treat it as an inventory file path:

```bash
ansible-playbook win_ping.yaml -i '40.87.108.94,'
```

## Run the Azure playbooks

Run the playbooks in the following order from inside the container:

### 1. Create the resource group

```bash
ansible-playbook azure_create_resource_group.yaml
```

### 2. Create the Windows VM

```bash
ansible-playbook azure_create_windows_vm.yaml
```

### 3. Create the Linux VM

```bash
ansible-playbook azure_create_linux_vm.yaml
```

### 4. Delete all resources

```bash
ansible-playbook azure_delete_ansible_env.yaml
```
