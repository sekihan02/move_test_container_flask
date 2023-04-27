# Use an official Ubuntu image as a parent image
FROM ubuntu:20.04

# Set the working directory to /app
WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y python3-pip

# Copy the current directory contents into the container at /app
COPY . .

RUN pip3 install -r requirements.txt

# Set the command to start jupyter lab
# runした時にjupyter labをlocalhostで起動し、root、パスなし
# アクセスはブラウザでlocalhost:8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]