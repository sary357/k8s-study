project_id = "gogox-analytics-non-prod"
region     = "asia-southeast1"
zone       = "asia-southeast1-a"
my_name = "fuming"
service_account = "tarraform-poc@gogox-analytics-non-prod.iam.gserviceaccount.com"
service_account_json_path="/Users/sary357/Desktop/gogox/gogox-analytics-non-prod-2a93cdbfc33e.json"
gke_num_nodes = "2"
# gke_version = "1.27.5-gke.200"
gke_version = "1.28.1-gke.201"
network_range = "10.0.0.0/16"

master_ipv4_network_range="10.3.0.0/28"

cluster_ip_range="10.1.0.0/16"
services_ip_range="10.2.0.0/16"

# vpn_ip_range_hk_vpn="18.162.226.52/32"
# vpn_ip_range_sg_vpn="13.228.124.16/32"
# fuming_ip_range="1.200.4.152/32"