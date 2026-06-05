codeunit 50004 "On-Hold Status Post Block"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure CheckBeforePosting(var PurchaseHeader: Record "Purchase Header")
    begin
        CheckOnHoldPurch(PurchaseHeader, 'posted');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure CheckBeforeRelease(var PurchaseHeader: Record "Purchase Header")
    begin
        CheckOnHoldPurch(PurchaseHeader, 'released');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CheckBeforeSalesPosting(var SalesHeader: Record "Sales Header")
    begin
        CheckOnHoldSales(SalesHeader, 'posted');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure CheckBeforeSalesRelease(var SalesHeader: Record "Sales Header")
    begin
        CheckOnHoldSales(SalesHeader, 'released');
    end;

    local procedure CheckOnHoldPurch(PurchaseHeader: Record "Purchase Header"; Action: Text[240])
    begin
        if PurchaseHeader."Order Hold Status" = PurchaseHeader."Order Hold Status"::"On Hold" then
            Error('Document %1 cannot be %2 as it is currently On Hold', PurchaseHeader."No.", Action);
    end;

    local procedure CheckOnHoldSales(SalesHeader: Record "Sales Header"; Action: Text[240])
    begin
        if SalesHeader."Order Hold Status" = SalesHeader."Order Hold Status"::"On Hold" then
            Error('Document %1 cannot be %2 as it is currently On Hold', SalesHeader."No.", Action);
    end;

}