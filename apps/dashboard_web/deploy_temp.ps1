$server = "58.238.37.52"
$user = "admin"
$pass = "KiSaN)@@@)$&"
$remotePath = "/home/iscan/Kisan/A31_Reco/iScanKeeper"

Write-Host "Uploading..."
$secpass = ConvertTo-SecureString -String $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user, $secpass)

# Upload file
scp dashboard_standalone.tar.gz "$user@$server`:$remotePath/"

# Deploy
ssh "$user@$server" "cd $remotePath && tar -xzf dashboard_standalone.tar.gz && cp -r .next/static .next/standalone/.next/ && cp -r public .next/standalone/ && cd .next/standalone && pm2 delete dashboard-web 2>/dev/null `|`| true && PORT=60500 HOSTNAME=0.0.0.0 pm2 start server.js --name 'dashboard-web' && pm2 save"

Write-Host "Done"
