<#
.SYNOPSIS
    Check if scoop is installed
#>
function Grant-ScoopInstalled {
    if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
        Throw "'scoop' was not found. Skip."
    }
}

<#
.SYNOPSIS
    Get all installed scoop buckets

.DESCRIPTION
    Get all installed scoop buckets and put the official buckets at the top.
#>
function Get-ScoopBuckets {
    Grant-ScoopInstalled

    # Sort array by custom order
    # Ref: https://stackoverflow.com/questions/48701384/powershell-custom-order-sorting
    #
    # Reverse array elements
    # Ref: https://stackoverflow.com/questions/22771724/reverse-elements-via-pipeline
    scoop bucket list | Sort-Object {(scoop bucket known | Sort-Object {(--$Script:i)}).IndexOf($_.Name)} -Descending
}

<#
.SYNOPSIS
    Get apps installed via scoop

.DESCRIPTION
    Get apps installed via scoop, putting the ones that from the offical
    buckets at the top, and sort them by name.
#>
function Get-ScoopApps {
    Grant-ScoopInstalled

    $Buckets = Get-ScoopBuckets

    # Sort by multiple properties using expressions
    # Ref: https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/sort-object?view=powershell-7.2#example-5-use-a-hash-table-to-sort-properties-in-ascending-and-descending-order
    #
    # Suppress "Installed apps:" message
    # Ref: https://powershell.one/code/9.html
    scoop list 6>$null |
        Sort-Object -Property @{Expression = {$Buckets.Name.IndexOf($_.Source)}},
                              @{Expression = "Name"}
}

<#
.SYNOPSIS
    Export data of scoop buckets and apps into a JSON object

.DESCRIPTION
    Export data of all added scoop buckets and installed app into a JSON
    object. The buckets are sorted by putting all offical ones at the top. The
    apps are also sorted in the same way in the same way, then sorted by names.

.OUTPUTS
    The path of the output JSON file or $null if scoop is not found
#>
function Export-ScoopData {
    Grant-ScoopInstalled

    @{
        bucket = Get-ScoopBuckets | Select-Object Name, Source, Updated
        app = Get-ScoopApps | Select-Object Name, Version, Source
    } | ConvertTo-Json
}

<#
.SYNOPSIS
    Export data of scoop buckets and apps into a JSON object

.DESCRIPTION
    Export data of all added scoop buckets and installed app into a JSON
    object. The buckets are sorted by putting all offical ones at the top. The
    apps are also sorted in the same way in the same way, then sorted by names.

.OUTPUTS
    The path of the output JSON file or an empty string if scoop is not found
#>
function Import-ScoopData {
    param(
        [ValidateScript({
            if (($_ | Test-Path -PathType Leaf)) {
                $true
            } else {
                throw "Input file path ('$_') does not exist"
            }
        })]
        [string] $JsonFile,

        [Parameter(ValueFromPipeline=$true)][string] $JsonText
    )

    Grant-ScoopInstalled

    if ($JsonFile) {
        $ScoopData = Get-Content -Path $JsonFile -Raw
    } elseif ($JsonText) {
        $ScoopData = $JsonText
    } else {
        Throw "Nothing to import."
    }

    $ScoopData = $ScoopData | ConvertFrom-Json -AsHashtable

    # Only add non-existing buckets
    $OldBuckets = Get-ScoopBuckets
    $ScoopData.bucket | ForEach-Object {
        $New = $_

        # Check the bucket using URL
        $Old = $OldBuckets | Where-Object {$_.Source -eq $New.Source}
        if ($Old.length -eq 0) {
            scoop bucket add $New.Name $New.Source
        } else {
            # If there is an existing bucket that using the same URL, rename
            # the imported bucket name
            if ($New.Name -ne $Old.Name) {
                $ScoopData.app | ForEach-Object {
                    $App = $_
                    if ($App.Source -eq $New.Name) {
                        $App.Source = $Old.Name
                    }
                }
            }
        }
    }

    $OldApps = Get-ScoopApps
    $ScoopData.app | ForEach-Object {
        if ($_.Name -in $OldApps.Name) { Return }
        scoop install "$($_.Source)/$($_.Name)"
    }
}
