node('master') {

  
    stage('prep') {
        sh '''
		        sudo su
                        sudo mkdir -p /home/inspector-code
			cd /home/inspector-code
			sudo git clone https://github.com/Shrashthi/Inspector.git
			cd Inspector/
            sudo chmod -R 755 /home/clone/Inspector/
            sudo terraform --version
            sudo terraform init
        '''
    }

    stage('plan') {
        sh '''
            
            cd /home/inspector-code/Inspector
            
            sudo export AWS_DEFAULT_REGION=us-east-1
			
            sudo terraform plan -out terraform.tfplan -input=false
        '''
    }

    stage('apply') {
        sh '''
            
           
            terraform apply terraform.tfplan
        '''
    }


}
