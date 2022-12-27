# builder image
FROM pelias/baseimage as builder

# libpostal apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y autoconf automake libtool pkg-config python3 && \
    rm -rf /var/lib/apt/lists/*

# clone libpostal
RUN git clone https://github.com/openvenues/libpostal /code/libpostal
WORKDIR /code/libpostal

# install libpostal
RUN ./bootstrap.sh && \
    ./configure --datadir=/usr/share/libpostal

RUN /code/libpostal/src/libpostal_data download all /usr/share/libpostal/libpostal; exit 0
RUN /code/libpostal/src/libpostal_data download all /usr/share/libpostal/libpostal; exit 0
RUN /code/libpostal/src/libpostal_data download all /usr/share/libpostal/libpostal; exit 0
RUN /code/libpostal/src/libpostal_data download all /usr/share/libpostal/libpostal; exit 0
RUN /code/libpostal/src/libpostal_data download all /usr/share/libpostal/libpostal; exit 0

RUN make && \
    DESTDIR=/libpostal make install && \
    ldconfig

# main image
FROM pelias/baseimage

COPY --from=builder /usr/share/libpostal /usr/share/libpostal
COPY --from=builder /libpostal /
