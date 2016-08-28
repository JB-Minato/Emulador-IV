unit Azit;

interface
uses Player ,Windows;
Type
  TAzit = Class
  Public
    procedure enterAgit(Player: TPlayer);
  End;

implementation
uses Globaldefs;
 
 procedure TAzit.enterAgit(Player: TPlayer);
  Begin
    with Player.Buffer do Begin
      Write(Prefix);
      WriteCD(DWORD(SVPID_ENTERAGIT));
      Write(#$AF#$FA#$BE#$69#$55#$1F#$E4#$BC#$81#$E6#$2D#$C6#$E9#$BC#$38#$28+
            #$AE#$77#$3C#$42#$2E#$28#$ED#$57#$AF#$4A#$7F#$83#$43#$17#$46#$CC+
            #$07#$AE#$9B#$04#$01#$09#$CE#$FD);
      WriteCd(Dword(Player.Socket.RemoteAddr.sin_addr.S_addr));
      Write(#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00#$00#$00#$00#$01);
      WriteCd(Dword(UDP_RELAYIP));
      WriteCw(Word(UDP_RELAYPORT));
      WriteCd(Dword(TCP_RELAYIP));
      WriteCw(Word(TCP_RELAYPORT));
      Write(#$01#$00#$01#$00#$00#$01#$2C#$00#$00#$00#$14#$00#$02#$4B#$52#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
            #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
            #$06#$01#$00#$00#$00#$00);
      Compress;
      Encrypt(GenerateIV(0),Random($FF));
      ClearPacket();
    end;
  Player.Send;
    End;

end.
