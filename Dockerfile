FROM alpine as build

RUN apk add --no-cache --virtual vtk-build-dependencies \
    git \
    build-base \
    cmake \
    mesa-dev \
    libexecinfo-dev

ENV REVISION=master
RUN git clone --depth 1 --branch ${REVISION} https://gitlab.kitware.com/vtk/vtk.git /vtk

WORKDIR /vtk/build

RUN cmake ..
RUN make
RUN make DESTDIR=/opt/vtk/ install

FROM alpine

COPY --from=build /opt/vtk/ /opt/vtk/

ENV USER=vtk \
    WORKSPACE=/workspace
RUN adduser-D -u 1000 ${USER} &&\
    mkdir -p ${WORKSPACE} &&\
    chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
WORKDIR ${WORKSPACE}
ENV PATH=${PATH}:/opt/vtk/bin

