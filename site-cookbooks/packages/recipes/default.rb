%w{
  xorg
  gdm
  gnome-session
  gnome-panel
  gnome-terminal
  firefox
  maven
  openjdk-8-jdk-headless
  libcurl4-openssl-dev
  nginx
  libjansson-dev
  subversion
  pngcrush
  python3-pillow
  libtool
  automake
  autoconf
  autotools-dev
  language-pack-en
  python-minimal
  python3.5-dev
  python3-setuptools
  libbz2-dev
  imagemagick
  libmagickcore-6.q16-2-extra
  python3-pip
  dos2unix
  liblzma-dev
  xvfb
  libicu-dev
  pkg-config
  zlib1g-dev
  libsdl1.2-dev
  tomcat8
  tomcat8-admin
  php7.0-common
  php7.0-cli
  php7.0-fpm
  php7.0-mysql
  unzip
  phantomjs
  zip
  libsdl2-dev
  libsdl2-image-dev
  libsdl2-image-2.0-0
  libsdl2-ttf-dev
  libsdl2-gfx-dev
  libxft-dev
  libgtk-3-0
  libgtk-3-dev
}.each do |pkgname|
  package "#{pkgname}" do
    action :install
    options '--no-install-recommends'
  end
end

