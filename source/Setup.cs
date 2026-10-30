using System;
using System.IO;
using System.Drawing;
using System.Windows.Forms;
using System.Runtime.InteropServices;
internal static class Setup {
 [DllImport("user32.dll")]static extern bool SetProcessDPIAware();
 [STAThread]static void Main(){SetProcessDPIAware();Application.EnableVisualStyles();Application.SetCompatibleTextRenderingDefault(false);Application.Run(new SetupForm());}
}
internal sealed class SetupForm:Form {
 TextBox folder,status;ComboBox modes;NumericUpDown width,height;Button install,undo;
 internal SetupForm(){Text="The Wolf Among Us Remastered — Ultrawide Fix 0.1.0";ClientSize=new Size(710,460);Font=new Font("Segoe UI",10);FormBorderStyle=FormBorderStyle.FixedDialog;MaximizeBox=false;StartPosition=FormStartPosition.CenterScreen;
  Controls.Add(new Label{Text="Ultrawide Fix",Font=new Font(Font.FontFamily,17,FontStyle.Bold),AutoSize=true,Location=new Point(22,18)});
  Controls.Add(new Label{Text="For the supported Windows build only. 3440×1440 is player-tested; other modes are trials.",AutoSize=true,Location=new Point(24,61)});
  Controls.Add(new Label{Text="Game folder",AutoSize=true,Location=new Point(24,100)});folder=new TextBox{Location=new Point(24,124),Size=new Size(558,27)};Controls.Add(folder);
  var browse=new Button{Text="Browse…",Location=new Point(592,122),Size=new Size(92,30)};browse.Click+=(s,e)=>{using(var b=new FolderBrowserDialog()){b.Description="Select the folder containing TheWolfAmongUsRemastered.exe";if(Directory.Exists(folder.Text))b.SelectedPath=folder.Text;if(b.ShowDialog(this)==DialogResult.OK)folder.Text=b.SelectedPath;}};Controls.Add(browse);
  string here=AppDomain.CurrentDomain.BaseDirectory;folder.Text=File.Exists(Path.Combine(here,Ultrawide.Exe))?here:Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),"Steam","steamapps","common","The Wolf Among Us Remastered");
  var display=Screen.PrimaryScreen.Bounds;Controls.Add(new Label{Text="Primary display detected: "+display.Width+" × "+display.Height,AutoSize=true,Location=new Point(24,170)});
  modes=new ComboBox{DropDownStyle=ComboBoxStyle.DropDownList,Location=new Point(24,200),Size=new Size(350,28)};modes.Items.AddRange(new object[]{"2560 × 1080 — untested","3440 × 1440 — player-tested","3840 × 1600 — untested","5120 × 1440 — experimental 32:9","Custom / detected display"});Controls.Add(modes);
  width=new NumericUpDown{Minimum=800,Maximum=16384,Value=Math.Max(800,Math.Min(16384,display.Width)),Location=new Point(392,201),Size=new Size(122,27)};height=new NumericUpDown{Minimum=600,Maximum=8640,Value=Math.Max(600,Math.Min(8640,display.Height)),Location=new Point(550,201),Size=new Size(122,27)};Controls.Add(width);Controls.Add(height);Controls.Add(new Label{Text="×",AutoSize=true,Location=new Point(526,204)});
  modes.SelectedIndexChanged+=(s,e)=>{int[][] p={new[]{2560,1080},new[]{3440,1440},new[]{3840,1600},new[]{5120,1440}};bool custom=modes.SelectedIndex==4;width.Enabled=height.Enabled=custom;if(!custom){width.Value=p[modes.SelectedIndex][0];height.Value=p[modes.SelectedIndex][1];}};modes.SelectedIndex=4;
  Controls.Add(new Label{Text="Setup adds these presets and your chosen custom mode to the game's resolution list.\r\nAfter installation, choose a resolution supported by your monitor inside the game.",AutoSize=true,Location=new Point(24,247)});
  install=new Button{Text="Install / update",Location=new Point(24,301),Size=new Size(170,36)};undo=new Button{Text="Undo setup changes",Location=new Point(208,301),Size=new Size(190,36)};install.Click+=(s,e)=>Run(false);undo.Click+=(s,e)=>Run(true);Controls.Add(install);Controls.Add(undo);
  status=new TextBox{Multiline=true,ReadOnly=true,ScrollBars=ScrollBars.Vertical,Location=new Point(24,353),Size=new Size(660,83),Text="Close the game before installing or undoing. Existing saves and preferences are preserved."};Controls.Add(status);
 }
 void Run(bool restore){install.Enabled=undo.Enabled=false;UseWaitCursor=true;try{status.Text=restore?Ultrawide.Undo(folder.Text):Ultrawide.Apply(folder.Text,(int)width.Value,(int)height.Value);}catch(Exception ex){status.Text="Setup could not complete: "+ex.Message;MessageBox.Show(this,ex.Message,"Ultrawide Fix",MessageBoxButtons.OK,MessageBoxIcon.Information);}finally{UseWaitCursor=false;install.Enabled=undo.Enabled=true;}}
}
