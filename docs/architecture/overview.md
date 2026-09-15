# Architecture decisions

## Network and control plane

The cluster API has no public endpoint. Operators and automation must reach it through a private, auditable path. Worker nodes use private subnets; public subnets exist only for NAT and load-balancer integration. Kubernetes subnet tags allow AWS load-balancer controllers to discover intended placement without making worker nodes public.

Each availability zone receives private and public routing. Production uses a NAT gateway in every AZ to avoid turning one NAT failure into an egress outage. Interface endpoints reduce internet dependency for ECR, STS, and CloudWatch Logs; S3 uses a gateway endpoint.

## Encryption and telemetry

EKS envelope-encrypts Kubernetes Secret resources with a customer-managed KMS key. The same key encrypts the dedicated control-plane log group. Rotation is enabled and deletion has a 30-day recovery window. This does not encrypt every possible application secret automatically; workloads should retrieve secrets through an approved secret-management pattern.

Control-plane API, audit, authentication, controller-manager, scheduler, and VPC Flow Logs go to encrypted CloudWatch log groups with one-year retention. Retention must still be adjusted to the organization’s policy and cost model.

## Identity and workloads

AWS-managed policies make the reference concise, but the intended evolution is dedicated EKS Pod Identity/IRSA roles for CNI and application service accounts. Never give workloads the node role. Cluster access should be managed through EKS access entries or a controlled identity provider—not hand-edited `aws-auth` mappings.

The namespace requests Pod Security Admission `restricted` enforcement. The workload uses no token mount, no privilege escalation, RuntimeDefault seccomp, read-only root filesystem, dropped capabilities, probes and resource limits. Default-deny policy is introduced before narrowly allowing DNS and required in-namespace ingress.
