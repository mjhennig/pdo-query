# ------------------------------------------------------------------------
# vim: set noexpandtab tabstop=4 textwidth=75                            :
# ------------------------------------------------------------------------
# This is the maintainer script for the pdo-query(1) tool and the files  :
# it ships with (e.g. the manual page).                                  :
# ------------------------------------------------------------------------

##
# Prepare a build directory with everything necessary
build:
	@for file in \
			bin/pdo-query \
			share/pdo-query/pdo-query.example.ini \
			man/man1/pdo-query.1 \
			Makefile.dist \
			README; do \
		dir="build/`dirname \"$$file\"`"; \
		if [ ! -d $$dir ]; then \
			echo -n "Creating \"$$dir\" directory ... "; \
			mkdir -p "$$dir" && echo "ok."; \
		fi; \
		echo -n "Transfering \"$$file\" ... "; \
		cp "$$file" "$$dir/`basename \"$$file\" .dist`"; \
		echo "ok."; \
	done
	@echo -n "Creating MANIFEST file ... "
	@cd build && md5sum `find * -type f | grep -v MANIFEST` > MANIFEST
	@echo "ok."

##
# Remove everything auto-generated, excluding packages
clean:
	@if [ -d build ]; then \
		echo -n "Removing \"build\" directory ... "; \
		rm -rf build && echo "ok."; \
	fi
	@for link in `find * -type l`; do \
		echo -n "Removing \"$$link\" link ... "; \
		rm "$$link" && echo "ok."; \
	done

##
# Remove everything auto-generated, including packages
distclean: clean
	@for archive in *.tar.gz *.tgz *.zip *.tar.bz *.bzip; do \
		if [ -e $$archive ]; then \
			echo -n "Removing \"$$archive\" archive ... "; \
			rm "$$archive" && echo "ok."; \
		fi \
	done

##
# Create a *.tar.gz package from the current build
pdo-query-%.tar.gz: build
	@echo -n "Creating "$@" archive ... "
	@ln -fs build "pdo-query-$*"
	@tar -hcvzf "pdo-query-$*.tar.gz" "pdo-query-$*" >/dev/null
	@echo "ok."
	@rm "pdo-query-$*"

##
# Create a *.zip package from the current build
pdo-query-%.zip: build
	@echo -n "Creating "$@" archive ... "
	@ln -fs build "pdo-query-$*"
	@zip -qr "pdo-query-$*.zip" "pdo-query-$*"
	@echo "ok."
	@rm "pdo-query-$*"


