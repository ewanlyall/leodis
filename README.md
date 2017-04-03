Scenario
========
The University of Leodis runs a farm of Apache web servers behind a load
balancer, which acts as the frontend to their entire online estate, including
the Undergraduate Course prospectus, Student VLE and Staff Email. The Web team
are continuously frustrated by the time taken by the System Administration team
to make simple Apache configuration updates; and after years of undocumented
tweaks and hacks, the System Administrators are reluctant to make any sizeable
changes to it.

Make rapid, repeatable changes to the web tier. In order to allow the Web
developers to implement additional Apache configuration changes in a timely
manner. As a platform engineer I need to have a mechanism to easily apply the
changes to the servers in any environment.

Acceptance Criteria
- Flaws with the existing server setup are highlighted
- Tool produced to restore the servers into a satisfactory state
  (i.e. fix the issues), and handle future Apache configuration changes

Further implementation notes
- You may use any configuration management frameworks/tools as you see fit
- The code must be idempotent
- The code must check for and report errors
- The code should meet the requirements and be able to support future extension
- Consider how you might test that your changes have not affected functionality

Assumptions you can make. The backend in the proxypass statements have been
modified for the purpose of this tech test. Modifying the backend is out of
scope for this test.

Flaws with the Existing Environment
===================================
A number of flaws have been identified with the existing web server environment,
highlighted below, with a brief explanantion as to the recommended course of
action:
1. The server is running Ubuntu 12.04.5 LTS. Ubuntu 12.04 reaches end of life
  in April 2017 and will no longer receive updates after that date (see
    https://www.ubuntu.com/info/release-end-of-life)
   - Recommendation - Rather than performing an in-place distribution upgrade,
  use the included chef cookbooks to provision a new server running the latest
  Ubuntu 16.04 LTS distribution. It will likely be faster than upgrading
  in-place, presents less risk and will generate a server of a known good
  configuration.
2. There's a large number of missing updates, including security patches and the
version of Apache itself is old.
   - Recommendation - Ensure system is patched up to date. Again, this is a
   risky operation on a system that is so out of date, my recommendation would
   be to deploy a new server from the latest machine image and provision with
   chef.
3. The Apache service is running as the root user. This poses a risk if the
web server service becomes compromised.
   - Recommendation - The apache service should be run as an un-priveledged
   user.
4. The Apache server root directory has mode 777. Again, this poses a security
risk as it grants all users on the server read, write and execute access to this
directory.
   - Recommendation - Directory permissions should be more restrictive.
5. No firewall enabled. A firewall should be used to limit access to only the
specified ports.
   - Recommendation - Enable and configure the UFW firewall to prevent access to
  all ports except 22 (ssh) and 80 (http)

Other Assumptions
=================
- Good security practice doesn't end with the server configuration. For example,
correct network configuration, including public and private subnets,
appropriate ACLs and/or security groups and so on.

- SSL should be enabled on the load-balancer in front of the web server farm.
This is preferable to enabling SSL on each host due to the resource overheads.

- Individual user accounts should be used with public key authentication for
ssh access to the server, rather than using a shared ssh private key for all
users.

- The code used to generate the node.js application (`app.js`) which runs the
backend service should be stored in source control and be subject to it's own
suite of unit tests. Application code and other binaries should not be stored in
chef, rather pulled directly from source control or a repository such as
artifactory. *Outside the scope of this scenario.*

Usage
=====
Testing
-------
To run the Inspec tests, from the `cookbooks/webserver` directory, run the
following:
```
kitchen test
```
This will start an Ubuntu 12.04.5 Vagrant VM, use chef zero to provision it then
perform the tests as per `tests/smoke/default/*.rb`.
