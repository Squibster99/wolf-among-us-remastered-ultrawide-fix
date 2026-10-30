using System;
using System.IO;
using System.Runtime.InteropServices;
public static class UltrawidePowerShell {
 public static void Initialize(string folder){Ultrawide.DataDirectory=Path.GetFullPath(folder);}
 public static string Install(string game,int width,int height){return Ultrawide.Apply(game,width,height);}
 public static string Undo(string game){return Ultrawide.Undo(game);}
 public static string Check(string game){string path=Path.Combine(game,Ultrawide.Exe);if(!File.Exists(path))throw new Exception("Game executable not found in that folder.");string hash=Ultrawide.Hash(File.ReadAllBytes(path));if(hash==Ultrawide.Original)return "Supported original executable. Ready to install.";if(hash==Ultrawide.Patched)return "Supported executable; the ultrawide rendering correction is already present.";throw new Exception("Unsupported or otherwise modified executable. No changes made.");}
 [StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] struct Mode {
  [MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)]public string Device;
  public ushort Spec,Driver,Size,Extra;public uint Fields;public int X,Y;public uint Orientation,Fixed;
  public short Color,Duplex,YResolution,TTOption,Collate;
  [MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)]public string Form;
  public ushort LogPixels;public uint Bits,Width,Height,Flags,Frequency,ICMMethod,ICMIntent,Media,Dither,Reserved1,Reserved2,PanWidth,PanHeight;
 }
 [DllImport("user32.dll",CharSet=CharSet.Unicode)]static extern bool EnumDisplaySettings(string device,int mode,ref Mode output);
 public static int[] Display(){var m=new Mode();m.Size=(ushort)Marshal.SizeOf(typeof(Mode));return EnumDisplaySettings(null,-1,ref m)?new[]{(int)m.Width,(int)m.Height}:new[]{0,0};}
}
