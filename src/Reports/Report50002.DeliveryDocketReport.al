report 50202 "Delivery Docket"
{
    DefaultRenderingLayout = SunsynkWord;
    //SunsynkWord = 'Reports\Report Layouts\SunsynkWord.docx';
    ApplicationArea = Warehouse;
    Caption = 'Delivery Docket';
    UsageCategory = ReportsAndAnalysis;
    WordMergeDataItem = "Warehouse Shipment Header";

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Document Status", "Location Code";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(WhseShipmentLineCaption; "Warehouse Shipment Line".TableCaption + ':' + WhseShipmentLine)
            {
            }
            column(WhseShipmentLine; WhseShipmentLine)
            {
            }
            column(No_WhseShipmentHeader; "No.")
            {
            }
            column(WarehouseShipmentStatusCaption; WarehouseShipmentStatusCaptionLbl)
            {
            }
            column(CurrReportPAGENOCaption; CurrReportPAGENOCaptionLbl)
            {
            }
            column(ShipmentMethod; "Shipment Method Code")
            {
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(PONumber; "External Document No.")
            {
            }
            column(DocumentStatusHeader; "Document Status")
            {
            }
            column(CustomerNo; CustomerNo)
            {
                Caption = 'Customer No.';
            }
            column(CustomerName; CustomerName)
            {
                Caption = 'Customer Name';
            }
            column(ShipToName; ShipToName)
            {
                Caption = 'Ship-to Name';
            }
            column(ShipToAddress; ShipToAddress)
            {
                Caption = 'Ship-to Address';
            }
            column(ShipToAddress2; ShipToAddress2)
            {
                Caption = 'Ship-to Address 2';
            }
            column(ShipToCity; ShipToCity)
            {
                Caption = 'Ship-to City';
            }
            column(ShipToPostCode; ShipToPostCode)
            {
                Caption = 'Ship-to Post Code';
            }
            column(ShipToCountry; ShipToCountry)
            {
                Caption = 'Ship-to Country';
            }
            dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.")
                                    where("Source Type" = const(37));//We are looking only for sales lines
                RequestFilterFields = Status;
                column(LocCode_WhseShipmentLine; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(No_WarehouseShipmentLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(DocStatus_WhseShipmentHdr; "Warehouse Shipment Header"."Document Status")
                {
                    IncludeCaption = true;
                }
                column(LocationBinMandatory; Location."Bin Mandatory")
                {
                }
                column(SourceNo_WhseShipmentLine; "Source No.")
                {
                    IncludeCaption = true;
                }
                column(SourceDoc_WhseShptLine; "Source Document")
                {
                    IncludeCaption = true;
                }
                column(BinCode_WhseShipmentLine; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(ZoneCode_WhseShipmentLine; "Zone Code")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_WhseShipmentLine; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription; "Description")
                {
                    IncludeCaption = true;
                }
                column(Quantity_WhseShipmentLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(UOMCode_WhseShipmentLine; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(QtyperUOM_WhseShptLine; "Qty. per Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(Status_WhseShipmentLine; Status)
                {
                    IncludeCaption = true;
                }
                column(QtytoShip_WhseShipmentLine; "Qty. to Ship")
                {
                    IncludeCaption = true;
                }
                column(QtyShipped_WhseShptLine; "Qty. Shipped")
                {
                    IncludeCaption = true;
                }
                column(QtyOutstdg_WhseShptLine; "Qty. Outstanding")
                {
                    IncludeCaption = true;
                }
                column(ShelfNo_WhseShipmentLine; "Shelf No.")
                {
                    IncludeCaption = true;
                }

                column(QtyPicked; "Qty. Picked")
                {
                    Caption = 'Qty. Picked';
                }
                dataitem(WhseItemTrackingLine; "Whse. Item Tracking Line")
                {
                    DataItemLink =
                        "Source Type" = field("Source Type"),
                        "Source Subtype" = field("Source Subtype"),
                        "Source ID" = field("Source No."),
                        "Source Ref. No." = field("Source Line No.");
                    DataItemTableView = sorting(
                        "Source ID", "Source Type", "Source Subtype", "Source Ref. No.");

                    column(SerialNo; "Serial No.")
                    {
                        Caption = 'Serial No.';
                    }
                    column(LotNo; "Lot No.")
                    {
                        Caption = 'Lot No.';
                    }
                    column(TrackingQty; "Quantity (Base)")
                    {
                        Caption = 'Tracking Qty.';
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    this.GetLocation("Location Code");

                    if SalesHeader.Get(SalesHeader."Document Type"::Order, "Source No.") then begin
                        CustomerNo := SalesHeader."Sell-to Customer No.";
                        CustomerName := SalesHeader."Sell-to Customer Name";
                        ShipToName := SalesHeader."Ship-to Name";
                        ShipToAddress := SalesHeader."Ship-to Address";
                        ShipToAddress2 := SalesHeader."Ship-to Address 2";
                        ShipToCity := SalesHeader."Ship-to City";
                        ShipToPostCode := SalesHeader."Ship-to Post Code";
                        ShipToCountry := SalesHeader."Ship-to Country/Region Code";
                    end
                    else begin
                        CustomerNo := '';
                        CustomerName := '';
                        ShipToName := '';
                        ShipToAddress := '';
                        ShipToAddress2 := '';
                        ShipToCity := '';
                        ShipToPostCode := '';
                        ShipToCountry := '';
                    end;
                end;
            }
        }
    }

    requestpage
    {
        Caption = 'Delivery Docket';
        AboutTitle = 'Delivery Docket Status';
        AboutText = 'Post-pick warehouse delivery docket showing confirmed picked quantities, customer PO, and SOR number.';
    }
    rendering
    {
        layout(SunsynkWord)
        {
            Type = Word;
            LayoutFile = 'Reports\Report Layouts\SunsynkWord.docx';
            Caption = 'SunSynk Delivery Docket (Word)';
            Summary = 'Post-pick warehouse delivery docket showing confirmed picked quantities, serial numbers, customer PO, and SOR number.';
        }

    }



    trigger OnPreReport()
    begin
        WhseShipmentLine := "Warehouse Shipment Line".GetFilters();
    end;

    var
        Location: Record Location;
        WhseShipmentLine: Text;
        WarehouseShipmentStatusCaptionLbl: Label 'Warehouse Shipment Status';
        CurrReportPAGENOCaptionLbl: Label 'Page';


    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    //-- Variable declaration for Sales Header and required fields
    var
        SalesHeader: Record "Sales Header";
        CustomerNo: Code[20];
        CustomerName: Text[100];
        ShipToName: Text[100];
        ShipToAddress: Text[100];
        ShipToAddress2: Text[50];
        ShipToCity: Text[30];
        ShipToPostCode: Code[20];
        ShipToCountry: Code[10];
    //SalesOrderNo   : Code[20];

}

