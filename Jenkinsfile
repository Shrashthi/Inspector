node('master') {

  
    stage('prep') {
        sh '''
                        sudo mkdir -p /home/inspector-code
			cd /home/inspector-code
			sudo git clone https://github.com/Shrashthi/Inspector.git
			cd Inspector/
            sudo chmod -R 755 /home/inspector-code/Inspector
            sudo terraform --version
            sudo terraform init
        '''
    }

    stage('plan') {
        sh '''
            
            cd /home/inspector-code/Inspector
            
			
            sudo terraform plan -out terraform.tfplan -input=false
            sudo chmod -R 755 /home/inspector-code/Inspector
        '''
    }

    stage('apply') {
        sh '''
            
           sudo cd /home/inspector-code/Inspector/
           sudo terraform apply -auto-approve "terraform.tfplan"
        '''
    }


}
