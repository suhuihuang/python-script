#!/bin/bash
#
dir=`pwd`

cd gcc
rpm -Uvh *.rpm --force --nodeps

cd ../glibc-2.17
mkdir build && echo build
cd build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make && make install
cd $dir

cd python3.6/lib
rpm -Uvh *.rpm --force --nodeps

cd $dir/python3.6
tar xf Python-3.6.1.tgz
cd Python-3.6.1
./configure --prefix=/usr/local/python3
make && make install
ln -s /usr/local/python3/bin/* /usr/bin/

cd $dir
pip3 install --no-index --find-links ./tmp -r requirement.txt
ln -s /usr/local/python3/bin/gunicorn /usr/bin/

cd oracle
rpm -ivh oracle-instantclient11.2-basic-11.2.0.1.0-1.x86_64.rpm
sh -c "echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf"
ldconfig
export LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib:$LD_LIBRARY_PATH
mkdir -p /usr/lib/oracle/12.2/client64/lib/network/admin


cd ../supervisor
rpm -Uvh python-setuptools-0.6.10-4.el6_9.noarch.rpm

tar xf meld3-1.0.2.tar.gz
cd meld3-1.0.2
python setup.py install
cd ..
tar xf supervisor-3.3.0.tar.gz
cd supervisor-3.3.0
python setup.py install
cd ..

cp supervisord /etc/init.d/
chmod +x /etc/init.d/supervisord

mkdir /etc/supervisord/conf.d -p
echo_supervisord_conf >/etc/supervisord.conf

cp supervisord.conf /etc/
cp sync.ini wbsearch.ini /etc/supervisord/conf.d/

/etc/init.d/supervisord restart
chkconfig supervisord on
/etc/init.d/iptables stop
chkconfig iptables off



