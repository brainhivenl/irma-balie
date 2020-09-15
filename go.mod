module github.com/tweedegolf/irma-balie

go 1.14

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/gorilla/websocket v1.4.2
	github.com/kelseyhightower/envconfig v1.4.0
	github.com/privacybydesign/irmago v0.5.0
)

replace astuart.co/go-sse => github.com/sietseringers/go-sse v0.0.0-20200223201439-6cc042ab6f6d

replace github.com/spf13/pflag => github.com/sietseringers/pflag v1.0.4-0.20190111213756-a45bfec10d59

replace github.com/spf13/viper => github.com/sietseringers/viper v1.0.1-0.20200205174444-d996804203c7
