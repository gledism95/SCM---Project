report 50000 "Update Bin UOM"
{
    ApplicationArea = All;
    Caption = 'Update Bin UOM';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    Permissions =
    tabledata "Warehouse Entry" = rmid,
    tabledata "Item Ledger Entry" = rmid,
    tabledata "Bin Content" = rmid;
    dataset
    {
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

                // PREVIEW MODE → Do NOT update anything
                if PreviewMode then
                    exit;

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
                        ToolTip = 'If enabled, no changes will be applied. Only simulated.';
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

    trigger OnPreReport()
    begin
        UpdatedWhseEntries := 0;
        UpdatedBinContents := 0;
    end;

    trigger OnPostReport()
    begin
        if not PreviewMode then
            Message(
                'Update complete.\Warehouse Entries updated: %1\Bin Contents updated: %2\Item Ledger Entries updated: %3',
                UpdatedWhseEntries,
                UpdatedBinContents,
                UpdatedItemLedgEntries
            );
    end;

    var
        NewUOM: Code[10];
        PreviewMode: Boolean;
        ItemFilter: Text[250];
        UpdatedWhseEntries: Integer;
        UpdatedBinContents: Integer;
        UpdatedItemLedgEntries: Integer;

}

