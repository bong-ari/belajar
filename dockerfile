FROM debian:11

# Update and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Create directory for Snort source
RUN mkdir ~/snort_src
WORKDIR ~/snort_src

# Install dependencies
RUN apt-get install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev \
    zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest libsqlite3-dev \
    libtool uuid-dev git autoconf bison flex libcmocka-dev libnetfilter-queue-dev libunwind-dev \
    libmnl-dev ethtool libjemalloc-dev

# Download and install libsafec
RUN wget https://github.com/rurban/safeclib/releases/download/v02092020/libsafec-02092020.tar.gz \
    && tar -xzvf libsafec-02092020.tar.gz \
    && cd libsafec-02092020.0-g6d921f \
    && ./configure \
    && make \
    && sudo make install

# Download and install PCRE
RUN wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz \
    && tar -xzvf pcre-8.45.tar.gz \
    && cd pcre-8.45 \
    && ./configure \
    && make \
    && sudo make install

# Download and install gperftools
RUN wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz \
    && tar xzvf gperftools-2.9.1.tar.gz \
    && cd gperftools-2.9.1 \
    && ./configure \
    && make \
    && sudo make install

# Download and install Ragel
RUN wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz \
    && tar -xzvf ragel-6.10.tar.gz \
    && cd ragel-6.10 \
    && ./configure \
    && make \
    && sudo make install

# Download and extract Boost
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz \
    && tar -xvzf boost_1_77_0.tar.gz

# Download and install Hyperscan
RUN wget https://github.com/intel/hyperscan/archive/refs/tags/v5.4.0.tar.gz \
    && tar -xvzf v5.4.0.tar.gz \
    && mkdir ~/snort_src/hyperscan-5.4.0-build \
    && cd hyperscan-5.4.0-build/ \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_77_0/ ../hyperscan-5.4.0 \
    && make \
    && sudo make install

# Download and install Flatbuffers
RUN wget https://github.com/google/flatbuffers/archive/refs/tags/v2.0.0.tar.gz -O flatbuffers-v2.0.0.tar.gz \
    && tar -xzvf flatbuffers-v2.0.0.tar.gz \
    && mkdir flatbuffers-build \
    && cd flatbuffers-build \
    && cmake ../flatbuffers-2.0.0 \
    && make \
    && sudo make install

# Download and install libdaq
RUN wget https://github.com/snort3/libdaq/archive/refs/tags/v3.0.5.tar.gz -O libdaq-3.0.5.tar.gz \
    && tar -xzvf libdaq-3.0.5.tar.gz \
    && cd libdaq-3.0.5 \
    && ./bootstrap \
    && ./configure \
    && make \
    && sudo make install \
    && sudo ldconfig

# Download and install Snort3
RUN wget https://github.com/snort3/snort3/archive/refs/tags/3.1.18.0.tar.gz -O snort3-3.1.18.0.tar.gz \
    && tar -xzvf snort3-3.1.18.0.tar.gz \
    && cd snort3-3.1.18.0 \
    && ./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc --enable-jemalloc \
    && cd build \
    && make \
    && sudo make install

# Create necessary directories and files
RUN sudo mkdir /usr/local/etc/rules \
    && sudo mkdir /usr/local/etc/so_rules/ \
    && sudo mkdir /usr/local/etc/lists/ \
    && sudo touch /usr/local/etc/rules/local.rules \
    && sudo touch /usr/local/etc/lists/default.blocklist \
    && sudo mkdir /var/log/snort

# Add custom Snort rule
RUN echo 'alert icmp any any -> any any (msg:"ICMP Traffic Detected"; sid:10000001; metadata:policy security-ips alert; )' | sudo tee -a /usr/local/etc/rules/local.rules

# Start Snort
CMD snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules
