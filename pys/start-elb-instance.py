#!/usr/bin/env python
import boto3
import time
import smtplib

email_from = 'wweber@2ndwatch.com'
email_to = 'wweber@2ndwatch.com'
email_cc = 'wweber@2ndwatch.com'
emaiL_subject = 'Primary IQS Server is in a Stopped State'
email_body = 'The Primary IQS server is in a stopped state. The Backup server has been stood up and place in line.'
instance = 'i-0b635e5e51c6dff5d'
loadbalance = 'cloudkernelspace'

#Instance Status
#Hard Code InstanceIDs to script
def lambda_handler(event, context):
    clientec2 = boto3.client('ec2')
    response = clientec2.start_instances(InstanceIds=[instance,],DryRun=False)
    print ("The EC2 Has started, waiting 5 seconds then registering the ELB ")
    clientelb = boto3.client('elb')
    response = clientelb.register_instances_with_load_balancer(LoadBalancerName=loadbalance, Instances=[{'InstanceId': instance,},],)
    print ("The EC2 Backup Instance has been added to the ELB.")
    ses = boto3.client('ses')
    response = ses.send_email(Source = email_from,Destination={
            'ToAddresses': [
                email_to,
            ],
            'CcAddresses': [
                email_cc,
            ]
        },
        Message={
            'Subject': {
                'Data': emaiL_subject
            },
            'Body': {
                'Text': {
                    'Data': email_body
                }
            }
        }
    )
