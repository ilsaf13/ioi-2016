#!/bin/bash
set -e

CONTESTANT_USERNAME=contestant

# Oracle JDK 8 repository
add-apt-repository -y ppa:webupd8team/java
# Code::blocks 16 repository
add-apt-repository -y ppa:damien-moore/codeblocks-stable
# Automate Oracle JDK license acceptance
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# Update packages list and upgrade everything if needed
apt-get -y update
apt-get -y upgrade
# Install Oracle JDK
apt-get -y install oracle-java8-installer oracle-java8-set-default
# Install FreePascal
apt-get -y install fpc fp-docs
# Install IDEs and editor that can be found in the repositories
apt-get -y install codeblocks codeblocks-contrib emacs geany gedit vim-gnome joe kate kdevelop lazarus nano vim ddd mc libappindicator1 libindicator7 stl-manual konsole libvte9 valgrind python-doc
# Install other software needed for contest management
apt-get -y install openssh-server screen ntpdate
# Install software that is not found in Ubuntu repositories
cd /tmp
# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
# Sublime Text 3
wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb
dpkg -i sublime-text_build-3114_amd64.deb
# Oracle JDK Documentation (official download link requires accepting license)
#wget https://pcms.university.innopolis.ru/files/jdk-8u91-docs-all.zip
wget http://ioi2016.ru/uploads/file_store/attached_file/8/docs.zip
unzip docs.zip -d /opt/
mv /opt/docs /opt/jdk-8u91-docs
# CPP Reference
wget http://upload.cppreference.com/mwiki/images/7/78/html_book_20151129.zip
unzip html_book_20151129.zip -d /opt/cppref
# Visual Studio Code
apt-get -y install git
wget https://az764295.vo.msecnd.net/stable/809e7b30e928e0c430141b3e6abf1f63aaf55589/vscode-amd64.deb
dpkg -i vscode-amd64.deb
sudo -H -u $CONTESTANT_USERNAME bash -c "mkdir -p /home/$CONTESTANT_USERNAME/.config/Code/User" 
sudo -H -u $CONTESTANT_USERNAME bash -c "mkdir -p /home/$CONTESTANT_USERNAME/.vscode/extensions" 
sudo -u $CONTESTANT_USERNAME bash -c "DISPLAY=:0 XAUTHORITY=/home/$CONTESTANT_USERNAME/.Xauthority HOME=/home/$CONTESTANT_USERNAME/ code --install-extension ms-vscode.cpptools"
# Eclipse 4.4 and CDT plugins
wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/mars/2/eclipse-java-mars-2-linux-gtk-x86_64.tar.gz
tar xzvf eclipse-java-mars-2-linux-gtk-x86_64.tar.gz -C /opt/
mv /opt/eclipse /opt/eclipse-4.5
/opt/eclipse-4.5/eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.eclipse.org/releases/mars \
-installIUs \
org.eclipse.cdt.feature.group,\
org.eclipse.cdt.build.crossgcc.feature.group,\
org.eclipse.cdt.launch.remote,\
org.eclipse.cdt.gnu.multicorevisualizer.feature.group,\
org.eclipse.cdt.testsrunner.feature.feature.group,\
org.eclipse.cdt.visualizer.feature.group,\
org.eclipse.cdt.debug.ui.memory.feature.group,\
org.eclipse.cdt.autotools.core,\
org.eclipse.cdt.autotools.feature.group,\
org.eclipse.linuxtools.valgrind.feature.group,\
org.eclipse.linuxtools.profiling.feature.group,\
org.eclipse.remote.core,\
org.eclipse.remote.feature.group
ln -s /opt/eclipse-4.5/eclipse /usr/bin/eclipse45
#Enable/disable AltGr
#wget https://pcms.university.innopolis.ru/files/disable_altgr.sh
#wget https://pcms.university.innopolis.ru/files/enable_altgr.sh
wget http://ioi2016.ru/uploads/file_store/attached_file/6/enable_altgr.sh
wget http://ioi2016.ru/uploads/file_store/attached_file/7/disable_altgr.sh
cp disable_altgr.sh /opt/
cp enable_altgr.sh /opt/
chmod +x /opt/*.sh
# Create desktop icons
for i in gedit codeblocks ddd emacs24 firefox geany gnome-calculator gnome-terminal google-chrome gvim lazarus-1.4.0 mc org.kde.kate org.kde.konsole python2.7 python3.4 sublime_text vim code
do
	cp /usr/share/applications/$i.desktop /home/$CONTESTANT_USERNAME/Desktop
done
for i in kdevelop
do
	cp /usr/share/applications/kde4/$i.desktop /home/$CONTESTANT_USERNAME/Desktop
done
cat << EOF > eclipse45.desktop
[Desktop Entry]
Type=Application
Name=Eclipse Mars
Comment=Eclipse Integrated Development Environment
Icon=/opt/eclipse-4.5/icon.xpm
Exec=eclipse45
Terminal=false
Categories=Development;IDE;Java; 
EOF
cat << EOF > disable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Disable AltGr
Comment=Disable AltGr
Exec=/opt/disable_altgr.sh
Terminal=true
Categories=AltGr; 
EOF
cat << EOF > enable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Enable AltGr
Comment=Enable AltGr
Exec=/opt/enable_altgr.sh
Terminal=true
Categories=AltGr; 
EOF
cat << EOF > cpp-doc.desktop
[Desktop Entry]
Type=Application
Name=C++ Documentation
Comment=C++ Documentation
Icon=firefox
Exec=firefox /opt/cppref/reference/en/index.html
Terminal=false
Categories=Documentation;C++;
EOF
cat << EOF > fp-doc.desktop
[Desktop Entry]
Type=Application
Name=FreePascal Documentation
Comment=FreePascal Documentation
Icon=firefox
Exec=firefox /usr/share/doc/fp-docs/2.6.4/fpctoc.html
Terminal=false
Categories=Documentation;FP;
EOF
cat << EOF > java-doc.desktop
[Desktop Entry]
Type=Application
Name=Java Documentation
Comment=Java Documentation
Icon=firefox
Exec=firefox /opt/jdk-8u91-docs/index.html
Terminal=false
Categories=Documentation;Java;
EOF
cat << EOF > python-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 2.7 Documentation
Comment=Python 2.7 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python-doc/html/index.html
Terminal=false
Categories=Documentation;Python2;
EOF
cat << EOF > stl-manual.desktop
[Desktop Entry]
Type=Application
Name=STL Manual
Comment=STL Manual
Icon=firefox
Exec=firefox /usr/share/doc/stl-manual/html/index.html
Terminal=false
Categories=Documentation;STL;
EOF
for i in eclipse45 disable_altgr enable_altgr cpp-doc fp-doc java-doc python-doc stl-manual
do
	cp $i.desktop /home/$CONTESTANT_USERNAME/Desktop
done
chmod a+x /home/$CONTESTANT_USERNAME/Desktop/*.desktop
