import json
import os
from flask import Flask, Response, request
import boto3
from boto3.dynamodb.conditions import Key

# Fetching the instance ID of the current machine (for debugging or health checks)
instance_id = os.popen("hostname -i").read().strip()

# Retrieving the DynamoDB table name from environment variables with a default fallback
# TC_DYNAMO_TABLE should be set in the environment variables to specify the table name.
dynamo_table_name = os.environ.get('TC_DYNAMO_TABLE', 'Candidates')

# Initializing DynamoDB resource and table object using boto3
# Ensure the AWS credentials and region configuration are properly set up.
dyndb_client = boto3.resource('dynamodb', region_name='us-east-2')
dyndb_table = dyndb_client.Table(dynamo_table_name)

# Initializing Flask application
candidates_app = Flask(__name__)

# Default route to handle invalid requests
@candidates_app.route('/', methods=['GET'])
def default():
    """
    Default endpoint to return an error response for invalid requests.
    Returns:
        JSON: Status message with HTTP 400.
    """
    return {"status": "invalid request"}, 400

# Health check endpoint ("go to green")
@candidates_app.route('/gtg', methods=['GET'])
def gtg():
    """
    Health check endpoint to verify the application's readiness.
    If the "details" query parameter is provided, it returns connection details.
    Returns:
        JSON: Connection status and instance ID if details are requested.
        Otherwise, an empty 200 response.
    """
    details = request.args.get("details")

    if "details" in request.args:
        return Response(
            json.dumps({"connected": "true", "instance-id": instance_id}),
            status=200,
            mimetype="application/json"
        )
    else:
        return Response(status=200)

# Retrieve a candidate by name
@candidates_app.route('/candidate/<name>', methods=['GET'])
def get_candidate(name):
    """
    Retrieves information about a specific candidate from DynamoDB.
    Args:
        name (str): The name of the candidate to retrieve.
    Returns:
        JSON: Candidate details if found, or a 404 error if not found.
    """
    try:
        response = dyndb_table.query(
            KeyConditionExpression=Key('CandidateName').eq(name)
        )

        if len(response['Items']) == 0:
            raise Exception  # Raise an exception if no items are found

        return Response(
            json.dumps(response['Items']),
            status=200,
            mimetype="application/json"
        )
    except:
        return "Not Found", 404

# Add or update a candidate
@candidates_app.route('/candidate/<name>', methods=['POST'])
def post_candidate(name):
    """
    Adds or updates a candidate record in DynamoDB.
    Args:
        name (str): The name of the candidate to add or update.
    Returns:
        JSON: Confirmation message with candidate name if successful, or an error if failed.
    """
    try:
        dyndb_table.put_item(Item={"CandidateName": name})
    except Exception as ex:
        return "Unable to update", 500

    return Response(
        json.dumps({"CandidateName": name}),
        status=200,
        mimetype="application/json"
    )

# Retrieve all candidates
@candidates_app.route('/candidates', methods=['GET'])
def get_candidates():
    """
    Retrieves a list of all candidates from DynamoDB.
    Returns:
        JSON: List of candidates if found, or a 404 error if none are found.
    """
    try:
        items = dyndb_table.scan()['Items']

        if len(items) == 0:
            raise Exception  # Raise an exception if no items are found

        return Response(
            json.dumps(items),
            status=200,
            mimetype="application/json"
        )
    except:
        return "Not Found", 404
