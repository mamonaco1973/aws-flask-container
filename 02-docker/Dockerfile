# Use the official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Update the package manager and install Python 3 and pip
RUN apt update -y && \                              # Update the list of available packages
    apt install -y python3-pip && \                 # Install Python 3 and pip
    apt-get clean && \                              # Clean up cached files to reduce image size
    mkdir /flask && \                               # Create a directory to hold the application files
    chmod 777 /flask                                # Set full read/write/execute permissions on the directory

# Copy application files to the /flask directory in the container
COPY app.py /flask/                                 # Copy the main Flask application file
COPY requirements.txt /flask/                       # Copy the Python dependencies file
COPY start_flask_app.sh /flask/                     # Copy the shell script to start the Flask app

# Prepare the application environment
RUN chmod +x /flask/start_flask_app.sh && \         # Make the startup script executable
    pip3 install -r /flask/requirements.txt --break-system-packages # Install dependencies from requirements.txt, bypassing system restrictions

# Expose port 8000 for the Flask application
EXPOSE 8000                                         

# Set the default command to run the Flask application
ENTRYPOINT [ "/flask/start_flask_app.sh" ]          # Define the shell script as the container's entry point
