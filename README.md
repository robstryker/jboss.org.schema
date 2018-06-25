## Summary

The jboss.org.schema GitHub repository is meant to provide a front-end interface for changes to schema 
belonging to JBoss, WildFly, EAP, or any other related technology, who needs to keep online schema up to date. 

This repository will help keep track of what changes were made, where the schema were pulled from 
(for example, what release of what product), and who made them. 

## Updating a schema

To update a schema, clone this repository and make the changes that you require. Then, simply submit a 
pull request on this repository. Jenkins jobs will investigate the pull request and make sure it will
merge cleanly with the expected state of jboss.org/schema. 

Commit messages should indicate where these changes are coming from. It is likely that most such changes
will be coming from a final release of some project or product. On occasion, however, it is possible some 
important backwards-compatible schema bug-fixes may be applicable for update even when the product 
has not yet been released. 

Care should be taken not to update the schema in such a way that existing runtimes using the schema may fail
to parse xml files targeting the new updated schema. 

## Jenkins Job

There are currently 3 jenkins jobs. They all seem broken or disabled. See below for manual instructions

1) jboss.org.schema-production  -  rsync down from web server and check for changes. If it finds some, it commits to production branch

2) jboss.org.schema-Pull-Request - Will check out the PR branch, make sure 'production' is up to date (or fail if not), and verify the PR *can* be merged

3) jboss.org.schema-productionToWeb - responds to changes in 'production' branch and attempts to rsync these changes up to the web server

Before merging any PR, it is important to first make sure jboss.org.schema-production runs in case someone else has updated the remote web server in the interim since the PR was approved.  Once jboss.org.schema-production runs successfully, you can merge in the PR.  The jboss.org.schema-productionToWeb will respond to the change and rsync back up to web server


## Manual steps
    WILDFLYLOC=/home/rob/apps/jboss/unzipped/wildfly-13.0.0.Final.zip.expanded/
    
    git clone 	git@github.com:robstryker/jboss.org.schema.git
    git clone       git@github.com:jbosstools/jbosstools-server.git
    
    
    cd jboss.org.schema/schema_htdocs
    SCHEMAHTDOCS=`pwd`
    rsync -rv --protocol=28 --exclude '.*/' --delete 'schema@filemgmt.jboss.org:/schema_htdocs/*' .
    git add -A && git commit -m "Update from remote webserver to git backup" --signoff
    
    cd ../../
    cd jbosstools-server/as/plugins/org.jboss.tools.as.catalog/
    CATALOGBUNDLE=`pwd`
    mvn clean install
    cd target/classes
    
    
    java  -Djboss.tools.as.catalog.plugin.directory.root=$CATALOGBUNDLE   org.jboss.tools.as.catalog.internal.CopyReleasedSchemaToJBossOrg  $WILDFLYLOC/docs/schema $SCHEMAHTDOCS jbossas
    
    cd ../../../../../../jboss.org.schema/schema_htdocs/
    git add -A && git commit -m "Update latest wildfly release" --signoff
    
    # Push this up to the server
    # We need to push up each folder individually, because our users don't have write permissions to the root folder
    
    for d in $(find . -mindepth 1 -maxdepth 1 -type d); do 
      cd ${d}
      echo beginning rsync for ${d}
      rsync -rut --rsh=ssh --protocol=28 . schema@filemgmt.jboss.org:/schema_htdocs/${d}/ --delete -vv
      # fail with exit code 1 if the rsync fails
      if [[ $? != 0 ]]; then 
        echo "RSYNC FAIL"; exit 1
      fi
      cd ../
    done
    
