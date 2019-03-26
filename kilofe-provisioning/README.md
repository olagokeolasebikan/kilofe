## Instructions for use

1) Copy values in the attched terraform.tfvars into or simply replace the terraform.tfvars.example with it, you may use your personal access_id and secret keys if you like


2) Download `Terraform` if you don't already have it installed:  
https://www.terraform.io/intro/getting-started/install.html


3) Create a `key pair` for use on the `AWS` `EC2` instances and put the `public`/`private` keys in `.private/kilofeci.pub`/`.private/kilofeci.pem`.

5) Use `Terraform` to check how the services will be provisioned:  
```
terraform plan
```

6) Provision using `Terraform`:  
```
terraform apply
```

7) Check the output of the provision and access the server via SSH and/or your web browser.  
```
## Provision output...
...
Apply complete! Resources: <No> added, 0 changed, 0 destroyed.


```
## Access server via SSH and Docker
ssh -i .private/kilofeci.pem ubuntu@<hostname>.compute.amazonaws.com
sudo docker ps
sudo docker exec -it <container-id> bash  
```

```
## Access servers via HTTP
http://<hostname>.compute.amazonaws.com:8080/ for jenkins
http://<hostname>.compute.amazonaws.com:3000/ for grafana
http://<hostname>.compute.amazonaws.com:4000/ for nodejs app

```

8) Complete Jenkins setup by finding the `/var/jenkins_home/secrets/initialAdminPassword` file via SSH and entering the contents in the HTTP interface (the HTTP interface should prompt you to do this). Then follow the instructions provided, installing standard plugins and creating the first admin account.

10) If there is a need to re-stage the server at any point, `taint` and re-`apply` via `Terraform`:  
```
terraform taint aws_instance.ci
terraform apply

11) Use terraform destroy to remove volume and terminate the instance.
```
