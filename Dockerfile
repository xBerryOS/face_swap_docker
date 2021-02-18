FROM rudychin/face_swap_docker:gpu

RUN cd ~ \
    && rm -fr face_swap \
    && git clone https://github.com/YuvalNirkin/face_swap \
    && cd face_swap \
    && mkdir build \
    && cd build \
    && cmake -DWITH_BOOST_STATIC=OFF \
        -DBUILD_INTERFACE_PYTHON=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_APPS=ON \
        -DBUILD_TESTS=OFF \
        cmake -DCMAKE_INSTALL_PREFIX=/installations/face_swap \
        -DCMAKE_BUILD_TYPE=Release ..\
    && make -j8 \
    && make install

WORKDIR /installations/face_swap
