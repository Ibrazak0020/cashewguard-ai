# ============================================
# CASHEWGUARD AI KNOWLEDGE BASE EXPORTER
# ============================================

# CHANGE THIS TO YOUR PROJECT PATH
$ProjectRoot = "C:\Users\KAZEEM IBRAHIM\cashewguard_ai"

# Output file
$OutputFile = Join-Path $ProjectRoot "CashewGuardAI_KnowledgeBase.txt"

if(Test-Path $OutputFile){
    Remove-Item $OutputFile
}

# Folders to export
$Folders = @(
    "lib",
    "api",
    "supabase",
    "assets",
    "test"
)

# File types to include
$Extensions = @(
".dart",
".yaml",
".yml",
".json",
".sql",
".md",
".txt",
".js",
".ts",
".py",
".xml"
)

# Root files
$RootFiles = @(
"pubspec.yaml",
"analysis_options.yaml",
"README.md"
)

function Write-Line{
    param($Text)

    Add-Content -Path $OutputFile -Value $Text
}

# ===================================================
# HEADER
# ===================================================

Write-Line "=============================================================="
Write-Line "CASHEWGUARD AI KNOWLEDGE BASE"
Write-Line "Generated: $(Get-Date)"
Write-Line "=============================================================="
Write-Line ""

# ===================================================
# PROJECT STRUCTURE
# ===================================================

Write-Line "PROJECT STRUCTURE"
Write-Line "================="
Write-Line ""

tree $ProjectRoot /F | Out-File "$env:TEMP\projecttree.txt"

Get-Content "$env:TEMP\projecttree.txt" |
Where-Object {
$_ -notmatch "\\android\\" -and
$_ -notmatch "\\ios\\" -and
$_ -notmatch "\\windows\\" -and
$_ -notmatch "\\linux\\" -and
$_ -notmatch "\\macos\\" -and
$_ -notmatch "\\web\\" -and
$_ -notmatch "\\build\\" -and
$_ -notmatch "\.dart_tool" -and
$_ -notmatch "\.idea" -and
$_ -notmatch "\.vscode"
} | Add-Content $OutputFile

Write-Line ""
Write-Line ""
Write-Line "=============================================================="
Write-Line "ROOT FILES"
Write-Line "=============================================================="

foreach($file in $RootFiles){

    $path = Join-Path $ProjectRoot $file

    if(Test-Path $path){

        Write-Line ""
        Write-Line "############################################################"
        Write-Line "FILE: $file"
        Write-Line "############################################################"
        Write-Line ""

        Get-Content $path | Add-Content $OutputFile
    }
}

# ===================================================
# EXPORT SOURCE CODE
# ===================================================

foreach($folder in $Folders){

    $FolderPath = Join-Path $ProjectRoot $folder

    if(!(Test-Path $FolderPath)){
        continue
    }

    Write-Line ""
    Write-Line ""
    Write-Line "=============================================================="
    Write-Line "FOLDER: $folder"
    Write-Line "=============================================================="

    Get-ChildItem $FolderPath -Recurse -File |

    Where-Object{

        $Extensions -contains $_.Extension

    } |

    Sort-Object FullName |

    ForEach-Object{

        Write-Line ""
        Write-Line "############################################################"
        Write-Line "FILE:"
        Write-Line ($_.FullName.Replace($ProjectRoot,""))
        Write-Line "############################################################"
        Write-Line ""

        try{

            Get-Content $_.FullName -Raw | Add-Content $OutputFile

        }

        catch{

            Write-Line "[Unable to read file]"

        }

        Write-Line ""
        Write-Line ""
    }
}

Write-Line ""
Write-Line "=========================="
Write-Line "END OF KNOWLEDGE BASE"
Write-Line "=========================="

Write-Host ""
Write-Host "DONE!"
Write-Host ""
Write-Host "Knowledge Base saved to:"
Write-Host $OutputFile