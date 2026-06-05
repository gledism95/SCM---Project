pageextension 50002 PurchOrdCardExt extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field(OrderHoldStatus; Rec."Order Hold Status")
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
            group(OnHoldGroup)
            {
                Caption = 'On Hold';

                action(SetOnHold)
                {
                    ApplicationArea = Suite;
                    Caption = 'Set On Hold';
                    Image = Lock;
                    ToolTip = 'Set the purchase order on hold and block processing.';
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
                    ApplicationArea = Suite;
                    Caption = 'Reopen From Hold';
                    Image = ReOpen;
                    ToolTip = 'Set the purchase order as open and allows posting';
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
        case Rec."Order Hold Status" of
            Rec."Order Hold Status"::Open:
                OrderHoldStyleExpr := 'StrongAccent';
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