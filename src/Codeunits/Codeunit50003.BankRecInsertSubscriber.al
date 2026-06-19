codeunit 50003 "Bank Rec Insert Subscriber"
{
    [EventSubscriber(ObjectType::Report, Report::"Trans. Bank Rec. to Gen. Jnl.", 'OnBeforeGenJnlLineInsert', '', false, false)]
    local procedure StampDefGlAccount(
        var
            GenJournalLine: Record "Gen. Journal Line";
            BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        DefaultAccMgmt: Codeunit "Bank Rec Default Gl Mgmt";
        DefaultGlAcc: Code[20];

    begin
        DefaultGlAcc := DefaultAccMgmt.GetDefaultGl();
        if DefaultGlAcc = ''
        then
            exit;

        if GenJournalLine."Account No." = '' then begin
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            GenJournalLine.Validate("Account No.", DefaultGlAcc);
        end;
    end;
}