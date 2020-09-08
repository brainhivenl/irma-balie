package common

import (
	"bytes"
	"context"
	"encoding/json"
	"os/exec"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
)

// ChallengeClaims is a Challenge in the JWT claims-sense.
// Acts as a challenge-response mechanism as the challenge will be signed by the MRTD using Active Authentication (AA).
// Original signed JWT should be resent to the server.
type ChallengeClaims struct {
	Challenge string `json:"challenge"`
	jwt.StandardClaims
}

// UnpackedPrototype is the set of fields in the unpacked Mrtd which are of interest to the client.
// We require valid to check whether the Mrtd itself is valid.
type UnpackedPrototype struct {
	Valid          bool   `json:"valid"`
	DocumentNumber string `json:"document_number"`
}

// IssuanceRequest is a request to the balie server for an issuance.
type IssuanceRequest struct {
	Challenge string          `json:"challenge"`
	Document  json.RawMessage `json:"document"`
}

// UnpackMrtd calls the external mrtd-unpack utility to unpack a document JSON.
func UnpackMrtd(mrtdCmd string, scannedDocument string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 3000*time.Millisecond)
	defer cancel()

	cmdParts := strings.Split(mrtdCmd, " ")
	cmd := exec.CommandContext(ctx, cmdParts[0], cmdParts[1:]...)
	cmd.Stdin = strings.NewReader(scannedDocument)

	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()

	if err != nil {
		return "", err
	}

	return out.String(), nil
}
