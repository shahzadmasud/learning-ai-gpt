FROM ubuntu:20.04

MAINTAINER Shahzad Masud shahzad.masud@gmail.com

# ----- BASE SYSTEM ------
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    tzdata \
    git \
    cmake \
    curl

# ----- PYTHON3 ------
RUN apt-get install -y \
    python3 \
    python3-pip

# ----- Change Local Time ------
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# ----- PATH VARIABLES  ------
ENV PYTHONPATH /usr/local/lib/python3.6 
COPY . ./
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
RUN python3 -m spacy download en

# model zoo
RUN mkdir models && \
    curl https://s3.amazonaws.com/models.huggingface.co/transfer-learning-chatbot/finetuned_chatbot_gpt.tar.gz > models/finetuned_chatbot_gpt.tar.gz && \
    cd models/ && \
    tar -xvzf finetuned_chatbot_gpt.tar.gz && \
    rm finetuned_chatbot_gpt.tar.gz
    
CMD ["bash"]