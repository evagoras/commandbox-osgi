# commandbox-osgi
A CommandBox command for creating OSGi compatible JARs.

## Install the command locally
```
box install commandbox-osgi
```

## Converting files
```
asgi convert file path=gson-2.8.5.jar bundleName=com.mycompany.myproject bundleVersion=1.0.0
```
Based on the docs, you can then use your bundle in CFML:
```
createObject( "java", "com.google.gson.GsonBuilder", "com.mycompany.myproject", "1.0.0" );
```

## Converting folders
You can either use an absolute or relative location for the folder. Example:
```
asgi convert folder path=C:\dev\sites\abc\lib bundleName=com.mycompany.myproject bundleVersion=1.0.0 recurse=true
```
