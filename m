From: EKC <webmaster@generalsynthesis.com>
Date: Wed, 7 Jun 2006 21:43:47 -0700
Subject: [Ocfs2-devel] Extended Attribute Support?
In-Reply-To: <20060608034600.GO3082@ca-server1.us.oracle.com>
References: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
	<20060607164519.GM3082@ca-server1.us.oracle.com>
	<355a4e960606071747n7ae0ea88u8a1d155586c85fe9@mail.gmail.com>
	<20060608034600.GO3082@ca-server1.us.oracle.com>
Message-ID: <355a4e960606072143q11e8a055vef0dca48b423a4bc@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I'm using a mainline kernel (2.6.16.20) that I've patched to support
Linux Vserver (http://www.linux-vserver.org). However, Linux Vserver
has some unsatisfied dependencies on extended attributes (to enable
copy-on-write, chroot-like jails, and disk quotas), so my plan is to
patch OCFS2 to enable support for linux vserver.

I have a fourteen node cluster of dual dual-core opterons with local
SATA disks that I was using for Lustre. My plan is to use aoe with
DRBD mirroring between pairs of nodes (each node has two disks) for
OCFS2.

I am using the cluster to distribute the load for self-contained
database-backed (mysql, Berkeley db, and o_append/mmap flat-file
"databases") applications, each of which is hosted in its own vserver.
If a node dies or resources become available elsewhere, the vserver is
shutdown on one node and launched on the other. Vserver instances
cannot run on more than one node at a time. The cluster FS is used to
enable this migration of vservers from one node to another.

This use case becomes complicated because I need to quickly "clone"
vservers. I've looked at layering unionfs or cowloop ontop of a
cluster fs. However, my preference is to use vserver's COW support
(hard-link two files and flag them as 'immutable' and 'unlink'; break
the link and copy the files on write,chmod,chown).

My compute and storage needs are closely correlated. Filesystem reads
dominate (80%) over writes. Directories are shared between nodes only
in COW cases. Metadata operations and read/writes have a a lot of
spatial locality. Cache coherency becomes an issue with the COW
(hardlinking) requirement.

If I can find a way to quickly "clone" vserver directories without
COW, this whole thing becomes much simpler. Each vserver basically a
1gb linux installation under one directory. I'm using two-port bonded
gigabit ethernet on a single cross-bar with jumbo (9k) frames between
nodes; and, dedicated cross-over gigabit ethernet between DRBD pairs.

On 6/7/06, Mark Fasheh <mark.fasheh@oracle.com> wrote:
> On Wed, Jun 07, 2006 at 06:47:13PM -0600, EKC wrote:
> > Speaking of Lustre, how does OCFS2 compare in terms of scalability?
> I'm no Lustre expert, so please take what I say with a grain of salt :) That
> said, Lustre seems to like to exist at the very high end of things -
> thousands of nodes where OCFS2 is much more limited.
>
> > My understanding of OCFS2 is that it is limited to a maximum of 254
> > cluster nodes. However, most of the OCFS2 documentation that I've read
> > uses node slots per volume in the single digits. Are there any
> > practical limitations to using 254 node slots per volume on OCFS2, and
> > creating an OCFS2 cluster with 254 nodes (each node with 254 volumes
> > mounted on it)?
> We test regularly on 16 node clusters here at Oracle. You would be correct
> however that the majority of usage we see is on the tens of nodes scale. As
> far as practical limitations to scaling, I think it may depend on your
> usage. What is your intended application for the cluster? Also, I'm curious
> as to what your shared storage will reside on.
>
> Off the top of my head, issues that might arise in a large cluster could be
> disk heartbeat overhead, lock mastery, and if you're doing lots of
> concurrent meta data updates to shared directories/files you would incur a
> performance hit as the meta data is synced to disk.
>
> > Since OCFS2 doesn't provide a unified namespace amongst volumes, I
> > would like to be able to mount the same volume across all of my
> > cluster nodes (up to 254). OCFS2 is attractive because of how clean
> > the code is, and its inclusion in the mainline kernel.
> Well thanks for the kind words regarding our code :) By the way, would you
> be using mainline kernels, or something provided by a distribution vendor
> (i.e., SUSE, Red Hat, etc)
>         --Mark
>
> --
> Mark Fasheh
> Senior Software Developer, Oracle
> mark.fasheh at oracle.com
>
>
