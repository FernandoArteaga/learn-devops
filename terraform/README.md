# Terraform

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and
provision cloud infrastructure using a high-level configuration language known as Hashicorp Configuration Language (HCL).

The main advantage of using Terraform is that it allows you to define your infrastructure as code once and then deploy it
in multiple environments, having always the same result.

We will provision a simple infrastructure that we can use to deploy the [my-awesome-app](../kubernetes/README.md#kubernetes-manifests)
example. This infrastructure will consist of a VPC, a public subnet, an internet gateway, a security group, and an EKS instance.

Requirements:
- Make sure you have the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed

## AWS

To provision the infrastructure in AWS, we will use the [AWS Terraform provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).
You can find the Terraform code in the [aws](./aws) directory.

Requirements:
- Make sure you have the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
- You need to have an AWS account and the [AWS CLI configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

## Provision the infrastructure

1. Select the cloud provider you want to use and follow the instructions in the respective directory. In this example,
   we will use AWS.
   ```sh
   cd aws
   ```
2. Adjust the values in the [_config.tf](./aws/_config.tfvars) file to match your environment.
3. Initialize the Terraform working directory and download the AWS provider plugin.
   ```sh
   terraform init
   ```
4. Create an execution plan.
   ```sh
   terraform plan -out tfplan
   ```
5. Apply the changes to the infrastructure.
   ```sh
    terraform apply tfplan
   ```

Once the infrastructure is provisioned, you can update your `kubeconfig` file to connect to the EKS cluster by running the following command:
```sh
aws eks --region us-east-1 update-kubeconfig --name learn-devops
```

## Clean up

Once you are done with the infrastructure, you can destroy it by running the following command:
```sh
terraform destroy
```
