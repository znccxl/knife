
# WARNING this is a developer makefile, not generated by Autotools.

check:
	( cd `uname` && $(MAKE) check )

install:
	( cd `uname` && $(MAKE) install )
	( cd `uname`64 && $(MAKE) install )

clean:
	( cd src && $(MAKE) clean )
	( cd `uname` && $(MAKE) clean )

bu:
	echo `find . -name '*~'`
	rm -f `find . -name '*~'`
