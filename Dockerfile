FROM amazonlinux:2


# Update yum
RUN yum update -y

# Install base command and libs
RUN yum install -y unzip less jq

# Install git
RUN yum install -y git

# Install tfenv, terraform:latest
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
RUN ~/.tfenv/bin/tfenv install latest && \
    ~/.tfenv/bin/tfenv use latest

# Install awscli
RUN curl -O https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip ./awscli-exe-linux-x86_64.zip && \
    ./aws/install


### copy directories 
COPY ./terraform /root/tf
COPY ./tools /root/tools


### set bash environment
RUN echo '' >> ~/.bashrc && \
    echo '' >> ~/.bashrc && \
    echo 'export PS1="@docker:\W \\$ "' >> ~/.bashrc && \
    echo 'alias la="ls -a"' >> ~/.bashrc && \
    echo 'alias ll="ls -al"' >> ~/.bashrc && \
    echo 'alias awsmfa="source /root/tools/awsmfa.sh"' >> ~/.bashrc

### move to workspace
WORKDIR /root/tf
