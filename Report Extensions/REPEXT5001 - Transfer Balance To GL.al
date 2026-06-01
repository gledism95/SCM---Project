reportextension 50001 "Trans. Bank Rec Ext" extends "Trans. Bank Rec. to Gen. Jnl."
{

    requestpage
    {
        layout
        {
            addlast(content)
            {
                group(DefaultPosting)
                {
                    Caption = 'Default G/L Acc Posting';
                    field(DefaultGlAccount; DefaultGlAccount)
                    {
                        ApplicationArea = All;
                        Caption = 'Default G/L Account';
                        TableRelation = "G/L Account"."No." where(
                            "Account Type" = const(Posting),
                            "Direct Posting" = const(true));
                        ToolTip = 'Specifies the G/L account used as default account on every generated journal line.';
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    var
        DefaultAccMgmt: Codeunit "Bank Rec Default Gl Mgmt";
    begin
        DefaultAccMgmt.SetDefaultGl(DefaultGlAccount);
    end;

    var
        DefaultGlAccount: Code[20];
}