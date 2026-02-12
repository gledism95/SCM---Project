pageextension 50051 CustomerListExt extends "Customer List"
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