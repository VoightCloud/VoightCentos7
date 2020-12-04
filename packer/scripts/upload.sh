#!/bin/bash

curl -v -u admin:${PASSWORD} --upload-file ./builds/${OVAFILE} http://nexus.voight.org:8081/repository/MachineImages/gold/centos/${OVAFILE}