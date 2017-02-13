# SharePoint Product Information
This PowerShell module provides information on each product and patch for a SharePoint 2010, 2013, or 2016 environment. As SharePoint Server 2016 no longer updates the build number in a consistent manner, it is important to determine what the current patch level is.

Usage:
```posh
    Import-Module .\SharePointProductInformation.psm1
    Get-SPProductInformation
```
The output consists of five fields: `DisplayName`: The name of the product, `IsLatest`: Is this the newest patch for that product installed to the farm (not the latest available patch), `Patch`: The name of the patch, `Version`: The patch version number, `SupportUrl`: The URL to the KB article for the patch, `MissingFrom`: Shows a value if one or more servers is missing this particular patch.
You can format the output as a table (`| ft -a`). The default output is in a list format.

Example output:
```posh
   PS C:\> Get-SPProductInformation | select displayname,islatest,patch | ft -a
   DisplayName                                         IsLatest Patch
   -----------                                         -------- -----
   Microsoft SharePoint Foundation 2016 Core           No       N/A
   Microsoft SharePoint Foundation 2016 Core           Yes      Update for Microsoft SharePoint Enterprise Server 2016 (KB2920721) 64-Bit Edition
   Microsoft SharePoint Foundation 2016 1033 Lang Pack Yes      N/A
   Microsoft Server Proof (Arabic) 2016                Yes      N/A
   Microsoft Server Proof (German) 2016                Yes      N/A
   Microsoft Server Proof (English) 2016               Yes      N/A
   Microsoft Server Proof (French) 2016                Yes      N/A
   Microsoft Server Proof (Russian) 2016               Yes      N/A
   Microsoft Server Proof (Spanish) 2016               Yes      N/A
   Microsoft SharePoint Server 2016                    Yes      N/A
```
