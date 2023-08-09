unit BFA.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Generics.Collections;

procedure CreateFrame;
procedure fnGoFrame(FFrom, FGo : String; FIsBack : Boolean = False);
procedure fnBack(FProc : TProc = nil);

implementation

uses frHome, frLoading, frLogin, BFA.Env, BFA.GoFrame, frMain, frDetail,
  frProduct, frTransaction;

procedure CreateFrame;
begin
  FLoading := TFLoading(FLoading.CallFrame(FMain.loFrame, TFLoading, C_LOADING));
  FLogin := TFLogin(FLogin.CallFrame(FMain.loFrame, TFLogin, C_LOGIN));
  FHome := TFHome(FHome.CallFrame(FMain.loFrame, TFHome, C_HOME));
  FDetail := TFDetail(FDetail.CallFrame(FMain.loFrame, TFDetail, C_DETAIL));

  FTransaction := TFTransaction(FTransaction.CallFrame(FMain.loFrame, TFTransaction, C_TRANSACTION));
  FProduct := TFProduct(FProduct.CallFrame(FMain.loFrame, TFProduct, C_PRODUCT));

  LListFrame.HideAll;
end;

procedure fnGoFrame(FFrom, FGo : String; FIsBack : Boolean = False);
begin
  if not Assigned(FListGo) then
    FListGo := TStringList.Create;

  if not Assigned(LListFrame.getFrame(FGo)) then begin
    ShowMessage('Sorry, Something wrong');
    Exit;
  end;

  goFrame := FGo;
  fromFrame := FFrom;

  if not FIsBack then
    FListGo.Add(goFrame);

  FTabCount := 0;

  LListFrame.Show(goFrame);
  if Assigned(LListFrame.getFrame(fromFrame)) then
    LListFrame.getFrame(fromFrame).Visible := False;
end;

procedure fnBack(FProc : TProc = nil);
begin
  if goFrame = C_LOADING then begin
    Exit;
  end else begin
    if (goFrame = C_LOGIN) OR (goFrame = C_HOME) then begin
      if FTabCount <= 1 then begin
        ShowMessage('Tap 2x for exit application');
      end else begin
        Application.Terminate;
      end;

      Inc(FTabCount);
      Exit;
    end;
  end;

  if Assigned(FProc) then begin
    FProc;
  end;

  fnGoFrame(FListGo[FListGo.Count - 1], FListGo[FListGo.Count - 2], True);
  FListGo.Delete(FListGo.Count - 1);

end;

end.
