function Send-Message
{
    <#
    .SYNOPSIS

    Display a pop-up message on a selected computer(s).

    .PARAMETER ComputerName

    The DNS name of the computer to display a message on.

    .PARAMETER Computer

    The ADComputer to display a message on.

    .PARAMETER Message

    The message to be displayed.

    .INPUTS

    String or Microsoft.ActiveDirectory.Management.ADComputer

    .OUTPUTS

    None.

    .EXAMPLE

    Send-Message -ComputerName NAME -Message "This is a message."

    .EXAMPLE

    Get-ADComputer -Filter 'Name -like "xyx"' | Send-Message -Message "Message"

    
    #>
    [cmdletbinding()]
    Param (
            [Parameter(Mandatory,Position=0,ParameterSetName='FromName')][string]$ComputerName,
            [Parameter(Mandatory,ValueFromPipeline=$true,Position=0,ParameterSetName='FromAD')][Microsoft.ActiveDirectory.Management.ADComputer]$Computer,
            [Parameter(Mandatory,Position=1)][string]$Message
    )
    Process 
    {
        if (($Computer | Select-Object -ExpandProperty Name) -eq $null)
        {
            Write-Verbose -Message "ComputerName defined"
            [string]$target = $ComputerName
        }
        else
        {
            Write-Verbose -Message "ADComputer defined"
            [string]$target = ($Computer | Select-Object -ExpandProperty Name)
        }
        Invoke-WmiMethod -Class Win32_Process -ComputerName $target -Name Create -ArgumentList "C:\Windows\System32\msg.exe * $Message" | Out-Null
    }
}
function Get-Uptime
{
    <#
    .SYNOPSIS

    Returns the date and time the system was last powered on.

    .PARAMETER ComputerName

    The DNS name of the computer to display a message on.


    .INPUTS

    String

    .OUTPUTS

    The name of the computer and the last boot time.

    .EXAMPLE

    Get-Uptime -ComputerName xyz
    
    #>
    [cmdletbinding()]
    Param
    (
        [Parameter(Mandatory,Position=0)][string]$ComputerName
    )
    Process
    {
        Get-CimInstance -ComputerName $ComputerName -ClassName win32_operatingsystem | Select-Object csname, lastbootuptime
    }
}
