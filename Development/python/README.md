# Python Env

This docker file is meant to provide a template for packing Python applications.

- Base: `python:3.11.2-alpine3.17`
- Working dir: `/app`

Application structure:

- `/app`: Application folder
- `/app/requirements.txt`: Requirements for pip to install
- `/app/main.py`: Application entry point