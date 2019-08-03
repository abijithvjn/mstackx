# mstackx
Create aws account

      git clone https://github.com/abijithvjn/mstack.git

Create one key named "mstackx" and keep it in ansible directory

Create bucket to keep terraform state. 

Replace the bucketname in terraform "main.tf" file in resource folder 

Then a commit is required on top of this. ===SO THIS IS NOT REUSABLE BEFORE COMMIT===

      cd <repo-home>/ansible
      ansible-playbook playbook/local.yml
      
      
      
This will create all the aws resources and clone the repository to bastion host + install ansible in bastion host
 
 
      ansible-playbook playbook/everything.yml


Configure Jenkins
Configure Elasticsearch and Kibana
COnfigure Install kubernetes cluster
Create required namespaces
Install guestbook app from using helm chart
Install prometheus and grafana
Install filebeat inside  kubernetes to send logs to elasticsearch



