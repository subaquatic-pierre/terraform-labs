.PHONY: port-forward

port-forward:
	@echo "Forwarding ArgoCD to http://localhost:8080..."
	@kubectl port-forward -n argocd svc/argocd-server 8080:80 > /dev/null 2>&1 &
	@echo "Port-forwards running in background. Use 'killall kubectl' to stop them."