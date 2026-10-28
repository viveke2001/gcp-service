output "vpc_name" {
  value = google_compute_network.name.name
}
output "subnetwork_name" {
  value = { for key, sub in google_compute_subnetwork.subnetwork : key => sub.name }
}   