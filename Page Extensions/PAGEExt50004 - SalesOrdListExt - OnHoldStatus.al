pageextension 50004 "SalesOrdListExt" extends "Sales Order List"
{
    layout
    {
        addafter(Status)
        {
            field("Order Hold Status"; Rec."Order Hold Status")
            {
                Caption = 'Order Hold Status';
                ApplicationArea = Suite;
                StyleExpr = OrderHoldStyleExpr;
                Editable = false;
            }
        }
    }

    actions
    {
        addbefore(Release)
        {
            group(OnHold)
            {
                Caption = 'On Hold';
                action(SetOnHold)
                {
                    Caption = 'Set on Hold';
                    ApplicationArea = Suite;
                    Image = Lock;
                    ToolTip = 'Set the sales order on hold and block processing.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Enabled = IsEditable;

                    trigger OnAction()
                    begin
                        Rec."Order Hold Status" := Rec."Order Hold Status"::"On Hold";
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                }
                action(ReopenRecord)
                {
                    Caption = 'Reopen From Hold';
                    ApplicationArea = Suite;
                    Image = ReOpen;
                    ToolTip = 'Set the sales order as open and allows proccessing.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Enabled = IsOnHold;

                    trigger OnAction()
                    begin
                        Rec."Order Hold Status" := Rec."Order Hold Status"::Open;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetVariables();
        case
            Rec."Order Hold Status" of
            Rec."Order Hold Status"::Open:
                OrderHoldStyleExpr := 'StrongAccent';
        end;
        case
            Rec."Order Hold Status" of
            Rec."Order Hold Status"::"On Hold":
                OrderHoldStyleExpr := 'Attention';
        end;
    end;

    local procedure SetVariables()
    begin
        IsEditable := (Rec.Status = Rec.Status::Open) and (Rec."Order Hold Status" <> Rec."Order Hold Status"::"On Hold");
        IsOnHold := (Rec.Status = Rec.Status::Open) and (Rec."Order Hold Status" = Rec."Order Hold Status"::"On Hold");
    end;

    var
        OrderHoldStyleExpr: Text;
        IsEditable: Boolean;
        IsOnHold: Boolean;
}