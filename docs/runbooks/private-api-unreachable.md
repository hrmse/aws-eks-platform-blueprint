# Runbook: private Kubernetes API is unreachable

## Triage

1. Confirm the caller is connected to the approved private administrative network and resolves the EKS endpoint to a private address.
2. Check caller DNS, route, VPN/Direct Connect health, and security-group path before changing EKS endpoint configuration.
3. Inspect cluster endpoint settings and control-plane security group; compare them with the reviewed Terraform state and plan.
4. Check CloudTrail and recent infrastructure changes for modified routes, NACLs, security groups, or identity permissions.

## Mitigation

Restore the intended private route or identity access through the approved change path. Escalate to the network/platform on-call owner if private connectivity is degraded. Making the endpoint public is an incident decision with an explicit time limit, CIDR restriction, and rollback.
