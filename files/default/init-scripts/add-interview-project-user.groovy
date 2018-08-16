import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

String keyfile = "/tmp/key"

Credentials gitUser = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,'github', "Github User", "interview-project-user", "interview-project-user1")
Credentials nexusUser = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,'nexus', "Nexus User", "admin", "admin123")
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), gitUser)
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), nexusUser)
