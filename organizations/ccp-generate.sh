#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}
function json_ccp1 {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template1.json
}

function yaml_ccp1 {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template1.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/hospital1.example.com/tlsca/tlsca.hospital1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/hospital1.example.com/ca/ca.hospital1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospital1.example.com/connection-hospital1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospital1.example.com/connection-hospital1.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/hospital2.example.com/tlsca/tlsca.hospital2.example.com-cert.pem
CAPEM=organizations/peerOrganizations/hospital2.example.com/ca/ca.hospital2.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospital2.example.com/connection-hospital2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/hospital2.example.com/connection-hospital2.yaml

ORG=3
P0PORT=10051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/laboratory.example.com/tlsca/tlsca.laboratory.example.com-cert.pem
CAPEM=organizations/peerOrganizations/laboratory.example.com/ca/ca.laboratory.example.com-cert.pem

echo "$(json_ccp1 $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/laboratory.example.com/connection-laboratory.json
echo "$(yaml_ccp1 $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/laboratory.example.com/connection-laboratory.yaml
