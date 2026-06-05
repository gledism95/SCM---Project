// codeunit 50201 "Item Certification Validation"
// {
//     [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
//     local procedure SalesLineAfterValidate(var Rec: Record "Sales Line")
//     var
//         Customer: Record Customer;
//         CertRec: Record Item_Ctr_CertSOD;
//         CountryCode: Code[10];
//     begin

//         if Rec."No." = '' then
//             exit;

//         if Customer.Get(Rec."Sell-to Customer No.")
//         then
//             CountryCode := Customer."Country/Region Code";

//         if Customer."Country/Region Code" = '' then
//             exit;


//         CertRec.SetRange(Item_No, Rec."No.");
//         CertRec.SetRange(Country, CountryCode);

//         If not CertRec.FindFirst() then
//             Error('Item %1 has no certification record for country/region %2. It must be explicitly certified before use on a sales line.', Rec."No.", CountryCode);

//         If not CertRec.Certified_for_Sale then
//             Error('Item %1 is not certified for sale for country/region %2.', Rec."No.", CountryCode);

//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, 'No.', false, false)]
//     local procedure PurchaseLineAfterValidate(var Rec: Record "Purchase Line")
//     var
//         Vendor: Record Vendor;
//         CertRec: Record Item_Ctr_CertSOD;
//         CountryCode: Code[10];
//     begin

//         if Rec."No." = '' then
//             exit;

//         if Vendor.Get(Rec."Buy-from Vendor No.")
//         then
//             CountryCode := Vendor."Country/Region Code";

//         if Vendor."Country/Region Code" = '' then
//             exit;


//         CertRec.SetRange(Item_No, Rec."No.");
//         CertRec.SetRange(Country, CountryCode);

//         If not CertRec.FindFirst() then
//             Error('Item %1 has no certification record for country/region %2. It must be explicitly certified before use on a purchase line.', Rec."No.", CountryCode);

//         If not CertRec.Certified_for_Purch then
//             Error('Item %1 is not certified for purchase for country/region %2.', Rec."No.", CountryCode);

//     end;

//     [EventSubscriber(ObjectType::Table, Database::Item, OnAfterInsertEvent, '', false, false)]
//     local procedure Item_OnAfterInsert(var Rec: Record Item)
//     var
//         CertRec: Record Item_Ctr_CertSOD;
//     begin
//         CertRec.Init();
//         CertRec.Item_No := Rec."No.";
//         CertRec.Insert(true);
//     end;
// }