#!/usr/bin/env python
# Retail Orders ETL Pipeline
# Kaggle → Python → SQL Server Analysis

import kaggle
import zipfile
import pandas as pd
import sqlalchemy as sal

print("Retail Orders ETL Pipeline Starting...")

# 1. DOWNLOAD FROM KAGGLE
print("Downloading dataset...")
kaggle.api.dataset_download_files('ankitbansal06/retail-orders', path='.', unzip=False)


print("Extracting orders.csv...")
zip_ref = zipfile.ZipFile('orders.csv.zip') 
zip_ref.extractall()
zip_ref.close()

# LOAD & CLEAN DATA
print("Loading and cleaning data...")
df = pd.read_csv('orders.csv', na_values=['Not Available','unknown'])
print(f"Loaded {len(df)} rows")
print("Ship Mode unique values:", df['Ship Mode'].unique())

# FEATURE ENGINEERING
print("Engineering features...")
df['profit'] = df['sale_price'] - df['cost_price']

# DATA TYPE CONVERSION
print("Converting dates...")
df['order_date'] = pd.to_datetime(df['order_date'], format="%Y-%m-%d")

#  CLEANUP COLUMNS
print("Dropping unneeded columns...")
df.drop(columns=['list_price','cost_price','discount_percent'], inplace=True)

print("\nETL Complete!")
print(f"Rows: {len(df)}, Columns: {df.shape[1]}")
print("Sample data:")
print(df[['order_date', 'profit', 'Ship Mode']].head())
print("\nNext: Run sql_analysis.sql")

# Optional: SQL Server connection (uncomment if SQL Server installed)
"""
import sqlalchemy as sal
engine = sal.create_engine('mssql+pyodbc://localhost/master?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes')
df.to_sql('df_orders', engine, index=False, if_exists='replace')
print("Data loaded to SQL Server!")
"""
