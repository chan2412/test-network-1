#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createLaboratory {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/laboratory.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/laboratory.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-laboratory --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-laboratory.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-laboratory.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-laboratory.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-laboratory.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/config.yaml

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-laboratory --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-laboratory --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-laboratory --id.name laboratoryadmin --id.secret laboratoryadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-laboratory -M ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/msp --csr.hosts peer0.laboratory.example.com --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-laboratory -M ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls --enrollment.profile tls --csr.hosts peer0.laboratory.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/laboratory.example.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/tlsca/tlsca.laboratory.example.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/laboratory.example.com/ca
  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/peers/peer0.laboratory.example.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/laboratory.example.com/ca/ca.laboratory.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-laboratory -M ${PWD}/../organizations/peerOrganizations/laboratory.example.com/users/User1@laboratory.example.com/msp --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/laboratory.example.com/users/User1@laboratory.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://laboratoryadmin:laboratoryadminpw@localhost:11054 --caname ca-laboratory -M ${PWD}/../organizations/peerOrganizations/laboratory.example.com/users/Admin@laboratory.example.com/msp --tls.certfiles ${PWD}/fabric-ca/laboratory/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/laboratory.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/laboratory.example.com/users/Admin@laboratory.example.com/msp/config.yaml
}
