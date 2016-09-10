                  unit SquareList;
interface
uses Player,Windows;
type
TSquarelist = class
public
  procedure Squarelist(PLayer: TPlayer);
end;
implementation

procedure TSquarelist.SquareList(Player: TPlayer);
  var
  i: integer;
  begin
    Player.Buffer.BIn:='';
   with Player.Buffer do Begin
        Write(Prefix);
        Write(Dword(Count));
        Write(#$25#$E4);
        Write(Word($140));
        Write(#$BE#$B5#$F1#$EC#$4C#$5B#$C2#$D0#$02#$BB#$3E#$61#$93#$10#$A5#$2E#$2B#$96#$B0#$EC#$EC#$8D#$44#$7F#$8A#$A1#$C1#$84#$42#$A2#$E0+
              #$38#$B2#$93#$3D#$76#$C1#$4E#$A9#$C3#$6A#$D7#$54#$70#$F1#$E7#$64#$61#$AA#$6E#$69#$5B#$7F#$E7#$2B#$4B#$45#$70#$FB#$C2#$10#$EE+
              #$4F#$20#$74#$53#$A8#$D0#$69#$71#$28#$B7#$DE#$48#$94#$CD#$C5#$D5#$8F#$E4#$89#$A6#$CE#$00#$2D#$E4#$B6#$16#$B1#$AE#$BB#$99#$74+
              #$F2#$8B#$6B#$9E#$EB#$31#$38#$9C#$22#$24#$0C#$81#$28#$A3#$59#$1A#$F4#$59#$95#$B2#$EF#$F2#$E1#$27#$E6#$AE#$F0#$8A#$A0#$02#$01+
              #$2C#$7A#$92#$83#$EF#$11#$4B#$E9#$C4#$75#$27#$DE#$FD#$AD#$2E#$0B#$5E#$C2#$BB#$14#$BF#$14#$EB#$77#$AB#$E9#$09#$DA#$8D#$87#$D1+
              #$BA#$A7#$2E#$4B#$08#$8C#$15#$DB#$D5#$9B#$BC#$E0#$BA#$50#$37#$99#$B3#$B3#$FE#$7E#$A8#$A0#$E9#$01#$84#$A1#$4D#$8C#$64#$0E#$41+
              #$29#$FA#$3D#$67#$3C#$5F#$1E#$BE#$C1#$6D#$78#$04#$6F#$96#$1F#$BE#$03#$B4#$4A#$2D#$74#$4F#$27#$61#$16#$1E#$9F#$AC#$75#$5F#$3B+
              #$DE#$E2#$B5#$5B#$FA#$26#$10#$CA#$04#$76#$DC#$F8#$10#$8A#$99#$D9#$9B#$77#$0A#$D6#$4E#$BF#$64#$1A#$5D#$95#$C4#$91#$3F#$35#$D7+
              #$D8#$61#$D1#$A4#$C8#$73#$9A#$04#$7A#$A5#$A0#$82#$7A#$87#$DB#$D2#$46#$0E#$66#$B3#$39#$46#$44#$65#$7F#$C5#$E1#$26#$5A#$36#$C9+
              #$95#$F1#$EA#$D3#$50#$BA#$F4#$72#$6F#$F4#$EF#$42#$7D#$26#$17#$FD#$0B#$F6#$A4#$44#$6C#$AF#$76#$D6#$F4#$9C#$F4#$A2#$AC#$92#$0B+
              #$33#$F1#$97#$19#$4F#$E9#$33#$3C#$F0#$79#$B6#$5F#$9E#$27#$D5#$10#$E1#$FE#$18#$65#$92#$19#$E3#$A6#$D9#$A0#$44#$D3#$D5#$E5#$1B+
              #$C2#$3D#$74#$13#$24#$51#$09#$1F#$6C#$82#$F4#$8A#$86#$85#$EF#$D6#$56#$F9#$28#$DA#$84#$0D#$D7#$51#$CB#$E1#$59#$33#$C8#$E5#$97+
              #$65#$A3#$FE#$D3#$23#$E0#$4C#$F6#$EC#$AD#$C2#$63#$40#$52#$0C#$4A#$3C#$27#$35#$31#$C5#$75#$76#$F6#$97#$F7#$24#$CA#$1F#$21#$B5+
              #$B1#$4A#$4E#$8E#$BD#$A8#$5B#$57#$7A#$ED#$1E#$FF#$D7#$CB#$03#$FF#$A1#$CC#$0A#$29#$7E#$3F#$63#$CC#$45#$DF#$72#$62#$99#$7F#$78+
              #$97#$95#$BD#$90#$8E#$4F#$EF#$30#$2C#$90#$7F#$8C#$70#$CA#$24#$72#$1C#$E1#$E2#$16#$4C#$7F#$0A#$75#$9C#$8D#$98#$04#$B0#$FC#$22+
              #$C3#$B6#$42#$1F#$45#$82#$B6#$E2#$30#$A5#$88#$55#$D8#$66#$D7#$E1#$6C#$6C#$20#$CA#$16#$E0#$0E#$A7#$7B#$1C#$10#$13#$B4#$7D#$80+
              #$D7#$7F#$39#$CD#$8F#$42#$41#$18#$37#$54#$62#$CB#$AD#$04#$67#$8D#$BD#$B0#$E9#$94#$58#$0A#$00#$14#$E4#$AF#$C7#$3B#$C8#$97#$B7+
              #$94#$DC#$E9#$F4#$D4#$66#$1E#$49#$00#$94#$20#$2A#$33#$17#$67#$92#$09#$A6#$73#$15#$6D#$8F#$A3#$E8#$67#$60#$BD#$81#$D2#$6D#$D7+
              #$6E#$1A#$FA#$57#$D7#$E5#$81#$A8#$3D#$E5#$52#$68#$FF#$3F#$7D#$21#$51#$4A#$1D#$79#$6F#$00#$2D#$D7#$8E#$88#$8A#$54#$F1#$7F#$98+
              #$E9#$06#$C3#$BC#$84#$D3#$39#$27#$9A#$E2#$88#$3D#$0C#$24#$2F#$71#$0A#$57#$25#$C4#$CB#$AE#$E5#$EF#$F9#$4D#$56#$D5#$9F#$31#$6A+
              #$A7#$B3#$97#$35#$F9#$56#$AA#$EF#$D2#$2A#$42#$5C#$44#$60#$9E#$0D#$DA#$2A#$76#$68#$5F#$60#$3F#$F3#$31#$6B#$F4#$50#$D3#$24#$D9+
              #$C6#$1B#$E4#$9C#$AF#$15#$C5#$E2#$AF#$AC#$3B#$3E#$44#$3A#$C9#$74#$3F#$4C#$43#$0D#$12#$6D#$78#$52#$4C#$32#$F1#$4E#$68#$D8#$CB+
              #$3A#$4C#$09#$DB#$85#$E1#$11#$9B#$A9#$B7#$22#$4D#$2D#$3B#$28#$A0#$03#$AE#$26#$D5#$97#$0D#$2F#$1E#$80#$BF#$76#$FD#$A8#$DF#$A8+
              #$77#$33#$E6#$65#$AD#$10#$BF#$54#$5C#$A7#$66#$F4#$42#$4D#$16#$A2#$61#$AC#$1E#$23#$D7#$54#$FE#$BE#$34#$A8#$CA#$BE#$7D#$5D#$C7+
              #$CD#$F0#$17#$1E#$2A#$AF#$BF#$26#$C1#$31#$E3#$F6#$5B#$09#$DB#$26#$CA#$D8#$82#$B3#$58#$8A#$8D#$B6#$DD#$B9#$D2#$D5#$A4#$EA#$81+
              #$DE#$29#$9E#$44#$D3#$C2#$1D#$D3#$CA#$14#$4B#$19#$74#$74#$47#$3F#$AF#$04#$1C#$74#$04#$18#$8E#$96#$67#$57#$B0#$0D#$B1#$EA#$9B+
              #$6F#$76#$52#$3E#$CB#$92#$52#$56#$CE#$55#$DD#$76#$7A#$78#$BD#$4A#$9F#$88#$D7#$95#$6D#$79#$0E#$2E#$84#$6E#$7C#$3D#$8B#$61#$30+
              #$94#$AE#$F0#$3A#$BE#$69#$40#$B4#$8D#$F1#$75#$2D#$CC#$23#$AD#$8E#$0A#$BC#$51#$AB#$DE#$20#$02#$F3#$FD#$62#$3E#$9F#$8D#$FC#$A4+
              #$5B#$74#$4C#$C0#$2F#$E9#$3B#$37#$0A#$69#$44#$6A#$5F#$BD#$02#$2D#$AA#$56#$28#$3B#$CE#$E8#$4F#$F5#$A9#$73#$40#$66#$44#$99#$F8+
              #$1C#$52#$41#$7D#$D7#$47#$E7#$E9#$31#$74#$59#$F9#$A9#$4F#$CF#$F4#$38#$80#$43#$A8#$EC#$CD#$1B#$2A#$42#$23#$6D#$FE#$61#$46#$9D+
              #$04#$D1#$19#$40#$D7#$F2#$AE#$81#$C7#$0D#$E8#$0E#$6D#$A9#$09#$F3#$CB#$8F#$E4#$16#$B7#$97#$1F#$D7#$24#$86#$E4#$85#$B1#$EF#$43+
              #$01#$0A#$B5#$B1#$65#$1F#$72#$C4#$40#$24#$7B#$AF#$A7#$40#$6B#$D2#$EC#$21#$90#$86#$8A#$B1#$70#$BE#$E2#$CA#$74#$DE#$55#$46#$9B+
              #$3E#$7B#$67#$1F#$E8#$ED#$9A#$36#$14#$76#$CC#$A3#$8E#$87#$2E#$DC#$14#$93#$F1#$96#$E1#$86#$EB#$B7#$C0#$B5#$AE#$CC#$CE#$D2#$13+
              #$28#$BE#$5E#$DD#$46#$D2#$7C#$4F#$6C#$B9#$BF#$07#$2E#$F7#$85#$26#$2A#$28#$DA#$45#$A2#$91#$0E#$2D#$35#$33#$9F#$B1#$17#$5A#$7C+
              #$D2#$03#$CB#$AF#$02#$B2#$BC#$1E#$34#$1E#$6E#$E9#$3C#$AE#$97#$E1#$7F#$B9#$A0#$8C#$71#$5D#$54#$30#$F9#$D6#$75#$57#$D7#$55#$B6+
              #$C2#$45#$36#$E4#$11#$46#$1E#$71#$EE#$5A#$CE#$D5#$4C#$C6#$28#$E5#$B1#$8A#$77#$BF#$4E#$16#$BE#$69#$17#$FC#$97#$CB#$33#$72#$0A+
              #$52#$5C#$9C#$0F#$B3#$DA#$0A#$7E#$60#$B3#$57#$21#$D5#$02#$FA#$D1#$A5#$7D#$34#$AA#$EC#$0A#$75#$D4#$D4#$B9#$2B#$64#$12#$1D#$3C+
              #$19#$EA#$72#$9E#$EB#$CA#$F5#$A0#$36#$30#$9F#$CD#$75#$E5#$D3#$0B#$F3#$FE#$2C#$2F#$7A#$7A#$B2#$B5#$73#$7B#$47#$0D#$8A#$4F#$C3+
              #$ED#$E4#$9C#$44#$B1#$E3#$68#$64#$BE#$F6#$6A#$E7#$AF#$72#$46#$2D#$D6#$53#$28#$EF#$CD#$12#$96#$88#$E3#$4C#$C5#$5D#$68#$2C#$61+
              #$9A#$CF#$05#$24#$F4#$5B#$11#$A4#$F5#$AA#$06#$D5#$13#$C6#$10#$42#$51#$BF#$3F#$2A#$A1#$41#$A5#$FE#$CC#$58#$B6#$39#$26#$E0#$48+
              #$92#$DD#$65#$C5#$88#$36#$05#$08#$2A#$FF#$7F#$35#$49#$1F#$DF#$93#$8B#$77#$AB#$9D#$41#$ED#$45#$FF#$12#$4E#$A3#$C1#$3E#$FC#$BD+
              #$BE#$04#$66#$E6#$37#$C0#$3A#$5B#$92#$FE#$A0#$B3#$4C#$DE#$22#$AA#$BF#$66#$0F#$B6#$F9#$7F#$19#$B6#$99#$43#$5E#$E7#$F3#$36#$F6+
              #$59#$68#$5F#$7D#$AB#$B8#$27#$37#$84#$64#$C2#$41#$7A#$03#$4B#$D7#$7A#$96#$60#$BA#$1F#$A0#$3E#$74#$65#$28#$F2#$2B#$30#$0A#$28+
              #$EA#$18#$AE#$B9#$39#$83#$49#$E0#$A2#$5B#$02#$56#$95#$BF#$BD#$87#$D9#$BB#$AB#$26#$C8#$B7#$3A#$51#$DA#$A0#$DC#$9A#$81#$11#$DE+
              #$FB#$AA#$4A#$0B#$5D#$6E#$D9#$96#$20#$57#$E5#$E5#$AC#$60#$83#$BF#$78#$63#$3D#$38#$3A#$77#$0F#$80#$E6#$40#$05#$B0#$09#$64#$48+
              #$5F#$2E#$61#$0E#$CA#$4E#$95#$58#$45#$68#$0C#$C3#$6D#$A1#$77#$55#$CB#$CC#$7E#$91#$39#$73#$C2#$E6#$5D#$F9#$8C#$40#$65#$7B#$C3+
              #$E8#$B2#$07#$66#$D5#$3B#$EC#$D7#$D3#$9E#$4B#$8E#$D7#$A4#$6C#$A5#$D6#$91#$62#$8B#$02#$35#$46#$4E#$3E#$A2#$E3#$FB#$59#$1B#$E6+
              #$1A#$4B#$77#$1D#$2D#$5A#$76#$12#$E2#$E8#$DC#$6F#$54#$E1#$63#$EC#$BF#$7D#$00#$8F#$FC#$98#$EE#$27#$95#$28#$73#$42#$D4#$81#$85+
              #$74#$CB#$5D#$A5#$AB#$3E#$3E#$96#$AB#$C0#$F4#$CC#$78#$52#$2A#$ED#$3A#$8F#$1A#$E0#$FE#$F9#$50#$CA#$4E#$D9#$20#$12#$65#$17#$DB+
              #$69#$AD#$8E#$51#$43#$C9#$56#$EA#$9C#$00#$0E#$BE#$D9#$31#$DA#$52#$3B#$A8#$D1#$07#$B1#$F9#$3D#$16#$BD#$33#$78#$49#$1A#$3F#$8E+
              #$5F#$D2#$FD#$C8#$F5#$AE#$B7#$CB#$2A#$61#$4E#$19#$66#$24#$20#$BF#$56#$BF#$59#$F7#$B6#$B8#$0C#$D9#$C3#$71#$39#$68#$1F#$A4#$41+
              #$F5#$F6#$C2#$95#$C8#$8E#$F7#$19#$01#$5E#$74#$0B#$C2#$09#$E4#$60#$82#$66#$43#$FF#$F7#$A9#$4D#$F1#$59#$60#$2E#$85#$3C#$32#$00+
              #$57#$70#$9F#$7D#$9F#$89#$E0#$BC#$F4#$18#$9E#$54#$CA#$26#$09#$34#$0B#$E5#$50#$C4#$20#$60#$4D#$93#$C8#$F5#$78#$EE#$66#$90#$C3+
              #$FB#$43#$58#$96#$3E#$B0#$70#$D5#$D2#$C5#$67#$73#$29#$79#$57#$25#$B5#$C5#$35#$D6#$0B#$95#$BA#$A1#$66#$30#$FB#$4E#$5F#$9E#$A3+
              #$C1#$D2#$FC#$08#$8E#$AC#$32#$4F#$7A#$BC#$DC#$C1#$C6#$AC#$BF#$67#$A7#$91#$92#$13#$96#$79#$9F#$27#$44#$0F#$8F#$45#$5C#$15#$97+
              #$F1#$5B#$E9#$C3#$E9#$EB#$7E#$12#$3A#$15#$AB#$31#$65#$B3#$67#$6A#$30#$10#$9C#$64#$06#$4D#$4F#$C6#$7C#$E6#$A3#$4B#$18#$85#$AB+
              #$48#$B5#$C7#$22#$06#$67#$E1#$98#$E8#$A8#$29#$4E#$27#$F8#$9D#$5E#$85#$57#$45#$1D#$F1#$37#$CC#$BE#$4B#$72#$71#$8F#$9D#$2B#$E4+
              #$66#$BC#$92#$CE#$62#$4C#$E1#$4E#$F0#$78#$FB#$80#$32#$82#$2E#$72#$CC#$98#$F1#$DE#$EB#$C7#$A6#$05#$E8#$7A#$DE#$97#$9A#$08#$27+
              #$F1#$4E#$4E#$A9#$0D#$7B#$AE#$0A#$9C#$B1#$E7#$CE#$21#$F2#$01#$0B#$77#$28#$57#$00#$B1#$49#$EF#$CE#$89#$1C#$E9#$0A#$09#$C6#$72+
              #$EE#$E2#$67#$18#$37#$6D#$39#$97#$D2#$A0#$DE#$86#$96#$A2#$B0#$2B#$9B#$EB#$F4#$B4#$91#$14#$32#$54#$23#$BE#$6A#$04#$B9#$B1#$A8+
              #$8A#$04#$29#$51#$75#$FA#$42#$B7#$1A#$44#$33#$62#$41#$C5#$1F#$76#$D9#$72#$A8#$03#$67#$39#$99#$24#$36#$8F#$7E#$43#$0B#$92#$00+
              #$82#$5F#$8F#$D2#$16#$96#$F9#$89#$E0#$05#$88#$E9#$56#$F3#$4D#$AE#$65#$6C#$E3#$82#$D7#$86#$14#$3D#$F4#$1A#$17#$1A#$8D#$A0#$88+
              #$24#$81#$BA#$DF#$E4#$20#$22#$5A#$F8#$66#$DA#$E0#$7D#$31#$E9#$48#$74#$28#$BF#$B8#$8A#$FB#$D1#$9D#$07#$0C#$96#$F6#$26#$BA#$9F+
              #$B3#$DF#$DA#$9C#$10#$A7#$D9#$6A#$B6#$6C#$F1#$5A#$D4#$24#$59#$85#$FA#$C4#$2F#$6C#$67#$55#$71#$F1#$AB#$E3#$3D#$55#$D6#$05#$93+
              #$C7#$F3#$97#$E2#$58#$9B#$B6#$4A#$65#$A6#$4B#$63#$B4#$45#$AA#$94#$6E#$70#$EC#$FC#$36#$2A#$68#$E9#$CE#$18#$04#$47#$68#$FB#$A6+
              #$6F#$4E#$D4#$11#$78#$7F#$E6#$DA#$BA#$E2#$6C#$1A#$F3#$1C#$CB#$C5#$A7#$1D#$65#$B0#$7F#$96#$63#$34#$63#$38#$0E#$82#$26#$8A#$D5+
              #$16#$4E#$E3#$50#$80#$5D#$91#$05#$2C#$97#$7F#$3D#$A1#$24#$61#$0A#$42#$A4#$DB#$A3#$1F#$BC#$17#$37#$E7#$05#$2E#$98#$78#$CD#$17+
              #$69#$98#$A1#$FF#$B0#$01#$20#$15#$F7#$83#$F8#$0F#$B9#$90#$B0#$1F#$0B#$C1#$7D#$71#$C4#$2E#$01#$D2#$DE#$69#$04#$7D#$93#$2A#$BD+
              #$5D#$31#$63#$B2#$3B#$E4#$08#$6E#$E4#$36#$BF#$56#$26#$BB#$95#$6E#$29#$11#$7F#$09#$F3#$14#$41#$9F#$35#$48#$43#$F2#$5C#$8F#$F7+
              #$E1#$2A#$9F#$D1#$58#$64#$1B#$F1#$9B#$15#$D1#$AE#$D9#$06#$40#$18#$6D#$65#$99#$F2#$02#$41#$33#$6B#$C2#$11#$CC#$75#$65#$5D#$09+
              #$BC#$AA#$18#$34#$CE#$8A#$EF#$D7#$15#$A7#$A9#$61#$83#$33#$0D#$12#$BC#$2F#$0B#$A0#$D0#$3E#$AA#$22#$11#$3C#$9F#$05#$2E#$52#$94+
              #$FA#$1B#$E2#$97#$2B#$10#$03#$F3#$E9#$B0#$0F#$B9#$38#$EF#$18#$FE#$43#$A9#$3F#$65#$59#$DD#$A4#$0F#$C2#$29#$D6#$23#$3B#$BD#$FC+
              #$54#$DF#$E3#$D0#$23#$07#$2F#$82#$D3#$50#$8B#$40#$A9#$59#$F6#$53#$47#$B2#$0E#$CD#$85#$94#$48#$57#$90#$3F#$A8#$8E#$53#$5F#$BA+
              #$E1#$41#$2A#$28#$E0#$39#$A2#$EE#$84#$53#$8A#$B1#$66#$8C#$8A#$45#$EC#$C6#$37#$A0#$28#$66#$0D#$46#$BD#$21#$AA#$8F#$BF#$EA#$FC+
              #$C8#$0A#$21#$DF#$E9#$7F#$E4#$6A#$4D#$37#$44#$94#$CB#$71#$92#$A4#$2C#$A3#$FF#$32#$43#$1B#$BB#$29#$60#$D7#$B6#$10#$6E#$1A#$DE+
              #$5A#$5B#$F8#$8A#$CC#$DC#$9C#$2C#$D5#$7C#$9E#$8D#$93#$D8#$1B#$5C#$B6#$70#$8D#$EA#$A4#$5B#$14#$67#$C7#$CE#$61#$84#$A5#$A0#$54+
              #$DB#$52#$94#$CC#$04#$4E#$61#$D8#$DF#$BA#$35#$D8#$06#$F1#$C2#$6D#$74#$4E#$6F#$58#$3C#$62#$D0#$4A#$02#$D9#$A6#$E9#$2D#$9E#$95+
              #$06#$BA#$ED#$93#$10#$BB#$99#$7D#$E8#$2C#$4D#$77#$F2#$70#$D3#$F1#$FD#$8E#$87#$F1#$DA#$E4#$4E#$B3#$D5#$51#$8B#$9C#$EF#$19#$54+
              #$3C#$76#$D8#$47#$CE#$D8#$99#$DB#$87#$BC#$B1#$84#$9B#$5B#$18#$EE#$23#$C4#$80#$F5#$05#$6C#$EE#$FE#$82#$71#$47#$DC#$D0#$BB#$6F+
              #$F4#$5F#$77#$01#$F5#$D2#$77#$43#$A7#$C0#$E0#$15#$1A#$F0#$E2#$A3#$D6#$CC#$86#$00#$C3#$DD#$8B#$D7#$FA#$72#$FA#$6C#$4D#$4B#$58+
              #$3C#$1B#$EF#$4F#$86#$9C#$29#$C7#$30#$AF#$18#$12#$AF#$C1#$F2#$E1#$D5#$81#$AE#$60#$AC#$FD#$E1#$81#$C9#$AD#$4D#$E6#$38#$39#$0D+
              #$FA#$CB#$6C#$17#$AF#$6E#$BD#$89#$A2#$C1#$E3#$57#$0C#$AC#$45#$D2#$B5#$8F#$26#$E9#$41#$2B#$B8#$FD#$85#$9A#$DE#$E2#$B9#$56#$E6+
              #$40#$13#$EB#$88#$CF#$CD#$43#$5D#$85#$DE#$10#$D8#$3A#$88#$30#$61#$05#$EC#$A5#$86#$2C#$AE#$71#$C9#$8D#$90#$93#$2F#$A8#$07#$E5+
              #$BA#$CA#$8E#$38#$91#$41#$19#$92#$F0#$4E#$07#$A0#$93#$57#$89#$D0#$92#$26#$75#$5F#$D7#$A3#$59#$D3#$9F#$D4#$54#$C8#$39#$42#$A1+
              #$1C#$CC#$48#$D4#$69#$66#$CD#$9C#$98#$F5#$39#$FE#$63#$0F#$F9#$61#$2B#$52#$1B#$02#$45#$9B#$EB#$35#$D4#$B7#$A7#$6A#$EA#$AB#$9E+
              #$B4#$35#$BF#$52#$DE#$05#$F8#$F0#$E1#$B3#$1D#$22#$97#$62#$EC#$CE#$65#$71#$FE#$15#$C8#$57#$1C#$B4#$D4#$D6#$65#$C7#$D6#$94#$0A+
              #$25#$5A#$BA#$1B#$6E#$6B#$ED#$DB#$E9#$36#$05#$B0#$60#$00#$95#$57#$D9#$0B#$3C#$3C#$18#$44#$81#$66#$6C#$2E#$05#$94#$E8#$36#$0D+
              #$8F#$A3#$7C#$F8#$DC#$AD#$45#$1E#$33#$43#$10#$0D#$11#$F8#$84#$97#$D9#$AA#$B0#$B8#$B3#$F6#$97#$21#$26#$90#$D2#$61#$80#$1B#$F3+
              #$FD#$E3#$E0#$D2#$C9#$71#$85#$97#$57#$0E#$31#$CF#$3E#$2E#$AC#$E6#$1B#$25#$58#$22#$48#$F0#$1E#$C6#$6F#$54#$6C#$A8#$DF#$E0#$20+
              #$49#$C1#$77#$60#$32#$20#$9D#$5F#$58#$75#$16#$4B#$8A#$07#$08#$08#$C3#$CB#$78#$7F#$CA#$DE#$76#$56#$91#$72#$5C#$9F#$4D#$02#$36+
              #$62#$49#$04#$9C#$A4#$CE#$01#$2C#$CF#$E8#$A3#$88#$B5#$62#$FE#$AD#$63#$48#$5F#$BC#$6D#$EF#$C7#$59#$1C#$0D#$9E#$0A#$4B#$21#$B5+
              #$2E#$82#$47#$00#$53#$9B#$38#$9B#$C7#$C6#$8A#$34#$9C#$F8#$DD#$8E#$ED#$15#$CB#$0A#$E7#$71#$08#$0B#$45#$4B#$DB#$B5#$47#$5B#$F0+
              #$A9#$AA#$37#$5A#$8F#$6B#$A6#$69#$F9#$36#$73#$6D#$10#$CF#$E8#$7D#$CF#$03#$91#$D6#$E0#$D8#$A1#$74#$28#$22#$7D#$E3#$30#$B5#$12+
              #$F1#$7D#$E1#$AB#$3E#$3A#$29#$3F#$C4#$75#$FE#$B2#$CE#$67#$40#$6F#$F1#$57#$0F#$71#$08#$47#$28#$B2#$C0#$D7#$A9#$4E#$1C#$AA#$03+
              #$EB#$EB#$0B#$24#$F7#$F2#$B4#$5F#$41#$30#$41#$5F#$AD#$4E#$15#$6B#$A5#$3D#$A6#$FF#$F1#$3F#$E2#$71#$43#$51#$7F#$DC#$51#$C5#$B5+
              #$C4#$AE#$DD#$51#$DD#$BA#$EE#$0B#$7F#$64#$CC#$5B#$4B#$16#$CC#$96#$FF#$95#$CB#$8C#$9C#$D4#$57#$BF#$EE#$61#$04#$F4#$09#$BC#$D8+
              #$DF#$B1#$D1#$B8#$81#$80#$88#$AD#$D4#$E9#$73#$98#$3A#$17#$FB#$C5#$E6#$B8#$30#$A6#$D1#$6E#$7A#$70#$D0#$72#$21#$18#$C8#$CC#$0F+
              #$FC#$38#$C6#$5A#$5A#$10#$A6#$0A#$02#$6D#$B9#$17#$21#$77#$D6#$56#$F3#$D4#$35#$E2#$BD#$5C#$50#$73#$3A#$B5#$44#$94#$D3#$4D#$87+
              #$78#$98#$A7#$90#$61#$E8#$AD#$4F#$D3#$CF#$75#$38#$AD#$05#$BB#$20#$6F#$40#$3C#$FA#$51#$16#$40#$D7#$A6#$6C#$F1#$09#$FF#$F8#$A3+
              #$3C#$3D#$D8#$49#$57#$E5#$B2#$87#$40#$45#$AB#$09#$68#$2B#$D5#$7A#$F1#$DD#$F4#$40#$FF#$F7#$69#$03#$12#$AC#$B5#$F2#$34#$79#$6B+
              #$FE#$FE#$87#$34#$94#$00#$9B#$D1#$A9#$7A#$EC#$5C#$5F#$0D#$7F#$90#$EE#$8C#$A0#$90#$64#$C1#$1B#$97#$5D#$2B#$B0#$7E#$C5#$B4#$21+
              #$AC#$0D#$2B#$C7#$DD#$C8#$D6#$72#$86#$2A#$CA#$70#$8D#$37#$73#$1C#$3F#$60#$CF#$4C#$C4#$55#$80#$43#$3C#$07#$32#$E7#$F1#$AD#$A2+
              #$F8#$18#$6E#$AE#$48#$1C#$8D#$3E#$29#$28#$EE#$43#$76#$CA#$63#$97#$B3#$0C#$4B#$59#$A0#$D0#$68#$15#$B1#$A1#$75#$DA#$86#$79#$45+
              #$EE#$C7#$60#$22#$5E#$63#$08#$0B#$53#$F0#$BB#$F6#$73#$7C#$77#$A7#$1A#$B1#$02#$78#$E8#$19#$2A#$05#$B2#$A0#$BC#$76#$6F#$A5#$99+
              #$73#$B7#$98#$E3#$0D#$06#$21#$0E#$30#$08#$24#$49#$60#$EB#$AD#$10#$8F#$80#$AE#$33#$F3#$27#$EF#$05#$A6#$28#$F8#$26#$26#$84#$2B+
              #$C0#$A4#$B9#$54#$00#$B3#$5E#$05#$84#$A4#$B8#$C7#$1E#$77#$DD#$20#$6D#$B1#$0C#$07#$F4#$5E#$00#$33#$3F#$5B#$8D#$7F#$DD#$52#$71+
              #$D7#$25#$A7#$A6#$33#$9D#$F4#$49#$C7#$88#$F8#$47#$97#$56#$0F#$F9#$E0#$0E#$19#$62#$0F#$C4#$2B#$8F#$8B#$20#$07#$B3#$05#$23#$06+
              #$C1#$8F#$B7#$62#$8B#$82#$08#$53#$CA#$F8#$C5#$1B#$0D#$2A#$33#$17#$C9#$00#$5B#$A8#$7D#$7E#$4C#$B1#$21#$7E#$FD#$4F#$BC#$66#$95+
              #$95#$31#$11#$73#$0A#$AA#$29#$47#$E2#$41#$1E#$E5#$0B#$33#$5E#$02#$29#$AA#$FF#$02#$4E#$4C#$54#$BF#$72#$9B#$09#$65#$5A#$04#$06+
              #$C9#$D0#$11#$CA#$05#$A9#$6D#$3A#$3E#$8D#$94#$49#$EA#$34#$47#$B0#$15#$72#$7D#$50#$8F#$68#$6B#$CD#$8C#$61#$B4#$A7#$9B#$60#$85+
              #$6B#$13#$70#$E9#$8E#$89#$06#$33#$1F#$59#$3C#$FC#$C8#$15#$A4#$9F#$AF#$27#$25#$79#$31#$39#$7D#$4E#$F7#$8A#$79#$16#$DF#$14#$31+
              #$94#$7C#$56#$05#$F7#$CF#$A9#$F0#$1F#$D2#$8C#$72#$D3#$40#$40#$B1#$DD#$6B#$B3#$A6#$32#$5A#$6D#$6B#$A7#$0F#$DB#$0F#$6D#$64#$2D+
              #$5F#$E2#$5D#$16#$FF#$D6#$F0#$7E#$26#$24#$14#$CD#$85#$A9#$14#$8C#$21#$36#$80#$45#$89#$2D#$F4#$7F#$FA#$ED#$57#$7A#$C3#$15#$91+
              #$BD#$DE#$DE#$24#$62#$AF#$96#$CD#$F0#$23#$44#$C4#$F3#$36#$03#$4C#$C2#$00#$F5#$3E#$5E#$12#$A6#$BC#$DF#$6E#$CB#$C3#$40#$B2#$78+
              #$7E#$F3#$ED#$B4#$E5#$EF#$1C#$1E#$80#$7B#$19#$29#$7F#$E9#$01#$D6#$86#$3B#$85#$EA#$C2#$3A#$8D#$DC#$3D#$BE#$B2#$87#$BC#$D4#$0C+
              #$03#$F0#$59#$49#$E4#$D4#$81#$A6#$DB#$F5#$73#$AF#$F6#$BB#$DE#$E6#$81#$AC#$40#$09#$76#$11#$EA#$DA#$D0#$31#$F6#$1E#$11#$BD#$B0+
              #$AD#$22#$B6#$C4#$FA#$63#$FC#$48#$0F#$CD#$63#$55#$E6#$C4#$94#$7F#$66#$62#$65#$D3#$F6#$B8#$1E#$37#$11#$0F#$D4#$4A);
        WriteCd(Dword(Player.Socket.RemoteAddr.sin_addr.S_addr));
        FixSize;
        Encrypt(GenerateIV(0),Random($FF));
        ClearPacket();
    End;
    Player.Send;
  end;
end.

