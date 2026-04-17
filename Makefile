BIN     := tls-ca-fetch
VERSION := v1.0.0
LDFLAGS := -ldflags="-s -w"

.PHONY: build cross clean

build:
	go build $(LDFLAGS) -o $(BIN) .

cross:
	GOOS=linux   GOARCH=amd64 go build $(LDFLAGS) -o releases/$(VERSION)/$(BIN)-linux-amd64 .
	GOOS=linux   GOARCH=arm64 go build $(LDFLAGS) -o releases/$(VERSION)/$(BIN)-linux-arm64 .
	GOOS=darwin  GOARCH=arm64 go build $(LDFLAGS) -o releases/$(VERSION)/$(BIN)-darwin-arm64 .
	GOOS=darwin  GOARCH=amd64 go build $(LDFLAGS) -o releases/$(VERSION)/$(BIN)-darwin-amd64 .
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o releases/$(VERSION)/$(BIN)-windows-amd64.exe .

clean:
	rm -f $(BIN) releases/$(VERSION)/$(BIN)-*
