# Use Windows Server Core base
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables
ENV PYTHON_VERSION=3.10.11

# Use PowerShell for RUN commands
SHELL ["powershell", "-Command"]

# Download and install Python
RUN Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$env:PYTHON_VERSION/python-$env:PYTHON_VERSION-amd64.exe" -OutFile python-installer.exe ; \
    Start-Process python-installer.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' -Wait ; \
    Remove-Item python-installer.exe

# Verify Python
RUN python --version

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install dependencies
RUN pip install --upgrade pip ; \
    if (Test-Path 'requirements.txt') { pip install -r requirements.txt }

# Expose port (adjust if needed)
EXPOSE 8000

# Start the Python app (adjust entry point if needed)
CMD ["python", "app.py"]
