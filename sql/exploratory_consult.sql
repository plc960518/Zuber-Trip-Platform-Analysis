import pandas as pd
URL='https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html'
weather_records = pd.read_html(URL, attrs={'id':'weather_records'})[0]
print(weather_records)