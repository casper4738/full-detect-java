# Script to Get Drive Information and Save to a File

# Set the output file path
$OutputFile = "DriveInfo.txt"

# Function to get drive information
function Get-DriveInfo {
  # Get all fixed drives (internal hard drives/SSDs)
  $Drives = Get-PSDrive -PSProvider FileSystem | Where-Object {$_.DriveType -eq "Fixed"}

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

    # Add the object to the array
    $DriveInfo += $DriveObject
  }

  # Return the array of drive objects
  return $DriveInfo
}

# Get the drive information
$DriveData = Get-DriveInfo

# Format the output as a table
$FormattedOutput = $DriveData | Format-Table -AutoSize

# Save the output to a file
$FormattedOutput | Out-File -FilePath $OutputFile

# Display a message indicating where the output was saved
Write-Host "Drive information saved to: $OutputFile"

# Optional: Display the drive information in the console
Write-Host "Drive Information:"
$DriveData | Format-Table -AutoSize # Display in console too