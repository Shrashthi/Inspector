node('master') {

  
    stage('prep') {
        sh '''
		    mkdir /home/inspector-code
			cd /home/inspector-code
			git clone https://github.com/Shrashthi/Inspector.git
			cd Inspector/
            chmod -R 755 /home/clone/Inspector/
            terraform --version
            terraform init
        '''
    }

    stage('plan') {
        sh '''
            
            cd /home/clone/Inspector/
            
            export AWS_DEFAULT_REGION=us-east-1
			
            terraform plan -out terraform.tfplan -input=false
        '''
    }

    stage('apply') {
        sh '''
            
           
            terraform apply terraform.tfplan
        '''
    }


    catch (e) {
        currentBuild.result = "FAILURE"
        throw e

    } finally {
        result = currentBuild.result ?: "SUCCESS"
        previousResult = currentBuild.previousBuild?.result
    }
}
