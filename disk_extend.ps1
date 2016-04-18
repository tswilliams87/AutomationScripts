#==============================================
# Generated On: 4/18
# Generated By: Gary Coburn
# Staff Engineer - Automation
# Organization: VMware
# Twitter: @coburngary
# Disk Extend v1.1
#==============================================
#----------------------------------------------
#==================USAGE=======================
# For Windows Server 2008 & 2012
# This script has been created to aid in disk extend
# And the services will need to be restarted.
#----------------------------------------------
#===============REQUIREMENTS===================
# For this script to run successfully be sure:
# 	*To run PowerShell as administrator
#	*To have admin rights on the server
#----------------------------------------------

# ----------------------------------------
# 	     Functions
# ----------------------------------------
# function to write output to both file and screen
function Write-Feedback()
{
    Write-Host -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor $msg;
    $msg | Out-File "C:\opt\disk_extend.txt" -Append;
}

function List-Disks {
  'list disk' | diskpart |
    ? { $_ -match 'disk (\d+)\s+online\s+\d+ .?b\s+\d+ [gm]b' } |
    % { $matches[1] }
}

function List-Partitions($disk) {
  "select disk $disk", "list partition" | diskpart |
    ? { $_ -match 'partition (\d+)' } |
    % { $matches[1] }
}

function Extend-Partition($disk, $part) {
  "select disk $disk","select partition $part","extend" | diskpart | Out-Null
}

# ----------------------------------------
# 	     End Functions
# ----------------------------------------
New-Item -ItemType Directory -Force -Path C:\opt
"Starting the log file" | Out-file -FilePath C:\opt\disk_extend.txt | Write-Host
$msg = "logging all messages:";$BackgroundColor = "Black";$ForegroundColor = "Green";Write-Feedback

$msg = "Running intial scan for new freespace ";$BackgroundColor = "Black";$ForegroundColor = "Green";Write-Feedback
"rescan" | diskpart

$msg = "Listing disk, finding freespace, and extending partition ";$BackgroundColor = "Black";$ForegroundColor = "Green";Write-Feedback
List-Disks | % {
  $disk = $_
  List-Partitions $disk | % {
    Extend-Partition $disk $_
  }
}

$msg = "Running final scan ";$BackgroundColor = "Black";$ForegroundColor = "Green";Write-Feedback
"rescan" | diskpart
