#!/bin/bash
yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Terraform Deployment</title>
<style>
body {
  background-color: #f4f4f4;
  font-family: Arial, sans-serif;
  text-align: center;
  padding-top: 100px;
}
h1 {
  color: #2E8B57;
  font-size: 40px;
}
p {
  color: #555;
  font-size: 18px;
}
.box {
  background: white;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  display: inline-block;
  padding: 30px 50px;
}
</style>
</head>
<body>
  <div class="box">
    <h1>Terraform Project</h1>
    <p>Successfully deployed using Terraform!</p>
  </div>
</body>
</html>