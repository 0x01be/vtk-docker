FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    cmake \
    mesa-dev \
    libexecinfo-dev

RUN git clone --depth 1 https://gitlab.kitware.com/vtk/vtk.git /vtk

RUN mkdir /vtk/build
WORKDIR /vtk/build

RUN cmake -DINSTALL_DIR=/opt/vtk ..
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/vtk/ /opt/vtk/

ENV PATH /opt/vtk/bin:$PATH

