#!/usr/bin/env  python

input_instance_list="/tmp/list.txt"


# format of list.txt
# machine-01564-standard                                us-central1-a              c2-standard-60                 10.128.1.50                 TERMINATED
# dev-4440001                                           asia-east1-a               n2-highcpu-80                  10.140.1.127                TERMINATED
with open(input_instance_list) as f:
    for line in f:
        # get instance name
        instance_name = line.split()[0]
        
        # get zone
        zone = line.split()[1]
         # cancel deletion protection
        print("gcloud compute instances update %s --no-deletion-protection --zone %s" % (instance_name, zone))

        print("gcloud compute instances delete %s --zone %s -q" % (instance_name, zone))
       