unit unitTranslate;

{
     Copyright (C) 2007-2010 by Thomas Dieffenbach
     giantics@gmx.de

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the
     Free Software Foundation, Inc.,
     59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, ComCtrls, menus, gettext, translations, forms;
  
procedure TranslateAll;

implementation

uses unitMain, unitConsoleOutput, unitGainConstant, unitInfo, UnitOptions;

procedure PassComponents(po: TPOFile; aComponent: TComponent);
var
  i: Integer;
  comp: TComponent;
begin
  //if (aComponent is TForm) and (not (aComponent = frmMP3GainMain)) then
  //  TForm(aComponent).Caption := po.Translate(TForm(comp).Caption, TForm(comp).Caption);
  for i:=0 to aComponent.ComponentCount-1 do
  begin
    comp := aComponent.Components[i];
    if comp is TControl then
    begin
      TControl(comp).Caption := po.Translate(TControl(comp).Caption, TControl(comp).Caption);
      TControl(comp).Hint    := po.Translate(TControl(comp).Hint   , TControl(comp).Hint);
    end;
    if comp is TMenuItem then
      TMenuItem(comp).Caption := po.Translate(TMenuItem(comp).Caption, TMenuItem(comp).Caption);
    (*if comp is TListView then
      for k:=0 to TListView(comp).Columns.Count-1 do
        TListView(comp).Columns[k].Caption :=
          po.Translate(TListView(comp).Columns[k].Caption, TListView(comp).Columns[k].Caption);*)
    PassComponents(po, aComponent.Components[i]);
  end;
end;

procedure TranslateAll;
var
  PODirectory, Lang, FallbackLang: String;
  po: TPOFile;
  PoFile: TStringList;
  k,p,cFound: Integer;
  S: String;
begin
  PODirectory := strBinDir + 'lang/';    // change that for release
  //Application.MessageBox(PChar(PODirectory),PChar('a'),0);
  GetLanguageIDs(Lang, FallbackLang); // in unit gettext
  TranslateUnitResourceStrings('UnitMain', PODirectory + 'easymp3gain.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('UnitMediaGain', PODirectory + 'easymp3gain.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('UnitGainConstant', PODirectory + 'easymp3gain.%s.po', Lang, FallbackLang);
  strLang := FallbackLang;
  if FileExists(PODirectory+'easymp3gain.'+FallbackLang+'.po') then
  begin
    po := TPOFile.Create(PODirectory+'easymp3gain.'+FallbackLang+'.po');
    try
      PassComponents(po,frmMP3GainMain);
      PassComponents(po,frmMP3GainConstant);
      PassComponents(po,frmMP3GainConsoleOutput);
      PassComponents(po,frmMP3GainGUIInfo);
      PassComponents(po,frmMP3GainOptions);
    finally
      po.Free;
    end;

    PoFile := TStringList.Create;
    PoFile.LoadFromFile(PODirectory+'easymp3gain.'+FallbackLang+'.po');
    cFound:=0;
    for k:=0 to PoFile.Count-1 do
    begin
       p := Pos('Translator:',PoFile[k]);  // Read translator out of po-file
       if (p>0) then
       begin
         S := Copy(PoFile[k],p+11,Length(PoFile[k])-(p+11-1));
         if S[Length(S)]='"' then S := Copy(S,1,Length(S)-1);
         if Copy(S,Length(S)-1,2)='\n' then S := Copy(S,1,Length(S)-2);
         frmMP3GainGUIInfo.MemoTranslation.Text := Trim(S);
         inc(cFound);
       end;
       (*p := Pos('Language-Team:',PoFile[k]);  // Read translation out of po-file
       if (p>0) then
       begin
         S := Copy(PoFile[k],p+14,Length(PoFile[k])-(p+14-1));
         if S[Length(S)]='"' then S := Copy(S,1,Length(S)-1);
         if Copy(S,Length(S)-1,2)='\n' then S := Copy(S,1,Length(S)-2);
         frmMP3GainGUIInfo.MemoTranslation.Lines.Add('('+Trim(S)+')');
         inc(cFound);
       end;*)
       if (cFound=1) then break;
    end;
    PoFile.Free;
  end;
end;

end.

