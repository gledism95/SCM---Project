tableextension 50001 PurchaseOrder extends "Purchase Header"
{
    fields
    {
        field(50001; "Order Hold Status"; Enum "Order Hold Status")
        {
            Caption = 'Order Hold Status';
            ToolTip = 'Specifies whether the record is on hold or open';
            Editable = false;
        }

    }

}