using libcomservice.Request.Channel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace libcomservice.Data
{
    public static class Querys
    {
        internal static void Execute_VerifyAccount(Session PLAYER, string Login, string Passwd)
        {
            DataSet DBAcess = new DataSet();
            GameServer.Sql.Exec(DBAcess, "SELECT * FROM  users WHERE Login = '{0}' AND passwd = '{1}'", Login, Passwd);
            if (DBAcess.Tables[0].Rows.Count > 0)
            {
                PLAYER.Account.Login = DBAcess.Tables[0].Rows[0]["Login"].ToString();
                PLAYER.Account.Passwd = DBAcess.Tables[0].Rows[0]["passwd"].ToString();
                PLAYER.Account.AccountID = Convert.ToInt32(DBAcess.Tables[0].Rows[0]["LoginUID"].ToString());
                PLAYER.Account.GamePoints = Convert.ToInt32(DBAcess.Tables[0].Rows[0]["gamePoint"].ToString());
                PLAYER.Account.CashPoints = Convert.ToInt32(DBAcess.Tables[0].Rows[0]["cashpoint"].ToString());
                //PLAYER.Account.WarehouseSize = Convert.ToInt32(DBAcess.Tables[0].Rows[0]["WarehouseSize"].ToString());
                Get_Authlevel(PLAYER, PLAYER.Account.AccountID);
                Get_UserNick(PLAYER, Login);
                Get_InvetoryInfo(PLAYER, PLAYER.Account.AccountID);
                PLAYER.Account.LifeBonusPoints = Convert.ToInt32(DBAcess.Tables[0].Rows[0]["LifeBonusPoint"].ToString());
            }
        }

        private static void Get_InvetoryInfo(Session p, int dwID)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "SELECT Size FROM GInventoryInfo  WHERE LoginUID = '{0}'", dwID);
            if (query.Tables[0].Rows.Count > 0)
            {
                p.Account.InventorySize = Convert.ToInt32(query.Tables[0].Rows[0]["Size"].ToString());
            }
        }

        private static void Get_Authlevel(Session p, int dwID)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "SELECT AuthLevel FROM UAGUserAuth  WHERE LoginUID = '{0}'", dwID);
            if (query.Tables[0].Rows.Count > 0)
            {
                p.Account.AuthLevel = Convert.ToInt32(query.Tables[0].Rows[0]["AuthLevel"].ToString());
            }
        }

        private static void Get_UserNick(Session PLAYER, string Login)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "SELECT Nick FROM NickNames  WHERE Login = '{0}'", Login);
            if (query.Tables[0].Rows.Count > 0)
            {
                PLAYER.Account.Nickname = query.Tables[0].Rows[0]["nick"].ToString();
            }
        }

        public static void Execute_ClearST(int userId)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE STGSkillTreeSet SET SetID = '0' WHERE LoginUID = '{0}'", userId);
        }

        public static void Execute_InsertSP(int userId, byte charType, long exp)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "INSERT INTO STGSkillTreeSP (LoginUID,CharType,SPExp,SPLv)  VALUES ('{0}','{1}','{2}','0')", userId, charType, exp);
        }


        public static void Execute_InsertST(int userId, byte charType, byte promotion, int stId, int groupId)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "SELECT * FROM STGSkillTreeSet  WHERE LoginUID = '{0}' AND CharType = '{1}' AND SkillID='{2}'", userId, charType, stId);
            if (query.Tables[0].Rows.Count > 0)
            {
                DataSet Query = new DataSet();
                GameServer.Sql.Exec(Query, "UPDATE STGSkillTreeSet SET SetID = '1' WHERE LoginUID = '{0}' AND CharType = '{1}' AND SkillID = '{2}'", userId, charType, stId);
            }
        }

        public static void Execute_InsertItem(string Login, uint itemuid, uint itemid, int quantity, int period, byte islook, byte requirelevel, byte gradeid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "INSERT INTO GoodsObjectlist (OwnerLogin,BuyerLogin,ItemID,RegDate,StartDate,EndDate,Quantity,Period,isLook,RequiredLevel,Grade)  VALUES ('{0}','{1}','{2}','00:00:00','00:00:00','00:00:00','{3}','{4}','{6}','{7}','{8}')", Login, Login, itemid, quantity, period, itemuid, islook, requirelevel, gradeid);
        }

        public static void Execute_RemoveItem(string login, int loginuid, uint itemuid)
        {
            DataSet data_0 = new DataSet();
            GameServer.Sql.Exec(data_0, "DELETE FROM GoodsObjectlist WHERE BuyerLogin = '{0}' AND ItemUID = '{1}'", login, itemuid);

            DataSet data_1 = new DataSet();
            GameServer.Sql.Exec(data_1, "DELETE FROM UIGAUserItemAttribute WHERE LoginUID = '{0}' AND  ItemUID = '{1}'", loginuid, itemuid);

            DataSet data_2 = new DataSet();
            GameServer.Sql.Exec(data_2, "DELETE FROM UIGAUserItemSocket WHERE LoginUID = '{0}' AND  ItemUID = '{1}'", loginuid, itemuid);
        }

        public static void Execute_InsertAttribute(int _loginuid, uint _itemuid, byte _typeId, int _value, byte _attributeState)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "INSERT INTO UIGAUserItemAttribute (LoginUID, ItemUID, TypeID, Value,AttributeState) VALUES  ('{0}', '{1}', '{2}','{3}','{4}');", _loginuid, _itemuid, _typeId, _value, _attributeState);
        }

        public static void Execute_InsertSockets(int loginuid, uint itemuid, int slot, int cardid, byte socketstate = 2)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "INSERT INTO UIGAUserItemSocket(LoginUID,ItemUID,SlotID,CardID,SocketState)VALUES('{0}', '{1}', '{2}','{3}','{4}');", loginuid, itemuid, slot, cardid, socketstate);
        }

        public static void Execute_AttributeClear(int loginuid, uint itemuid)
        {
            DataSet data_1 = new DataSet();
            GameServer.Sql.Exec(data_1, "DELETE FROM UIGAUserItemAttribute WHERE LoginUID = '{0}' AND  ItemUID = '{1}'", loginuid, itemuid);
        }

        public static void Execute_UpgradeItem(string login, uint index, uint itemuid, int quantity, byte upgrade, uint equippedUid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectlist SET  StrongLevel = '{0}', EquippedItemUID = '{4}',Quantity = '{5}' WHERE OwnerLogin = '{1}' AND ItemID = '{2}' AND ItemUID = '{3}'", upgrade, login, index, itemuid, equippedUid, quantity);
        }

        public static void Execute_ChangeLook(string login, uint index, int status, uint itemuid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectlist SET  islook = '{0}' WHERE OwnerLogin = '{1}' AND ItemID = '{2}' AND ItemUID = '{3}'", status, login, index, itemuid);
        }

        public static void Execute_DeleteItem(string login, int itemid, int itemuid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "DELETE FROM GoodsObjectlist WHERE OwnerLogin = '{0}' AND ItemID = '{1}' AND ItemUID = '{1}' ", login, itemid, itemuid);
        }

        public static void Execute_BanMember(string Login)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE  users SET AuthLevel = '-1' WHERE Login = '{0}'", Login);
        }


        public static void Execute_UpdateWinAndLose(string login, int CharacterID, int Win, int Lose)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE characters SET Win = '{0}',  Lose = '{1}' WHERE Login = '{2}'   AND CharType = '{3}'", Win, Lose, login, CharacterID);
        }

        public static void Execute_UpdateGP(int loginid, int newGP)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE users SET gamePoint = '{0}' WHERE LoginUID = '{1}'", newGP, loginid);
        }

        public static void Execute_UpdateVP(int loginid, int newVP)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE VCGAVirtualCash SET VCPoint = '{0}' WHERE LoginUID = '{1}'", newVP, loginid);
        }


        public static void Execute_UpdateMyCoins(string login, int newMyCoins)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectlist SET Quantity = '{0}' WHERE OwnerLogin = '{1}' AND ItemID = '362080' ", newMyCoins, login);
        }

        public static void Execute_UpdateGPoint(Session p, int newDP)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GPointBag SET Point = '{0}' WHERE LoginUID = '{1}' ", newDP, p.Account.AccountID);
        }

        public static void Execute_UpdateItem(string login, uint item, uint itemuid, int quantity)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectlist SET Quantity = '{0}' WHERE BuyerLogin = '{1}' AND ItemID = '{2}' AND ItemUID = '{3}'", quantity, login, item, itemuid);
        }


        public static int CheckItemExist(string login, int value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT   Quantity FROM  GoodsObjectlist WHERE OwnerLogin = '{0}' AND  ItemID = '{1}'", login, value);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Quantity"].ToString());
            }
            else
            {
                return 0;
            }
        }

        public static byte SelectGradeID(uint value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT   GradeID FROM  GoodsInfoList WHERE GoodsID = '{0}'", value);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToByte(Query.Tables[0].Rows[0]["GradeID"].ToString());
            }
            else
            {
                return 2;
            }
        }

        public static int CheckItemExistGacha(string login, uint value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT   Quantity FROM  GoodsObjectlist WHERE OwnerLogin = '{0}' AND  ItemID = '{1}'", login, value);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Quantity"].ToString());
            }
            else
            {
                return 0;
            }
        }


        public static int CheckItemExistGetUID(string Login, int _value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT   ItemUID  FROM  GoodsObjectlist WHERE OwnerLogin = '{0}' AND  ItemID = '{1}'", Login, _value);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["ItemUID"].ToString());
            }
            else
            {
                return 0;
            }
        }

        public static void Execute_UpdateQuantity(string Login, int _value, int quantity, uint itemuid)
        {
            //UPDATE GoodsObjectList SET [Quantity] = '29'WHERE OwnerLogin = 'admin1' AND ItemID = '102030' AND ItemUID = '25'
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectList SET Quantity = '{0}' WHERE OwnerLogin = '{1}' AND ItemID = '{2}' AND ItemUID = '{3}'", quantity, Login, _value, itemuid);
        }

        public static void Execute_UpdateQuantityGacha(string Login, uint _value, int quantity, uint itemuid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE GoodsObjectlist SET  Quantity = '{0}' WHERE OwnerLogin = '{1}' AND ItemID = '{2}' AND ItemUID = '{3}'", quantity, Login, _value, itemuid);
        }

        public static void Execute_UpdateLifeBonus(int loginid, int value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "UPDATE   users SET LifeBonusPoint = '{0}' WHERE LoginUID = '{1}'", value, loginid);
        }

        public static int Execute_SelectVirtualPoint(int loginid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT VCPoint  FROM  VCGAVirtualCash WHERE LoginUID = '{0}'", loginid);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["VCPoint"].ToString());
            }
            return 0;
        }

        public static int Execute_SelectPriceByItemID(int ItemID)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT Price  FROM  goodsinfolist WHERE GoodsID = '{0}'", ItemID);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Price"].ToString());
            }
            return 0;
        }

        public static int Execute_SelectKindByItemID(int ItemID)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT Kind  FROM  goodsinfolist WHERE GoodsID = '{0}'", ItemID);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Kind"].ToString());
            }
            return 0;
        }

        public static int Execute_CheckGuildExists(string _GuildName)
        {
            if (_GuildName.Length < 2 || _GuildName.Length > 20)
                return 1;
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT * FROM  GuildInfo WHERE Name = '{0}'", _GuildName);
            if (Query.Tables[0].Rows.Count > 0)
            {
                if (_GuildName.Contains("~"))
                    return 5;
                return 6;
            }
            return 0;
        }

        public static int Execute_CheckGuildExists(uint _guildid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT * FROM  GuildInfo WHERE Guildid = '{0}'", _guildid);
            if (Query.Tables[0].Rows.Count == 0) return 6;

            return 0;
        }

        public static void Execute_VerifyGuilds()
        {
            GameServer.clearGuildList();
            DataSet Query = GameServer.Sql.Command("SELECT *  FROM  GuildInfo");
            for (int i = 0; i < Query.Tables[0].Rows.Count; i++)
            {
                GameServer.AddGuild
                    (
                        Convert.ToInt32(Query.Tables[0].Rows[i]["GuildId"].ToString()),
                    //"defaultmark.dds",
                        Query.Tables[0].Rows[i]["Mark"].ToString(),
                        Query.Tables[0].Rows[i]["Name"].ToString(),
                    //"hiro",
                        Query.Tables[0].Rows[i]["Master"].ToString(),
                    //"00:00:00",
                        Query.Tables[0].Rows[i]["RegDate"].ToString(),
                        Convert.ToInt32(Query.Tables[0].Rows[i]["Point"].ToString()),
                    //"",
                        Query.Tables[0].Rows[i]["cafe_url"].ToString(),
                    //""
                        Query.Tables[0].Rows[i]["Explanation"].ToString()
                    );
            }
        }

        public static void Execute_SelectMembersforGuilds(int guildID)
        {
            try
            {
                int GuildPosition = -1;
                for (int i = 0; i < GameServer.GuildList.Count; i++)
                    if (GameServer.GuildList[i].Id == guildID)
                        GuildPosition = i;

                if (GuildPosition == -1)
                    return;

                DataSet data_0 = new DataSet();
                GameServer.Sql.Exec(data_0, "SELECT *  FROM  GuildUser WHERE GuildID = '{0}'", guildID);
                for (int i = 0; i < data_0.Tables[0].Rows.Count; i++)
                {
                    DataSet data_1 = GameServer.Sql.Command("SELECT *  FROM  users WHERE Login = '{0}'", data_0.Tables[0].Rows[i]["login"].ToString());
                    DataSet data_2 = GameServer.Sql.Command("SELECT Nick  FROM  Nicknames WHERE Login = '{0}'", data_0.Tables[0].Rows[i]["login"].ToString());

                    GameServer.AddMember(
                        GuildPosition,
                        data_1.Tables[0].Rows[i]["login"].ToString(),
                        data_2.Tables[0].Rows[i]["Nick"].ToString(),
                        Convert.ToInt32(data_1.Tables[0].Rows[i]["LoginUID"].ToString())
                        );
                }
            }
            catch (Exception e)
            {
                Log.Write("\n{0}\n\n", e.ToString());
            }
        }

        public static void Execute_InsertGuildInfo(string _name, string _master, string _explanation, string _email, string _cafe_url)
        {
            DataSet data_0 = new DataSet();
            GameServer.Sql.Exec(data_0, "INSERT INTO GuildInfo([Name],[Master],[Explanation],[Email],[cafe_url],[NumMembers]) VALUES ('{0}','{1}','{2}','{3}','{4}','0')", _name, _master, _explanation, _email, _cafe_url);

            DataSet data_1 = new DataSet();
            GameServer.Sql.Exec(data_1, "SELECT GuildID  FROM  GuildInfo WHERE Name = '{0}'", _name);

            Execute_InsertGuildUserInfo(_master, Convert.ToUInt32(data_1.Tables[0].Rows[0]["GuildID"].ToString()), 5);
        }

        public static void Execute_InsertGuildUserInfo(string _login, uint _guildId, int _userLevel)
        {
            DataSet data_0 = new DataSet();
            GameServer.Sql.Exec(data_0, "INSERT INTO GuildUser([Login],[GuildId],[UserLevel])VALUES('{0}','{1}','{2}')", _login, _guildId, _userLevel);

            DataSet data1 = new DataSet();
            GameServer.Sql.Exec(data1, "UPDATE GuildInfo SET NumMembers = [NumMembers]+1 Where GuildID = '{0}'", _guildId);
        }

        public static void Execute_GetGuildInfo(Session player)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT guildID  FROM  GuildUser WHERE login = '{0}'", player.Account.Login);
            if (Query.Tables[0].Rows.Count > 0)
            {
                player.GuildInfo.userGuild.guildidid = Convert.ToInt32(Query.Tables[0].Rows[0]["guildID"].ToString());
                DataSet Query0 = new DataSet();
                GameServer.Sql.Exec(Query0, "SELECT *  FROM  GuildInfo WHERE GuildId = '{0}'", player.GuildInfo.userGuild.guildidid);
                if (Query0.Tables[0].Rows.Count > 0)
                {
                    player.GuildInfo.userGuild.guildname = Query0.Tables[0].Rows[0]["Name"].ToString();
                    player.GuildInfo.userGuild.guildimage = Query0.Tables[0].Rows[0]["Mark"].ToString();
                }
                if (player.GuildInfo.userGuild.guildimage == null)
                {
                    player.GuildInfo.userGuild.guildimage = "defaultmark.dds";
                }
            }
        }

        internal static void Execute_VerifyStages(Session player)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT * FROM  UGGAUserGameClear WHERE LoginUID = '{0}' ORDER BY ModeID ASC", player.Account.AccountID);
            if (Query.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < Query.Tables[0].Rows.Count; i++)
                {
                    player.StagesCount.ChargeStages(Convert.ToInt32(Query.Tables[0].Rows[i]["ModeID"].ToString()), Convert.ToByte(Query.Tables[0].Rows[i]["DificutyLV1"].ToString()), Convert.ToByte(Query.Tables[0].Rows[i]["DificutyLV2"].ToString()), Convert.ToByte(Query.Tables[0].Rows[i]["DificutyLV3"].ToString()));
                }
            }
            else
            {
                player.StagesCount.ChargeStages(7, 1, 1, 1);
            }
        }


        internal static void VerifyGameClear(Session player, int StageID, byte Lv1, byte Lv2, byte Lv3)
        {
            DataSet NewQuery0 = new DataSet();
            GameServer.Sql.Exec(NewQuery0, "SELECT * FROM UGGAUserGameClear WHERE ModeID = '{0}' AND LoginUID ='{1}'", StageID, player.Account.AccountID);
            if (NewQuery0.Tables[0].Rows.Count == 0)
            {
                DataSet NewQuery = new DataSet();
                GameServer.Sql.Exec(NewQuery, "INSERT INTO UGGAUserGameClear (  LoginUID,  ModeID,  DificutyLV1,  DificutyLV2,  DificutyLV3) VALUES  (    '{0}',    '{1}',    '{2}',    '{3}',    '{4}'  )", player.Account.AccountID, StageID, Lv1, Lv2, Lv3);
                player.StagesCount.AddStage(player.Account.AccountID, StageID, Lv1, Lv2, Lv3);
            }
        }

        internal static void InsertPet(int playerid, uint PetID, uint PetUID, string PetName)
        {
            DataSet NewQuery = new DataSet();
            GameServer.Sql.Exec(NewQuery, "INSERT INTO GPet (PetUID,LoginUID,PetID,PetName) VALUES ('{0}', '{1}', '{2}', '{3}')", PetUID, playerid, PetID, PetName);
        }

        internal static void SetCharacterPet(Session player, int PetID, int PetUID, string PetName, int CharacterID)
        {
            DataSet UpdateQuery = new DataSet();
            GameServer.Sql.Exec(UpdateQuery, "UPDATE  characters SET  PetID = '{0}' WHERE Login = '{1}'  AND CharType = '{2}'", PetUID, player.Account.Login, CharacterID);
        }

        internal static void RemovePet0(Session player, int CharacterID)
        {
            DataSet UpdateQuery = new DataSet();
            GameServer.Sql.Exec(UpdateQuery, "UPDATE  characters SET  PetID = '0' WHERE Login = '{0}'   AND CharType = '{1}'", player.Account.Login, CharacterID);
        }

        public static void Execute_SelectCalendar(Session user, ushort year, byte month)
        {
            user.Account.AttendancePoints.Clear();
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT * FROM  calendar WHERE id = '{0}' AND year = '{1}' AND month = '{2}' ORDER BY day ASC", user.Account.AccountID, year, month);
            if (Query.Tables[0].Rows.Count > 0)
            {
                for (int x = 0; x < Query.Tables[0].Rows.Count; x++)
                {
                    user.Account.AttendancePoints.Add
                        (
                            new sCalendar()
                            {
                                Day = Convert.ToInt32(Query.Tables[0].Rows[x]["day"].ToString()),
                                Month = Convert.ToInt32(Query.Tables[0].Rows[x]["month"].ToString()),
                                type = Convert.ToInt32(Query.Tables[0].Rows[x]["type"].ToString()),
                            }
                        );
                }
            }
        }

        public static void Execute_UpdateCalendar()
        {
            DataSet data = GameServer.Sql.Command("Exec UpdateCalendarNew");
        }

        public static void Update_DiaryPoint(Session player, ushort year, byte month, byte day, byte type)
        {
            DataSet UpdateQuery = new DataSet();
            GameServer.Sql.Exec(UpdateQuery, "UPDATE   calendar SET  type = '{0}' WHERE id = '{1}' AND year = '{2}' AND month = '{3}' AND day = '{4}'", type, player.Account.AccountID, year, month, day);
        }

        public static void Insert_DiaryPoint(Session player, ushort year, byte month, byte day, byte type)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "INSERT INTO calendar (id, year, month, day, type) VALUES  ('{0}', '{1}', '{2}', '{3}', '{4}') ", player.Account.AccountID, year, month, day, type);
        }

        public static void Additensdepot(int LoginUID, uint ItemID, uint ItemUID, int Quantity, byte Character)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "INSERT INTO Depot (LoginUID,ItemID, ItemUID, Quantity, Character) VALUES ('{0}','{1}','{2}','{3}','{4}')", LoginUID, ItemID, ItemUID, Quantity, Character);

        }

        public static void DepotRemove(int LoginUID, uint ItemID)
        {
            DataSet query = new DataSet();
            GameServer.Sql.Exec(query, "Delete from Depot WHERE LoginUID = '{0}' AND ItemID = '{1}'", LoginUID, ItemID);

        }

        public static int Execute_SelectDiaryPoints(int loginid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT Point  FROM  GPointBag WHERE LoginUID = '{0}'", loginid);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Point"].ToString());
            }
            return 0;
        }

        public static void Execute_UpdatePlayerTimer(int timer, int id)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "UPDATE Users SET playTime = '{0}' WHERE LoginUID = '{1}'", timer, id);
        }

        public static void Execute_ResetCalendar()
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "UPDATE Users SET playTime = '0'");

            DataSet data1 = new DataSet();
            GameServer.Sql.Exec(data1, "UPDATE Calendar SET Type = '3' WHERE Type = '2'");
        }

        public static void Execute_UpdatePeriod()
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT Period FROM GoodsObjectlist");
            for (int x = 0; x < Query.Tables.Count; x++)
            {
                if (Convert.ToInt32(Query.Tables[0].Rows[x]["Period"].ToString()) != -1 && Convert.ToInt32(Query.Tables[0].Rows[x]["Period"].ToString()) != 0)
                {
                    DataSet query1 = new DataSet();
                    GameServer.Sql.Exec(query1, "UPDATE GoodsObjectlist SET Period ='{0}' WHERE Period = '{1}'", Convert.ToInt32(Query.Tables[0].Rows[x]["Period"].ToString()) - 1, Convert.ToInt32(Query.Tables[0].Rows[x]["Period"].ToString()));
                }
                DataSet query0 = new DataSet();
                GameServer.Sql.Exec(query0, "DELETE FROM GoodsObjectlist WHERE Period = '0'");
            }
        }

        public static int SelectKind(uint _goodsid)
        {
            DataSet data =
                GameServer.Sql.Command("SELECT Kind FROM GoodsInfoList WHERE GoodsID = '{0}'", _goodsid);

            if (GameServer.Sql.TotalRows(data) > 0)
                return GameServer.Sql.ColumInt32(data, "Kind", 0);
            return 0;
        }

        public static int SelectKind(int _goodsid)
        {
            DataSet data =
                GameServer.Sql.Command("SELECT Kind FROM GoodsInfoList WHERE GoodsID = '{0}'", _goodsid);

            if (GameServer.Sql.TotalRows(data) > 0)
                return GameServer.Sql.ColumInt32(data, "Kind", 0);
            return 0;
        }

        public static int SelectType(uint _goodsid)
        {
            DataSet data =
                GameServer.Sql.Command("SELECT ItemType FROM GoodsInfoList WHERE GoodsID = '{0}'", _goodsid);

            if (GameServer.Sql.TotalRows(data) > 0)
                return GameServer.Sql.ColumInt32(data, "ItemType", 0);
            return 0;
        }

        public static int SelectType(int _goodsid)
        {
            DataSet data =
                GameServer.Sql.Command("SELECT ItemType FROM GoodsInfoList WHERE GoodsID = '{0}'", _goodsid);

            if (GameServer.Sql.TotalRows(data) > 0)
                return GameServer.Sql.ColumInt32(data, "ItemType", 0);
            return 0;
        }

        public static int Execute_SelectCash(int loginid)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT CashPoint  FROM users  WHERE LoginUID = '{0}'", loginid);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["CashPoint"].ToString());
            }
            return 0;
        }

        public static int SelectItemDepot(int LoginID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT ItemID FROM WarehouseS4 WHERE LoginUID = '{0}'", LoginID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["ItemID"].ToString());
            }
            return 0;
        }

        public static int SelectItemUIDDepot(int LoginID, int ItemID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT ItemUID FROM WarehouseS4 WHERE LoginUID = '{0}' and ItemID = '{1}' ", LoginID, ItemID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["ItemUID"].ToString());
            }
            return 0;
        }

        public static int SelectQuantityDepot(int LoginID, int ItemUID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT Quantity FROM WarehouseS4 WHERE LoginUID = '{0}' and ItemUID ='{1}'", LoginID, ItemUID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["Quantity"].ToString());
            }
            return 0;
        }

        public static byte SelectStrongLevelDepot(int LoginID, int ItemUID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT StrongLevel FROM WarehouseS4 WHERE LoginUID = '{0}' and ItemUID ='{1}'", LoginID, ItemUID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToByte(data.Tables[0].Rows[0]["StrongLevel"].ToString());
            }
            return 0;
        }

        public static byte SelectGradeIDDepot(int LoginID, int ItemUID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT Grade FROM WarehouseS4 WHERE LoginUID = '{0}' and ItemUID ='{1}'", LoginID, ItemUID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToByte(data.Tables[0].Rows[0]["Grade"].ToString());
            }
            return 0;
        }

        public static int SelectSlotCountS4(int LoginID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT SlotCount FROM WarehouseInfoS4 WHERE LoginUID = '{0}'", LoginID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["SlotCount"].ToString());
            }
            return 0;
        }

        public static int SelectItensCount(int LoginID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT COUNT (LoginUID) as total FROM WarehouseS4", LoginID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["total"].ToString());
            }
            return 0;
        }

        public static void Execute_RecargaLife(int loginid, int Quantity)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "UPDATE users SET LifeBonusPoint = LifeBonusPoint + '{0}' WHERE loginuid = '{1}'", Quantity, loginid);
        }

        public static int SelectReviveCount(string Login)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT Quantity from  GoodsObjectlist WHERE BuyerLogin ='{0}' and ItemID = '71440'", Login);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["Quantity"].ToString());
            }
            return 0;
        }

        public static int SelectQuantityDiary(uint value)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT Factor FROM  GPointBagItemList WHERE ItemID = '{0}'", value);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["Factor"].ToString());
            }
            return 0;
        }

        public static int Execute_selectCurrentBonus(int Login)
        {
            DataSet Query = new DataSet();
            GameServer.Sql.Exec(Query, "SELECT LifeBonusPoint FROM users WHERE LoginUID = '{0}'", Login);
            if (Query.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(Query.Tables[0].Rows[0]["LifeBonusPoint"].ToString());
            }
            return 0;
        }

        public static void Execute_ExtendInventory(int value, int loginid)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "UPDATE GInventoryInfo  SET Size = Size + '{0}' WHERE loginuid = '{1}'", value, loginid);
        }

        public static uint GetGuildUID
        {
            get
            {
                DataSet data =
                    GameServer.Sql.Command("SELECT GuildId FROM GuildInfo");
                if (GameServer.Sql.TotalRows(data) > 0)
                {
                    return
                        GameServer.Sql.ColumUInt32(data, "GuildId", GameServer.Sql.TotalRows(data) - 1) + 1;
                }
                return 1;
            }
        }

        public static int Execute_SelectItemID(string Login, uint ItemUID)
        {
            DataSet data = new DataSet();
            GameServer.Sql.Exec(data, "SELECT ItemID FROM GoodsObjectlist WHERE OwnerLogin = '{0}' and ItemUID = '{1}' ", Login, ItemUID);
            if (data.Tables[0].Rows.Count > 0)
            {
                return Convert.ToInt32(data.Tables[0].Rows[0]["ItemID"].ToString());
            }
            return 0;
        }

        public static void Execute_UpdateUsersNumIncrement(short port)
        {
            DataSet data = GameServer.Sql.Command("UPDATE ConnectStatusDB SET UserNum = UserNum + 1 WHERE ServerPort = '{0}'", port);
        }

        public static void Execute_UpdateUsersNumDecrement(short port)
        {
            DataSet data = GameServer.Sql.Command("UPDATE ConnectStatusDB SET UserNum = UserNum - 1 WHERE ServerPort = '{0}'", port);
        }
    }
}
