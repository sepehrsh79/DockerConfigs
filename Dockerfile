FROM python:3.11

RUN mkdir /app

# Fix python printing
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV DJANGO_SUPERUSER_EMAIL = ''
ENV DJANGO_SUPERUSER_USERNAME = ''
ENV DJANGO_SUPERUSER_PASSWORD = ''

RUN python3.11 -m pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip 
RUN python3.11 -m pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple setuptools wheel cython
RUN apt-get -o Acquire::Check-Valid-Until=false update -y
RUN apt-get -o Acquire::Check-Valid-Until=false upgrade -y
    
# Installing all python dependencies
ADD ./requirements.txt ./
RUN pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
RUN pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple gunicorn celery

COPY scripts/entrypoint.sh /
RUN sed -i 's/\r$//g' /entrypoint.sh
RUN chmod o+x /entrypoint.sh

COPY scripts/start-django.sh /
RUN sed -i 's/\r$//g' /start-django.sh
RUN chmod o+x /start-django.sh

COPY scripts/start-celeryworker.sh /
RUN sed -i 's/\r$//g' /start-celeryworker.sh
RUN chmod o+x /start-celeryworker.sh

COPY scripts/start-celerybeat.sh /
RUN sed -i 's/\r$//g' ./start-celerybeat.sh
RUN chmod o+x ./start-celerybeat.sh

COPY scripts/start-flower.sh /
RUN sed -i 's/\r$//g' ./start-flower.sh
RUN chmod o+x ./start-flower.sh

# copy project
ADD ./ /app/

WORKDIR /app

# run entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh && exec \"$@\""]
