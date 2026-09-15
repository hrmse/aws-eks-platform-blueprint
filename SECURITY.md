# Security policy

Do not commit AWS credentials, Terraform state, kubeconfig files, or real
network ranges that disclose sensitive infrastructure. Report a suspected
security issue privately to the repository owner rather than opening a public
issue with exploitable detail.

The defaults intentionally keep the EKS API private and encrypt Kubernetes
secrets. They are reference defaults, not a compliance certification. Review
IAM, CIDRs, logging retention, and deletion windows with the owning team.
