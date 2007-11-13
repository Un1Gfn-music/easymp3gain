program easymp3gain;

{
     Copyright (C) 2007 by Thomas Dieffenbach
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

uses
  {$IFDEF UNIX}{_$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{_$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, Unitmain, unitinfo, UnitMP3Gain, unitgainconstant;

begin
  Application.Initialize;
  Application.CreateForm(TfrmMp3GainGUIMain, frmMp3GainGUIMain);
  Application.CreateForm(TfrmMP3GainGUIInfo, frmMP3GainGUIInfo);
  Application.CreateForm(TfrmMP3GainConstant, frmMP3GainConstant);
  frmMP3GainGUIMain.Init;
  Application.Run;
end.
