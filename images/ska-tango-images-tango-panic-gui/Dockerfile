ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder:9.3.29"
FROM $BASE_IMAGE

LABEL \
      author="Andrew Bolin <andrew.bolin@csiro.au>, Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the Panic GUI application available from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-panic-gui" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango Panic GUI"

# # # NOTES
# - pip2 crashes if the package we want isn't in the SKA repo,
#     so we temporarily hide the SKA pip.conf
# - python-qt4 is needed for the panic gui (but not PyAlarm)
# - pip doesn't automically install lxml (needed for GUI but not PyAlarm)
# - Format of boost library name was apparently changed between 1.65 and 1.67,
#     so we make a symlink
# - panic uses python 2, but 'python' maps to python3 in our base image,
#     so we use sed to edit the PyAlarm launcher
ENV DEBIAN_FRONTEND=noninteractive

RUN mv /etc/pip.conf /tmp/ska_pip_conf


RUN apt-get update && \
    apt-get -y install python2.7
    
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python27.so /usr/lib/x86_64-linux-gnu/libboost_python-py27.so && \
    pip install panic lxml

RUN mv /tmp/ska_pip_conf /etc/pip.conf
RUN sed -i.original 's/python/python2/g' `which PyAlarm`

# now the VNC stuff (ref. tango-vnc image in ska-tango-images repo)
ENV DISPLAY=:20

USER root

RUN apt-get update && apt-mark hold iptables && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils  \
      xfce4  \
      gtk3-engines-xfce \
      libgtk-3-bin \
      mousepad \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal  \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
      xfce4-notes-plugin \
      xfce4-places-plugin \
      xfce4-sensors-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin \
      libxv1 \
      mesa-utils \
      mesa-utils-extra

RUN sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

RUN apt-get update && apt-get install -y \
    git \
    x11vnc \
    software-properties-common \
    unzip \
    curl \
    slim \
    xvfb \
    novnc \
    python-websockify

#Expose port 5920 to view display using VNC Viewer
EXPOSE 5920
EXPOSE 6081

CMD Xvfb :20 -screen 0 1366x768x16 & x11vnc -passwd TestVNC -display :20 -N -forever & startxfce4 & websockify --web /usr/share/novnc 6081 localhost:5920
