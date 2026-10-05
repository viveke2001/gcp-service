module "network" {      
    source = "../modules/network"
    vpc_name = "my-vpc"
    subnetworks = {
        "public-subnet-1" = {
            ip_cidr_range = "10.0.1.0/24"
            region = "us-central1"
            stack_type = "IPV4_ONLY"
            is_public = true
            secondary_ip_range = []
        },
        "private-subnet-1" = {
            ip_cidr_range = "10.0.2.0/24"
            region = "us-central1"
            stack_type = "IPV4_ONLY"
            is_public = false
            secondary_ip_range = []
        }
    }
}