report 50001 "Update Bin UOM - Preview Mode"
{
    ApplicationArea = All;
    Caption = 'Update Bin UOM - Preview Mode';
    UsageCategory = ReportsAndAnalysis;
    // ========== MODIFIED: Changed to support Word layout ==========
    ProcessingOnly = false;
    DefaultRenderingLayout = PreviewLayout;
    // ===============================================================
    Permissions =
    tabledata "Warehouse Entry" = rmid,
    tabledata "Item Ledger Entry" = rmid,
    tabledata "Bin Content" = rmid;

    dataset
    {
        // ========== ADDED: Preview Summary ==========
        dataitem(PreviewHeader; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportTitle; 'UOM Update Preview Report') { }
            column(PreviewNote; 'NO CHANGES HAVE BEEN APPLIED - This is a preview only') { }
            column(NewUOMCode; NewUOM) { }
            column(IsPreviewMode; PreviewMode) { }
            column(SummaryWhseCount; PreviewWhseCount) { }
            column(SummaryILECount; PreviewILECount) { }
            column(SummaryBCCount; PreviewBCCount) { }
            column(SummaryTotalCount; PreviewWhseCount + PreviewILECount + PreviewBCCount) { }

            trigger OnPreDataItem()
            begin
                if not PreviewMode then
                    CurrReport.Break();
            end;
        }
        // ============================================

        dataitem(BinContent; "Bin Content")
        {
            RequestFilterFields =
                "Item No.",
                "Variant Code",
                "Location Code",
                "Bin Code";

            column(OldUOM; "Unit of Measure Code") { }
            column(NewUOMDisplay; NewUOM) { }
            column(PreviewModeDisplay; PreviewMode) { }

            trigger OnPreDataItem()
            begin
                if ItemFilter <> '' then
                    SetFilter("Item No.", ItemFilter);

                // ========== ADDED: Skip in preview mode ==========
                if PreviewMode then
                    CurrReport.Break();
                // =================================================
            end;

            trigger OnAfterGetRecord()
            var
                WhseEntry: Record "Warehouse Entry";
                ILEntry: Record "Item Ledger Entry";
                OldWhseEntryUOM: Code[10];
                OldIlLEEntryUOM: Code[10];
            begin
                OldWhseEntryUOM := WhseEntry."Unit of Measure Code";
                OldIlLEEntryUOM := ILEntry."Unit of Measure Code";

                // --- STEP 1: Update Warehouse Entries ---
                WhseEntry.SetRange("Item No.", "Item No.");
                WhseEntry.SetRange("Location Code", "Location Code");
                WhseEntry.SetRange("Bin Code", "Bin Code");
                WhseEntry.SetRange("Variant Code", "Variant Code");

                if WhseEntry.FindSet(true, false) then begin
                    repeat
                        if (WhseEntry."Unit of Measure Code" <> NewUOM) then begin
                            WhseEntry.Validate("Unit of Measure Code", NewUOM);
                            WhseEntry.Modify(true);
                            UpdatedWhseEntries := UpdatedWhseEntries + 1;
                        end;
                    until WhseEntry.Next() = 0;
                end;

                WhseEntry.Reset();
                ILEntry.Reset();
                ILEntry.SetRange("Item No.", "Item No.");
                ILEntry.SetRange("Variant Code", "Variant Code");
                if ILEntry.FindSet(true, false) then begin
                    repeat
                        if (ILEntry."Unit of Measure Code" <> NewUOM) then begin
                            ILEntry.Validate("Unit of Measure Code", NewUOM);
                            ILEntry.Modify(true);
                            UpdatedItemLedgEntries := UpdatedItemLedgEntries + 1;
                        end;
                    until ILEntry.Next() = 0;
                end;

                // --- STEP 2: Rename Bin Content (PK Change) ---
                Rename(
                    "Location Code",
                   "Bin Code",
                    "Item No.",
                  "Variant Code",
                   NewUOM
               );

                UpdatedBinContents := UpdatedBinContents + 1;
            end;
        }

        // ========== ADDED: Preview Warehouse Entries ==========
        dataitem(WarehouseEntryPreview; "Warehouse Entry")
        {
            column(WhseEntryNo; "Entry No.") { }
            column(WhseItemNo; "Item No.") { }
            column(WhseLocationCode; "Location Code") { }
            column(WhseBinCode; "Bin Code") { }
            column(WhseVariantCode; "Variant Code") { }
            column(WhseOldUOM; "Unit of Measure Code") { }
            column(WhseNewUOM; NewUOM) { }
            column(WhseTableName; 'Warehouse Entry') { }

            trigger OnPreDataItem()
            var
                BinContentLocal: Record "Bin Content";
            begin
                if not PreviewMode then
                    CurrReport.Break();

                // Apply same filters as main report
                if ItemFilter <> '' then begin
                    BinContentLocal.SetFilter("Item No.", ItemFilter);
                    if BinContentLocal.FindSet() then begin
                        repeat
                            SetFilter("Item No.", BinContentLocal."Item No.");
                            SetFilter("Location Code", BinContentLocal."Location Code");
                            SetFilter("Bin Code", BinContentLocal."Bin Code");
                            SetFilter("Variant Code", BinContentLocal."Variant Code");
                        until BinContentLocal.Next() = 0;
                    end;
                end;

                SetFilter("Unit of Measure Code", '<>%1', NewUOM);
            end;

            trigger OnAfterGetRecord()
            begin
                PreviewWhseCount += 1;
            end;
        }
        // ======================================================

        // ========== ADDED: Preview Item Ledger Entries ==========
        dataitem(ItemLedgerEntryPreview; "Item Ledger Entry")
        {
            column(ILEEntryNo; "Entry No.") { }
            column(ILEItemNo; "Item No.") { }
            column(ILELocationCode; "Location Code") { }
            column(ILEVariantCode; "Variant Code") { }
            column(ILEOldUOM; "Unit of Measure Code") { }
            column(ILENewUOM; NewUOM) { }
            column(ILETableName; 'Item Ledger Entry') { }

            trigger OnPreDataItem()
            var
                BinContentLocal: Record "Bin Content";
            begin
                if not PreviewMode then
                    CurrReport.Break();

                // Apply same filters as main report
                if ItemFilter <> '' then begin
                    BinContentLocal.SetFilter("Item No.", ItemFilter);
                    if BinContentLocal.FindSet() then begin
                        repeat
                            SetFilter("Item No.", BinContentLocal."Item No.");
                            SetFilter("Variant Code", BinContentLocal."Variant Code");
                        until BinContentLocal.Next() = 0;
                    end;
                end;

                SetFilter("Unit of Measure Code", '<>%1', NewUOM);
            end;

            trigger OnAfterGetRecord()
            begin
                PreviewILECount += 1;
            end;
        }
        // ========================================================

        // ========== ADDED: Preview Bin Content ==========
        dataitem(BinContentPreview; "Bin Content")
        {
            RequestFilterFields =
                "Item No.",
                "Variant Code",
                "Location Code",
                "Bin Code";

            column(BCItemNo; "Item No.") { }
            column(BCLocationCode; "Location Code") { }
            column(BCBinCode; "Bin Code") { }
            column(BCVariantCode; "Variant Code") { }
            column(BCOldUOM; "Unit of Measure Code") { }
            column(BCNewUOM; NewUOM) { }
            column(BCTableName; 'Bin Content') { }

            trigger OnPreDataItem()
            begin
                if not PreviewMode then
                    CurrReport.Break();

                if ItemFilter <> '' then
                    SetFilter("Item No.", ItemFilter);
            end;

            trigger OnAfterGetRecord()
            begin
                PreviewBCCount += 1;
            end;
        }
        // ================================================
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NewUOM; NewUOM)
                    {
                        Caption = 'New Unit of Measure Code';
                        TableRelation = "Unit of Measure".Code;
                        ApplicationArea = All;
                    }

                    field(PreviewMode; PreviewMode)
                    {
                        Caption = 'Preview Mode (No Changes Applied)';
                        ApplicationArea = All;
                        ToolTip = 'If enabled, no changes will be applied. A preview report will be generated.';
                    }
                }

                group("Additional Item Filters")
                {
                    field(ItemFilter; ItemFilter)
                    {
                        Caption = 'Item No. Filter (Optional)';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    // ========== ADDED: Rendering layouts ==========
    rendering
    {
        layout(PreviewLayout)
        {
            Type = Word;
            LayoutFile = 'Reports\Report Layouts\UOMUpdatePreview.docx';
            Caption = 'UOM Update Preview';
        }
    }
    // ==============================================

    trigger OnPreReport()
    begin
        UpdatedWhseEntries := 0;
        UpdatedBinContents := 0;
        UpdatedItemLedgEntries := 0;
        // ========== ADDED ==========
        PreviewWhseCount := 0;
        PreviewILECount := 0;
        PreviewBCCount := 0;
        // ===========================
    end;

    trigger OnPostReport()
    begin
        // ========== MODIFIED: Only show message when not in preview ==========
        if not PreviewMode then begin
            Message(
                'Update complete.\' +
                'Warehouse Entries updated: %1\' +
                'Bin Contents updated: %2\' +
                'Item Ledger Entries updated: %3',
                UpdatedWhseEntries,
                UpdatedBinContents,
                UpdatedItemLedgEntries
            );
        end;
        // ======================================================================
    end;

    var
        NewUOM: Code[10];
        PreviewMode: Boolean;
        ItemFilter: Text[250];
        UpdatedWhseEntries: Integer;
        UpdatedBinContents: Integer;
        UpdatedItemLedgEntries: Integer;
        // ========== ADDED: Preview counters ==========
        PreviewWhseCount: Integer;
        PreviewILECount: Integer;
        PreviewBCCount: Integer;
    // =============================================
}
