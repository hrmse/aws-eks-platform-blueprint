# Operations guide

## Day-two checks

- Inspect EKS control-plane log delivery and retention after cluster creation.
- Confirm each node is private and in an expected AZ; review NAT and endpoint traffic/costs against the environment budget.
- Verify the CNI actually enforces NetworkPolicy before treating the provided policies as a security boundary.
- Use `kubectl get events -A --sort-by=.lastTimestamp` during rollout issues.
- Review addon and Kubernetes-version support windows monthly. Upgrade in a non-production environment before production.

## Change management

Terraform plans are security-sensitive: they can reveal resource identifiers and network design. Store plan artifacts only in protected CI systems. Require peer review for changes that affect IAM, KMS policy, endpoint exposure, networking, remote state, or node scaling. Never apply a plan generated for a different account, region, or environment.

## Break-glass access

Document a time-bounded, audited break-glass role outside this repository. Test it periodically from the same private access path used by operators. Do not solve an API access outage by enabling the public endpoint without an approved incident decision.
