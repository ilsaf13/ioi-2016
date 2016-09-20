#!/bin/bash
set -e

CONTESTANT_USERNAME=contestant

# Install IDEs and editor that can be found in the repositories
apt-get -y --force-yes install khelpcenter intltool libvte-dev
# Update javadoc
wget https://pcms.university.innopolis.ru/files/jdk-8u101-docs-all.zip
unzip jdk-8u101-docs-all.zip -d /opt/
mv /opt/docs /opt/jdk-8u101-docs
rm -rf /opt/jdk-8u91-docs
# Add to NetBeans->Tools->Java Platforms->Javadoc manually

# Install software that is not found in Ubuntu repositories
cd /tmp
cat << EOF > java-doc.desktop
[Desktop Entry]
Type=Application
Name=Java Documentation
Comment=Java Documentation
Icon=firefox
Exec=firefox /opt/jdk-8u101-docs/index.html
Terminal=false
Categories=Documentation;Java;
EOF
cp java-doc.desktop /home/$CONTESTANT_USERNAME/Desktop
# Free Pascal docs
wget https://pcms.university.innopolis.ru/files/fp-doc-html.zip
unzip fp-doc-html.zip -d /opt/
mv /opt/doc /opt/fp-doc
# Add /opt/fp-doc/fpctoc.html to FreePascal->Help->Files manually

# Update Geany-plugins
apt-get -y remove geany
wget http://download.geany.org/geany-1.28.tar.gz
tar xvf geany-1.28.tar.gz
cd geany-1.28
./configure
make
make install
cd ..
wget https://pcms.university.innopolis.ru/files/geany-plugins-master.zip
unzip geany-plugins-master.zip
cd geany-plugins-master
libtoolize
./autogen.sh
make
make install
cd ..

chmod a+x /home/$CONTESTANT_USERNAME/Desktop/*.desktop
