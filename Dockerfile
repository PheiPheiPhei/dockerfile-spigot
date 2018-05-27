FROM t13a/yaourt AS builder

RUN sudo -u builder yaourt -S --noconfirm s6 spigot

FROM archlinux/base

COPY --from=builder /pkg /pkg

RUN pacman -Syu --noconfirm cronie grep netcat procps-ng tar which && \
    pacman -U --noconfirm /pkg/* && \
    rm -rf /pkg

ADD rootfs /

EXPOSE 25565

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "s6-svscan", "/etc/s6" ]
