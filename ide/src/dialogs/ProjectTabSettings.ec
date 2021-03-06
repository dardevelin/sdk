import "Project"

class ProjectTab : Tab
{
   Project project;

   background = formColor;
   text = $"Project";

   Label labelModuleName { this, position = { 8, 8 }, labeledWindow = moduleName };
   EditBox moduleName
   {
      this, size = { 180, 22 }, position = { 8, 24 };
      text = $"Module Name", hotKey = altM;
      NotifyModified = ProjectControlModified;
   };
   
   Label lcompilerConfigsDir { this, position = { 8, 52 }, labeledWindow = compilerConfigsDir };
   PathBox compilerConfigsDir
   {
      this, size = { 210, 22 }, position = { 8, 68 };
      text = $"Compiler Configurations Directory", hotKey = altC;
      browseDialog = settingsFileDialog;
      NotifyModified = ProjectControlModified;
   };

   Label labelDescription { this, position = { 8, 96 }, labeledWindow = description };
   EditBox description
   {
      this, size = { 290, 100 }, anchor = { left = 8, top = 112, right = 8 };
      multiLine = true, hasVertScroll = true;
      text = $"Description", hotKey = altD;
      NotifyModified = ProjectControlModified;
   };

   Label labelLicense { this, position = { 8, 218 }, labeledWindow = license };
   EditBox license
   {
      this, size = { 290, 22 }, anchor = { left = 8, top = 236, right = 8, bottom = 8 };
      multiLine = true, hasVertScroll = true;
      text = $"License", hotKey = altL;
      NotifyModified = ProjectControlModified;
   };

   void SaveChanges()
   {
      if(description.modifiedDocument || license.modifiedDocument ||
            moduleName.modifiedDocument || compilerConfigsDir.modifiedDocument)
      {
         char * s;
         delete project.moduleName; project.moduleName = CopyString(moduleName.contents);
         project.description = s = description.multiLineContents; delete s;
         project.license = s = license.multiLineContents; delete s;
         project.compilerConfigsDir = compilerConfigsDir.path;
         
         project.topNode.modified = true;
         ide.projectView.modifiedDocument = true;
         ide.projectView.Update(null);
      }
   }

   bool ProjectControlModified(CommonControl control)
   {
      modifiedDocument = true;
      return true;
   }

   bool OnCreate()
   {
      moduleName.contents = project.moduleName;
      compilerConfigsDir.path = project.compilerConfigsDir;
      description.contents = project.description;
      license.contents = project.license;
      return true;
   }

   bool OnClose(bool parentClosing)
   {
      if(modifiedDocument)
      {
         DialogResult diagRes = MessageBox
         {
            type = yesNoCancel, master = ide,
            text = $"Save changes to project options?",
            contents = $"Would you like to save changes made to the project options?"
         }.Modal();
         if(diagRes == cancel)
            return false;
         if(diagRes == yes)
            SaveChanges();
         modifiedDocument = false;
      }
      return true;
   }
}
