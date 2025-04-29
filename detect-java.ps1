Function DetectJava($FileSystem) {
	Get-Childitem -Path "$FileSystem" -Filter 'java.exe' -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
		
		$PropertiesVersion 	= & "$($_.FullName)" -XshowSettings:properties -version 2>&1 
		$Vendor 			= $PropertiesVersion | Select-String -Pattern "java.vendor = " | ForEach-Object { ($_.Line -replace 'java.vendor = ', '').Trim() }  
		$VendorVersion 		= $PropertiesVersion | Select-String -Pattern "java.vendor.version = " | ForEach-Object { ($_.Line -replace 'java.vendor.version = ', '').Trim() }  
		$Version 			= $PropertiesVersion | Select-String -Pattern "java.version = " | ForEach-Object { ($_.Line -replace 'java.version = ', '').Trim() }  
		$VersionDate 		= $PropertiesVersion | Select-String -Pattern "java.version.date = " | ForEach-Object { ($_.Line -replace 'java.version.date = ', '').Trim() }  
		$OsArch 			= $PropertiesVersion | Select-String -Pattern "os.arch = " | ForEach-Object { ($_.Line -replace 'os.arch = ', '').Trim() }  
		$OsName 			= $PropertiesVersion | Select-String -Pattern "os.name = " | ForEach-Object { ($_.Line -replace 'os.name = ', '').Trim() }  
		$OsVersion 			= $PropertiesVersion | Select-String -Pattern "os.version = " | ForEach-Object { ($_.Line -replace 'os.version = ', '').Trim() }  
		$JavaHome 			= $PropertiesVersion | Select-String -Pattern "java.home = " | ForEach-Object { ($_.Line -replace 'java.home = ', '').Trim() }  
		$UserName 			= $PropertiesVersion | Select-String -Pattern "user.name = " | ForEach-Object { ($_.Line -replace 'user.name = ', '').Trim() }  
		
		[PsCustomObject]@{
			'Vendor' 			= $Vendor
			'Version'    		= $Version + " ($($VendorVersion) - $($VersionDate)) "
			'Operation System' 	= $OsName + " " + $OsVersion + " " + $OsArch
			'User' 				= $UserName
			'Java Home'     	= $JavaHome
			#'Path'       		= $_.FullName
		}
		 
	} # | Select-Object -First 2
}



Function GetDrive {
	$Drives = Get-PSDrive -PSProvider FileSystem 
	return $Drives
}



$OutputFile = "Java-Information.txt"

Start-Transcript -Path "$OutputFile"

Write-Host "=============================="
Write-Host "=== Detect Java In Windows ==="
Write-Host "=============================="

$User 		 = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$Drives 	 = GetDrive
$DriveString = $Drives -join ", " 

Write-Host "  User : " + $User
Write-Host "  Drive Detect : [$($DriveString)] "
Write-Host 
Write-Host 

foreach ($Drive in $Drives) {
	Write-Host "Scanning in Drive : $($Drive)"
	
	# Get the Java information
	DetectJava "$($Drive.Root)"  | Format-Table -AutoSize
}



Write-Host "Java information saved to: $OutputFile"
Write-Host "=== Finished ==="
 
