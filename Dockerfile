FROM officialkali/kali
MAINTAINER steev@kali.org

RUN echo "deb http://archive.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
echo "deb-src http://archive.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean
RUN apt-get install -y openssh-server
RUN echo 'root:M00nF1sh' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get install -y metasploit-framework

EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 8443
CMD ["/usr/sbin/sshd", "-D"]
