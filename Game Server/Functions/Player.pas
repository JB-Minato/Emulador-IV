unit Player;

interface

uses System.Win.ScktComp, System.SysUtils, CryptLib, Misc, System.StrUtils,
     Windows, Data.DB, Currencys, DBCon, AccountInfo, Characters, Inventory,
     Pets, SortUS;

type
  TPlayer = class
    Socket: TCustomWinSocket;
    Buffer: TCryptLib;
    MySQL: TQuery;
    AccInfo: TAccountInfo;
    Currency: TCurrency;
    Chars: TCharacters;
    Inventory: TInventory;
    SortUS: TSortUS;
    Pets: TPet;
    ID: Integer;
    procedure LoadLogin;
    procedure Send;
    constructor Create(Socket: TCustomWinSocket; MySQL: TQuery; SortUS: TSortUS);
    destructor Destroy; override;
  end;

implementation

uses GlobalDefs, Log;

constructor TPlayer.Create(Socket: TCustomWinSocket; MySQL: TQuery; SortUS: TSortUS);
var
  TIV, TIV2: AnsiString;
begin
  Self.Socket:=Socket;
  Self.MySQL:=MySQL;
  Self.SortUS:=SortUS;
  ID:=0;
  Buffer:=TCryptLib.Create;
  Buffer.IV:=#$C7#$D8#$C4#$BF#$B5#$E9#$C0#$FD; //IV padrão pego do main
  Buffer.IV2:=#$C0#$D3#$BD#$C3#$B7#$CE#$B8#$B8; //IV2 padrão pego do main
  TIV:=GerarCode;
  TIV2:=GerarCode;
  Buffer.Prefix:=Copy(GerarCode,1,2);
  Buffer.Count:=0;
  Buffer.BIn:='';
  with Buffer do begin
    Write(#$00#$00#$14#$E3#$00#$00#$00);
    Write(Word(SVPID_IV_SET));
    Write(Dword(Count));
    Write(Prefix);
    Write(#$00#$00#$00);
    Write(Byte(Length(TIV2)));
    Write(TIV2);
    Write(#$00#$00#$00);
    Write(Byte(Length(TIV)));
    Write(TIV);
    Write(#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00+
          #$00#$00);
    FixSize;
    Encrypt(GenerateIV(0),Random($FF));
    ClearPacket();
  end;
  Send;
  Buffer.IV:=TIV;
  Buffer.IV2:=TIV2;
  Buffer.Prefix:=AnsiString(AnsiReverseString(String(Buffer.Prefix)));
end;

destructor TPlayer.Destroy;
begin
  AccInfo.Update;
  Buffer.Free;
  inherited;
end;

procedure TPlayer.LoadLogin;
var
  Login, Senha: AnsiString;
  i, i2: Integer;
  Temp: TRInventory;
begin
  with Buffer do begin
    Login:=RS(12,RB(11));
    Senha:=RS(16+RB(11),RB(RB(11)+15));
    Server.MySQL.SetQuery('SELECT ID, LOGIN, PASS, ONLINECS, ONLINEGS FROM Users WHERE LOGIN = :Login AND PASS = :Pass');
    Server.MySQL.AddParameter('Login',Login);
    Server.MySQL.AddParameter('Pass',Senha);
    Server.MySQL.Run(1);
    if Server.MySQL.Query.IsEmpty = False then begin
      if (Server.MySQL.Query.Fields[3].AsInteger = 0) or (Server.MySQL.Query.Fields[4].AsInteger = 1) then begin
        Logger.Write(Format('Usuário já logado [Handle: %d]',[Socket.Handle]),Errors);
        Socket.Close;
        Exit;
      end;
      Logger.Write(Format('Login OK! [Handle: %d]',[Socket.Handle]),Warnings);
      //Poe GS como logado

      AccInfo:=TAccountInfo.Create(MySQL.Query.Fields[0].AsInteger,MySQL);
      Currency:=TCurrency.Create(MySQL,AccInfo);
      Chars:=TCharacters.Create(MySQL,AccInfo);
      Inventory:=TInventory.Create(MySQL,AccInfo);
      Pets:=TPet.Create(MySQL,AccInfo);

      Buffer.BIn:='';
      with Buffer do begin
        Write(Prefix);
        Write(Dword(Count));
        Write(#$04);
        Write(Word(226));
        Write(#$00#$04#$00#$00#$00#$00#$00#$55#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$64#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00+
              #$00#$F0#$00#$00#$00#$02#$00#$00#$00#$00#$00#$00#$02#$24#$00#$00#$00#$03#$00#$00#$00#$00#$00#$00#$03#$74#$00#$00#$00#$04+
              #$00#$00#$00#$00#$00#$00#$05#$96#$00#$00#$00#$05#$00#$00#$00#$00#$00#$00#$08#$0C#$00#$00#$00#$06#$00#$00#$00#$00#$00#$00+
              #$0A#$AC#$00#$00#$00#$07#$00#$00#$00#$00#$00#$00#$0D#$A0#$00#$00#$00#$08#$00#$00#$00#$00#$00#$00#$10#$BE#$00#$00#$00#$09+
              #$00#$00#$00#$00#$00#$00#$14#$30#$00#$00#$00#$0A#$00#$00#$00#$00#$00#$00#$1A#$18#$00#$00#$00#$0B#$00#$00#$00#$00#$00#$00+
              #$20#$7E#$00#$00#$00#$0C#$00#$00#$00#$00#$00#$00#$27#$A1#$00#$00#$00#$0D#$00#$00#$00#$00#$00#$00#$2F#$42#$00#$00#$00#$0E+
              #$00#$00#$00#$00#$00#$00#$37#$DF#$00#$00#$00#$0F#$00#$00#$00#$00#$00#$00#$41#$39#$00#$00#$00#$10#$00#$00#$00#$00#$00#$00+
              #$4B#$8F#$00#$00#$00#$11#$00#$00#$00#$00#$00#$00#$56#$E1#$00#$00#$00#$12#$00#$00#$00#$00#$00#$00#$63#$6E#$00#$00#$00#$13+
              #$00#$00#$00#$00#$00#$00#$71#$36#$00#$00#$00#$14#$00#$00#$00#$00#$00#$00#$80#$39#$00#$00#$00#$15#$00#$00#$00#$00#$00#$00+
              #$90#$B6#$00#$00#$00#$16#$00#$00#$00#$00#$00#$00#$A8#$FE#$00#$00#$00#$17#$00#$00#$00#$00#$00#$00#$C3#$92#$00#$00#$00#$18+
              #$00#$00#$00#$00#$00#$00#$E1#$1A#$00#$00#$00#$19#$00#$00#$00#$00#$00#$01#$01#$42#$00#$00#$00#$1A#$00#$00#$00#$00#$00#$01+
              #$24#$B2#$00#$00#$00#$1B#$00#$00#$00#$00#$00#$01#$4B#$BE#$00#$00#$00#$1C#$00#$00#$00#$00#$00#$01#$76#$BA#$00#$00#$00#$1D+
              #$00#$00#$00#$00#$00#$01#$BD#$9A#$00#$00#$00#$1E#$00#$00#$00#$00#$00#$02#$0B#$DC#$00#$00#$00#$1F#$00#$00#$00#$00#$00#$02+
              #$61#$80#$00#$00#$00#$20#$00#$00#$00#$00#$00#$02#$C0#$00#$00#$00#$00#$21#$00#$00#$00#$00#$00#$03#$27#$DA#$00#$00#$00#$22+
              #$00#$00#$00#$00#$00#$03#$9A#$0A#$00#$00#$00#$23#$00#$00#$00#$00#$00#$04#$17#$8C#$00#$00#$00#$24#$00#$00#$00#$00#$00#$04+
              #$CF#$F4#$00#$00#$00#$25#$00#$00#$00#$00#$00#$05#$9A#$BC#$00#$00#$00#$26#$00#$00#$00#$00#$00#$06#$79#$DC#$00#$00#$00#$27+
              #$00#$00#$00#$00#$00#$07#$6F#$4C#$00#$00#$00#$28#$00#$00#$00#$00#$00#$08#$7D#$04#$00#$00#$00#$29#$00#$00#$00#$00#$00#$09+
              #$A6#$4C#$00#$00#$00#$2A#$00#$00#$00#$00#$00#$0A#$ED#$1C#$00#$00#$00#$2B#$00#$00#$00#$00#$00#$0C#$54#$BC#$00#$00#$00#$2C+
              #$00#$00#$00#$00#$00#$0D#$DF#$CC#$00#$00#$00#$2D#$00#$00#$00#$00#$00#$0F#$92#$E4#$00#$00#$00#$2E#$00#$00#$00#$00#$00#$11+
              #$E8#$E6#$00#$00#$00#$2F#$00#$00#$00#$00#$00#$14#$7A#$CA#$00#$00#$00#$30#$00#$00#$00#$00#$00#$17#$4E#$4E#$00#$00#$00#$31+
              #$00#$00#$00#$00#$00#$1B#$09#$26#$00#$00#$00#$32#$00#$00#$00#$00#$00#$1F#$23#$7A#$00#$00#$00#$33#$00#$00#$00#$00#$00#$23+
              #$A7#$22#$00#$00#$00#$34#$00#$00#$00#$00#$00#$29#$71#$C4#$00#$00#$00#$35#$00#$00#$00#$00#$00#$2F#$D0#$8C#$00#$00#$00#$36+
              #$00#$00#$00#$00#$00#$39#$77#$AE#$00#$00#$00#$37#$00#$00#$00#$00#$00#$44#$17#$31#$00#$00#$00#$38#$00#$00#$00#$00#$00#$4F+
              #$C6#$D0#$00#$00#$00#$39#$00#$00#$00#$00#$00#$5C#$A1#$70#$00#$00#$00#$3A#$00#$00#$00#$00#$00#$6A#$C5#$20#$00#$00#$00#$3B+
              #$00#$00#$00#$00#$00#$7B#$DF#$8E#$00#$00#$00#$3C#$00#$00#$00#$00#$00#$8E#$B0#$86#$00#$00#$00#$3D#$00#$00#$00#$00#$00#$A3+
              #$63#$89#$00#$00#$00#$3E#$00#$00#$00#$00#$00#$BA#$27#$94#$00#$00#$00#$3F#$00#$00#$00#$00#$00#$D5#$79#$6C#$00#$00#$00#$40+
              #$00#$00#$00#$00#$00#$F3#$87#$CA#$00#$00#$00#$41#$00#$00#$00#$00#$01#$17#$58#$4B#$00#$00#$00#$42#$00#$00#$00#$00#$01#$3E+
              #$BE#$0F#$00#$00#$00#$43#$00#$00#$00#$00#$01#$6D#$68#$ED#$00#$00#$00#$44#$00#$00#$00#$00#$01#$A0#$BD#$98#$00#$00#$00#$45+
              #$00#$00#$00#$00#$01#$EE#$6C#$8C#$00#$00#$00#$46#$00#$00#$00#$00#$02#$6E#$9B#$64#$00#$00#$00#$47#$00#$00#$00#$00#$03#$13+
              #$16#$71#$00#$00#$00#$48#$00#$00#$00#$00#$03#$E1#$DE#$D9#$00#$00#$00#$49#$00#$00#$00#$00#$04#$E1#$C5#$B5#$00#$00#$00#$4A+
              #$00#$00#$00#$00#$06#$1A#$8D#$95#$00#$00#$00#$4B#$00#$00#$00#$00#$08#$A9#$93#$AA#$00#$00#$00#$4C#$00#$00#$00#$00#$0C#$ED+
              #$41#$E1#$00#$00#$00#$4D#$00#$00#$00#$00#$13#$2E#$66#$75#$00#$00#$00#$4E#$00#$00#$00#$00#$1B#$C7#$F5#$17#$00#$00#$00#$4F+
              #$00#$00#$00#$00#$28#$7E#$BD#$4F#$00#$00#$00#$50#$00#$00#$00#$00#$32#$A1#$39#$B7#$00#$00#$00#$51#$00#$00#$00#$00#$3F#$4D+
              #$08#$B0#$00#$00#$00#$52#$00#$00#$00#$00#$4F#$24#$AB#$C8#$00#$00#$00#$53#$00#$00#$00#$00#$62#$F3#$50#$2E#$00#$00#$00#$54+
              #$00#$00#$00#$00#$7B#$B6#$FC#$6C);
        FixSize;
        Encrypt(GenerateIV(0),Random($FF));
        ClearPacket();
      end;
      Send;

      Inventory.Compile(Self);

      Buffer.BIn:='';
      with Buffer do begin
        Write(Prefix);
        Write(Dword(Count));
        Write(#$00);
        Write(Word(3));
        WriteCd(Dword(Length(AccInfo.Login)*2));
        WriteZd(AccInfo.Login);
        WriteCd(Dword(Length(AccInfo.Nick)*2));
        WriteZd(AccInfo.Nick);
        Write(#$00);
        WriteCd(Dword(Currency.GP));
        Write(#$D0#$04#$06#$C0#$10#$04#$06#$FD#$01);
        WriteCd(Dword(Socket.RemoteAddr.sin_addr.S_addr));
        Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$FF#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$0D#$00#$00#$00#$00+
              #$00);
        Write(Byte(Length(Chars.Chars)));
        for i:=0 to Length(Chars.Chars)-1 do begin
          Write(Byte(Chars.Chars[i].CharID));
          Write(Byte(Chars.Chars[i].CharID));
          Write(#$00#$00#$00#$00);
          Write(Byte(Chars.Chars[i].Promotion));
          Write(#$00#$00#$00#$00#$00);
          WriteCd(Dword(Chars.Chars[i].EXP));
          Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00);
          WriteCd(Dword(Chars.Chars[i].EXP));
          Write(#$00#$00#$00);
          Write(Byte(Chars.Chars[i].Level));
          WriteCd(Dword(Length(Chars.Chars[i].Equips)));
          for i2:=0 to Length(Chars.Chars[i].Equips)-1 do begin
            WriteCd(Dword(Chars.Chars[i].Equips[i2].ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Chars.Chars[i].Equips[i2].ID));
            Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                  #$00#$00#$00#$00#$00#$00#$00#$00#$00);
          end;
          if Chars.Chars[i].Pet > 0 then
            Write(#$00#$00#$00#$01)
          else
            Write(#$00#$00#$00#$00);
          WriteCd(Dword(Chars.Chars[i].Pet));
          Write(#$00#$00#$00#$04#$00#$00#$00#$A0#$00#$00+
                #$00#$01#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$01#$9B#$00#$00#$00#$00#$00+
                #$00#$01#$9B);
          if (Chars.Chars[i].SWeapon = True) and (Chars.Chars[i].SWeaponID > 0) then begin
            Temp:=Inventory.ContainID(Chars.Chars[i].SWeaponID);
            WriteCd(Dword(Temp.ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Temp.ID));
            Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                  #$00#$00#$00#$00#$00#$00#$00#$00#$00);
          end
          else
            Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                  #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                  #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                  #$00);
          Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$01#$2C#$00#$00#$01#$2C#$00+
                #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00#$07);
        end;

          Write(#$24#$C4);
        WriteCd(Dword(AccInfo.ID));
        Write(#$00#$00#$00#$12#$52#$00#$65#$00#$62#$00#$6F#$00#$72#$00#$6E#$00#$20#$00#$56#$00#$49+
              #$00#$00#$00#$00#$01#$00#$00#$00#$01#$00#$00#$00#$DC#$52#$00#$65#$00#$66#$00#$65#$00#$72#$00#$2D#$00#$61#$00#$2D#$00#$66+
              #$00#$72#$00#$69#$00#$65#$00#$6E#$00#$64#$00#$20#$00#$69#$00#$73#$00#$20#$00#$62#$00#$61#$00#$63#$00#$6B#$00#$21#$00#$20+
              #$00#$49#$00#$6E#$00#$76#$00#$69#$00#$74#$00#$65#$00#$20#$00#$79#$00#$6F#$00#$75#$00#$72#$00#$20#$00#$66#$00#$72#$00#$69+
              #$00#$65#$00#$6E#$00#$64#$00#$73#$00#$20#$00#$61#$00#$6E#$00#$64#$00#$20#$00#$68#$00#$61#$00#$76#$00#$65#$00#$20#$00#$74+
              #$00#$68#$00#$65#$00#$6D#$00#$20#$00#$72#$00#$65#$00#$66#$00#$65#$00#$72#$00#$20#$00#$79#$00#$6F#$00#$75#$00#$20#$00#$74+
              #$00#$6F#$00#$20#$00#$77#$00#$69#$00#$6E#$00#$20#$00#$54#$00#$4F#$00#$4E#$00#$53#$00#$20#$00#$6F#$00#$66#$00#$20#$00#$46+
              #$00#$52#$00#$45#$00#$45#$00#$20#$00#$53#$00#$54#$00#$55#$00#$46#$00#$46#$00#$20#$00#$66#$00#$6F#$00#$72#$00#$20#$00#$62+
              #$00#$6F#$00#$74#$00#$68#$00#$20#$00#$6F#$00#$66#$00#$20#$00#$79#$00#$6F#$00#$75#$00#$2E#$00#$00#$00#$00#$4E#$00#$00#$00+
              #$07#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00+
              #$00#$00#$09#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0A#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$0B#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0C#$00#$00#$00#$01#$01#$01#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$0D#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0E#$00#$00#$00#$01#$01#$01#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$0F#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$10#$00#$00#$00#$01#$01+
              #$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$11#$00#$00#$00#$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$12#$00#$00#$00+
              #$01#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$13#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$14#$00+
              #$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$15#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00+
              #$16#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$17#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00+
              #$00#$00#$18#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$19#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00+
              #$00#$00#$00#$00#$1A#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$1B#$00#$00#$00#$01#$07#$01#$00#$01#$00+
              #$02#$00#$00#$00#$00#$00#$1D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$1E#$00#$00#$00#$01#$07#$01#$00#$01+
              #$00#$02#$00#$00#$00#$00#$00#$24#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$27#$00#$00#$00#$01#$03#$01+
              #$00#$00#$00#$01#$00#$00#$00#$00#$00#$28#$00#$00#$00#$01#$03#$01#$00#$00#$00#$01#$00#$00#$00#$00#$00#$29#$00#$00#$00#$01+
              #$03#$01#$00#$00#$00#$01#$00#$00#$00#$00#$00#$2A#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$2B#$00#$00+
              #$00#$01#$03#$01#$00#$00#$00#$01#$00#$00#$00#$00#$00#$2C#$00#$00#$00#$01#$03#$01#$00#$00#$00#$01#$00#$00#$00#$00#$00#$2D+
              #$00#$00#$00#$01#$03#$01#$00#$00#$00#$01#$00#$00#$00#$00#$00#$2E#$00#$00#$00#$01#$03#$01#$00#$00#$00#$01#$00#$00#$00#$00+
              #$00#$2F#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$30#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00+
              #$00#$00#$00#$31#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$32#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02+
              #$00#$00#$00#$00#$00#$33#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$34#$00#$00#$00#$01#$07#$01#$00#$01+
              #$00#$02#$00#$00#$00#$00#$00#$35#$00#$00#$00#$01#$07#$01#$00#$01#$00#$02#$00#$00#$00#$00#$00#$36#$00#$00#$00#$01#$07#$01+
              #$00#$01#$00#$02#$00#$00#$00#$00#$00#$37#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$38#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$39#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3A#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$3B#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3C#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$3D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3E#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$3F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$40#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$43#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$44#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$45#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$46#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$47#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$48#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$4A#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$4B#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$4C#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$4E#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$4F#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$50#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$51#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$52#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$53#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$54#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$55#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$56#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$57#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$58#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$59#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$5A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5B#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$5C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5D#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$00#$00#$00#$5E#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5F#$00#$00#$00#$00#$00+
              #$00#$00#$00#$00#$00#$00#$12#$F3#$76#$D3#$00#$00#$00#$0D#$00#$07#$0D#$BE#$00#$00#$00#$01#$00#$98#$96#$81#$00#$00#$00#$00+
              #$56#$76#$25#$68#$56#$74#$D3#$E8#$00#$00#$00#$00#$00#$07#$0D#$C8#$00#$00#$00#$01#$00#$98#$96#$82#$00#$00#$00#$00#$56#$76+
              #$25#$68#$56#$74#$D3#$E8#$00#$00#$00#$00#$00#$07#$0D#$D2#$00#$00#$00#$01#$00#$98#$96#$83#$00#$00#$00#$00#$56#$7B#$21#$D0+
              #$56#$79#$D0#$50#$00#$00#$00#$00#$00#$07#$0D#$DC#$00#$00#$00#$01#$00#$98#$96#$84#$00#$00#$00#$00#$56#$7B#$21#$D0#$56#$79+
              #$D0#$50#$00#$00#$00#$00#$00#$07#$19#$08#$00#$00#$00#$01#$00#$98#$96#$81#$00#$00#$00#$00#$56#$76#$25#$68#$56#$74#$D3#$E8+
              #$00#$00#$00#$00#$00#$07#$19#$12#$00#$00#$00#$01#$00#$98#$96#$82#$00#$00#$00#$00#$56#$76#$25#$68#$56#$74#$D3#$E8#$00#$00+
              #$00#$00#$00#$07#$22#$18#$00#$00#$00#$01#$00#$98#$97#$69#$00#$00#$00#$00#$56#$76#$25#$E0#$56#$74#$D4#$60#$00#$00#$00#$00+
              #$00#$07#$22#$2C#$00#$00#$00#$01#$00#$98#$97#$6B#$00#$00#$00#$00#$56#$76#$25#$E0#$56#$74#$D4#$60#$00#$00#$00#$00#$00#$07+
              #$22#$90#$00#$00#$00#$01#$00#$98#$97#$75#$00#$00#$00#$00#$56#$76#$25#$E0#$56#$74#$D4#$60#$00#$00#$00#$00#$00#$07#$24#$52+
              #$00#$00#$00#$01#$00#$98#$96#$81#$00#$00#$00#$00#$56#$76#$25#$68#$56#$74#$D3#$E8#$00#$00#$00#$00#$00#$07#$24#$5C#$00#$00+
              #$00#$01#$00#$98#$96#$82#$00#$00#$00#$00#$56#$76#$25#$68#$56#$74#$D3#$E8#$00#$00#$00#$00#$00#$07#$24#$66#$00#$00#$00#$01+
              #$00#$98#$96#$83#$00#$00#$00#$00#$56#$7B#$91#$24#$56#$7A#$3F#$A4#$00#$00#$00#$00#$00#$07#$24#$70#$00#$00#$00#$01#$00#$98+
              #$96#$84#$00#$00#$00#$00#$56#$7B#$91#$24#$56#$7A#$3F#$A4#$00#$00#$00#$00#$00#$00#$01#$18#$00#$00#$00#$00#$00#$5A#$00#$00+
              #$00#$00#$00#$80#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$18#$4D#$00#$73#$00#$67#$00#$53#$00#$65#$00#$72#$00#$76#$00+
              #$65#$00#$72#$00#$5F#$00#$30#$00#$35#$00#$00#$00#$00#$0C#$31#$32#$37#$2E#$30#$2E#$30#$2E#$31#$24#$54#$00#$00#$00#$00#$00+
              #$02#$5E#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$FF#$FF#$FF#$FF#$00#$00#$00#$0C#$31#$32#$37#$2E#$30#$2E#$30#$2E+
              #$31#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$03#$56#$76#$25#$68#$56#$7B#$91#$9C#$00#$00#$00#$00);
        WriteCd(Dword(Length(Pets.Pets)));
        for i:=0 to Length(Pets.Pets)-1 do begin
          Write(#$00#$00#$00#$01);
          WriteCd(Dword(Pets.Pets[i].ID));
          Write(#$00#$00#$00#$01);
          WriteCd(Dword(Pets.Pets[i].ID));
          WriteCd(Dword(Pets.Pets[i].ItemID));
          WriteCd(Dword(Length(Pets.Pets[i].Name)*2));
          WriteZd(Pets.Pets[i].Name);
          Write(#$00#$00#$00#$03#$00);
          WriteCd(Dword(Pets.Pets[i].EXP));
          Write(#$01#$00#$00#$00#$64#$02#$00#$00#$00#$64);
          WriteCd(Dword(Pets.Pets[i].EXP));
          WriteCd(Dword(Pets.Pets[i].Level));
          Write(Pets.Pets[i].EVO);
          if Pets.GetPetTransform(Pets.Pets[i].ItemID) = Pets.Pets[i].ItemID then
            Write(#$FF#$FF#$FF#$FF)
          else
            WriteCd(Dword(Pets.GetPetTransform(Pets.Pets[i].ItemID)));
          WriteCd(Dword(Pets.Pets[i].Health));
          WriteCd(Dword(Pets.Pets[i].Health));
          if (Pets.Pets[i].Slot1 > 0) and (Pets.Pets[i].Slot2 > 0) then
            Write(#$00#$00#$00#$02)
          else
            if (Pets.Pets[i].Slot1 = 0) and (Pets.Pets[i].Slot2 = 0) then
              Write(#$00#$00#$00#$00)
            else
              Write(#$00#$00#$00#$01);
          if Pets.Pets[i].Slot2 > 0 then begin
            Temp:=Inventory.ContainID(Pets.Pets[i].Slot2);
            WriteCd(Dword(Temp.ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Temp.ID));
            Write(#$00);
          end;
          if Pets.Pets[i].Slot1 > 0 then begin
            Temp:=Inventory.ContainID(Pets.Pets[i].Slot1);
            WriteCd(Dword(Temp.ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Temp.ID));
            Write(#$00);
          end;
          if (Pets.Pets[i].Slot1 > 0) and (Pets.Pets[i].Slot2 > 0) then
            Write(#$00#$00#$00#$02)
          else
            if (Pets.Pets[i].Slot1 = 0) and (Pets.Pets[i].Slot2 = 0) then
              Write(#$00#$00#$00#$00)
            else
              Write(#$00#$00#$00#$01);
          if Pets.Pets[i].Slot2 > 0 then begin
            Temp:=Inventory.ContainID(Pets.Pets[i].Slot2);
            WriteCd(Dword(Temp.ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Temp.ID));
            Write(#$00);
          end;
          if Pets.Pets[i].Slot1 > 0 then begin
            Temp:=Inventory.ContainID(Pets.Pets[i].Slot1);
            WriteCd(Dword(Temp.ItemID));
            Write(#$00#$00#$00#$01);
            WriteCd(Dword(Temp.ID));
            Write(#$00);
          end;
          Write(#$00#$00#$00#$00#$00#$00#$00#$00#$00+
                #$00#$00#$00);
          WriteCw(Word(Pets.Pets[i].Bind));
        end;


Write(#$00+
#$00#$00#$00#$01#$00#$00#$01#$04#$00#$00#$00#$00#$00#$00#$00#$0A#$00#$00#$00#$00#$01#$01#$00#$00#$00#$01#$61#$D0#$B2#$C0+
#$00#$64#$7E#$EE#$A2#$00#$08#$A2#$10#$6B#$7E#$67#$18#$00#$00#$00#$00#$A4#$75#$46#$E0#$56#$7B#$8F#$75#$C0#$00#$00#$00#$00+
#$00#$00#$13#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00#$00#$00#$01#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$02#$00#$00#$00#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$03#$00#$00#$00#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$04#$00#$00#$00#$04#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$05#$00#$00#$00#$05#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$06#$00#$00#$00#$06#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$07#$00#$00#$00#$07#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$08#$00#$00#$00#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$09#$00#$00#$00#$09#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$0A#$00#$00#$00#$0A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0B#$00#$00#$00#$0B#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0C#$00#$00#$00#$0C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$0D#$00#$00#$00#$0D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0E#$00#$00#$00#$0E#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$0F#$00#$00#$00#$0F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$10#$00#$00#$00#$10#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$11#$00#$00#$00#$11#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$12#$00#$00#$00#$12#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$02#$00#$00#$00#$0A#$00#$01#$F1#$C6#$00#$00#$00+
#$13#$00#$0C#$22#$CC#$00#$00#$01#$90#$01);
        Compress;
        Encrypt(GenerateIV(0),Random($FF));
        ClearPacket();
      end;
      Send;

      //diferente mas ctz n
      Buffer.BIn:='';
      with Buffer do begin
        Write(Prefix);
        Write(Dword(Count));
        Write(#$01);
        Write(Word(150));
        Write(#$00#$00#$1C#$00#$56#$7C#$A9#$48#$00#$00#$07#$DF#$00#$00#$00#$0C#$00#$00#$00#$18#$00#$00#$00#$12#$00#$00#$00#$1A#$00#$00#$00#$10);
        FixSize;
        Encrypt(GenerateIV(0),Random($FF));
        ClearPacket();
      end;
      Send;

      Buffer.BIn:='';
      with Buffer do begin
        Write(Prefix);
        Write(Dword(Count));
        Write(#$04);
        Write(Word(225));
        Write(#$00#$00#$C4#$00#$00#$00#$00#$07#$00#$00#$00#$43#$00#$00#$00#$43#$00#$00#$00#$01#$00#$0A#$1E#$3C#$00#$00#$00#$01#$00#$00+
              #$00#$01#$00#$0A#$1E#$46#$00#$00#$00#$01#$00#$00#$00#$44#$00#$00#$00#$44#$00#$00#$00#$01#$00#$0B#$62#$4C#$00#$00#$00#$01+
              #$00#$00#$00#$00#$00#$00#$00#$45#$00#$00#$00#$45#$00#$00#$00#$01#$00#$0A#$1E#$3C#$00#$00#$00#$01#$00#$00#$00#$01#$00#$0A+
              #$1E#$46#$00#$00#$00#$01#$00#$00#$00#$47#$00#$00#$00#$47#$00#$00#$00#$01#$00#$0C#$52#$D8#$00#$00#$00#$01#$00#$00#$00#$01+
              #$00#$0C#$55#$1C#$00#$00#$00#$01#$00#$00#$00#$48#$00#$00#$00#$48#$00#$00#$00#$01#$00#$0D#$72#$A8#$00#$00#$00#$01#$00#$00+
              #$00#$00#$00#$00#$00#$4B#$00#$00#$00#$4B#$00#$00#$00#$01#$00#$0F#$89#$E4#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00#$53+
              #$00#$00#$00#$53#$00#$00#$00#$01#$00#$11#$A4#$9A#$00#$00#$00#$01#$00#$00#$00#$00);
        FixSize;
        Encrypt(GenerateIV(0),Random($FF));
        ClearPacket();
      end;
      Send;

    end
    else begin
      Logger.Write(Format('Login ou senha incorretos [Handle: %d]',[Socket.Handle]),Errors);
      Socket.Close;
      Exit;
    end;
  end;
end;

procedure TPlayer.Send;
var
  Data: PAnsiChar;
  DataLen, Sent: Integer;
begin
  if Socket.Connected then begin
    Data:=PAnsiChar(Buffer.BIn);
    DataLen:=Length(Buffer.BIn);
    while DataLen > 0 do begin
      Sent:=Socket.SendBuf(Data^, DataLen);
      if Sent > 0 then begin
        Inc(Data,Sent);
        Dec(DataLen,Sent);
      end;
    end;
    if Buffer.Count = $FFFF then
      Buffer.Count:=1
    else
      Inc(Buffer.Count,1);
  end;
end;

end.
