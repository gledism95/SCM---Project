pageextension 50005 "ItemCardExt_Certification" extends "Item Card"
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
                begin
                    Page.Run(Page::ItemCertificationList);
                end;
            }
        }
    }



}
