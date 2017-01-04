FROM alpine:3.4
MAINTAINER Lutz Mueller <mueller.lutz@gmail.com>

#build firebird 2.5 from sources on alpine. instructions copied from https://gist.github.com/usmansaleem/1cb81d366fd721bd09b85579dc37aacf

ENV         FIREBIRD_HOME  /usr/local/firebird
ENV         PATH           $PATH:$FIREBIRD_HOME/bin
ENV         PREFIX         $FIREBIRD_HOME
RUN         apk update && \
            apk add --no-cache --virtual=build-dependencies build-base ncurses-dev icu-dev tar ca-certificates curl && \
            update-ca-certificates && \
            mkdir /work && cd /work && \
            curl -L -o firebird-source.tar.bz2 http://downloads.sourceforge.net/project/firebird/firebird/2.5.4-Release/Firebird-2.5.4.26856-0.tar.bz2 && \
            tar --strip=1 -xf firebird-source.tar.bz2 && \
            sed -i '194s/.*/#if 0/'  src/common/classes/rwlock.h && \
            sed -i '35s/.*/ /'  src/jrd/perf.h && \
            ./configure --enable-superserver \
                    --prefix=${PREFIX} --with-fbbin=${PREFIX}/bin --with-fbsbin=${PREFIX}/bin --with-fblib=${PREFIX}/lib \
                    --with-fbudf=${PREFIX}/UDF \
                    --with-fbintl=${PREFIX}/intl --with-fbmisc=${PREFIX}/misc --with-fbplugins=${PREFIX} \
                    --with-fblog=/var/firebird/log --with-fbglock=/var/firebird/run \
                    --with-fbconf=/var/firebird/etc --with-fbmsg=${PREFIX} \
                    --with-fbsecure-db=/var/firebird/system --with-system-icu  && \
            make && \
            make silent_install && \
            make clean && \
            apk del curl ca-certificates tar icu-dev ncurses-dev build-base build-dependencies && \
            rm -rf /tmp/* /var/cache/apk/* /work
EXPOSE      3050

WORKDIR     /usr/local/firebird

CMD fbguard -daemon -forever
