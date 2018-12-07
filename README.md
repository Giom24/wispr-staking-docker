# wispr-staking-docker
A Docker-Container that builds and runs an Wispr Wallet in staking mode.

Replace the placeholders in the Dockerfile with your username and password to create an non-root user inside the Container.

Copy your already encrypted wallet.dat in this directory.

**Build the Container:**  
$ sudo docker build . -t wispr-staking-image

**Run the Container:**  
$ sudo docker run -dit --name=wispr-staking wispr-staking-image

**Unlock Your Wallet:**  
$ sudo docker exec -it wispr-staking ~/unlock.sh

Now, type in your Walletpassphare.

After Syncing all the blocks, Staking should start automatically.
