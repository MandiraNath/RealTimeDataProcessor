import json
import boto3
import time
from datetime import datetime

# Initialize Timestream write client
timestream_write = boto3.client('timestream-write')

# Constants
DATABASE_NAME = 'realtime-timestream-db'
TABLE_NAME = 'realtime-timestream-table'
BATCH_SIZE = 100  # Maximum number of records per batch
MAX_TIME_INTERVAL = 10  # Maximum time interval in seconds

# Global variables to hold the batch data and the last batch time
batch = []
last_batch_time = time.time()

def lambda_handler(event, context):
    global batch, last_batch_time
    
    # Process incoming Kinesis records
    for record in event['Records']:
        # Decode Kinesis data
        payload = json.loads(record['kinesis']['data'])
        
        # Convert the record to Timestream format
        timestream_record = {
            'Dimensions': [
                {'Name': 'dimension_name_1', 'Value': payload['dimension_value_1']},
                {'Name': 'dimension_name_2', 'Value': payload['dimension_value_2']}
            ],
            'MeasureName': 'measure_name',
            'MeasureValue': str(payload['measure_value']),
            'MeasureValueType': 'DOUBLE',  # or 'BIGINT', 'BOOLEAN', etc.
            'Time': str(int(datetime.utcnow().timestamp() * 1000))  # Current time in milliseconds
        }
        
        batch.append(timestream_record)
        
        # Check if the batch size is reached
        if len(batch) >= BATCH_SIZE:
            flush_batch()

    # Check if the maximum time interval has elapsed
    if time.time() - last_batch_time >= MAX_TIME_INTERVAL:
        flush_batch()
        
    return {
        'statusCode': 200,
        'body': 'Processed {} records'.format(len(event['Records']))
    }

def flush_batch():
    global batch, last_batch_time
    
    if batch:
        try:
            # Write records to Timestream
            response = timestream_write.write_records(
                DatabaseName=DATABASE_NAME,
                TableName=TABLE_NAME,
                Records=batch
            )
            print(f'Successfully wrote {len(batch)} records to Timestream')
        except Exception as e:
            print(f'Error writing to Timestream: {str(e)}')
        finally:
            # Reset the batch and update the last batch time
            batch = []
            last_batch_time = time.time()
