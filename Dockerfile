# Use Python 3.12 slim image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install setuptools first to avoid build issues
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
COPY src/api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the API source code
COPY src/api/ ./api/

# Copy the trained model and preprocessor
COPY models/trained/ ./models/trained/

# Copy the main application
COPY src/api/main.py .
COPY src/api/inference.py .
COPY src/api/schemas.py .

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"] 