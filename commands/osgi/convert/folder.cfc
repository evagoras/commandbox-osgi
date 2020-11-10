component {

	/**
	 * Converts all the JAR files in the folder into their OSGi equivalent.
	 * This is how you call it:
	 * 
	 * {code:bash}
	 * osgi convert folder path=<folder_path> bundleName=com.company.project bundleVersion=1.0.0
	 * {code}
	 * 
	 * @path.hint The JAR file to be converted
	 * @bundleName.hint The OSGi Bundle Name, like 'com.company.project'
	 * @bundleVersion.hint The version of the OSGi bundle, like '1.0.0'
	 * @recurse.hint Recurse down the directory path for nested JARs
	 * 
	 */
	function run(
		required string path,
		required string bundleName,
		required string bundleVersion,
		boolean recurse = false
	) {
		/**
		 * Get a directory list of all JARs in the folder, deep lookup or not.
		 * For each JAR call the file converter.
		 * Update the Progress Bar at the end of each JAR conversion.
		 * 
		 */
		var userFolderPath = resolvePath(arguments.path);
		var currentDirectory = getCWD();
		jars = directoryList(path = userFolderPath, filter = "*.jar", recurse = arguments.recurse, listInfo = "path");
		var totalJarCount = arrayLen(jars);
		var conversionErrors = 0;
		var conversionSuccesses = 0;
		print.line()
			.line(totalJarCount & " JARs to convert:")
			.line()
			.toConsole();
		for (var i = 1; i <= totalJarCount; i++) {
			job.start(jars[i]);
			job.addLog("Processing...");
			try {
				command("osgi convert file")
					.params(
						path = jars[i],
						bundleName = arguments.bundleName,
						bundleVersion = arguments.bundleVersion,
						output = false
					)
					.run(returnOutput = true);
				conversionSuccesses++;
				job.complete();
			} catch (any e) {
				conversionErrors++;
				job.error("Error: " & e.message);
			}
		}
		command("cd " & currentDirectory).run(returnOutput = true);
		print.line()
			.boldText("Results:")
			.line()
			.indentedBlueLine("Successes: " & conversionSuccesses)
			.indentedRedLine("Failures:  " & conversionErrors);
	}

}