page 50001 ItemCertificationList
{
    Caption = 'Item Certification List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ItemCountryCertification;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Item No"; Rec."Item No")
                {
                    Caption = 'Item No.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    Caption = 'Country Code';
                }
                field("Certified for Purchase"; Rec."Certified for Purchase")
                {
                    Caption = 'Certified for Purchase';
                }
                field("Certified for Sale"; Rec."Certified for Sale")
                {
                    Caption = 'Certified for Sales';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}