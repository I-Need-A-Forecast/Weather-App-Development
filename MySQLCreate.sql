create user 'dfeltault'@'localhost' identified by 'mysql'
GRANT ALL PRIVILEGES ON *.* TO 'dfeltault'@'localhost'
create database WX;

USE WX;

CREATE TABLE if not exists current_observation
(
	Observation_ID INT not null auto_increment UNIQUE Primary Key
,credit VARCHAR(255) 
,credit_URL VARCHAR(255) 
,suggested_pickup VARCHAR(255) 
,suggested_pickup_period INT 
,location VARCHAR(255) 
,station_id VARCHAR(255) 
,latitude VARCHAR(255)
,longitude VARCHAR(255)
,elevation INT 
,observation_time VARCHAR(255) 
,observation_time_rfc822 VARCHAR(255) 
,weather VARCHAR(255) 
,temperature_string VARCHAR(255) 
,temp_f DECIMAL(18,4)
,temp_c DECIMAL(18,4)
,water_temp_f DECIMAL(18,4)
,water_temp_c DECIMAL(18,4)
,relative_humidity INT 
,wind_string VARCHAR(255) 
,wind_dir VARCHAR(255)
,wind_degrees INT 
,wind_mph DECIMAL(18,4)
,wind_gust_mph DECIMAL(18,4)
,wind_kt DECIMAL(18,4)
,wind_gust_kt DECIMAL(18,4)
,pressure_string VARCHAR(255) 
,pressure_mb DECIMAL(18,4)
,pressure_in DECIMAL(18,4)
,pressure_tendency_mb DECIMAL(18,4)
,pressure_tendency_in DECIMAL(18,4)
,dewpoint_string VARCHAR(255) 
,dewpoint_f DECIMAL(18,4)
,dewpoint_c DECIMAL(18,4)
,heat_index_string VARCHAR(255) 
,heat_index_f INT 
,heat_index_c INT 
,windchill_string VARCHAR(255) 
,windchill_f INT 
,windchill_c INT 
,visibility_mi DECIMAL(18,4)
,wave_height_m DECIMAL(18,4)
,wave_height_ft DECIMAL(18,4)
,dominant_period_sec INT 
,average_period_sec DECIMAL(18,4)
,mean_wave_dir VARCHAR(255)
,mean_wave_degrees INT 
,tide_ft DECIMAL(18,4)
,steepness VARCHAR(255)
,water_column_height DECIMAL(18,4)
,surf_height_ft VARCHAR(255)
,swell_dir VARCHAR(255)
,swell_degrees INT 
,swell_period VARCHAR(255)
,icon_url_base VARCHAR(255) 
,icon_name VARCHAR(255) 
,two_day_history_url VARCHAR(255) 
,icon_url_name VARCHAR(255) 
,ob_url VARCHAR(255) 
,disclaimer_url VARCHAR(255) 
,copyright_url VARCHAR(255) 
,privacy_policy_url VARCHAR(255) 
  
)

