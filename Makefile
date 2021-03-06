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
ERROR         := FALSE
.PHONY: all build build-nocache test tag_latest release

all: build

check:
ifndef ID
	$(info [ERROR] ID is not defined: Run <git config --add user.id "cmaoling">)
	@(ERROR="TRUE")
else
	@echo "Will use following ID provided through git: $(ID)"
endif
ifndef EMAIL
        $(info [ERROR] EMAIL is not defined: Run <git config --add user.email "cmaoling@gmail.com">)
	@(ERROR="TRUE")
else
	@echo "Will use following eMail provided through git: $(EMAIL)"
endif
ifndef NAME
        $(info [ERROR] NAME is not defined: Run <git config --add user.name "Colinas Maoling">)
	@(ERROR="TRUE")
else
	@echo "Will use following maintainer provided through git: $(NAME)"
endif
ifeq ($(ERROR), "FALSE")
	$(error "Unable to continue, please fix above errors first.$(ERROR),$(ID),$(NAME),$(EMAIL)")
else
	@echo "All variables are set."
endif


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
	$(eval PARENT  = $(shell echo "$(PARENT)" | tr '[:upper:]' '[:lower:]'))
	@echo "Parent : <$(PARENT)> Dir: <$(PARENT_DIR)>"

build: check Personalize
	@echo "[Personalize] *** PWD=$(ROOT_DIR) ID=<$(ID)> EMAIL=<$(EMAIL)> GIT=<$(GIT)> DOCKER=$(DOCKERFILE) NAME=$(SED_NAME) TAG=<$(TAG)> PARENT_NAME=<$(PARENT)> PARENT_TAG=<$(PARENT_TAG)>   ***"
	@echo "[Personalize] $(TEMPDIR)"
	sed -e 's/\[current.repository\]/$(TARGET)/' -e 's/\[current.tag\]/$(TAG)/' -e 's/\[parent.repository\]/$(PARENT)/' -e 's/\[parent.tag\]/$(PARENT_TAG)/' -e 's/\[user.id\]/$(ID)/' -e 's/\[user.name\]/$(SED_NAME)/' -e 's/\[user.email\]/$(EMAIL)/' ${DOCKERFILE} > $(TEMPDIR)/Dockerfile
	tar cvf $(TEMPDIR)/tarball --exclude-ignore=<(find . -type f -name '*Makefile*' | sed -r 's|/[^/]+$$||' | sort | uniq | grep -v '^\.$$ ') --exclude-vcs --exclude=Makefile .
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
