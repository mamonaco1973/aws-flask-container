FROM ubuntu:24.04

# Update the package manager and install Python 3 and pip

RUN apt update -y && \
    apt install -y python3-pip && \
    apt-get clean && \
    mkdir /flask && \
    chmod 777 /flask

COPY app.py /flask/
COPY requirements.txt /flask/
COPY start_flask_app.sh /flask/
COPY utils.py /flask/

RUN chmod +x /flask/start_flask_app.sh &&  \
    pip3 install -r /flask/requirements.txt --break-system-packages

EXPOSE 8000

# Set a default command
ENTRYPOINT [ "/flask/start_flask_app.sh" ]
