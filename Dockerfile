# Base Image
FROM ubuntu:latest

RUN apt-get update; \
    apt install -y openssh-client; \
    apt-get install -y wget curl apt-transport-https; \
    apt install -y python3-pip

# Install Ansible and AWS SDKs
RUN pip3 install --upgrade pip --break-system-packages; \
    pip3 install --break-system-packages "ansible"; \
    pip3 install --break-system-packages boto; \
    pip3 install --break-system-packages boto3

# Install AZ CLI
RUN apt-get update; \
    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg; \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/azure-cli-archive-keyring.gpg > /dev/null; \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/azure-cli-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list; \
    apt-get update; \
    apt-get install -y azure-cli

# Install AZ Collection Requirements for Ansible
RUN pip3 install --break-system-packages "ansible[azure]"; \
    pip3 install --break-system-packages "ansible[azure.azcollection]"; \
    pip3 install --break-system-packages -r "$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"] + "/ansible_collections/azure/azcollection/requirements.txt")')"

# Azure credentials are injected at runtime via --env-file.
ENV AZURE_SUBSCRIPTION_ID=""
ENV AZURE_CLIENT_ID=""
ENV AZURE_SECRET=""
ENV AZURE_TENANT=""

# Set the working directory
WORKDIR /ansible


