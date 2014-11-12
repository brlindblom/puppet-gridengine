Puppet module for gridengine installation

Installation packages are assumed to come from EPEL.

Clients should inherit gridengine::execd
the server should inherit gridengine::qmaster

Module pulls the latest Son-of-GridEngine from Dave Love's Fedora copr repository

New server:

```puppet
node 'qmaster.example.com' {
  gridengine::qmaster {
    "$hostname":
      sgecell => default;
  }
}

...
node 'execd.example.com' {
  gridengine::execd {
    "qmaster.example.com":
      sgecell => default;
  }
}
```
