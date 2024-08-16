import boto3
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import tempfile
from datetime import datetime, timedelta

# Initialize AWS clients
timestream_query = boto3.client('timestream-query')
s3 = boto3.client('s3')

# Constants
DATABASE_NAME = 'realtime-timestream-db'
TABLE_NAME = 'realtime-timestream-table'
S3_BUCKET = 'realtime-timestream-bucket'
S3_PREFIX = 'data/'  # Optional: Specify a folder or prefix within the bucket
TIME_INTERVAL = 10  # Time interval in minutes

def lambda_handler(event, context):
    # Calculate the time window
    end_time = datetime.utcnow()
    start_time = end_time - timedelta(minutes=TIME_INTERVAL)
    
    # Format timestamps for the query
    start_time_str = start_time.strftime('%Y-%m-%d %H:%M:%S')
    end_time_str = end_time.strftime('%Y-%m-%d %H:%M:%S')
    
    # Query Timestream for data in the last TIME_INTERVAL minutes
    query = f"""
    SELECT *
    FROM "{DATABASE_NAME}"."{TABLE_NAME}"
    WHERE time BETWEEN '{start_time_str}' AND '{end_time_str}'
    """
    
    response = timestream_query.query(QueryString=query)
    
    if 'Rows' not in response or len(response['Rows']) == 0:
        return {
            'statusCode': 200,
            'body': 'No new data to process.'
        }

    # Process the query result into a DataFrame
    column_info = response['ColumnInfo']
    rows = response['Rows']
    
    # Extracting the data
    data = []
    for row in rows:
        record = []
        for i, field in enumerate(row['Data']):
            record.append(field.get('ScalarValue'))
        data.append(record)
    
    # Create DataFrame
    df = pd.DataFrame(data, columns=[col['Name'] for col in column_info])
    
    # Convert DataFrame to Parquet
    table = pa.Table.from_pandas(df)
    
    with tempfile.NamedTemporaryFile(suffix=".parquet") as temp_file:
        pq.write_table(table, temp_file.name)
        
        # Upload the Parquet file to S3
        s3_key = f"{S3_PREFIX}timestream_data_{end_time.strftime('%Y%m%d_%H%M%S')}.parquet"
        s3.upload_file(temp_file.name, S3_BUCKET, s3_key)
    
    return {
        'statusCode': 200,
        'body': f'Data saved to S3: {s3_key}'
    }
