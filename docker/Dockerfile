FROM ubuntu

RUN apt update && apt upgrade -y
   
RUN apt install curl wget unzip python3 -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
    chmod +x kops && \
    mv kops /usr/local/bin/

RUN cd ~ && \
    wget https://releases.hashicorp.com/terraform/1.3.1/terraform_1.3.1_linux_amd64.zip && \
    unzip terraform_1.3.1_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin && \
    export PATH=$PATH:/usr/local/bin


