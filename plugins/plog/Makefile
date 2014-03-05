PREFIX?= /usr/local
BINDIR?= ${PREFIX}/bin
MANDIR?= ${PREFIX}/share/man
INSTALL?= install
INSTALLDIR= ${INSTALL} -d
INSTALLBIN= ${INSTALL} -m 755
INSTALLMAN= ${INSTALL} -m 644

all: uninstall man install

uninstall:
	rm -f ${DESTDIR}${BINDIR}/plog
	rm -f ${DESTDIR}${MANDIR}/man1/plog.1

install:
	${INSTALLDIR} ${DESTDIR}${BINDIR}
	${INSTALLBIN} plog ${DESTDIR}${BINDIR}
	${INSTALLDIR} ${DESTDIR}${MANDIR}/man1
	${INSTALLMAN} plog.1 ${DESTDIR}${MANDIR}/man1

man: plog.1

plog.1: plog.1.md
	pandoc -s -w man plog.1.md -o plog.1

.PHONY: all man uninstall install
