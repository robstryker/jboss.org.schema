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

There are currently two separate jobs proposed. The first will handle PRs, validate that 
the repository is in sync with the expected state of the server, and otherwise assist 
in making sure the PR is usable. 

The second will handle the merging of the data to upstream jboss.org/schema server. 


