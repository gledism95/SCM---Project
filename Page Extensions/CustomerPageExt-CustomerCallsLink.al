
pageextension 50050 "CustomerExt" extends "Customer Card"
{
    actions
    {
        addbefore("&Customer")

        {

            action(ServiceCalls)

            {

                ApplicationArea = all;

                Image = NewProperties;

                Caption = 'Service Calls';

                RunObject = page 50000;
            }
        }
    }
}