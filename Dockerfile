# Use an existing image as a base
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Copy the scripts and config into the container
COPY ./Configuration ./Configuration/
COPY ./Functions ./Functions
COPY ./Help_and_Setup ./Help_and_Setup/
COPY ./pandoc_conversion.sh ./

# Install any necessary dependencies (e.g., curl, jq)
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    pandoc

# Give execute permissions to your scripts
RUN chmod +x *.sh

# Command to run your main script
CMD ["./pandoc_conversion.sh"]

# Build the image with the following command:
# docker build -t <image_name> <path_to_dockerfile> (ex. docker build -t pandoc .)
# Run the container with the following command:
# docker run <image_name> <args> (ex. docker run pandoc ./pandoc_conversion.sh help)
