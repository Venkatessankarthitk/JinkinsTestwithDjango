#!groovy

node {

    try {
        stage 'Checkout'
            checkout scm

            sh 'git log HEAD^..HEAD --pretty="%h %an - %s" > GIT_CHANGES'
            def lastChanges = readFile('GIT_CHANGES')
            

        stage 'Test'
            sh 'virtualenv env -p python3.5'
            sh '. env/bin/activate'
            sh 'env/bin/pip install -r requirements.txt'
            sh 'env/bin/python3.5 manage.py test'

        stage 'Deploy'
            sh './deployment/deploy_prod.sh'

    }

    catch (err) {
        

        throw err
    }

}
