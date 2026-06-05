# ============================================================
# SCM---Project — AL Structure & Rename Script
# Author: Gledis Muca / DynSol
# Description: Restructures the SCM BC AL extension project
#              to follow AL best practices:
#              - Moves all .al files under src/
#              - Renames folders to PascalCase, no spaces
#              - Renames files to Dot.Separator convention
#              - Fixes duplicate TableExt ID (50001 → 50002)
#              - Fixes ReportExt ID (5001 → 50001)
# Usage: Run from the root of your SCM---Project folder
#        .\Restructure-SCM-Project.ps1
# ============================================================

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot  # Folder where this script lives (project root)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " SCM Project — Restructure & Rename" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Root: $root"
Write-Host ""

# ------------------------------------------------------------
# STEP 1 — Create new src/ folder structure
# ------------------------------------------------------------
Write-Host "[1/5] Creating src/ folder structure..." -ForegroundColor Yellow

$folders = @(
    "src\Enums",
    "src\TableExtensions",
    "src\PageExtensions",
    "src\Codeunits",
    "src\Reports",
    "src\ReportExtensions",
    "src\ReportLayouts"
)

foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "  Created: $folder" -ForegroundColor Green
    } else {
        Write-Host "  Already exists: $folder" -ForegroundColor Gray
    }
}

# ------------------------------------------------------------
# STEP 2 — Define rename + move map
# Old path (relative to root) → New path (relative to root)
# ------------------------------------------------------------
Write-Host ""
Write-Host "[2/5] Building rename map..." -ForegroundColor Yellow

$moves = @(
    # Enums
    @{ From = "ENum\ENUM50001 - OrderHoldStatus.al";                               To = "src\Enums\Enum50001.OrderHoldStatus.al" },

    # Table Extensions — NOTE: SalesHeader fixed from duplicate 50001 → 50002
    @{ From = "Table Extensions\TABLEExt50001 - PurchaseHeaderOnHoldExtension.al"; To = "src\TableExtensions\TableExt50001.PurchaseHeaderOnHold.al" },
    @{ From = "Table Extensions\TABLEExt50001 - SalesHeaderOnHoldExtension.al";    To = "src\TableExtensions\TableExt50002.SalesHeaderOnHold.al" },

    # Page Extensions
    @{ From = "Page Extensions\PAGEExt50001 - PurchOrdExt - OnHoldStatus.al";      To = "src\PageExtensions\PageExt50001.PurchaseOrderListOnHold.al" },
    @{ From = "Page Extensions\PAGEExt50002 - PurchOrdCardExt - OnHoldStatus.al";  To = "src\PageExtensions\PageExt50002.PurchaseOrderCardOnHold.al" },
    @{ From = "Page Extensions\PAGEExt50003 - SalesOrdCardExt - OnHoldStatus.al";  To = "src\PageExtensions\PageExt50003.SalesOrderCardOnHold.al" },
    @{ From = "Page Extensions\PAGEExt50004 - SalesOrdListExt - OnHoldStatus.al";  To = "src\PageExtensions\PageExt50004.SalesOrderListOnHold.al" },
    @{ From = "Page Extensions\PAGEExt50052 - ItemCardExt-IncludeCERT.al";         To = "src\PageExtensions\PageExt50052.ItemCardCertification.al" },
    @{ From = "Page Extensions\PAGEExt50053 - ItemListExt-IncludeCERT.al";         To = "src\PageExtensions\PageExt50053.ItemListCertification.al" },

    # Codeunits
    @{ From = "Codeunits\COD50001 - Bank Rec Default Gl Mgmt.al";                  To = "src\Codeunits\Codeunit50001.BankRecDefaultGLMgmt.al" },
    @{ From = "Codeunits\COD50002.ItemCertificationValidation.al";                 To = "src\Codeunits\Codeunit50002.ItemCertificationValidation.al" },
    @{ From = "Codeunits\COD50003 - Bank Rec Insert Subscriber.al";                To = "src\Codeunits\Codeunit50003.BankRecInsertSubscriber.al" },
    @{ From = "Codeunits\COD50004 - On Hold Status Block.al";                      To = "src\Codeunits\Codeunit50004.OnHoldStatusBlock.al" },

    # Reports
    @{ From = "Reports\Rep50000-UpdateBinUOM.al";                                  To = "src\Reports\Report50000.UpdateBinUOM.al" },
    @{ From = "Reports\Rep50001-UpdateBinUOM_WordLayout.al";                       To = "src\Reports\Report50001.UpdateBinUOMWordLayout.al" },
    @{ From = "Reports\Rep50002-DeliveryDocketReport.al";                          To = "src\Reports\Report50002.DeliveryDocketReport.al" },

    # Report Extensions — NOTE: ID fixed from 5001 → 50001
    @{ From = "Report Extensions\REPEXT5001 - Transfer Balance To GL.al";          To = "src\ReportExtensions\ReportExt50001.TransferBalanceToGL.al" },

    # Report Layouts (Word docs)
    @{ From = "Reports\Report Layouts\SunsynkWord.docx";                           To = "src\ReportLayouts\SunsynkWord.docx" },
    @{ From = "Reports\Report Layouts\UOMUpdatePreview.docx";                      To = "src\ReportLayouts\UOMUpdatePreview.docx" }
)

Write-Host "  $($moves.Count) files mapped." -ForegroundColor Green

# ------------------------------------------------------------
# STEP 3 — DRY RUN: Preview all moves before doing anything
# ------------------------------------------------------------
Write-Host ""
Write-Host "[3/5] DRY RUN — Preview of changes:" -ForegroundColor Yellow
Write-Host ""

$errors = 0
foreach ($move in $moves) {
    $fromFull = Join-Path $root $move.From
    $toFull   = Join-Path $root $move.To
    $exists   = Test-Path $fromFull

    if ($exists) {
        Write-Host "  MOVE: $($move.From)" -ForegroundColor White
        Write-Host "    TO: $($move.To)" -ForegroundColor Green
    } else {
        Write-Host "  MISSING: $($move.From)" -ForegroundColor Red
        $errors++
    }
    Write-Host ""
}

if ($errors -gt 0) {
    Write-Host "  ⚠  $errors source file(s) not found. Review paths above before continuing." -ForegroundColor Red
}

# ------------------------------------------------------------
# STEP 4 — Confirm before executing
# ------------------------------------------------------------
Write-Host ""
$confirm = Read-Host "Proceed with renaming and moving? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host ""
    Write-Host "Aborted. No files were changed." -ForegroundColor Yellow
    exit 0
}

# ------------------------------------------------------------
# STEP 5 — Execute moves
# ------------------------------------------------------------
Write-Host ""
Write-Host "[4/5] Moving and renaming files..." -ForegroundColor Yellow

$moved   = 0
$skipped = 0

foreach ($move in $moves) {
    $fromFull = Join-Path $root $move.From
    $toFull   = Join-Path $root $move.To

    if (Test-Path $fromFull) {
        Move-Item -Path $fromFull -Destination $toFull -Force
        Write-Host "  ✓ $($move.To)" -ForegroundColor Green
        $moved++
    } else {
        Write-Host "  ✗ Skipped (not found): $($move.From)" -ForegroundColor DarkYellow
        $skipped++
    }
}

# ------------------------------------------------------------
# STEP 6 — Clean up old empty folders
# ------------------------------------------------------------
Write-Host ""
Write-Host "[5/5] Cleaning up empty old folders..." -ForegroundColor Yellow

$oldFolders = @(
    "ENum",
    "Table Extensions",
    "Page Extensions",
    "Codeunits",
    "Reports\Report Layouts",
    "Reports",
    "Report Extensions"
)

foreach ($folder in $oldFolders) {
    $path = Join-Path $root $folder
    if (Test-Path $path) {
        $remaining = Get-ChildItem -Path $path -Recurse | Measure-Object
        if ($remaining.Count -eq 0) {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "  Removed empty folder: $folder" -ForegroundColor Green
        } else {
            Write-Host "  Skipped (not empty): $folder — check manually" -ForegroundColor DarkYellow
        }
    }
}

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Done." -ForegroundColor Cyan
Write-Host "  Files moved:   $moved" -ForegroundColor Green
Write-Host "  Files skipped: $skipped" -ForegroundColor DarkYellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Open VS Code and verify the src/ structure looks correct" -ForegroundColor Gray
Write-Host "  2. Update app.json if it references specific file paths" -ForegroundColor Gray
Write-Host "  3. Run AL: Publish (F5) to confirm no compile errors" -ForegroundColor Gray
Write-Host "  4. git add -A && git commit -m 'refactor: restructure project to AL best practices'" -ForegroundColor Gray
Write-Host ""
