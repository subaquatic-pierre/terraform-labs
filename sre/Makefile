.PHONY: port-forward

port-forward:
	@echo "Forwarding Grafana to http://localhost:5000..."
	@kubectl port-forward -n monitoring svc/grafana 5000:80 > /dev/null 2>&1 &
	@echo "Forwarding Alloy UI to http://localhost:5001..."
	@kubectl port-forward -n monitoring svc/alloy 5001:12345 > /dev/null 2>&1 &
	@echo "Forwarding Mimir UI to http://localhost:5002..."
	@kubectl port-forward -n monitoring svc/mimir-gateway 5002:8080 > /dev/null 2>&1 &
	@echo "Port-forwards running in background. Use 'killall kubectl' to stop them."