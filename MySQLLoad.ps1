<#

#>

#Reload:  Use existing WX\TempXML
$Reload=$flase
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$MySQLAdminUserName = 'dfeltault'
$MySQLAdminPassword = 'mysql'
$MySQLDatabase = 'WX'
$MySQLHost = 'localhost'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase

Start-Transcript ([environment]::CurrentDirectory + "\MySQLLoad.log") -Append
("Starting WX Load: " + (get-date).ToShortTimeString())
if ($DA) {Remove-Variable DA}
if ($DS) {Remove-Variable DS}
if ($DT) {Remove-Variable DT}


$DA = New-Object "MySql.Data.MySqlClient.MySqlDataAdapter" 
$DS = New-Object "System.Data.Dataset"
$DT = New-Object "System.Data.DataTable"

Function GetObsTable{
    TRY {
        $CommandString = "Select * from current_observation LIMIT 1"
        [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
        $SQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)
        
        Write-Verbose ("Connecting to: " + $SqlConnection.ConnectionString)
        $SqlConnection.Open()
        if ($SqlConnection.State -eq "Open") {
                $da.SelectCommand =  $CommandString
                $da.SelectCommand.Connection = $SqlConnection
            
                # Auto Build Insert command
                $DABuild = New-Object "MySQL.Data.MySQLClient.MySQLCommandBuilder"
                $DABuild.DataAdapter=$da
                $DABuild.RefreshSchema()

                $DAFillVal = $DA.Fill($DS)

                # check for existence here or Failure of Fill
                if ($DS.Tables.Count -eq 1){
                ("Table Found: " + $DS.Tables[0].TableName + " Rows: " +  $ds.Tables[0].Rows.Count)
                
                $Script:DT= $ds.Tables[0]
                $Script:DT.AcceptChanges()
                }
                
                else {Throw("No Tables Found")}
            } #ConnectionOpen
        } #TRY

    CATCH {Throw}

    Finally {
        $SqlConnection.Close()
    }
}

Function ReadObsXML ($FileName){
Try {
    $Obs = [XML](Get-Content $FileName)
        Return $Obs
}

Catch {"Error Reading: " + $FileName}

}

Function AddRow($CO) {
    #Write-Verbose ("Adding Row: " + $CO.Location)
    $CORow = $DT.NewRow() #| Out-Null

    if(!([string]::IsNullOrEmpty($CO.credit))) {$CORow.credit =$CO.credit}
    if(!([string]::IsNullOrEmpty($CO.credit_URL))) {$CORow.credit_URL =$CO.credit_URL}
    #IMAGE
    if(!([string]::IsNullOrEmpty($CO.suggested_pickup))) {$CORow.suggested_pickup=$CO.suggested_pickup}
    if(!([string]::IsNullOrEmpty($CO.suggested_pickup_period))) {$CORow.suggested_pickup_period}
    if(!([string]::IsNullOrEmpty($CO.location))) {$CORow.location=$CO.location}  
    if(!([string]::IsNullOrEmpty($CO.station_id))) {$CORow.station_id=$CO.station_id}
    if(!([string]::IsNullOrEmpty($CO.latitude))) {$CORow.latitude=$CO.latitude}
    if(!([string]::IsNullOrEmpty($CO.longitude))) {$CORow.longitude=$CO.longitude}
    if(!([string]::IsNullOrEmpty($CO.elevation))) {$CORow.elevation=$CO.elevation}

    #Additional handling for Date/TIme fields
    if(!([string]::IsNullOrEmpty($CO.observation_time))) {$CORow.observation_time=$CO.observation_time}
    
    #If we don't get a good date/time  skip this record
    if(([string]::IsNullOrEmpty($CO.observation_time_rfc822))) {break}
    $CORow.observation_time_rfc822=$CO.observation_time_rfc822
    [Datetime]$ObsDate = $CO.observation_time_rfc822
    $USTDateTime = $ObsDate.ToUniversalTime()
    $CORow.obsDate = $USTDateTime.ToShortDateString()
    $CORow.obsTime = $USTDateTime.tostring("HH:mm:ss")

    if(!([string]::IsNullOrEmpty($CO.weather))){$CORow.weather=$CO.weather}
    if(!([string]::IsNullOrEmpty($CO.temperature_string))) {$CORow.temperature_string=$CO.temperature_string}
    if(!([string]::IsNullOrEmpty($CO.temp_f))) {$CORow.temp_f=$CO.temp_f}
    if(!([string]::IsNullOrEmpty($CO.temp_c))) {$CORow.temp_c=$CO.temp_c}
    if(!([string]::IsNullOrEmpty($CO.water_temp_f))) {$CORow.water_temp_f=$CO.water_temp_f}
    if(!([string]::IsNullOrEmpty($CO.water_temp_c))) {$CORow.water_temp_c=$CO.water_temp_c}
    if(!([string]::IsNullOrEmpty($CO.relative_humidity))) {$CORow.relative_humidity=$CO.relative_humidity}
    if(!([string]::IsNullOrEmpty($CO.wind_string))) {$CORow.wind_string=$CO.wind_string}
    if(!([string]::IsNullOrEmpty($CO.wind_dir))) {$CORow.wind_dir=$CO.wind_dir}
    if(!([string]::IsNullOrEmpty($CO.wind_degrees))) {$CORow.wind_degrees=$CO.wind_degrees}
    if(!([string]::IsNullOrEmpty($CO.wind_mph))) {$CORow.wind_mph=$CO.wind_mph}
    if(!([string]::IsNullOrEmpty($CO.wind_gust_mph))) {$CORow.wind_gust_mph=$CO.wind_gust_mph}
    if(!([string]::IsNullOrEmpty($CO.wind_kt))) {$CORow.wind_kt=$CO.wind_kt }
    if(!([string]::IsNullOrEmpty($CO.wind_gust_kt))) {$CORow.wind_gust_kt=$CO.wind_gust_kt}
    if(!([string]::IsNullOrEmpty($CO.pressure_string))) {$CORow.pressure_string=$CO.pressure_string}
    if(!([string]::IsNullOrEmpty($CO.pressure_mb))) {$CORow.pressure_mb=$CO.pressure_mb}
    if(!([string]::IsNullOrEmpty($CO.pressure_in))) {$CORow.pressure_in=$CO.pressure_in}
    if(!([string]::IsNullOrEmpty($CO.pressure_tendency_mb))) {$CORow.pressure_tendency_mb=$CO.pressure_tendency_mb} 
    if(!([string]::IsNullOrEmpty($CO.pressure_tendency_in))) {$CORow.pressure_tendency_in=$CO.pressure_tendency_in}
    if(!([string]::IsNullOrEmpty($CO.dewpoint_string))) {$CORow.dewpoint_string=$CO.dewpoint_string}
    if(!([string]::IsNullOrEmpty($CO.dewpoint_f))) {$CORow.dewpoint_f=$CO.dewpoint_f}
    if(!([string]::IsNullOrEmpty($CO.dewpoint_c))) {$CORow.dewpoint_c=$CO.dewpoint_c}
    if(!([string]::IsNullOrEmpty($CO.heat_index_string))) {$CORow.heat_index_string=$CO.heat_index_string}
    if(!([string]::IsNullOrEmpty($CO.heat_index_f))) {$CORow.heat_index_f=$CO.heat_index_f}
    if(!([string]::IsNullOrEmpty($CO.heat_index_c))) {$CORow.heat_index_c=$CO.heat_index_c}
    if(!([string]::IsNullOrEmpty($CO.windchill_string))) {$CORow.windchill_string=$CO.windchill_string}
    if(!([string]::IsNullOrEmpty($CO.windchill_f))) {$CORow.windchill_f=$CO.windchill_f}
    if(!([string]::IsNullOrEmpty($CO.windchill_c))) {$CORow.windchill_c=$CO.windchill_c}
    if(!([string]::IsNullOrEmpty($CO.visibility_mi))) {$CORow.visibility_mi=$CO.visibility_mi}
    if(!([string]::IsNullOrEmpty($CO.wave_height_m))) {$CORow.wave_height_m=$CO.wave_height_m}
    if(!([string]::IsNullOrEmpty($CO.wave_height_ft))) {$CORow.wave_height_ft=$CO.wave_height_ft}
    if(!([string]::IsNullOrEmpty($CO.dominant_period_sec))) {$CORow.dominant_period_sec=$CO.dominant_period_sec}
    if(!([string]::IsNullOrEmpty($CO.average_period_sec))) {$CORow.average_period_sec=$CO.average_period_sec}
    if(!([string]::IsNullOrEmpty($CO.mean_wave_dir))) {$CORow.mean_wave_dir=$CO.mean_wave_dir}
    if(!([string]::IsNullOrEmpty($CO.mean_wave_degrees))) {$CORow.mean_wave_degrees=$CO.mean_wave_degrees}
    if(!([string]::IsNullOrEmpty($CO.tide_ft))) {$CORow.tide_ft=$CO.tide_ft}
    if(!([string]::IsNullOrEmpty($CO.steepness))) {$CORow.steepness=$CO.steepness}
    if(!([string]::IsNullOrEmpty($CO.water_column_height))) {$CORow.water_column_height=$CO.water_column_height}
    if(!([string]::IsNullOrEmpty($CO.surf_height_ft))) {$CORow.surf_height_ft=$CO.surf_height_ft}
    if(!([string]::IsNullOrEmpty($CO.swell_dir))) {$CORow.swell_dir=$CO.swell_dir}
    if(!([string]::IsNullOrEmpty($CO.swell_degrees))) {$CORow.swell_degrees=$CO.swell_degrees}
    if(!([string]::IsNullOrEmpty($CO.swell_period))) {$CORow.swell_period=$CO.swell_period}
    if(!([string]::IsNullOrEmpty($CO.icon_url_base))) {$CORow.icon_url_base=$CO.icon_url_base}
    if(!([string]::IsNullOrEmpty($CO.icon_name))) {$CORow.icon_name=$CO.icon_name}
    if(!([string]::IsNullOrEmpty($CO.two_day_history_url))) {$CORow.two_day_history_url=$CO.two_day_history_url}
    if(!([string]::IsNullOrEmpty($CO.icon_url_name))) {$CORow.icon_url_name=$CO.icon_url_name}
    if(!([string]::IsNullOrEmpty($CO.ob_url))) {$CORow.ob_url=$CO.ob_url}
    if(!([string]::IsNullOrEmpty($CO.disclaimer_url))) {$CORow.disclaimer_url=$CO.disclaimer_url}
    if(!([string]::IsNullOrEmpty($CO.copyright_url))) {$CORow.copyright_url=$CO.copyright_url}
    if(!([string]::IsNullOrEmpty($CO.privacy_policy_url))) {$CORow.privacy_policy_url=$CO.privacy_policy_url}

    $dt.rows.add($CORow)
}

Function WriteDT {
    TRY {
        $SQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)
        Write-Verbose ("Connecting to: " + $SqlConnection.ConnectionString)
        $SqlConnection.Open()
        if ($SqlConnection.State -eq "Open") {
            $da.UpdateBatchSize=100
            $DAUpdateCount = $da.Update($DT)
            ("Current_Observation Rows Updated: " + $DAUpdateCount)
           
        } #connection open
    }

    CATCH {Throw}

    Finally {
        $SqlConnection.Close()
    }
}

Function ReadAllXML 
{

$TempLocation = [environment]::GetEnvironmentVariable("TMP") + "\WX-XML"

 if (!$Reload) {
    #Ensure a clean start
    if(test-path ($TempLocation + "\*.xml")){Remove-Item  ($TempLocation + "\*.xml")}
    
   
    #$VMTemp = $VerbosePreference
    #$VerbosePreference="SilentlyContinue"
    "Download all_xml.zip TO TMP..."
    Invoke-WebRequest -Uri 'https://w1.weather.gov/xml/current_obs/all_xml.zip' -WebSession $fb -OutFile ([environment]::GetEnvironmentVariable("TMP")+'\all_xml.zip')
    "Unzipping Files..."
    Expand-Archive -path ([environment]::GetEnvironmentVariable("TMP")+'\all_xml.zip')  -DestinationPath $TempLocation
    #$VerbosePreference = $VMTemp
    }


    Get-ChildItem $TempLocation | sort LastWriteTime   | 
    Foreach-Object {
        #Eliminate Old observations
        if($_.LastWriteTimeUtc -gt [datetime]::Today) {
        #ReadObsXML may return Null if failed to read
        $Obs = ReadObsXML $_.FullName
        if(!([string]::IsNullOrEmpty($Obs))) {AddRow($Obs.current_observation) | out-null}
        }
    }
}


$StartTime = $(get-date)

GetObsTable
ReadAllXML
("Rows Added: " +  $ds.Tables[0].Rows.Count)
$elapsedTime = $(get-date) - $StartTime
$ReadTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
"ReadTime: " + $ReadTime
$StartTime = $(get-date)

WriteDT
#if(test-path ($tempLocation)) {Remove-Item ($TempLocation)}
$elapsedTime = $(get-date) - $StartTime
$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
("Write Time: " + $totalTime)
stop-Transcript
