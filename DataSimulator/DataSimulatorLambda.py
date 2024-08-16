import boto3
import json
import time
import random

# Initialize the Kinesis client
kinesis_client = boto3.client('kinesis', region_name='us-east-1')

# Constants
STREAM_NAME = 'realtime-data-stream'  # Replace with your Kinesis stream name
SAMPLING_RATE = 0.1  # 100 ms

def generate_frequency_data():
    """Simulate real-time frequency data."""
    stepnumber = stepnumber + 1     # Step number autoincrement integer
    starttime = int(time.time() * 1000)  # Current time in milliseconds
    duration = 5 + random.uniform(5,15)  # Duration can be 5 to 15
    frequency = 50 + random.uniform(-0.5, 0.5)  # 50 Hz with small random noise
    return {
        'stepnumber': stepnumber,
        'starttime': starttime,
        'duration': duration,
        'frequency': frequency
    }

def send_to_kinesis(data):
    """Send data to Kinesis Data Stream."""
    kinesis_client.put_record(
        StreamName=STREAM_NAME,
        Data=json.dumps(data),
        PartitionKey=str(data['timestamp'])  # Use timestamp as partition key
    )

def main():
    while True:
        data = generate_frequency_data()
        send_to_kinesis(data)
        print(f"Sent data: {data}")
        time.sleep(SAMPLING_RATE)

if __name__ == '__main__':
    main()
