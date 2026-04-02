## Handling SSH Keys

To securely handle SSH keys for deployment, generate a new key pair, upload the Private Key to your Bitbucket repository under Pipelines > SSH Keys, 
and add the corresponding Public Key to the ~/.ssh/authorized_keys file for the deployment user on the EC2 instance. Finally, define the EC2 host address
securely as a Deployment Variable (e.g., $$Flow_Server_IP) in Bitbucket settings, allowing the atlassian/ssh-run pipe to connect without exposing credentials 
in the repository

Result of Pipeline run:
<img width="959" height="563" alt="image" src="https://github.com/user-attachments/assets/33db175a-9ace-4b64-ac7e-6b575ce3f7e7" />

<img width="959" height="565" alt="image" src="https://github.com/user-attachments/assets/4b7fa3b7-ab1d-4da0-b485-56754720c3e7" />
