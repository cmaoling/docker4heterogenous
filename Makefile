SHELL          = /bin/bash
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR   := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
ROOT_DIR      := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PARENT_DIR    := $(shell dirname $(realpath $(lastword $(ROOT_DIR))))
PARENT        := $(notdir $(patsubst %/,%,$(dir $(ROOT_DIR))))
DIRECTORY     := $(sort $(dir $(wildcard */)))
TARGET        := $(shell echo "$(CURRENT_DIR)" | tr '[:upper:]' '[:lower:]')
GIT           := $(shell which git)
ID            := $(shell $(GIT) config --get user.id)
EMAIL         := $(shell $(GIT) config --get user.email)
NAME          := $(shell $(GIT) config --get user.name)
ARCH          := $(shell uname -m)
PARENTMAKE    := $(shell ls $(ROOTDIR)/../Makefile 2>/dev/null)
DOCKERFILE    := Dockerfile
TEMPDIR       := $(shell mktemp -d)
.PHONY: all build build-nocache test tag_latest release

all: build

Dockerfile:
	@echo "[Dockerfile]" 
	$(eval TEST = $(DOCKERFILE)"."$(ARCH))
ifeq (,$(wildcard $(TEST)))
		$(eval DOCKERFILE=$(DOCKERFILE).$(ARCH))
		@echo "Using Dockerfile=$(DOCKERFILE) provided for Architecture=$(ARCH)"
else
		@echo "Using default Dockerfile=$(DOCKERFILE)"
endif

bootstrap: $(ROOT_DIR)/Makefile
	@echo -n "[Bootstrap  ] Parent-Make <$@> <$(ROOT_DIR)>: "
	@for a in  $(DIRECTORY); do \
		echo "$${a}Dockerfile"; \
		if [ -d $$a ]; then \
			if [ `ls -1  $${a}Dockerfile* 2>/dev/null | wc -l` -gt 0 ]; then \
				cp $(ROOT_DIR)/Makefile $$a; \
				$(MAKE) -C $$a $@; \
			else \
				echo "skipping folder $$a"; \
			fi; \
		fi; \
	done;
	@echo "Done!"

parent: $(ROOT_DIR)/../Makefile
	@echo -n "[Parent     ] Parent-Make <$@> <$(ROOT_DIR)>: "
	-@make -C $(ROOT_DIR)/.. -f $(ROOT_DIR)/../Makefile -k bootstrap
	@make -C $(ROOT_DIR)/.. -f $(ROOT_DIR)/../Makefile -k build


Personalize: Dockerfile
	@echo -n "[Dockerfile] Personalize <$(DOCKERFILE)>: "
	$(eval SED_NAME = $(shell echo "$(NAME)" | sed 's/ /\\ /g' ))
	$(eval TAG  = $(shell cat image.tag 2> /dev/null))
	$(eval TAG  = $(shell echo ":$(TAG)" | sed -e 's/^:$$//g' ))
	@echo -n "Image-Tag: <$(TAG)> "
	$(eval PARENT_TAG  = $(shell cat ../image.tag 2> /dev/null))
	$(eval PARENT_TAG  = $(shell echo ":$(PARENT_TAG)" | sed -e 's/^:$$//g' | tr '[:upper:]' '[:lower:]'))
	@echo -n "Parent-Tag: <$(PARENT_TAG)> "
	@echo "Parent : <$(PARENT)> Dir: <$(PARENT_DIR)>"

build: Personalize
	@echo "[Personalize] *** PWD=$(ROOT_DIR) ID=<$(ID)> EMAIL=<$(EMAIL)> GIT=<$(GIT)> DOCKER=$(DOCKERFILE) NAME=$(SED_NAME) TAG=<$(TAG)> PARENT_NAME=<$(PARENT)> PARENT_TAG=<$(PARENT_TAG)>   ***"
	@echo "[Personalize] $(TEMPDIR)"
	sed -e 's/\[current.repository\]/$(TARGET)/' -e 's/\[current.tag\]/$(TAG)/' -e 's/\[parent.repository\]/$(PARENT)/' -e 's/\[parent.tag\]/$(PARENT_TAG)/' -e 's/\[user.id\]/$(ID)/' -e 's/\[user.name\]/$(SED_NAME)/' -e 's/\[user.email\]/$(EMAIL)/' ${DOCKERFILE} > $(TEMPDIR)/Dockerfile
	tar cvf  $(TEMPDIR)/tarball .
	tar --delete --wildcards -f $(TEMPDIR)/tarball ./Dockerfile*
	@cd $(TEMPDIR); tar rf $(TEMPDIR)/tarball ./Dockerfile
	tar tvf $(TEMPDIR)/tarball
	cat $(TEMPDIR)/tarball | docker build -t $(ID)/$(TARGET)$(TAG) -
	rm -rf $(TEMPDIR)

tag_latest:
	docker tag -f $(TARGET):$(VERSION) $(TARGET):latest

release: build test tag_latest
	@if ! docker images $(TARGET) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(TARGET) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(TARGET)
	@echo "*** Don't forget to run 'twgit release/hotfix finish' :)" 
