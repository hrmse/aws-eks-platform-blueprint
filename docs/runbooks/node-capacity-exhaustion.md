# Runbook: node capacity is exhausted

## Triage

1. Inspect pending-pod events, requested resources, taints, affinity, and Pod Disruption Budgets. Do not scale nodes before identifying an impossible scheduler constraint.
2. Compare requested capacity with node-group min/max and AWS quota/instance availability in each selected AZ.
3. Check Cluster Autoscaler or Karpenter ownership rules; do not race an autoscaler by manually changing Terraform `desired_size`.
4. Check whether a deployment lacks resource requests/limits or has a pathological HPA target.

## Mitigation

Use the established autoscaling path. If an emergency manual capacity increase is approved, record it, reconcile it with IaC afterward, and confirm nodes join expected private subnets. Follow up with a right-sizing review.
