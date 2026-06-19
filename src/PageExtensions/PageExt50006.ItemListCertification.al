pageextension 50006 "ItemListExt_Certification" extends "Item List"
{
    actions
    {
        addlast(Functions)
        {
            action(ItemCertificationList)
            {
                ApplicationArea = All;
                Caption = 'Item/Country Certification List';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemCertRec: Record ItemCountryCertification;
                begin
                    ItemCertRec.SetRange("Item No", Rec."No.");
                    Page.Run(Page::ItemCertificationList, ItemCertRec);
                end;
            }
        }
    }
}
