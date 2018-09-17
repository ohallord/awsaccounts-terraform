#!/usr/bin/python
# #__author__ = 'Dan O'Halloran'
#
# This scripts performs these actions:
#   1. Creates new accounts under a given aws orgination
#
#

import sys
import traceback
import boto3
import botocore
import logging
import time
import json
from optparse import OptionParser



outfile = open("/var/log/create_org_accounts.txt",'w')


logger = logging.getLogger('create_org_accounts')
logger.setLevel(logging.DEBUG)
# create file handler which logs even debug messages
fh = logging.FileHandler('/var/log/create_org_accounts.log')
fh.setLevel(logging.DEBUG)

# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)

formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# add the handlers to the logger
logger.addHandler(fh)
logger.addHandler(ch)

def move_account(newaccountId,destinationParentId,sourceParentId):
    logger.debug("-- move_account -- New Account ID: %s" % str(newaccountId))
    try:
        logger.debug("-- move_account --")
        session = boto3.Session(profile_name=awsProfile)
        client = session.client('organizations')

        response = client.move_account(
                AccountId=newaccountId,
                SourceParentId=sourceParentId,
                DestinationParentId=destinationParentId
        )
        retcode = response


        logger.debug("-- move_account -- Return: {0}".format(retcode))

    except Exception as e:
        logger.debug("-- move_account -- Error: Unable to move account" )
        logger.debug("-- move_account -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("-- move_account -- Finished")
        return retcode

def get_account_status(statusId):
    logger.debug("-- get_account_status -- Account Name: %s" % str(statusId))
    try:
        logger.debug("-- create_account --")
        session = boto3.Session(profile_name=awsProfile)
        client = session.client('organizations')

        account_id = 0

        time.sleep(10)

        account_status = 'IN_PROGRESS'
        while account_status == 'IN_PROGRESS':

            response = client.describe_create_account_status(
                CreateAccountRequestId=statusId
            )

            status = response['CreateAccountStatus']
            print "Account Status Response ==> {0}".format(status)
            account_status = status['State']
            print "Account State ==> {0}".format(account_status)

        #cloudWatchId = inPuts['Id']

        if account_status == 'SUCCEEDED':
            account_id = status.get('AccountId')
            print "New Account ID: {0}".format(account_id)
            root_id = client.list_roots().get('Roots')[0].get('Id')
        elif account_status == 'FAILED':
            print("Account creation failed: " + status.get('FailureReason'))
            account_id = -1
            sys.exit(1)
        #root_id = client.list_roots().get('Roots')[0].get('Id')


        logger.debug("-- get_account_status -- Targets: {0}".format(json.dumps(status)))
        logger.debug("-- get_account_status -- Status ID: {0}".format(statusId))
    # logger.debug("-- list_cloudwatch_job_targets -- Response: {0}".format(response))


    except Exception as e:
        logger.debug("-- get_account_status -- Job Definition Name: %s" % str(account_name))
        logger.debug("-- get_account_status -- Error: Unable to create account" )
        logger.debug("-- get_account_status -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("-- create_account -- Finished")
        return account_id

def create_account(awsProfile,email,account_name,rolearn):
    logger.debug("-- create_account -- Account Name: %s" % str(account_name))
    try:
        logger.debug("-- create_account --")
        session = boto3.Session(profile_name=awsProfile)
        client = session.client('organizations')
        statusId = 0

        response = client.create_account(
            Email=email,
            AccountName=account_name
        )
        print "create_account  --- Response ---  {0}".format(response)
        status = response['CreateAccountStatus']
        print "Create Account Status {0}".format(status)
        statusId = status['Id']
        state = status['State']
        print "Account Status ID {0}".format(statusId)
        print "The State is [{0}]".format(state)
        #cloudWatchId = inPuts['Id']

        logger.debug("-- create_account -- Targets: {0}".format(json.dumps(status)))
        logger.debug("-- create_account -- Status ID: {0}".format(statusId))
    # logger.debug("-- list_cloudwatch_job_targets -- Response: {0}".format(response))

    except botocore.exceptions.ClientError as e:
        print "Boto Exception -- Failed to create account: [{0}]".format(e)
        logger.debug("-- create_account -- Account Name: %s" % str(account_name))
        logger.debug("-- create_account -- Error: Unable to create account" )
        logger.debug("-- create_account -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    except Exception as e:
        print "Failed to create account: [{0}]".format(e)
        logger.debug("-- create_account -- Account Name: %s" % str(account_name))
        logger.debug("-- create_account -- Error: Unable to create account" )
        logger.debug("-- create_account -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("-- create_account -- Finished")
        return statusId

def get_root(awsProfile,account_name):
    logger.debug("-- get_root -- Account Name: %s" % str(account_name))
    try:
        rootId = 0
        logger.debug("-- get_root --")
        session = boto3.Session(profile_name=awsProfile)
        client = session.client('organizations')
        statusId = 0

        response = client.list_roots(

        )
        roots = response['Roots']
        rootId = roots[0]['Id']
        print "Organization Root ID {0}".format(rootId)

    except botocore.exceptions.ClientError as e:
        print "Boto Exception -- Failed to cget_root: [{0}]".format(e)
        logger.debug("-- get_root -- Account Name: %s" % str(account_name))
        logger.debug("-- get_root -- Error: Unable to create account" )
        logger.debug("-- get_root -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    except Exception as e:
        print "Failed to get_root: [{0}]".format(e)
        logger.debug("-- get_root -- Account Name: %s" % str(account_name))
        logger.debug("-- get_root -- Error: Unable to create account" )
        logger.debug("-- cget_root -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("-- get_root -- Finished")
        return rootId


def get_organizational_units_for_parent(awsProfile,parentId):
    logger.debug("-- get_root -- Account Name: %s" % str(account_name))
    try:
        logger.debug("-- get_organizational_units_for_parent --")
        session = boto3.Session(profile_name=awsProfile)
        client = session.client('organizations')
        ouId = 0

        response = client.list_organizational_units_for_parent(
            ParentId=parentId
        )
        print "Rsponse: {0}".format(response)
        # roots = response['Roots']
        # rootId = roots[0]['Id']
        # print "Organization Root ID {0}".format(rootId)

    except botocore.exceptions.ClientError as e:
        print "Boto Exception -- Failed to cget_root: [{0}]".format(e)
        logger.debug("-- get_organizational_units_for_parent -- Account Name: %s" % str(account_name))
        logger.debug("-- get_organizational_units_for_parent -- Error: Unable to create account" )
        logger.debug("-- get_organizational_units_for_parent -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    except Exception as e:
        print "Failed to get_organizational_units_for_parent: [{0}]".format(e)
        logger.debug("-- get_organizational_units_for_parent -- Account Name: %s" % str(account_name))
        logger.debug("-- get_organizational_units_for_parent -- Error: Unable to create account" )
        logger.debug("-- get_organizational_units_for_parent -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("-- get_root -- Finished")
        return ouId


if __name__ == "__main__":

    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)

    parser.add_option("-e", "--email", dest="email",
                      help="What is the email for this account")
    parser.add_option("-p", "--profile",dest="aws_profile", default="default",
                      help="This is the aws Profile You want (default/aws01/aws02/aws03)")
    parser.add_option("-n", "--name",dest="account_name", default="default",
                      help="This name of the new account")
    parser.add_option("-r", "--rolearn",dest="rolearn",
                      help="The Role ARN for the role you want to apply to the newly created account.")
    parser.add_option("-d", "--parentname",dest="destinationParentId",
                      help="The unique identifier (ID) of the root or organizational unit that you want to move the account to.")
    parser.add_option("-s", "--sourceparentid",dest="sourceParentId",
                      help="The unique identifier (ID) of the root or organizational unit that you want to move the account from.")

    # parser.add_option("-c", "--cloudwatchjob",dest="cloud_watch_job_name",
    #                   help="What do you want to call the job")
    # parser.add_option("-t", "--cwtargetfile",dest="cw_target_json_file",
    #                   help="The File with the Json File")
    # # parser.add_option("-i", "--cwid",dest="cw_target_id",
    # #                   help="The cloud watch ID")
    # parser.add_option("-a", "--lambdaarn",dest="lambda_arn",
    #                   help="The the arn for the lambda function")
    # parser.add_option("-e", "--cloudWatchEventName",dest="cloudWatchEventName",
    #                   help="The Cloudwatch Event Name")
    (options, args) = parser.parse_args()

    awsProfile = options.aws_profile
    email =  options.email  #str(sys.argv[2])
    account_name = options.account_name  # str(sys.argv[3])
    destinationParentId = options.destinationParentId
    sourceParentId = options.sourceParentId
    # cloudWatchTargetJsonFile = options.cw_target_json_file
    #
    # lambdaArn = options.lambda_arn
    # cloudWatchId = options.cw_target_id


    # logger.debug("aws Profile:          %s" % awsProfile)
    # logger.debug("Job Definition Name:  %s" % jobDefinitionName)
    # logger.debug("Cloud Watch Job Name: %s" % cloudWatchJobName)
    # logger.debug("Container Properties File Name: %s" % containerPropsFileName)
    # logger.debug("Cloud Watch Target File Name: %s" % cloudWatchTargetJsonFile)
    # # logger.debug("Cloud Watch ID: %s" % cloudWatchId)
    # logger.debug("Lambda Function Arn: %s" % lambdaArn)

    try:

        rootId = get_root(awsProfile,sourceParentId)
        get_organizational_units_for_parent(awsProfile,'ou-wpa8-j1k711m1')
        # statusId =  create_account(awsProfile,email,account_name,rolearn)
        # if statusId != 0:
        #    newaccountId = get_account_status(statusId)
        # if newaccountId > 0:
        #    move_account(newaccountId,destinationParentId,sourceParentId)


    except Exception as e:
        logger.debug("Error: Unable to set up Batch jobs" )
        logger.debug("-- Main -- ERROR: {0}".format(str(e)))
        traceback.print_exc(file=open("/var/log/create_org_accounts.log","w"))
        raise
    finally:
        logger.debug("Finished")

        #if __name__ == "__main__": main()