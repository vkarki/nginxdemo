# NGINX 
## Description
The Terraform code deploys Nginx in Azure using Azure pipelines.  

## Usage Guidelines

### Requirements
1) A Service Principal with **Contributor** access.  
2) A storage container to store the state files.

### Folder Structure
infra - This contains the terraform child modules used in deploying nginx VM.  
orchestrate - This contains the parent module. 
pipelines - This contains the ADO pipeline 

### Azure DevOps Pipeline

1) Create ARM service connections and update the names in terraform tasks.  
2) The pipeline is manually run and consists of two stages Create and Destroy. Select either of the stage and run the pipeline.  

### Local Terrafrom Execution  
1) Set the below environment variables  

          ```cmd
          setx ARM_CLIENT_ID  "xxx"  
          setx ARM_CLIENT_SECRET "xxx"  
          setx ARM_SUBSCRIPTION_ID "xxx"  
          setx ARM_TENANT_ID "xxx"  
          setx TF_VAR_service_principal_id  "xxx"   
          setx TF_VAR_service_principal_secret "xxx"  
          setx TF_VAR_storage_account_key "xxx"  
          setx TF_VAR_subscription_id "xxx"  
          ```
2) Create a file in the *backend* folder with the name of *nginxDev.tfvars* and fill the details of the storage account as mentioned below.  
          
          subscription_id      = "xxx"  
          tenant_id            = "xxx"  
          resource_group_name  = "xxx"  
          storage_account_name = "xxx"  
          container_name       = "xxx"  
          key                  = "xxx.tfstate"  

3) Create a file in the *globalvars* folder with the name of *ngnix.tfvars*.    

          rg                    = "aeinfradev"  
          automationAccount     = "aeInfraDev-AAE"  

4) Initialize Terraform on the working directory containing Terraform configuration files. 

          ```terraform
          terraform init -backend-config=./backend/nginxDev.tfvars
          ```

5) This command perform a refresh of the state file and later creates an execution plan.  

          ```terraform
          terraform plan -var-file ./globalvars/nginxDev.tfvars -out=nginxDev.tfplan
          ```

6) Apply the changes required to reach the desired state of the configuration.  

          ```terraform
          terraform apply nginxDev.tfplan --auto-approve
          ```

7) Destroy the infrastructure managed by terraform.  

          ```terraform
          terraform destroy -var-file ./globalvars/nginxDev.tfvars --auto-approve
          ```
