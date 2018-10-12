function Invoke-TervisDeployNPSServerConfiguration {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]$Computername,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]$NPSConfigFile
    )
    process{
        $RemoteNPSConfigPath = Invoke-OutputFileToRemoteTempPath -ComputerName $Computername -FileContent $NPSConfigFile
        Invoke-Command -ComputerName $Computername -ScriptBlock {
            Import-NPSConfiguration -Path $using:RemoteNPSConfigPath
        }
    }
}

function Invoke-AzureMFANPSServerProvision {
    $EnvironmentName = "Infrastructure"
    $ApplicationName = "AzureMFANPS"
#    $TervisApplicationDefinition = Get-TervisApplicationDefinition -Name $ApplicationName
    Invoke-ApplicationProvision -ApplicationName $ApplicationName -EnvironmentName $EnvironmentName
    $Nodes = Get-TervisApplicationNode -ApplicationName $ApplicationName -EnvironmentName $EnvironmentName
    $NPSConfig = (Get-PasswordstateDocument -DocumentLocation password -DocumentID 48).innerxml
    $Nodes | Invoke-TervisDeployNPSServerConfiguration -NPSConfigFile $NPSConfig
}

