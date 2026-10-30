using System;using System.IO;using System.Linq;using System.Text;using System.Reflection;using BlowFishCS;
internal static class FormatChecks {
 static void Check(bool value,string message){if(!value)throw new Exception(message);}
 static ulong CRC(string name){ulong c=0;foreach(byte b in Encoding.UTF8.GetBytes(name.ToLowerInvariant())){c^=(ulong)b<<56;for(int i=0;i<8;i++)c=(c<<1)^((c>>63)!=0?0x42f0e1eba9ea3693UL:0);}return c;}
 static int Main(string[] args){try{
  Directory.CreateDirectory(args[0]);var data=typeof(Ultrawide).GetField("DataDirectory",BindingFlags.NonPublic|BindingFlags.Static);if(data!=null)data.SetValue(null,Path.GetFullPath(args[1]));
  byte[] key=(byte[])typeof(Ultrawide).GetField("Key",BindingFlags.NonPublic|BindingFlags.Static).GetValue(null);
  foreach(var mode in new[]{new[]{2560,1080},new[]{3440,1440},new[]{3840,1600},new[]{5120,1440},new[]{3000,1250}}){
   byte[] code=Ultrawide.Code(mode[0],mode[1]),archive=Ultrawide.Addon(mode[0],mode[1]);
   Check(Encoding.ASCII.GetString(archive,0,4)=="NCTT"&&Encoding.ASCII.GetString(archive,12,4)=="4ATT","Archive markers");
   Check(BitConverter.ToUInt64(archive,4)==(ulong)(archive.Length-12)&&BitConverter.ToUInt32(archive,20)==1,"Directory size/count");
   Check(CRC("Menu_settings.lua")==0xe4c822402cd81ef5UL&&BitConverter.ToUInt64(archive,24)==CRC("Menu_settings.lua"),"Wrong engine filename identifier");
   Check(Encoding.ASCII.GetString(archive,52,18)=="Menu_settings.lua\0","Asset filename");
   int start=52+65536;byte[] payload=archive.Skip(start).ToArray();Check(payload.Take(4).SequenceEqual(new byte[]{27,76,69,110}),"Encrypted wrapper");
   Check(!payload.Skip(4).SequenceEqual(code.Skip(4)),"Plaintext incorrectly stored as encrypted Lua");
   byte[] body=new BlowFish(key,7).Crypt_ECB(payload.Skip(4).ToArray(),7,true),plain=new byte[]{27,76,117,97}.Concat(body).ToArray();
   Check(plain.SequenceEqual(code),"Final archive does not decrypt to generated Lua");
   Check(BitConverter.ToString(plain.Take(18).ToArray())=="1B-4C-75-61-52-00-01-04-04-04-04-00-19-93-0D-0A-1A-0A","Wrong engine Lua ABI");
   string stem=Path.Combine(args[0],mode[0]+"x"+mode[1]);File.WriteAllBytes(stem+".luac",plain);File.WriteAllBytes(stem+".ttarch2",archive);
  }Console.WriteLine("PASS: independent resource identifiers and final stored/decrypted Lua payloads for four presets and a custom mode.");return 0;
 }catch(Exception e){Console.Error.WriteLine(e);return 1;}}
}
