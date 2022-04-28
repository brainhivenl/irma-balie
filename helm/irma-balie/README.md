## Sets of vars

```bash
export COMPANY_CONTEXT=gke_s11-company-test_europe-west4-a_companycluster-test
export IRMA_BALIE_NAMESPACE=irma-balie-test
```

```bash
export COMPANY_CONTEXT=gke_s11-company-prod_europe-west4_companycluster-prod
export IRMA_BALIE_NAMESPACE=irma-balie-prod
```

## Create namespace

```bash
kubectl --context ${COMPANY_CONTEXT} \
	create ns ${IRMA_BALIE_NAMESPACE}
```

## Docker pull permission from the cluster

Create a kubernetes secret to allow the docker daemon to pull images from stack11/commonground/irma-balie.

Create an access token with `read_registry` permission at:
https://gitlab.com/stack11/commonground/irma-balie/-/settings/access_tokens, use the ${cluster_name}-regcred as access token name for easy identification of the token at gitlab.

```bash
kubectl \
    --context ${COMPANY_CONTEXT} \
    --namespace ${IRMA_BALIE_NAMESPACE} \
    create secret docker-registry gitlab-regcred \
    --docker-server=registry.gitlab.com \
    --docker-username=k8s \
    --docker-password=<gitlab_access_token>
```

## Setup jwt privkey and scheme privkeys

```bash
kubectl \
    --context ${COMPANY_CONTEXT} \
    --namespace ${IRMA_BALIE_NAMESPACE} \
    create secret generic irma-server-jwt \
    --from-literal "jwt_privkey=$(op --vault 6tt5i3krs7owek3rva4p3txhvm document get nk2qwmxw2c3sfblbnncxiytleu)"

kubectl \
    --context ${COMPANY_CONTEXT} \
    --namespace ${IRMA_BALIE_NAMESPACE} \
    create secret generic irma-server-pilot-amsterdam-privkeys \
    --from-literal "0.xml=$(op --vault 6tt5i3krs7owek3rva4p3txhvm document get 54bt2gicviicifgswkbxtxhp4u)"\
    --from-literal "1.xml=$(op --vault 6tt5i3krs7owek3rva4p3txhvm document get hsu62qmcjtakumk7ipphtp343y)"
```
