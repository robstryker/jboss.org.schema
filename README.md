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

There are currently 3 jenkins jobs:

1) jboss.org.schema-production  -  rsync down from web server and check for changes. If it finds some, it commits to production branch

2) jboss.org.schema-Pull-Request - Will check out the PR branch, make sure 'production' is up to date (or fail if not), and verify the PR *can* be merged

3) jboss.org.schema-productionToWeb - responds to changes in 'production' branch and attempts to rsync these changes up to the web server

Before merging any PR, it is important to first make sure jboss.org.schema-production runs in case someone else has updated the remote web server in the interim since the PR was approved.  Once jboss.org.schema-production runs successfully, you can merge in the PR.  The jboss.org.schema-productionToWeb will respond to the change and rsync back up to web server


