from __future__ import print_function

import boto3

#define region, safely, I think
ec2 = boto3.resource('ec2', region_name="us-east-1")

#For logging, I think
logger = logging.getLogger()
#True - Do nothing False - screw it all up
debugMode = False

def lambda_handler(event, context):
#List EC2 instances
base = ec2.instances.all()

#loop over runnings Instances
for instance in base:

#Tag the Volumes
	for vol in instance.volumes():
#print(vol.attachments[0]['Device'])
	if debugMode == True:
		print("[DEBUG] " + str(vol))
		tag_cleanup(instance, vol.attachments[0]['Device'])
	else:
	tag = vol.create_tags(Tags=tag_cleanup(instance, vol.attachments[0]['Device']))
	print("[INFO]: " + str(tag))

#------------- Functions ------------------
#returns the type of configuration that was performed

def tag_cleanup(instance, detail):
    tempTags=[]
    v={}

    for t in instance.tags:
        #pull the name tag
        if t['Key'] == 'Name':
            v['Value'] = t['Value'] + " - " + str(detail)
            v['Key'] = 'Name'
            tempTags.append(v)
        #Set the important tags that should be written here
        elif t['Key'] == 'Location':
            print("[INFO]: Location Tag " + str(t))
            tempTags.append(t)
            print("[INFO]: Skip Tag - " + str(t))

    print("[INFO] " + str(tempTags))
    return(tempTags)
