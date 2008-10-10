From: Fabio M. Di Nitto <fdinitto@redhat.com>
Date: Fri, 10 Oct 2008 06:53:45 +0200
Subject: [Ocfs2-devel] Cluster Summit Report
Message-ID: <1223614425.18797.17.camel@daitarn-fedora.int.fabbione.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

The general feeling was that the Cluster Summit was a very good
experience for everybody and that the amount of work done during those
3 days would have taken months on normal communication media. Of the 3
days schedule only 2 and half were required as the people have been way
more efficient than expected. A lot of the pre-scheduled discussions
have been dropped in a natural fashion as they were absorbed, discussed
or deprecated at the source into other talks. People, coming from
different environments with different experience and use cases, made a
huge difference.

While we did discuss to a greater level of technical details, this is a
short summary of what will happen (in no particular order):

Tree's splitting:
- This item should be first and last at the same time.
  As a consequence of what has been decided, almost all trees will need
  to be divided and reorganized differently.
  As an example, RedHat specific bits will remain in one tree, while
  common components (such as dlm and fencing+fencing agents) will leave 
  in their own separate projects.
  Details of the split are still to be determined. Low hanging fruits
  will be done first (gnbd and gfs* for example).

- We discussed using clusterlabs.org as the go-to page for users,
  listing the versions of the latest (stable) components from all
  sources. The openSUSE Build Service could then be used as a hosting
  provider for this "community distro".

- For the heartbeat tree, all that will eventually remain in it is the
  heartbeat "cluster infrastructure layer" (can't drop for backwards
  compatibility for a while).

- Eventually some core libraries will migrate into corosync.

- fabbione to coordinate the splitting.

- lmb will coordinate the Linux-HA split and help with the build service
  stuff (if we go ahead with that).

Standard fencing:
- fencing daemon, libraries and agents will be merged (from RedHat and
  heartbeat) into two new projects (so that agents can be released
  independently from the daemon/libs).

- fencing project will grow a simulator for regression testing (honza). 
  The simulator will be a simple set of scripts that collect outputs 
  from all known fencing devices and pass them back to the agents to 
  test functionalities. While not perfect, it will still allow to do 
  basic regression testing. We discussed this in terms of rewriting the 
  RAs as simple python classes, which would interact with the world 
  through IO abstractions (which would then be easy to capture/replay).

- honzaf will write up an ABI/API for the agents which merges both
  functionalities and features.

- Possibly agents will need to be rewritten/re-factored as part of the
  merge; some of the C plug-ins might become python classes etc

- lmb, dejan, honza and dct to work on it.

Release time lines:
- As the trees will merge and split into separate projects, RM's will
  coordinate effort to make sure the new work will be available as 
  modular as possible.

- All releases will be available in neutral area for users to download 
  in one shot as discussed previously.

Standard logging:
- Everybody to standardize on logsys.

- The log recorder is worth mentioning here - buffering debug logging so
  that it can be dumped (retroactively) when a fault is encountered.
  Very useful feature.

- heartbeat has a hb_report feature to gather logs, configurations, 
  stack traces from core dumps etc from all cluster nodes, that'll be 
  extended over time to support all this too

- New features will be required in logsys to improve the user 
  experience.

Init scripts:
- agreed that all init scripts shipped from upstream need to be LSB 
  compliant and work in a distribution independent way. Users should 
  not need to care when installing from our tarballs.

- With portable packages, any differences should be hidden in there.

Packaging from upstream:
- in order to speed up adoption, our plan is to ship .spec and debian/
  packaging format directly from upstream and with support from   
  packagers. This will greatly reduce the time of propagation from 
  upstream release into users that do not like installing manually.
  Packages can be built using the openSUSE build service to avoid 
  requirement on new infrastructure.

Standard quorum service:
- Chrissie to implement the service within corosync/openais.

- API has been discussed and explained in depth.

Standard configuration:
- New stack will standardize on CIB (from pacemaker). CIB is approx. a 
  ccsd on steroids.

- fabbione to look into CIB, and port libccs to libcib.

- chrissie to port LDAP loader to CIB.

Common shell scripting library for RA's:
- Agreed to merge and review all RA's. This is a natural step as 
  rgmanager will be deprecated.

- lon and dejan to work on it.

Clustered Samba:
- More detailed investigation required but the short line is that 
  performance testing are required.

- Might require RA.

- Investigate benefit from infiniband.

- Nice to see samba integrated with corosync/openais.

Split site:
- There are 2 main scenarios for split site:
  - Metropolitan Area Clusters: "low" latency, redundancy affordable
  - Wide Area Clusters: high latency, expensive redundancy

  Each case has different problematic s (as latency and speed of the
  links). We will start tackling "remote" and only service/application 
  fail-over. Data Replication will come later as users will demand it.

- lmb to write the code for the "3rd site quorum" service tied into 
  pacemaker resource dependency framework.

- Identified need for some additional RAs to coordinate routing/address
  resolution switch-over; interfacing with routing protocols
  (BGP4/OSPF/etc) and DNS.

Misc:

- corosync release cycles
  - "Flatiron" to be released in time for February (+ Wilson/openAIS)
  - Need to understand effects of RDMA versus IP over infiniband

- openSharedRoot presentation
  - Lots of unsolved issues, mostly related to clunky CDSL emulation,
    and the need to bring up significant portions of the stack before
    mounting root

- NTT:
  - Raised lots of issues about supportability too
  - NTT will drive a stonith agent which works nicely with crashdumps 
    too
