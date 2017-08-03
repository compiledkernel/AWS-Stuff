#!/usr/bin/env python
import boto3
import time

#define region, safely, I think
ec2 = boto3.resource('ec2', region_name="us-west-2")

#Client import maybe frivilous
elb = boto3.client('elb')
ec2 = boto3.client('ec2')

#For logging
logger = logging.getLogger()

#True - Do nothing False - screw it all up
debugMode = False

#Lamba Handler thingy
def lambda_handler(event, context):
#List EC2 instances
base = ec2.instances.all()

#Instance Status
#Hard Code InstanceIDs to script
if debugMode == True:
    print("[DEBUG]")
else
def lambda_handler(event, context):
    client = boto3.client('ec2')
    client.start_instances(InstanceIds=['i-031f209f64e8c004d',],
                           DryRun=False)
    print ("[INFO]: ")

elif
#Attach Instances to ELB once started.
#Hardcode Instance
def lamdba_hander(event, context):
    client = boto3.client('elb')
    client.register_instances_with_load_balancer(LoadBalancerName='IQS-elb-prod',
                                                 Instances=[{'i-031f209f64e8c004d': 'CWPINQA5002'},])
print("[INFO]: ")
