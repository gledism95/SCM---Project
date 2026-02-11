// Extension to Item List
pageextension 50053 "ItemListExt_Certification" extends "Item List"
{
    actions
    {
        addlast(Functions)
        {
            action(ItemCertificationList)
            {
                ApplicationArea = All;
                Caption = 'Item/Country Certification List';
                Image = List; // You can choose another icon if preferred
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemCertRec: Record Item_Ctr_CertSOD;
                begin
                    ItemCertRec.SetRange("Item_No", Rec."No.");
                    ; // copy the selected row in the list
                    Page.Run(Page::Item_Ctr_CertList, ItemCertRec);
                end;
            }
        }
    }
}