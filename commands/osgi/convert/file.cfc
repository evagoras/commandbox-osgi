component {

	/**
	 * Converts a JAR file into its OSGi equivalent.
	 * This is how you call it:
	 * 
	 * {code:bash}
	 * osgi convert file path=<file_path> bundleName=com.company.project bundleVersion=1.0.0
	 * {code}
	 * 
	 * @path.hint The JAR file to be converted
	 * @bundleName.hint The OSGi Bundle Name, like 'com.company.project'
	 * @bundleVersion.hint The version of the OSGi bundle, like '1.0.0'
	 * @output.hint Run with console output
	 * 
	 */
	function run(
		required string path,
		required string bundleName,
		required string bundleVersion,
		boolean output = true
	) {
		/**
		 * Expand the contents of the JAR file.
		 * Delete the meta-inf folder if there is one.
		 * Add a manifest.txt file with the properties you want, version and name.
		 * cd into the JAR contents folder.
		 * Run the jar command to create the new JAR.
		 */
		var userFilePath = resolvePath(arguments.path);
		var currentDirectory = getCWD();
		var originalFIleDirectory = getDirectoryFromPath(userFilePath);
		var originalFileWithExt = getFileFromPath( userFilePath );
		var originalFileName = listDeleteAt(originalFileWithExt, listLen(originalFileWithExt, "."), ".");
		command("cd " & originalFIleDirectory).run(returnOutput = true);
		var osgiPackageName = originalFileName & "-osgi";
		var osgiPackageFullPath = originalFIleDirectory & osgiPackageName;
		var osgiJarFullPath = originalFIleDirectory & osgiPackageName & ".jar";
		if (arguments.output == true) {
			print.line( "From file: " & userFilePath );
			print.line( "To file:   " & osgiJarFullPath );
			print.line( "Processing..." ).toConsole();
		}
		fileCopy(source = userFilePath, destination = osgiJarFullPath);
		var zipFileFullPath = originalFIleDirectory & osgiPackageName & ".zip";
		fileMove(source = osgiJarFullPath, destination = zipFileFullPath);
		directoryCreate(osgiPackageFullPath);
		cfzip(action = "unzip", destination = osgiPackageFullPath, file = zipFileFullPath);
		fileDelete(zipFileFullPath);
		command("cd " & osgiPackageFullPath).run(returnOutput = true);
		var metaInfFolder = osgiPackageFullPath & "\META-INF";
		if (directoryExists(metaInfFolder)) {
			directoryDelete(path=metaInfFolder, recurse=true);
		}
		var manifestFile = osgiPackageFullPath & "\manifest.txt";
		if (fileExists(manifestFile)) {
			fileDelete(manifestFile);
		}
		var manifestFileContent = "";
		savecontent variable="manifestFileContent" {
			writeOutput( "Bundle-SymbolicName: #arguments.bundleName#
Bundle-Version: #arguments.bundleVersion#
Bundle-Name: #arguments.bundleName#" );
		}
		fileWrite(filePath=manifestFile, data=manifestFileContent);
		command("!jar")
			.params("cvfm " & osgiPackageName & ".jar manifest.txt .")
			.run(returnOutput = true);
		command("cd " & originalFIleDirectory).run( returnOutput = true );
		fileMove(osgiPackageFullPath & "\" & osgiPackageName & ".jar", originalFIleDirectory);
		directoryDelete(path=osgiPackageFullPath, recurse=true);
		command("cd " & currentDirectory).run(returnOutput = true);
		if (arguments.output == true) {
			print.line("Finished");
		}
	}

}