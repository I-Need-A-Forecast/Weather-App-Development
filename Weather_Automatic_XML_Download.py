import urllib
from datetime import datetime, timedelta

while 1:
    print 'Run something..'

    urllib.urlretrieve("https://w1.weather.gov/xml/current_obs/all_xml.zip", "file.zip8")

    dt = datetime.now() + timedelta(hours=1)
    dt = dt.replace(minute=15)

    while datetime.now() < dt:
        time.sleep(1)

