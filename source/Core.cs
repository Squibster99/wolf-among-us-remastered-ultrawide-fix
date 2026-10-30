using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Security.Cryptography;
using System.Diagnostics;
using System.Xml.Linq;
using BlowFishCS;

internal static class Ultrawide {
 internal const string Original="e8cedcf34066760e480689d44964dc5596f5585c77a19a2627786a8163a65616",Patched="460b789149554cf31dfbef60b16cf503a7afd19a3b3f1f79a6bd119b4821a615",Exe="TheWolfAmongUsRemastered.exe",Archive="Fables_pc_Ultrawide_ar_all.ttarch2",Descriptor="_resdesc_50_Ultrawide.lua",Receipt="UltrawideFix.install.xml";
 const int Offset=0x818486;
 static byte[] Key={0x85,0xca,0x8f,0xa0,0x89,0xdf,0x64,0x73,0xa2,0xb2,0xd6,0xc6,0x9e,0xca,0xc6,0x88,0x99,0x5a,0x73,0xd8,0x9f,0xe1,0x9b,0xe2,0x96,0x51,0x9f,0x9b,0x9a,0xce,0xcd,0x99,0xd2,0x76,0x62,0x7f,0xa7,0xc4,0x9b,0xd8,0xda,0xe7,0xa9,0x9c,0x67,0x78,0xb3,0xd1,0xb1,0xc8,0x99,0x64,0xa0,0xa2,0x85};
 internal static string Hash(byte[] b){using(var h=SHA256.Create())return BitConverter.ToString(h.ComputeHash(b)).Replace("-","").ToLowerInvariant();}
 static byte[] Resource(string name){using(var s=Assembly.GetExecutingAssembly().GetManifestResourceStream(name)){if(s==null)throw new Exception("Missing setup resource: "+name);using(var m=new MemoryStream()){s.CopyTo(m);return m.ToArray();}}}
 internal static byte[] Code(int width,int height){
  if(width<800||height<600||width>16384||height>8640)throw new Exception("Choose a width from 800 to 16384 and a height from 600 to 8640.");
  byte[] input=Resource("template"),needle=Encoding.ASCII.GetBytes("CUSTOM_ULTRAWIDE_MODE");int at=-1;
  for(int i=4;i<=input.Length-needle.Length;i++){bool match=true;for(int j=0;j<needle.Length;j++)if(input[i+j]!=needle[j]){match=false;break;}if(match){if(at>=0)throw new Exception("Ambiguous template");at=i;}}
  if(at<4||BitConverter.ToUInt32(input,at-4)!=needle.Length+1||input[at+needle.Length]!=0)throw new Exception("Unsupported Lua template");
  byte[] mode=Encoding.ASCII.GetBytes(width+"x"+height);
  using(var m=new MemoryStream())using(var w=new BinaryWriter(m)){w.Write(input,0,at-4);w.Write(mode.Length+1);w.Write(mode);w.Write((byte)0);w.Write(input,at+needle.Length+1,input.Length-at-needle.Length-1);return m.ToArray();}
 }
 internal static byte[] Encrypt(byte[] code){var cipher=new BlowFish(Key,7).Crypt_ECB(code.Skip(4).ToArray(),7,false);var check=new BlowFish(Key,7).Crypt_ECB((byte[])cipher.Clone(),7,true);if(!check.SequenceEqual(code.Skip(4)))throw new Exception("Script verification failed");return new byte[]{27,76,69,110}.Concat(cipher).ToArray();}
 internal static byte[] Addon(int width,int height){byte[] script=Encrypt(Code(width,height)),name=Encoding.ASCII.GetBytes("Menu_settings.lua\0");using(var m=new MemoryStream())using(var w=new BinaryWriter(m)){
  w.Write(Encoding.ASCII.GetBytes("NCTT"));w.Write((ulong)(12+28+65536+script.Length));w.Write(Encoding.ASCII.GetBytes("4ATT"));w.Write(65536);w.Write(1);w.Write(0xe4c822402cd81ef5UL);w.Write(0UL);w.Write(script.Length);w.Write(0);w.Write((ushort)0);w.Write((ushort)0);w.Write(name);w.Write(new byte[65536-name.Length]);w.Write(script);return m.ToArray();}}
 internal static byte[] Patch(byte[] bytes,bool enable){string before=Hash(bytes);if(before!=Original&&before!=Patched)throw new Exception("This game executable is not the supported build. Nothing was installed. See README.txt.");byte[] result=(byte[])bytes.Clone();result[Offset]=(byte)(enable?0:1);if(Hash(result)!=(enable?Patched:Original))throw new Exception("Executable verification failed");return result;}
 static void Closed(){if(Process.GetProcessesByName("TheWolfAmongUsRemastered").Length!=0)throw new Exception("Close every The Wolf Among Us Remastered window before using setup.");}
 static string A(string game){return Path.Combine(game,"Archives",Archive);}static string D(string game){return Path.Combine(game,"Archives",Descriptor);}
 static byte[] ReadOptional(string file){return File.Exists(file)?File.ReadAllBytes(file):null;}
 static void Put(string path,byte[] data){if(data==null){if(File.Exists(path))File.Delete(path);}else File.WriteAllBytes(path,data);}
 static bool Active(XElement r){return r!=null&&(string)r.Attribute("active")=="true";}
 static void CheckFiles(string game,XElement r){if(Hash(File.ReadAllBytes(A(game)))!=(string)r.Element("archiveHash")||Hash(File.ReadAllBytes(D(game)))!=(string)r.Element("descriptorHash"))throw new Exception("The installed ultrawide files have changed. Setup will not overwrite them.");}
 static void WriteExe(string path,byte[] original,byte[] desired){if(original.SequenceEqual(desired))return;using(var f=new FileStream(path,FileMode.Open,FileAccess.ReadWrite,FileShare.Read)){byte[] now=new byte[f.Length];int n=0,t;while(n<now.Length&&(t=f.Read(now,n,now.Length-n))>0)n+=t;if(!now.SequenceEqual(original))throw new Exception("The executable changed during setup");f.Position=Offset;f.WriteByte(desired[Offset]);f.Flush(true);}if(Hash(File.ReadAllBytes(path))!=Hash(desired))throw new Exception("Executable readback failed");}
 internal static string Apply(string game,int width,int height,bool test=false){
  if(!test)Closed();game=Path.GetFullPath(game);string exe=Path.Combine(game,Exe);if(!File.Exists(exe)||!Directory.Exists(Path.Combine(game,"Archives")))throw new Exception("Choose the game folder containing "+Exe+" and Archives.");
  byte[] before=File.ReadAllBytes(exe),patched=Patch(before,true),archive=Addon(width,height),descriptor=Resource("descriptor");
  string receipt=Path.Combine(game,Receipt);XElement old=File.Exists(receipt)?XElement.Load(receipt):null;
  byte[] oldA=ReadOptional(A(game)),oldD=ReadOptional(D(game));string backup;
  if(Active(old)){CheckFiles(game,old);backup=(string)old.Element("backup");}
  else{
   if((oldA!=null&&Hash(oldA)!="9687c20ae4fb5f20f97753a1791bdcd5d135c29bb0009261a9df2b4768c4add5")||(oldD!=null&&Hash(oldD)!="338b43c27c9b06fef344cc41c2f9746b95e48e40fa3830978f88ac542788aab8"))throw new Exception("Other files already use this ultrawide addon's names. Remove or back up that version before using setup.");
   backup=Path.Combine(game,"UltrawideFix-backup-"+DateTime.Now.ToString("yyyyMMdd-HHmmss-fff"));Directory.CreateDirectory(backup);if(oldA!=null)File.WriteAllBytes(Path.Combine(backup,"archive.bin"),oldA);if(oldD!=null)File.WriteAllBytes(Path.Combine(backup,"descriptor.bin"),oldD);
  }
  var r=Active(old)?new XElement(old):new XElement("UltrawideFix",new XAttribute("active","true"),new XElement("beforeExe",Hash(before)),new XElement("backup",backup),new XElement("beforeArchive",oldA==null?"":Hash(oldA)),new XElement("beforeDescriptor",oldD==null?"":Hash(oldD)));
  r.SetAttributeValue("active","true");r.SetElementValue("archiveHash",Hash(archive));r.SetElementValue("descriptorHash",Hash(descriptor));r.SetElementValue("width",width);r.SetElementValue("height",height);r.SetElementValue("version","0.1.2");
  try{File.WriteAllBytes(A(game),archive);File.WriteAllBytes(D(game),descriptor);WriteExe(exe,before,patched);if(Hash(File.ReadAllBytes(A(game)))!=Hash(archive)||Hash(File.ReadAllBytes(D(game)))!=Hash(descriptor))throw new Exception("Addon readback failed");r.Save(receipt);}
  catch{Put(A(game),oldA);Put(D(game),oldD);byte[] now=File.ReadAllBytes(exe);if(Hash(now)==Patched&&Hash(before)==Original)WriteExe(exe,now,before);throw;}
  return "Installed. Start the game and choose "+width+"x"+height+" in Settings > Graphics.\r\nCommon presets are also available. Saves and other settings were not changed.";
 }
 internal static string Undo(string game,bool test=false){
  if(!test)Closed();game=Path.GetFullPath(game);string path=Path.Combine(game,Receipt);if(!File.Exists(path))throw new Exception("No installation receipt was found in this folder.");var r=XElement.Load(path);if(!Active(r))return "This setup installation has already been undone.";CheckFiles(game,r);
  string backup=Path.GetFullPath((string)r.Element("backup")),prefix=game.TrimEnd(Path.DirectorySeparatorChar)+Path.DirectorySeparatorChar;if(!backup.StartsWith(prefix,StringComparison.OrdinalIgnoreCase)||!Path.GetFileName(backup).StartsWith("UltrawideFix-backup-"))throw new Exception("Unexpected backup location");
  string prior=(string)r.Element("beforeExe");if(prior!=Original&&prior!=Patched)throw new Exception("Invalid receipt");string exe=Path.Combine(game,Exe);byte[] before=File.ReadAllBytes(exe),restore=Patch(before,prior==Patched);
  byte[] a=ReadOptional(Path.Combine(backup,"archive.bin")),d=ReadOptional(Path.Combine(backup,"descriptor.bin"));if((a==null?"":Hash(a))!=(string)r.Element("beforeArchive")||(d==null?"":Hash(d))!=(string)r.Element("beforeDescriptor"))throw new Exception("Backup files changed or are missing");
  byte[] currentA=File.ReadAllBytes(A(game)),currentD=File.ReadAllBytes(D(game));try{Put(A(game),a);Put(D(game),d);WriteExe(exe,before,restore);r.SetAttributeValue("active","false");r.Save(path);}catch{Put(A(game),currentA);Put(D(game),currentD);byte[] now=File.ReadAllBytes(exe);if(Hash(now)!=Hash(before))WriteExe(exe,now,before);throw;}
  return "Undone: the executable and ultrawide addon were restored to their state before this setup.\r\nBackups were retained. Your current saves and display preferences were preserved.";
 }
}
