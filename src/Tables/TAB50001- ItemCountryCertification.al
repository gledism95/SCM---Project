table 50001 ItemCountryCertification
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Item No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'The Item No to be inserted in the certification list';
            TableRelation = Item;
        }
        field(3; "Country Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'The country and region in the certification list';
            TableRelation = "Country/Region";
        }

        field(4; "Certified for Sale"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Shows if the item is certified for sale in this country';
        }
        field(5; "Certified for Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Shows if the item is certified for purchase in this country';
        }
    }

    keys
    {
        key(Key1; "Item No", "Country Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
    // ItemList: Record "Item";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}