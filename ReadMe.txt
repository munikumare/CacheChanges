************************PROCESS************************************
Navigate to the DiffSample Folder using GitBash

Change the name of src-reg -> src
****
Run command "ant CIValidate" in GitBash
	- The target will run and generate a "deploy" folder a 
	  "deploy.zip" folder and a cache.properties file.
	- The first time running this means it will generate a copy of your src folder.
	  After that it will just create a folder with only the files that have changed
****
Rename src -> src-reg
Rename src-UAT -> src
****
run command "ant CIValidate" in GitBash
	- This will effectivly diff the two folders and create a deploy folder of just the
	  the diffrent files between the orgs

In order to run validation you need to update the build.properties file with your login information
