FROM python:3.11.2-alpine3.17
RUN apk upgrade
COPY app /app/
# You can also use git repo:
# ADD https://github.com/to/repo /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD [ "python3", "main.py" ]