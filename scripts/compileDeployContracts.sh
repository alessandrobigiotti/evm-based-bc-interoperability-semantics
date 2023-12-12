#!/bin/bash -u

# Copyright 2023 Alessandro Bigiotti
# Licensed under Apache License, version 2.0
if [ ! -f $PWD/scripts/compileDeployContracts.sh ]
then
  cd ../
fi
echo "-------------------------------------------------------------------------"
echo "Compiling Smart Contracts..."
echo "-------------------------------------------------------------------------"
truffle compile
echo "-------------------------------------------------------------------------"
echo "Deploy smart contracts on Chain A..."
echo "-------------------------------------------------------------------------"
truffle migrate --reset --network=chainA
echo "-------------------------------------------------------------------------"
echo "Deploy smart contracts on Chain B..."
echo "-------------------------------------------------------------------------"
truffle migrate --reset --network=chainB
echo "-------------------------------------------------------------------------"
echo "Done."
echo "-------------------------------------------------------------------------"
