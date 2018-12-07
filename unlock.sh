#!/bin/sh
echo "Wallet password:"
stty -echo
read password;
stty echo
echo "Wait for Wisprd to start..."
sleep 30
echo "Unlock Wallet (Stake-only)";
wispr-cli walletpassphrase $password 0 true;