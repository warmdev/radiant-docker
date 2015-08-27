FROM centos:7

RUN yum -y update; yum clean all; yum -y install wget git ed libcurl-devel gcc-c++

WORKDIR /opt/
# Install R
RUN wget https://mran.revolutionanalytics.com/install/RRO-3.2.1-el7.x86_64.tar.gz; \
    tar xzf RRO-3.2.1-el7.x86_64.tar.gz; \
    cd RRO-3.2.1 && ./install.sh; \
    cd /opt/ && rm -rf RRO-3.2.1-el7.x86_64.tar.gz && rm -rf RRO-3.2.1
# Install necessary R packages
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')"
# Install Shiny Server
RUN wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.0.721-rh5-x86_64.rpm; \
	yum install -y --nogpgcheck shiny-server-1.4.0.721-rh5-x86_64.rpm; \
	rm -rf shiny-server-1.4.0.721-rh5-x86_64.rpm
# Install Radiant
RUN R -e "install.packages('radiant', repos='http://vnijs.github.io/radiant_miniCRAN/')"
RUN git clone --depth 1 https://github.com/vnijs/radiant.git; \
	cp -r radiant /srv/shiny-server; \
	cd /opt; rm -rf radiant; \
	cd /srv/shiny-server/radiant; rm -rf .Rbuildignore .git .gitingore .travis.yml build tests
# Add starting script
ADD shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]