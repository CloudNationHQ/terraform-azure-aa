This deploys private endpoint for automation accounts

## Notes

The private endpoint is created by this module itself; an additional module is used for the private dns zone.

Currently, there’s no dedicated subresource or private endpoint support solely for cloud-based runbooks. Therefore it's tied to the subresource DSCAndHybridWorker.
