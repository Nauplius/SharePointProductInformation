Add-PSSnapin Microsoft.SharePoint.PowerShell -EA 0

function Get-SPProductInformation
{
    param
    (
     [string]
     [Parameter(Mandatory=$false)]
     $path = [string]::Empty
    )

    $patchList = @()
    $products = Get-SPProduct

    if($products.Count -lt 1)
    {
        Write-Host -ForegroundColor Red "No Products found."
        break
    }

    foreach($product in $products.PatchableUnitDisplayNames)
    {
        $unit = $products.GetPatchableUnitInfoByDisplayName($product)
        $i = 0

        foreach($patch in $unit.Patches)
        {
            $obj = [PSCustomObject]@{
                DisplayName = ''
                IsLatest = ''
                Patch = ''
                Version = ''
                SupportUrl = ''
                MissingFrom = ''
            }

            $obj.DisplayName = $unit.DisplayName

            if ($unit.LatestPatch.Version.ToString() -eq $unit.Patches[$i].Version.ToString())
            {
                $obj.IsLatest = "Yes"
            }
            else
            {
                $obj.IsLatest = "No"
            }
                        
            if (($unit.Patches[$i].PatchName) -ne [string]::Empty)
            {
                if ($unit.Patches[$i].ServersMissingThis.Count -ge 1)
                {
                    $missing = [System.String]::Join(',',$unit.Patches[$i].ServersMissingThis.ServerName)
                }
                else
                {
                    $missing = ''
                }

                $obj.Patch = $unit.Patches[$i].PatchName
                $obj.Version = $unit.Patches[$i].Version.ToString()
                $obj.SupportUrl = $unit.Patches[$i].Link.AbsoluteUri
                $obj.MissingFrom = $missing
                $missing = $null
            }
            else
            {
                $obj.Patch = "N/A"
                $obj.Version = "N/A"
                $obj.SupportUrl = "N/A"
                $obj.MissingFrom = "N/A"
            }

            $patchList += $obj
            $obj = $null
            ++$i
        }
    }

    if ($path -ne '')
    {
        try
        {
            Test-Path $path | out-null
        }
        catch
        {
            Write-host -ForegroundColor Red "Invalid path."
            break
        }
        $date = Get-Date -Format MM-dd
        $farm = Get-SPFarm

        if ($path.EndsWith('.csv'))
        {
            $patchList | Export-Csv $path -NoTypeInformation
             Write-Host -ForegroundColor Green "Build information exported to $path"
        }
        else
        {
            $patchList | Export-Csv "$path\$date-$($farm.EncodedFarmId).csv" -NoTypeInformation
            Write-Host -ForegroundColor Green "Build information exported to $path\$date-$($farm.EncodedFarmId).csv"
        }
    }
    else
    {
        return $patchList
    }
}