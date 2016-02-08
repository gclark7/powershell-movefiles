### 2016-2-5
## gregclark2k11@gmail.com
# file movement system

function transferLocalFilesToRemoteServer {
    param ( [String]$serverURL, [String]$user, [String]$password, [String]$moveFrom, [String[]]$moveWhat, [String]$moveTo)
}

function moveFilesLocally{
    param( [String]$moveFrom, [String]$moveTo, [String[]]$moveWhat, [String] $logLocation)
    $userMessage = "Testing values"
    $fileCounter = 0
    $readyToMove = $false

    # sanity checks

    if(-not $moveWhat){
        $userMessage = "no files specified"
        logThis -message $userMessage -logLocation $logLocation
        return $userMessage

    }

    if(-not $moveFrom -or -not (Test-Path $moveFrom)){
        $userMessage = "from location not specified :: $moveFrom"
        logThis -message $userMessage -logLocation $logLocation
        return $userMessage
    }

    if(-not $moveTo -or -not (Test-Path $moveTo)){
        $userMessage = "destination not specified :: $moveTo"
        logThis -message $userMessage -logLocation $logLocation
        return $userMessage
    }

    # test moveWhat
    $readyToMove = testPathExists -moveFrom $moveFrom -moveWhat $moveWhat -logLocation $logLocation
    

    if($readyToMove){
        Move-Item -path "$moveFrom\$moveWhat" -Destination $moveTo
        $userMessage = "moved files $moveFrom\$moveWhat"
        logThis -message $userMessage -logLocation $logLocation
    }

    return $userMessage
}



function logThis{
    param([String]$message, [String]$logLocation)
    $logDate = Date -Format "MM-dd-yyyy HH:mm"
    if(-not (Test-Path $logLocation)){
        createMissingFile -file $logLocation -fileType "file"
    }

    if($logLocation){
        Out-File -FilePath $logLocation -InputObject "$logDate $message" -Append
    }

}

function createMissingFile{
    param([String]$file,[String] $fileType)

    $type = "file"

    if($fileType -like "directory"){
        $type = "directory"
    }

    if($file){
        New-Item $file -ItemType $type -force
    }
}

function testPathExists {
    param([String]$moveFrom,[String[]]$moveWhat, [String]$logLocation)
    $readyToMove = $false
    $fileCounter = 0

    if($moveWhat.Length -gt 1){
        ForEach($testFile in $moveWhat){
            if(-not (Test-Path "$moveFrom\$testFile")){
            logThis -message "unable to find $moveFrom\$testFile" -logLocation $logLocation

            }else{
                $fileCounter++

            }

            if($fileCounter -eq $moveWhat.Length){
                $userMessage = "moving files..."
                $readyToMove = $true
            }else{
                $userMessage = "unable to find all files...check logs at $logLocation"
            }

        }
    }else{
        if(-not (Test-Path "$moveFrom\$moveWhat")){
            $userMessage = "unable to find $moveFrom\$moveWhat"
            logThis -message $userMessage -logLocation $logLocation

        }else{
            $userMessage = "moving files..."
            $readyToMove = $true

        }
        
    }

    return $readyToMove
}


function convertWindowsPathToCygwinPath {
    param([String]$windowsPath, [String]$logLocation)
    $userMessage = "checking Path"
    [String[]]$manipulatePath = ""
    $convertRoot = "" #mostlikely will take c:\ and convert to just c
    $convertedPath = ""
    
    if(!$windowsPath){
        $userMessage = "no path provided:: $windowPath"
        logThis -message $userMessage -logLocation $logLocation
        return $convertedPath
    }

    #break down windowPath
    $manipulatePath = $windowsPath.Split("\\")

    #strip the root directory x:\
    $convertRoot = $manipulatePath[0]

    #remove windowPath root 
    $manipulatePath = $manipulatePath[1..($manipulatePath.Length-1)]

    #remove x:\ leaving x
    if($convertRoot -like "*:*"){
        $convertRoot = $convertRoot[0]
    }

    #begin convertedPath
    $convertedPath = "$convertRoot/"

    #assemble convertedPath
    ForEach( $dir in $manipulatePath){
        $convertedPath += "$dir/"
    }$convertedPath = $convertedPath.Substring(0,($convertedPath.Length-1))  #[0..($convertedPath.Length-1)]
    
    return $convertedPath

}
