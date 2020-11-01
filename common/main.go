package common

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
)

// UniversalDateLayout is the layout for universal dates consumed by time.Parse.
const UniversalDateLayout = "2006-01-02"

// ChallengeClaims is a Challenge in the JWT claims-sense.
// Acts as a challenge-response mechanism as the challenge will be signed by the MRTD using Active Authentication (AA).
// Original signed JWT should be resent to the server.
type ChallengeClaims struct {
	Challenge string `json:"challenge"`
	jwt.StandardClaims
}

// MrtdRequest is a request that is sent to MrtdUnpack.
type MrtdRequest struct {
	Challenge string          `json:"challenge"`
	Document  json.RawMessage `json:"document"`
}

// UnpackedPrototype is the set of fields in the unpacked Mrtd which are of interest to the client or server.
// We require valid to check whether the Mrtd itself is valid.
type UnpackedPrototype struct {
	Valid          bool   `json:"valid"`
	DocumentCode   string `json:"document_code"`
	DocumentNumber string `json:"document_number"`
	FirstNames     string `json:"first_names"`
	LastName       string `json:"last_name"`
	Nationality    string `json:"nationality"`
	PersonalNumber string `json:"personal_number"`
	DateOfBirth    string `json:"date_of_birth"`
	DateOfExpiry   string `json:"date_of_expiry"`
	Issuer         string `json:"issuer"`
	Gender         string `json:"gender"`
	FaceImage      string `json:"face_image"`
}

// IssuanceRequest is a request to the balie server for an issuance.
type IssuanceRequest struct {
	Challenge string          `json:"challenge"`
	Document  json.RawMessage `json:"document"`
}

// IssuanceClaims is the response after an issuance request, to be signed in a JWT.
type IssuanceClaims struct {
	SessionPtr json.RawMessage `json:"session_ptr"`
	Token      string          `json:"token"`
	jwt.StandardClaims
}

// StatusResponse is the response resulting from a service status request. If any fields are valued false, the service not ready.
type StatusResponse struct {
	Upstream bool `json:"upstream"`
	Clock    bool `json:"clock"`
}

// IsOK yields whether all status messages are OK.
func (status StatusResponse) IsOK() bool {
	return status.Upstream && status.Clock
}

func runMrtd(timeout time.Duration, mrtdCmd string, input []byte, getVersion bool) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	cmdParts := strings.Split(mrtdCmd, " ")

	if getVersion {
		cmdParts = append(cmdParts, "version")
	} else {
		cmdParts = append(cmdParts, "stdin")
	}

	cmd := exec.CommandContext(ctx, cmdParts[0], cmdParts[1:]...)
	cmd.Stdin = bytes.NewReader(input)
	cmd.Stderr = os.Stderr

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

	return runMrtd(30*time.Second, mrtdCmd, requestBytes, false)
}

// TestMrtd runs the external mrtd-unpack utility, without any input, to verify the functionality.
func TestMrtd(mrtdCmd string) error {
	version, err := runMrtd(30*time.Second, mrtdCmd, nil, true)

	if err != nil {
		return err
	}

	if strings.TrimSpace(version) != "1.0.0" {
		return errors.New("Mrtd-unpack does not seem to be the correct version")
	}

	return nil
}

func overAge(now time.Time, dateOfBirth time.Time, years int) string {
	if now.Before(dateOfBirth.AddDate(years, 0, 0)) {
		return "no"
	}

	return "yes"
}

// ToCredentialAttributes converts an UnpackedPrototype to the attributes intended for an IRMA credential.
func (up UnpackedPrototype) ToCredentialAttributes(now time.Time) (map[string]string, error) {
	dateOfBirth, err := time.Parse(UniversalDateLayout, up.DateOfBirth)
	if err != nil {
		return nil, err
	}

	result := map[string]string{
		"dateofexpiry":   up.DateOfExpiry,
		"assurancelevel": "Substantial",
		"documentnumber": up.DocumentNumber,
		"gender":         up.Gender,
		"firstnames":     up.FirstNames,
		"surname":        up.LastName,
		"dateofbirth":    up.DateOfBirth,
		"nationality":    up.Nationality,
		"over12":         overAge(now, dateOfBirth, 12),
		"over16":         overAge(now, dateOfBirth, 16),
		"over18":         overAge(now, dateOfBirth, 18),
		"over21":         overAge(now, dateOfBirth, 21),
		"over65":         overAge(now, dateOfBirth, 65),
		"personalnumber": up.PersonalNumber,
		"photo":          up.FaceImage,
	}

	return result, nil
}
