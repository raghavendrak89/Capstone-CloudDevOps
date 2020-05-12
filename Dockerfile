FROM python:3.7

RUN apt-get install curl -y
RUN apt-get install wget -y
RUN pip3 install flask && pip3 install flask
RUN pip3 install requests && pip3 install argparse && pip3 install PyYAML && pip3 install flask-expects-json
RUN pip3 install pytz && pip3 install tzlocal && pip3 install pytz


WORKDIR /home/webhook
COPY webhook/app_flask.py /home/webhook

#ENTRY POINT
CMD python3 app_flask.py 

EXPOSE 8885
