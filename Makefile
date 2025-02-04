PKG_PREFIX := github.com/thunderbird86/go-sandbox

PKG_TAG ?= $(shell git tag -l --points-at HEAD)

DATEINFO_TAG ?= $(shell date -u +'%Y%m%d-%H%M%S')

BUILDINFO_TAG ?= $(shell echo $$(git describe --long --all | tr '/' '-')$$( \
	      git diff-index --quiet HEAD -- || echo '-dirty-'$$(git diff-index -u HEAD | openssl sha1 | cut -d' ' -f2 | cut -c 1-8)))

LATEST_TAG ?= latest

ifeq ($(PKG_TAG),)
PKG_TAG := $(BUILDINFO_TAG)
endif

GO_BUILDINFO = -X '$(PKG_PREFIX)/lib/buildinfo.Version=$(APP_NAME)-$(DATEINFO_TAG)-$(BUILDINFO_TAG)'

TAR_OWNERSHIP ?= --owner=1000 --group=1000

.PHONY: $(MAKECMDGOALS)

include app/*/Makefile
include deployment/*/Makefile

all: \
	echo-server-prod \

check-all: fmt vet golangci-lint govulncheck

clean-checkers: remove-golangci-lint remove-govulncheck

benchmark:
	go test -bench=. ./app/...

vendor-update:
	go get -u ./app/...
	go mod tidy -compat=1.23
	go mod vendor

app-local:
	CGO_ENABLED=0 go build $(RACE) -ldflags "$(GO_BUILDINFO)" -o bin/$(APP_NAME)$(RACE) $(PKG_PREFIX)/app/$(APP_NAME)