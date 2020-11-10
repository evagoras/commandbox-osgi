# commandbox-osgi
This is a ForgeBox CommandBox module for converting JARs into named and versioned OSGi bundle compatible JARs.

## Install the command locally through CommandBox
```
install commandbox-osgi
```

## Uninstall the command locally through CommandBox
```
uninstall commandbox-osgi
```

## Requirements
The project needs the Java JDK installed on your computer and two Path variables defined in your Windows Environment. On my PC they are:
```
JAVA_HOME = C:\Program Files\Java\jdk1.8.0_231
Path += %JAVA_HOME%\bin
```

## Converting files
The path to the file can be relative or absolute. The bundle name and version can be anything you like.
```
osgi convert file path=gson-2.8.5.jar bundleName=com.mycompany.myproject bundleVersion=1.0.0
```
Based on the docs, you can then use your bundle in CFML. Currently this only works with Lucee, Adobe might add it for their 2020 release.
```
createObject( "java", "com.google.gson.GsonBuilder", "com.mycompany.myproject", "1.0.0" );
```

## Converting folders
You can either use an absolute or relative location for the folder. The `resurse` attribute is for processing JARs in nested folders. Example:
```
osgi convert folder path=C:\dev\sites\abc\lib bundleName=com.mycompany.myproject bundleVersion=1.0.0 recurse=true
```
