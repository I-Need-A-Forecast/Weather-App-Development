SELECT 
    obsDate,
    obsTime,
    CONVERT_TZ(CONCAT(ObsDate, ' ', ObsTime),
            '+0:00',
            'SYSTEM') AS dt,

    DATE_FORMAT(
		CONVERT_TZ(CONCAT(ObsDate, ' ', ObsTime),
                    '+0:00',
                    'SYSTEM'),
            '%Y-%m-%d %r') AS LocalT,
    Observation_time,
    station_ID,
    temp_f,
    weather
FROM
    wx.current_observation
WHERE
    station_ID = 'kmsp'
ORDER BY obsDate desc, obstime DESC

select ObsDate, count(*) 
from wx.current_observation
WHERE
    station_ID = 'kmsp'
Group by ObsDate
Order by ObsDate desc


select * from wx.current_observation
WHERE
    station_ID = 'kmsp'
order by Observation_ID DEsc

limit 5000

