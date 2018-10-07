PREFIX ?= /usr
DESTDIR ?=
BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions

all:
	@echo "This package adds bash completion to vboxmanage. no compilation needed"
	@echo ""
	@echo "To install it try \"make install\" instead."

install:
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)/"
	@install -v -m 644 VBoxManage  "$(DESTDIR)$(BASHCOMPDIR)/VBoxManage"
	@ln -sv "VBoxManage" "$(DESTDIR)$(BASHCOMPDIR)/vboxmanage"
	@echo
	@echo "bash completion for vboxmanage installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(BASHCOMPDIR)/VBoxManage" \
		"$(DESTDIR)$(BASHCOMPDIR)/vboxmanage"

.PHONY: install uninstall
