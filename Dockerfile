FROM ubuntu:16.04
MAINTAINER AnanasYuu <yuyihuang0702@163.com>

# Install dependencies and Create folders
RUN apt-get update && apt-get install --yes bash-completion apt-utils iputils-ping vim wget git-core \
    python python-pip python-dev && \
    pip install --upgrade pip && \
    sed -i "32,38s/^#//g" /etc/bash.bashrc && \
    mkdir -p /rally \
             /home/rally/data \
             /home/rally/source \
             /home/rally/html_result/rally \
             /home/rally/html_result/tempest

# Install and configuration Rally
RUN wget -P /rally/ https://raw.githubusercontent.com/openstack/rally/0.11.2/install_rally.sh && \
    sed -i 's/^RALLY_GIT_BRANCH=.*/RALLY_GIT_BRANCH="0.11.2"/' /rally/install_rally.sh && \
    sed -i 's/^RALLY_DATABASE_DIR=.*/RALLY_DATABASE_DIR=\/home\/rally\/data/' /rally/install_rally.sh && \
    sed -i 's/SOURCEDIR="\$ORIG_WD".*/SOURCEDIR="\$ORIG_WD"\/home\/rally\/source/' /rally/install_rally.sh && \
    echo 'cp $SOURCEDIR/etc/motd /etc/motd' >> /rally/install_rally.sh && \
    echo '. /usr/local/etc/bash_completion.d/rally.bash_completion' >> /etc/bash.bashrc && \
    echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc && \
    bash /rally/install_rally.sh && \
    sed -i "s/ajax.googleapis.com\/ajax\/libs\/angularjs/cdnjs.cloudflare.com\/ajax\/libs\/angular.js/" \
    /usr/local/lib/python2.7/dist-packages/rally/ui/templates/task/report.html && \
    sed -i "s/ajax.googleapis.com\/ajax\/libs\/angularjs/cdnjs.cloudflare.com\/ajax\/libs\/angular.js/" \
    /usr/local/lib/python2.7/dist-packages/rally/ui/templates/task/trends.html && \
    sed -i "s/ajax.googleapis.com\/ajax\/libs\/angularjs/cdnjs.cloudflare.com\/ajax\/libs\/angular.js/" \
    /usr/local/lib/python2.7/dist-packages/rally/ui/templates/verification/report.html

COPY . /home/rally/

# Cleanup packages.
RUN apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/

#Recreate rally database
RUN rally db recreate

#Changing workdir
WORKDIR /home/rally

# Docker volumes have specific behavior that allows this construction to work.
# Data generated during the image creation is copied to volume only when it's
# attached for the first time (volume initialization)
#VOLUME ["/home/rally/data"]
CMD ["/bin/bash"]
