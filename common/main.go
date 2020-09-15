package common

import (
	"bytes"
	"context"
	"encoding/json"
	"os"
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

// MrtdRequest is a request that is sent to MrtdUnpack.
type MrtdRequest struct {
	Challenge string `json:"challenge"`
	json.RawMessage
}

// UnpackedPrototype is the set of fields in the unpacked Mrtd which are of interest to the client or server.
// We require valid to check whether the Mrtd itself is valid.
type UnpackedPrototype struct {
	Valid          bool   `json:"valid"`
	DocumentCode   string `json:"document_code"`
	DocumentNumber string `json:"document_number"`
	FirstNames     string `json:"first_name"`
	LastName       string `json:"last_name"`
	Nationality    string `json:"nationality"`
	PersonalNumber string `json:"personal_number"`
	DateOfBirth    string `json:"date_of_birth"`
	DateOfExpiry   string `json:"date_of_expiry"`
	Gender         string `json:"gender"`
	FaceImage      string `json:"face_image"`
}

// IssuanceRequest is a request to the balie server for an issuance.
type IssuanceRequest struct {
	Challenge string          `json:"challenge"`
	Document  json.RawMessage `json:"document"`
}

func runMrtd(timeout time.Duration, mrtdCmd string, input []byte, pipeStderr bool) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	cmdParts := strings.Split(mrtdCmd, " ")

	if input != nil {
		cmdParts = append(cmdParts, "stdin")
	}

	cmd := exec.CommandContext(ctx, cmdParts[0], cmdParts[1:]...)
	cmd.Stdin = bytes.NewReader(input)
	if pipeStderr {
		cmd.Stderr = os.Stderr
	}

	var out bytes.Buffer
	cmd.Stdout = &out
	if err := cmd.Run(); err != nil {
		return "", err
	}

	return out.String(), nil
}

// UnpackMrtd calls the external mrtd-unpack utility to unpack a document JSON.
func UnpackMrtd(mrtdCmd string, request MrtdRequest) (string, error) {
	requestBytes, err := json.Marshal(request)
	if err != nil {
		return "", err
	}

	return runMrtd(3*time.Second, mrtdCmd, requestBytes, true)
}

// TestMrtd runs the external mrtd-unpack utility, without any input, to verify the functionality.
func TestMrtd(mrtdCmd string) (string, error) {
	return runMrtd(30*time.Second, mrtdCmd, nil, false)
}
