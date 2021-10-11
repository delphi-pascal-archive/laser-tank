(*******************************************************
 **             Laser Tank ver 3.1.8                  **
 **               By Jim Kindley                      **
 **               (c) 1998, 1997, 1996                **
 **                  Sound Unit                       **
 *******************************************************
 **                                                   **
 ** Ported to Delphi 3 by  :                          **
 ** Dominique Louis <Dominique@SavageSoftware.com.au> **
 ** On July 26, 2001 .                                **
 **                                                   **
 *******************************************************)

 { All Sounds are Wav files loaded into the lt_sfx.res resource file.
   I created a new type of resource in the resource workshop, called "wSound".
   Then you can compile the wave files into the resource
}
unit lt_sfx;

interface

{$R lt_sfx.res}

uses
  Windows,
  MMSystem;

const
  MaxSounds = 20; { the maximum number of Sounds }
  snd_NoStop = $0010; { don't stop any currently playing sound }
  ResTypeName = 'WSOUND';


var
  SFx: array[1..MaxSounds] of THandle;
  LastSFWord: word = 0;
  SFXError: Word = 0;
  Sound_On: Boolean = true; { true when Sound is On }

procedure SoundPlay(sn: word); { SoundPlay(5) Play sound 5 }
procedure SFxInit; { Load all sounds }
procedure SoundKill; { This Unloads All Data }

implementation

procedure SoundPlay(sn: Word);
var
  p: pointer;
begin
  if not Sound_On then
    exit;
  p := LockResource(SFx[sn]);
  sndplaySound(p, SND_ASYNC or SND_MEMORY ); { 5 = memory & async }
  UnLockResource(SFx[sn]);
end;

procedure SoundLoad(S: pChar);
var
  h: Thandle;
begin
  h := LoadResource(hInstance, FindResource(hInstance, s, ResTypeName ) );
  if h = 0 then
    SFXError := LastSFWord + 1
  else
  begin
    inc(LastSFWord);
    SFx[LastSFWord] := h; { put resource handle in Sound Array }
  end;
end;

procedure SFxInit;
begin
  SoundLoad('EXPLOS');
  SoundLoad('LASER');
  SoundLoad('MOVE');
  SoundLoad('PING');
  SoundLoad('MOVET');
  SoundLoad('ENDLEV');
  SoundLoad('DIE');
  if SFXError <> 0 then
    messagebox(0, 'Loading Error', 'Error', mb_ok);
end;

procedure SoundKill;
{ run this to release all the memory used to store the sounds }
var
  i: word;
begin
  for i := 1 to LastSFWord do
    FreeResource(SFx[i]);
  LastSFWord := 0;
end;

end.
