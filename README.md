<h1> Summary </h1>
This bicep template creates 
- vnet 
- seperate subnet for web, db and vm 

<h1> How it works </h1>

login to azure account using below command 

<code> az login </code>

execute below command to create resource. main.bicep is the main module to run and parameters.json is the paramter file to pass 

<code> az deployment sub create -f .\main.bicep -p parameters.json -l eastus </code>

<h1> Refer related links </h1>

https://github.com/amtkmr1990/bicep_webapp_template

https://github.com/amtkmr1990/bicep_VM_template

https://github.com/amtkmr1990/bicep_azuresqldb_template
