### 2016-2-5
## gregclark2k11@gmail.com
# file movement system

$userMessage = "running time"
$timeStamp = Date -Format "yyyyMMddmmss"
$monitorDirectory = "C:\FolderMonitorSystem\Exports\Magento"
$archiveDirectory = "$monitorDirectory\archives"#\$timeStamp"
$logDirectory = "$monitorDirectory\logs"
$logFile = "log.txt"
$errorDirectory = "errors"

$moveFrom = $monitorDirectory

$moveToLocalDirectory = "$archiveDirectory"
$moveWhatFiles = "*.csv"


$transferToRemoteURL = "192.168.1.13:"  #$1
$remoteUser = "greg" #$2
$remoteUserPass = "s3rv3rOne" #$3
$transferToRemoteDirectory = "" #$4

