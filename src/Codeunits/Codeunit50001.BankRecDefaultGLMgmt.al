codeunit 50001 "Bank Rec Default Gl Mgmt"
{
    SingleInstance = true;

    var
        DefaultGlAccount: Code[20];

    procedure SetDefaultGl(AccountNo: Code[20])
    begin
        DefaultGlAccount := AccountNo;
    end;

    procedure GetDefaultGl(): Code[20]
    begin
        exit(DefaultGlAccount);
    end;


}