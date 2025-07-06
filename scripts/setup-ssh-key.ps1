$KeyName = "devops-key"
$KeyPath = "$HOME\.ssh\$KeyName"

# Create .ssh folder if missing
if (!(Test-Path "$HOME\.ssh")) {
    New-Item -ItemType Directory -Path "$HOME\.ssh" | Out-Null
}

# Generate key if not exists
if (!(Test-Path "$KeyPath")) {
    Write-Host "Generating SSH key..."
    ssh-keygen -t rsa -b 2048 -f "$KeyPath" -N ""
} else {
    Write-Host "SSH key already exists at $KeyPath"
}

# Upload to AWS
Write-Host "Uploading key to AWS..."
aws ec2 import-key-pair `
    --key-name $KeyName `
    --public-key-material "fileb://$KeyPath.pub" `
    --query 'KeyName' --output text

Write-Host "SSH key setup completed"
