# geth-helm-chart

1. Create a disk on google cloud:
	`gcloud compute disks create bitcore-node-data-testnet --zone europe-west1-c --size 500 --type pd-standard`

2. Fill in the values in `staging/values.yaml`

3. Install the Helm chart:
	`helm install --name bitcore-testnet --namespace bitcore-service-testnet -f ./staging/values.yaml ./bitcore-chart/`

# misc

1. Tainting nodes:
1. kubectl taint node gke-production-bitcore-node-pool-2422b335-9xlg dedicated=bitcore:NoSchedule
