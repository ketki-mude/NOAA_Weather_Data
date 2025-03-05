import os
import requests
import csv
import datetime
import boto3
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# AWS Configuration
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION")
AWS_S3_BUCKET_NAME = os.getenv("AWS_S3_BUCKET_NAME")

# NOAA API Configuration
NOAA_API_URL = os.getenv("NOAA_API_URL")
NOAA_API_KEY = os.getenv("NOAA_API_KEY")

# List of Boston Zip Codes
ZIP_CODES = ["02119", "02115", "02111", "02108", "02109"]

# NOAA Weather Station IDs (One station for Boston - Change if needed)
STATION_ID = "GHCND:USW00014739"

# Define the start year
START_YEAR = 2020
CURRENT_YEAR = datetime.datetime.today().year

# AWS S3 Client
s3_client = boto3.client(
    "s3",
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name=AWS_REGION
)

# Function to fetch NOAA weather data for a specific year and zip code
def fetch_noaa_weather_data(start_date, end_date, zip_code):
    headers = {"token": NOAA_API_KEY}
    params = {
        "datasetid": "GHCND",
        "stationid": STATION_ID,
        "datatypeid": "TMAX",  # Max temperature
        "units": "metric",
        "startdate": start_date,
        "enddate": end_date,
        "limit": 1000,
    }

    all_data = []
    offset = 1

    while True:
        params["offset"] = offset
        response = requests.get(NOAA_API_URL, headers=headers, params=params)

        if response.status_code == 200:
            data = response.json()
            if "results" in data:
                for entry in data["results"]:
                    all_data.append({
                        "date": entry["date"],
                        "station": entry["station"],
                        "temperature": entry["value"] / 10,  # Convert from tenths of degrees
                        "zipcode": zip_code
                    })
                offset += 1000
            else:
                break
        else:
            print(f"Error fetching data for {zip_code} ({start_date} to {end_date}): {response.text}")
            break

    return all_data

# Function to upload CSV to S3 directly
def upload_to_s3(zip_code, csv_data):
    s3_key = f"weatherData/{zip_code}/noaa_weather_{zip_code}.csv"

    csv_content = "date,station,temperature,zipcode\n"
    for row in csv_data:
        csv_content += f"{row['date']},{row['station']},{row['temperature']},{row['zipcode']}\n"

    s3_client.put_object(
        Bucket=AWS_S3_BUCKET_NAME,
        Key=s3_key,
        Body=csv_content
    )

    print(f"File uploaded to S3: s3://{AWS_S3_BUCKET_NAME}/{s3_key}")

# Main function to process all zip codes
def main():
    for zip_code in ZIP_CODES:
        print(f"Fetching data for Zip Code: {zip_code}")
        all_weather_data = []

        for year in range(START_YEAR, CURRENT_YEAR + 1):
            start_date = f"{year}-01-01"
            end_date = f"{year}-12-31" if year != CURRENT_YEAR else datetime.datetime.today().strftime("%Y-%m-%d")
            
            weather_data = fetch_noaa_weather_data(start_date, end_date, zip_code)
            all_weather_data.extend(weather_data)

        if all_weather_data:
            upload_to_s3(zip_code, all_weather_data)
        else:
            print(f"No data available for {zip_code}.")

if __name__ == "__main__":
    main()
