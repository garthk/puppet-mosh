Puppet module for [Mosh].

## Installation

    cd /etc/puppet/modules
    git clone git://github.com/garthk/puppet-mosh mosh

## Usage

    include mosh

The class will:

* Perform `apt-get update`
* Install `python-software-properties` for `add-apt-repository`
* Add [ppa:keithw/mosh] to your `apt` sources via a file in
  `/etc/apt/sources.list.d`
* Import [Keith's key][7BF6DFCD] from `keyserver.ubuntu.com`
* Perform `apt-get update` again
* Install `language-pack-en-base`
* Install [Mosh]

[7BF6DFCD]: http://keyserver.ubuntu.com:11371/pks/lookup?search=0xF2923D3F37FEF230BDDC376E3EB9326A7BF6DFCD&op=index
[ppa:keithw/mosh]: https://launchpad.net/~keithw/+archive/mosh

**WARNING:** You might think of installing `language-pack-en-base` as
damage if you prefer your servers speaking another language. See
"Help Wanted", below.

## Testing:

### Smoke Testing

* `make test` or `make smoke` to perform a simple [smoke test]

### Vagrant

* Install [Mosh] and [Vagrant]

* Get the `lucid32` box (safe even if you already have it):

        vagrant box add lucid32 http://files.vagrantup.com/lucid32.box

* Launch the virtual machine:

        vagrant up
        vagrant ssh

* Once at the `vagrant@mosh:~$` prompt:

        LANG=en_US.UTF-8 mosh-server

* Note the port and key after the `MOSH CONNECT` line, which might be:

        MOSH CONNECT 60001 RandomLookingKey

* Back on your local machine, run `mosh-client` with the correct key and
  port, e.g.:

        MOSH_KEY=RandomLookingKey mosh-client 192.168.31.44 60001

## Help Wanted

Please [get in touch](http://twitter.com/garthk) if you find any way to
either:

* Enable `LANG=en_US.UTF-8` without instlling `language-pack-en-base`
* `vagrant ssh -c "LANG=en_US.UTF-8 mosh-server"` without it responding
  with `ioctl TIOCGWINSZ: Invalid argument`
* Add an `-F configfile` argument to `mosh`, to be passed through to `ssh`
* In general, get `mosh` working with `vagrant ssh` so the procedure
  above isn't so torturous

[Mosh]: http://mosh.mit.edu/
[Vagrant]: http://vagrantup.com/
[smoke test]: http://docs.puppetlabs.com/guides/tests_smoke.html
[get in touch]: http://twitter.com/garthk
