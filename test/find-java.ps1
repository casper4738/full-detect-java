Function DetectJava($FileSystem) {
    
	$DetectJava = Get-ChildItem -Path "$FileSystem" -Include "java.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 2 -ExpandProperty FullName
	
	Write-Host "DetectJava"
	Write-Host "$DetectJava"
	Write-Host "================="
	
	ForEach($obj in $DetectJava){

		Write-Host "$obj"
	}
	
}

Function DetectJava2($FileSystem) {
	Get-Childitem -Path 'C:\' -Filter 'java.exe' -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
		
		$TestJava="java"
		$Vendor = & "$($TestJava)" -XshowSettings:properties -version 2>&1 
		$Vendor = $Vendor | Select-String -Pattern "java.vendor = " | ForEach-Object { ($_.Line -replace 'java.vendor = ', '').Trim() }  
		
		[PsCustomObject]@{
			'Path'       = $_.FullName
			'Version'    = (Get-Command $_.FullName | Select-Object -ExpandProperty Version)
			'ExeVersion' = $_.VersionInfo.ProductVersion 
			'Architecture' = $_.Architecture 
			'User' = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
			'Vendor' = $Vendor

		}
		 
	} | Select-Object -First 2
}

Function GetVendor () {
	
	
java -XshowSettings:properties -version 2>&1 | Select-String -Pattern "java.vendor = " | ForEach-Object { ($_.Line -replace 'java.vendor = ', '').Trim() }

}

Function test() {
	
	
	Get-ChildItem -Path 'C:\' -Filter 'java.exe' -Recurse -Force -ErrorAction SilentlyContinue | Select-Object -First 2 -Property @{
		label = 'Vendor'
		expr = { Invoke-Expression  "$($_.FullName)   -version " }
	  },
	  @{
		label = 'Size(KB)'
		expr = {  Invoke-Expression java "-XshowSettings:properties -version " 2>&1 | Select-String -Pattern "java.vendor = " | ForEach-Object { ($_.Line -replace 'java.vendor = ', '').Trim() } }
	  }, LastWriteTime, FullName


}


Function  GetDrive() {
	$Drives = Get-PSDrive -PSProvider FileSystem 

  # Create an array to store the formatted drive information
  $DriveInfo = @()

  # Loop through each drive
  foreach ($Drive in $Drives) {
    # Calculate sizes in GB (rounded down)
    $FreeGB  = ($Drive.Free / 1GB) -as [int]
    $UsedGB  = ($Drive.Used / 1GB) -as [int]
    $TotalGB = (($Drive.Free + $Drive.Used) / 1GB) -as [int]

    # Create a custom object with the drive information
    $DriveObject = [PSCustomObject]@{
      DriveLetter = $Drive.Root
      DriveType   = $Drive.DriveType
      TotalGB     = $TotalGB
      FreeGB      = $FreeGB
      UsedGB      = $UsedGB
      FileSystem  = $Drive.FileSystem
      Label       = $Drive.VolumeLabel
    }

    Write-Host "$($Drive.Root)"
  }
  
}


GetDrive




#DetectJava2 "C:\"

# test 