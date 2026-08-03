output "jenkins_public_ip" {
  value       = azurerm_public_ip.jenkins_ip.ip_address
  description = "Public IP address to access Jenkins UI at http://<IP>:8080"
}

output "jenkins_vm_id" {
  value       = azurerm_linux_virtual_machine.jenkins_vm.id
  description = "Resource ID of the Jenkins Virtual Machine"
}