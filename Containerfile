# Utiliza a imagem base mais recente do RHEL 8
FROM registry.redhat.io/ubi8/ubi

# Instala o Apache e PHP da coleção de softwares (SCL) e limpa todos os dados do cache de instalação
RUN yum -y install --disableplugin=subscription-manager \
    httpd \
    && yum --disableplugin=subscription-manager clean all

# Adiciona o arquivo index.html ao diretório padrão do Apache
ADD index.html /var/www/html/

# Modifica o arquivo de configuração do Apache para escutar na porta 8888
RUN sed -i 's/^Listen 80/Listen 8888/' /etc/httpd/conf/httpd.conf \
    && chgrp -R 0 /var/log/httpd /var/run/httpd \
    && chmod -R g=u /var/log/httpd /var/run/httpd

# Expõe a porta 8888 no container
EXPOSE 8888

# Define o usuário para o ID 1001
USER 1001

# Define o comando que será executado ao iniciar o container
CMD ["httpd", "-D", "FOREGROUND"]

