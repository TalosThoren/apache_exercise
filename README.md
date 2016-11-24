# Chef Exercise

## Description

I've been tasked with the following [assignment](ASSIGNMENT.md). This can be
summarize as "create a cookbook which updates apache configurations on a
single-node rotation."

## Process

I'll document my process here. It's been some time since I've maintained a chef
workstation. When last we met, the chef development kit was the officially
endorsed environment for deploying a workstation. I installed and reacquainted
myself with it:

- [Chef DK](https://downloads.chef.io/chef-dk/)

I then began researching and reacquainting myself with chef best practices. I
drew upon the following resources, primarily:

- [Patterns to Follow](https://docs.chef.io/ruby.html#patterns-to-follow)
- [The Berkshelf Way](https://github.com/pulseenergy/chef-style-guide/blob/master/the_berkshelf_way)
- [Pulse Energy Styleguide](https://github.com/pulseenergy/chef-style-guide)

## User Story

### Value statement

An operator can update multiple apache servers without interrupting service
on more than one instance at a time.

### Acceptance Criteria

- Updates apache configuration successfully on each instance
- Ensures only one instance can be interrupted at any given moment in time
- Ensures updated configuration is loaded by apache

With our simple user story above, we can begin breaking down requirements to
accomplish the goal.

Some thoughts:

- The cookbook is not tasked with installing apache. If we're treating this "the
  berkshelf way" then we'll want to be able to run it independent of apache
  httpd server installation.
..1. This means we'll be providing a public interface for a wrapper cookbook to
    consume
..2. We'll probably want to ensure this only runs if necessary. Presumably we
    won't be running this if apache isn't installed, but we'll probably want to
    check that apache is running and directories are present.
..3. We'll want to conform to configuration standards enforced by standard
    upstream cookbooks that provide apache. It is reasonable to assume that our
    users will expect us to be compatible with the apache2 community cookbook.
- Each run will need to gather data about all available apache nodes. Each run
  needs to determine if another node is currently unavailable.

## Walk Through of Execution

What steps do we need to perform to accomplish this goal?

1. Check if any nodes are down (implemented with tags).
2. If not, add down-tag to current node.
3. Update configuration.
4. Reload (or restart if necessary) apache httpd.
5. Remove down-tag

## What should we test for?

Local tests should ensure configuration files exist as expected. We should
probably also test down-tag addition and removal. The following resource
discusses how to implement multi-node kitchen tests, which we'll use.

### Resources

- [Multinode Testing with Test-Kitchen](http://www.hurryupandwait.io/blog/multi-node-test-kitchen-tests-and-working-with-vagrant-nat-addressing-with-virtualbox)

## Implementation

The completed implementation is somewhat underwhelming. It provides a public
interface via the `files/default/apache2` directory. It provides a simple
default config in that directory for testing.

A test recipe exists to install apache2 on our test-kitchen instances. This
approach probably breaks best practices.

A second test recipe exists, as well as a test-kitchen instance configuration,
for creating a sentinel instance, which simply sets the down-tag. Unfortunately,
I learned that I made bad assumptions about local testing tools. The chef-zero
provider, which the "nodes" provider I am using relies upon, simply does not
return anything when searching tags. This breaks my intended test, and testing
must be rethought.

As the assignment says, however, we want a working solution now rather than a
perfect solution never.

I don't have the resources to test this on real infrastructure, presently, so
we'll have to suffice with a run of the test-kitchen instance. A log of that run
can be found [here](default-ubuntu-1404.log).
