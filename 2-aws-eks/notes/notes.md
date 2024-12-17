# PART 1: EKS

```
https://github.com/terraform-aws-modules/terraform-aws-eks
```

### Setting a KUBECONFIG Cluster
```
aws eks update-kubeconfig --region us-east-1 --name my-cluster-al2023
```

### SIDE - Christopher Hein - reference from 6yrs ago
```
https://github.com/christopherhein/terraform-eks/tree/master/cluster
```

---

### PART 1: EKS Run CarvedRockApi

Set the cluster in kubeconfig
```
aws eks --region us-east-1 update-kubeconfig --name ascode-cluster
```

```
helm repo update [ingress-nginx] // Or omit the ingress-nginx to update all of them
```

Install Ingress CRD
```
helm install --set controller.watchIngressWithoutClass=true --namespace ingress-nginx --create-namespace ingress-nginx ingress-nginx/ingress-nginx
```

Monitoring Ingress
```
kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller
```
```
kubectl cluster-info
```

Deployment - us the YAML Directory from the project
- [CarvedRock Deployment YAML Files](./eks-carvedrock-deploy/)

```
kubectl apply -f eks-carvedrock-deploy
```

Realign the Ingress routing rule
1) Get the EXTERNAL-IP
```
kubectl get all -n ingress-nginx
```
1) Update the ingress.yaml
```yaml
rules:
  - host: a44643b54ba0940a09fa204b4b711a03-436631403.us-east-1.elb.amazonaws.com
```

1) If using localhost set the hosts file
```
172.20.165.7 carved.rock.api
```

Test the APIs
```
https://a44643b54ba0940a09fa204b4b711a03-436631403.us-east-1.elb.amazonaws.com/products/products?category=all
```

```
https://a44643b54ba0940a09fa204b4b711a03-436631403.us-east-1.elb.amazonaws.com/WeatherForecast
```

---

### PART 2: Recap on CIDRSUBNET

Cidrsubnet Recap
```
https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
```

Format
```
cidrsubnet(prefix, newbits, netnum)
```

--- 
Install ipcalc on Ubuntu
```
https://lindevs.com/install-ipcalc-on-ubuntu/
```

Example
```
ipcalc 10.1.2.0/24
```

```
Address:   10.1.2.0             00001010.00000001.00000010. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   10.1.2.0/24          00001010.00000001.00000010. 00000000
HostMin:   10.1.2.1             00001010.00000001.00000010. 00000001
HostMax:   10.1.2.254           00001010.00000001.00000010. 11111110
Broadcast: 10.1.2.255           00001010.00000001.00000010. 11111111
Hosts/Net: 254                   Class A, Private Internet
```

---

Binary Scale
~~1 2 4 8 16 32 64 128~~
```
128 64 32 16 8 4 2 1
```
---

### Calc Overview
```
cidrsubnet("10.1.2.0/24", 4, 15)
```

the function will first convert the given IP address string into an equivalent binary representation
```
00001010 00000001 00000010 00000000
```

The /24 at the end of the prefix string specifies that the first 24 bits -- or, the first three octets -- of the address identify the network while the remaining bits (32 - 24 = 8 bits in this case) identify hosts within the network.

10.1.2.0/28
```
10         1          2          netnum(15) | host
00001010 | 00000001 | 00000010 | XXXX       | 0000
00001010 | 00000001 | 00000010 | 1111       | 0000
128 64 32 16 |  8 4 2 1
```
10.1.2.0/24
10.1.2.240/28

### Examples
```
cidrsubnet("10.1.2.0/24", 4, 15)
```
128 64  32  16  8   4   2   1
1   1   1   1   0   0   0   0
10.1.2.240/28

cidrsubnet("10.1.2.0/24", 4, 1)
10.1.2.16/28

cidrsubnet("10.1.2.0/24", 4, 2)
10.1.2.32/28

cidrsubnet("10.1.2.0/24", 4, 3)
10.1.2.48/28

cidrsubnet("10.1.2.0/24",4, 5)
10.1.2.80/28

---

cidrsubnet("10.0.0.0/16", 4, k)
cidrsubnet("10.0.0.0/16", 8, k + 48)
cidrsubnet("10.0.0.0/16", 8, k + 52)

8   4   2   1

128 64  32  16  8   4   2   1
1   1   
cidrsubnet("10.0.0.0/16", 4, 0)
10.0.0.0/20
cidrsubnet("10.0.0.0/16", 4, 1)
10.0.16.0/20
cidrsubnet("10.0.0.0/16", 4, 8)
10.0.48.0/20

128 64  32  16  8   4   2   1
X   X   
128 64  32  16  8   4   2   1


  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]


cidrsubnet("10.0.0.0/16", 4, 0)
10.0.0.0/20

cidrsubnet("10.0.0.0/16", 8, 48)
128 64  32  16  8   4   2   1
10.0.48.0/24

cidrsubnet("10.0.0.0/16", 8, 52)
10.0.52.0/24


```
aws eks update-kubeconfig --region us-east-1 --name my-cluster-al2023
```

NextSteps
```
https://www.youtube.com/watch?v=q6tjkmX_DPM
https://github.com/ansarshaik965/CICD-Terraform-EKS/blob/master/EKS/main.tf
```

# PART 2: ECS

```
https://github.com/terraform-aws-modules/terraform-aws-ecs
```