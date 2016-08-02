FROM centos:7

RUN yum -y update; yum clean all; yum -y install which wget git ed libcurl-devel gcc-c++ pango-devel librsvg2-devel

WORKDIR /opt/
# Install R
RUN wget https://mran.revolutionanalytics.com/install/mro/3.3.0/MRO-3.3.0.el7.x86_64.rpm; \
    yum install -y MRO-3.3.0.el7.x86_64.rpm; rm -rf MRO-3.3.0.el7.x86_64.rpm

# Install necessary R packages
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')"
# Install Shiny Server
RUN wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.4.802-rh5-x86_64.rpm; \
	yum install -y --nogpgcheck shiny-server-1.4.4.802-rh5-x86_64.rpm; \
	rm -rf shiny-server-1.4.4.802-rh5-x86_64.rpm
# Install Radiant
RUN R -e "install.packages('radiant', repos='https://radiant-rstats.github.io/minicran/')"
RUN git clone --depth 1 https://github.com/radiant-rstats/radiant; \
	cp -r radiant /srv/shiny-server; \
	cd /opt; rm -rf radiant; \
	cd /srv/shiny-server/radiant; rm -rf .Rbuildignore .git .gitingore .travis.yml build
# Add starting script
ADD shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]
