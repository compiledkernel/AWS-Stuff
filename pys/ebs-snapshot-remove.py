#Import the Goods
import json
import boto3
import logging
import time

#Tell me what Im doing when I do it
logger = logging.getLogger()
logger.setLevel(logging.ERROR)

#The Client is always right
ec = boto3.client('ec2')

#Define who gets it based on their Tags, Backup and backup only
def lambda_handler(event, context):
    reservations = ec.describe_instances(
        Filters=[
            {'Name': 'tag-key', 'Values': ['backup', 'Backup']},
        ]
    ).get(
        'Reservations', []
    )

    instances = sum(
        [
            [i for i in r['Instances']]
            for r in reservations
        ], [])

    print "Found %d instances that need backing up" % len(instances)

    for instance in instances:
        for dev in instance['BlockDeviceMappings']:
            if dev.get('Ebs', None) is None:
                continue
            vol_id = dev['Ebs']['VolumeId']
            print "Found EBS volume %s on instance %s" % (
                vol_id, instance['InstanceId'])

            ec.create_snapshot(
                VolumeId=vol_id,
            )
            time.sleep(300)
            ec.delete_volume(
                VolumeID=vol_id,
            )
