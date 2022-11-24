## Terraform para ser importando dentro do OCI como um STACK ## 

```
oci resource-manager stack create --compartment-id ocid1.compartment.oc1..xxxx --config-source ./Terraform/extra_nodes/extra_nodes.zip --variables file://vars_to_stack.json --display-name "CLI Extra nodes" --description "New nodes for workload only labeled" --working-directory "" 

oci resource-manager job create-apply-job --execution-plan-strategy AUTO_APPROVED --stack-id ocid1.ormstack.oc1.sa-saopaulo-1.xxxx

oci resource-manager job get  --job-id ocid1.ormjob.oc1.sa-saopaulo-1.xxx
oci resource-manager job get-detailed-log-content --job-id ocid1.ormjob.oc1.sa-saopaulo-1.xxx 

oci resource-manager job create-destroy-job --execution-plan-strategy AUTO_APPROVED --stack-id ocid1.ormstack.oc1.sa-saopaulo-1.xxxx

``` 





