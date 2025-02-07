# 1global
Deploy Infra 4 1Global

Steps to deploy a three vm infrtastrucutre on a vmware cluster:
- 1 server running nginx to proxy traffic from the port 80 to aanother server on port 5000
- 1 server running a simple rest application "Hello World" on port 5000
- 1 server running and also deploy a third server running mysql.

A Ubuntu template was previously create only with an user account, ubuntu

Each VM will have the network (IP, netmask, dns) configured during the deploy and will be accessed by ssh with user 1global.

vm1-nginx 10.150.190.190/24
vm2-app 10.150.190.191/24
vm3-db 10.150.190.192/24

Steps
on the shell run
1) sudo terraform init
2) sudo terraform plan
3) sudo terraform deploy
 
After a sucessful deploy it+s time to laod the ssh pub keys
   The pub keys are load on a git repo. Now run the following palybooks.
   The inventory file contains the information on the servers that ansible will need to connect.
   
1) ansible-playbook -i inventory.yaml ssh_key_setup.yaml
2) ansible-playbook -i inventory.yaml nginx.yaml
3) ansible-playbook -i inventory.yaml rest_api.yaml
4) ansible-playbook -i inventory.yaml mysql.yaml (it's going to fail because of an issue with the db access user creation)

After all the deploy are done you can access the reverse proxy to check if the rest app is responding
curl -I http://10.150.190.190

There is a long way to walk and there is a huge space to improve.

Thank you for the opportunity.

   
