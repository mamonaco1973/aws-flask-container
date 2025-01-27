## Dockerfile Summary

This Dockerfile builds a containerized environment for a Flask application using **Amazon Linux 2023**. Here's what it does:

### **Base Image**:
   - Starts with **Amazon Linux 2023** as the base image.

### **Environment Preparation**:
   - Updates the package manager and installs Python 3 and pip.
   - Cleans up temporary files to reduce image size.

### **Directory Setup**:
   - Creates a `/flask` directory for the application and assigns full permissions.

### **File Management**:
   - Copies the application files (`app.py`, `requirements.txt`, `start_flask_app.sh`, and `utils.py`) into the `/flask` directory.

### **Permissions**:
   - Makes the `start_flask_app.sh` script executable.

### **Dependencies Installation**:
   - Installs Python dependencies listed in `requirements.txt`.

### **Default Command**:
   - Specifies that the container runs the `start_flask_app.sh` script when started.


