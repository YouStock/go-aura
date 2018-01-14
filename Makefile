# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: aura android ios aura-cross swarm evm all test clean
.PHONY: aura-linux aura-linux-386 aura-linux-amd64 aura-linux-mips64 aura-linux-mips64le
.PHONY: aura-linux-arm aura-linux-arm-5 aura-linux-arm-6 aura-linux-arm-7 aura-linux-arm64
.PHONY: aura-darwin aura-darwin-386 aura-darwin-amd64
.PHONY: aura-windows aura-windows-386 aura-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

aura:
	build/env.sh go run build/ci.go install ./cmd/aura
	@echo "Done building."
	@echo "Run \"$(GOBIN)/aura\" to launch aura."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/aura.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Aura.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

aura-cross: aura-linux aura-darwin aura-windows aura-android aura-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/aura-*

aura-linux: aura-linux-386 aura-linux-amd64 aura-linux-arm aura-linux-mips64 aura-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-*

aura-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/aura
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep 386

aura-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/aura
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep amd64

aura-linux-arm: aura-linux-arm-5 aura-linux-arm-6 aura-linux-arm-7 aura-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep arm

aura-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/aura
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep arm-5

aura-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/aura
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep arm-6

aura-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/aura
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep arm-7

aura-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/aura
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep arm64

aura-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/aura
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep mips

aura-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/aura
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep mipsle

aura-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/aura
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep mips64

aura-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/aura
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/aura-linux-* | grep mips64le

aura-darwin: aura-darwin-386 aura-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/aura-darwin-*

aura-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/aura
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/aura-darwin-* | grep 386

aura-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/aura
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/aura-darwin-* | grep amd64

aura-windows: aura-windows-386 aura-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/aura-windows-*

aura-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/aura
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/aura-windows-* | grep 386

aura-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/aura
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/aura-windows-* | grep amd64
