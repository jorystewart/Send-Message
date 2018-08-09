function Send-Message
{
    <#
    .SYNOPSIS

    Display a pop-up message on a selected computer.

    .PARAMETER ComputerName

    The DNS name of the computer to display the message on.

    .PARAMETER Message

    The message to be displayed.

    .OUTPUTS

    None.

    .EXAMPLE

    Send-Message -ComputerName NAME -Message "This is a message."
    
    #>
    [cmdletbinding()]
    Param (
            [Parameter(Mandatory,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)][alias("Name")][string]$ComputerName,
            [Parameter(Mandatory)][string]$Message
    )
    Process 
    {
        Invoke-WmiMethod -Class Win32_Process -ComputerName $ComputerName -Name Create -ArgumentList "C:\Windows\System32\msg.exe * $Message" | Out-Null
    }
}
