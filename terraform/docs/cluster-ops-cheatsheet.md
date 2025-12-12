## Cluster Ops Cheatsheet

- `terraform init && terraform plan && terraform apply` — plan/apply infra.
- `terraform import <addr> <id>` — bring existing K8s/Helm into state (e.g., `terraform import module.networking.module.pihole.kubernetes_deployment.pihole networking/pihole`).
- `terraform state rm <addr>` — drop a bad state entry before re-importing.
- `helm list -A` — list Helm releases across namespaces.
- `kubectl get pods -A` / `kubectl get pvc -A` / `kubectl get sc` — quick health/storage check.
- `kubectl describe pod -n <ns> <pod>` — events/restarts/probes.
- `kubectl logs -n <ns> <pod> [-c <container>]` — container logs.
- `kubectl exec -n <ns> <pod> -- <cmd>` — run in pod (e.g., curl/health).
- `kubectl apply -f <file>` / `kubectl delete -f <file>` — apply/remove manifests.
- `kubectl port-forward -n <ns> svc/<name> <local>:<svc-port>` — temporary local access.
- `kubectl get ingress -A` / `kubectl describe ingress -n <ns> <name>` — ingress routing/hosts.
- `kubectl rollout status deploy/<name> -n <ns>` — watch readiness; `kubectl rollout restart deploy/<name> -n <ns>` to restart.
- `kubectl get events -A --sort-by=.lastTimestamp | tail -n 20` — recent cluster events.
- Storage: use `openebs-hostpath` for single-node PVs (e.g., Pi-hole); if PVC stuck, `kubectl delete pvc <name> -n <ns>` then re-apply Terraform.

- `kubectl get pvc -n databases | grep -i qdrant` - check Qdrant PVC status.
- `kubectl describe pvc -n databases qdrant-qdrant-0` - check Qdrant PVC details.
- `kubectl get pods -n databases | grep  qdrant` - check qdrant pod status.
- `helm uninstall qdrant -n databases` - uninstall qdrant.
