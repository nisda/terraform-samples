FROM amazonlinux:2

# configuration
ARG terraform_version="1.1.2"


# Install terraform, awscli, and other commands
RUN yum install -y unzip less jq
RUN curl -O https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip
RUN unzip ./terraform_${terraform_version}_linux_amd64.zip -d /usr/local/bin/
RUN curl -O https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip ./awscli-exe-linux-x86_64.zip
RUN ./aws/install


### copy directories 
COPY ./terraform /root/tf
COPY ./tools /root/tools


### set bash environment
RUN echo '' >> ~/.bashrc
RUN echo '' >> ~/.bashrc
RUN echo 'export PS1="@docker:\W \\$ "' >> ~/.bashrc
RUN echo 'alias la="ls -a"' >> ~/.bashrc
RUN echo 'alias ll="ls -al"' >> ~/.bashrc
RUN echo 'alias awsmfa="source /root/tools/awsmfa.sh"' >> ~/.bashrc

### move to workspace
WORKDIR /root/tf
