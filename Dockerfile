FROM docker.io/centos
MAINTAINER xiaoluohao
EXPOSE 3000
RUN echo "Asia/shanghai" > /etc/timezone;
ADD beef /var/www
ADD init.sh /
RUN chmod 755 /init.sh
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
    && rpm -Uvh http://mirrors.sohu.com/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
RUN yum clean all && yum makecache
RUN yum install -y gem \
	&& yum install -y gcc-c++ \
	&& yum install -y gcc \
	&& yum install -y ruby-* \
	&& yum install -y sqlite \
	&& yum install -y openssl-devel \
	&& yum install -y sqlite-devel 
RUN gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
RUN gem install bundler 
RUN bundle config mirror.https://rubygems.org https://ruby.taobao.org
RUN gem install sqlite3-ruby
WORKDIR /var/www
RUN bundle install
RUN cat config.yaml | grep driver:
ENTRYPOINT ["/bin/sh","/init.sh"]
