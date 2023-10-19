FROM public.ecr.aws/lambda/python:3.11

# Install Python packages
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy function code and models
COPY app.py ${LAMBDA_TASK_ROOT}
COPY models/*.pkl ${LAMBDA_TASK_ROOT}/models/

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
ENV NLTK_DATA=/tmp
ENV AWS_LAMBDA_FUNCTION_TIMEOUT=360
CMD [ "app.lambda_handler" ]