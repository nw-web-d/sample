FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP /usr/src/app/hello.py

EXPOSE 5000

# CMD [ "flask", "run" ]
CMD [ "python", "/usr/src/app/hello.py" ]

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://127.0.0.1:5000/ || exit 1
