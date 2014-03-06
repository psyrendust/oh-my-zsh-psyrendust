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
	ronn plog.1.ronn
	mv plog.1 man1/plog.1
	mv plog.1.html man1/plog.1.html

.PHONY: all man uninstall install
