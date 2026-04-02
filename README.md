## Handling SSH Keys

To securely handle SSH keys for deployment, generate a new key pair, upload the Private Key to your Bitbucket repository under Pipelines > SSH Keys, 
and add the corresponding Public Key to the ~/.ssh/authorized_keys file for the deployment user on the EC2 instance. Finally, define the EC2 host address
securely as a Deployment Variable (e.g., $$Flow_Server_IP) in Bitbucket settings, allowing the atlassian/ssh-run pipe to connect without exposing credentials 
in the repository
