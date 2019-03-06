rpm -Uvh python-setuptools-0.6.10-4.el6_9.noarch.rpm

tar xf meld3-1.0.2.tar.gz
cd meld3-1.0.2
python setup.py install

tar xf supervisor-3.3.0.tar.gz
cd supervisor-3.3.0
python setup.py install

cp supervisord /etc/init.d/
chmod +x /etc/init.d/supervisord

mkdir /etc/supervisord/conf.d -p
echo_supervisord_conf >/etc/supervisord.conf

vim  /etc/supervisord.conf
[inet_http_server] 
port=0.0.0.0:9001  
username=user      
password=123       
找到上面四行，去掉注释。127.0.0.1 改成 0.0.0.0


[include]
files = /etc/supervisord/conf.d/*.ini
在最后两行，去掉注释，把路径改成：/etc/supervisord/conf.d/*.ini


cp wbsearch  sync /etc/supervisord/conf.d/
修改wbsearch 和 sync的路径：/opt/heejue/nudt/flask_es/

最后
/etc/init.d/supervisord stop
/etc/init.d/supervisord start
chkconfig supervisord on

在浏览器中访问：

ip:9001

