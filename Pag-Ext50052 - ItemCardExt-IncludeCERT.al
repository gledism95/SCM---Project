// Extension to Item Card
pageextension 50052 "ItemCardExt_Certification" extends "Item Card"
{

    layout
    {
        addlast(InventoryGrp) // You can choose another FastTab or group if preferred
        {
            field(Intent; Rec.Intent)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the intent of the item (e.g., Resale, Pre-Production, R&D).';
            }
        }
    }

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
                begin
                    // Placeholder: Open certification list page
                    // Replace "Item Certification List" with your actual page name/ID
                    Page.Run(Page::Item_Ctr_CertList);
                end;
            }
        }
    }



}