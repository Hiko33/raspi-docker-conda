# FROM ubuntu:latest
# 32ビット版のUbuntuは動作がおかしいのでRaspbianを入れることにした
FROM raspbian/stretch:latest
RUN apt-get update && apt-get install -y \
	sudo \
	wget \
	vim \
	bzip2 \
	pigpio
WORKDIR /opt

# dpkg-reconfigureで、dashをbashに変更する
RUN wget https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh && \
	chmod +x Berryconda3-2.0.0-Linux-armv7l.sh && \
	echo "dash dash/sh boolean false" | sudo debconf-set-selections && \
	sudo dpkg-reconfigure --frontend=noninteractive dash && \
	sh /opt/Berryconda3-2.0.0-Linux-armv7l.sh -b -p /opt/berryconda3 && \
	rm -f Berryconda3-2.0.0-Linux-armv7l.sh

ENV PATH /opt/berryconda3/bin:$PATH

RUN pip install --upgrade pip
# RUN apt-get install -y python3-rpi.gpio
# add jupyter lab and necessary packages
RUN conda install -y \
	jupyterlab \
	matplotlib \
	numpy \
	pandas \
	scipy \
	seaborn
# GPIO enable command
RUN pigpiod
WORKDIR /
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]
# Docker run command sample
# docker run -p 8888:8888 -v ~/Desktop/ds_python/:/work_pi --rm --privileged --name my-lab <docker image>
