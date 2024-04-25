# Stage 1: Build
FROM python:3.9 AS builder
WORKDIR /app

# Copy only the requirements file to install dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Stage 2: Production
FROM python:3.9-slim
WORKDIR /app

# Copy only the built application and installed dependencies from the builder stage
COPY --from=builder /app /app

# Expose the port
EXPOSE 8001

# Define the command to run the server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]
