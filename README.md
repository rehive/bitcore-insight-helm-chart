# geth-helm-chart

1. Create a disk on google cloud:
	`gcloud compute disks create bitcore-node-data-testnet --zone europe-west1-c --size 500 --type pd-standard`

2. Fill in the values in `staging/values.yaml`

3. Install the Helm chart:
	`helm install --name bitcore --namespace bitcore-service-testnet --set NETWORK=testnet -f ./staging/values.yaml ./bitcore-chart/`

# misc

1. Tainting nodes:
1. kubectl taint node gke-staging-bitcore-node-pool-9a52a300-9x2f dedicated=bitcore:NoSchedule

# local

1. `docker run --env NETWORK=testnet --restart=unless-stopped -P -d -p 127.0.0.1:3001:3001 --name testnet gcr.io/rehive-services/bitcore-node:latest`
