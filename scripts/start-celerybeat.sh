#!/bin/sh

rm -f './celerybeat.pid'
celery -A core beat -l info