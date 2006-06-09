From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 8 Jun 2006 21:08:24 -0700
Subject: [Ocfs2-devel] Extended Attribute Support?
In-Reply-To: <355a4e960606072143q11e8a055vef0dca48b423a4bc@mail.gmail.com>
References: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
	<20060607164519.GM3082@ca-server1.us.oracle.com>
	<355a4e960606071747n7ae0ea88u8a1d155586c85fe9@mail.gmail.com>
	<20060608034600.GO3082@ca-server1.us.oracle.com>
	<355a4e960606072143q11e8a055vef0dca48b423a4bc@mail.gmail.com>
Message-ID: <20060609040824.GT3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 07, 2006 at 09:43:47PM -0700, EKC wrote:
> I have a fourteen node cluster of dual dual-core opterons with local
> SATA disks that I was using for Lustre. My plan is to use aoe with
> DRBD mirroring between pairs of nodes (each node has two disks) for
> OCFS2.
Ok, so what's the maximum node count per shared disk here? 2 or 14? Either
value is easily within the range of what we test with here. Total nodes in
the cluster shouldn't really your performance.

> I am using the cluster to distribute the load for self-contained
> database-backed (mysql, Berkeley db, and o_append/mmap flat-file
> "databases") applications, each of which is hosted in its own vserver.
So one thing we don't support yet is shared writeable mmap. It looks like we
might have that going soon though, as David Howells has a patch in -mm which
makes that alot easier to implement in OCFS2.

> This use case becomes complicated because I need to quickly "clone"
> vservers. I've looked at layering unionfs or cowloop ontop of a
> cluster fs. However, my preference is to use vserver's COW support
> (hard-link two files and flag them as 'immutable' and 'unlink'; break
> the link and copy the files on write,chmod,chown).
After having read the vserver home page, their COW support seems promising,
but I'm unaware of how they implement that so I couldn't comment on OCFS2
interaction.

> My compute and storage needs are closely correlated. Filesystem reads
> dominate (80%) over writes. Directories are shared between nodes only
> in COW cases. Metadata operations and read/writes have a a lot of
> spatial locality. Cache coherency becomes an issue with the COW
> (hardlinking) requirement.
Ok, so mostly reads and with COW, writes look like they'll be mostly node
local. This is an optimum load for OCFS2 as you will not have many inodes
which have to be passed between nodes.

So taking into account node numbers and your expected load it seems like you
probably have a fair chance of making that work, assuming we get those
features you're missing.

Well, you certainly have an interesting use case, and I hope that OCFS2 can
accomodate your needs.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
