#!/bin/sh

celery -A core.celery worker -l info