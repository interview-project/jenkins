import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

String keyfile = "/tmp/key"

Credentials githubUser = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,'9e271867-3858-42c8-823b-2fc4691bf223', "Github User", "interview-project-user", "interview-project-user1")
Credentials nexusUser = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,'9e271867-3858-42c8-823b-2fc4691bf223', "Nexus User", "admin", "admin123")
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), nexusUser)
