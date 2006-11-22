From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Nov 22 17:26:07 2006
Subject: [Ocfs2-devel] Local FS mount
In-Reply-To: <4564DF42.2010905@oracle.com>
References: <4564DF42.2010905@oracle.com>
Message-ID: <20061123012604.GJ26014@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 22, 2006 at 03:37:38PM -0800, Sunil Mushran wrote:
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/LocalMount

Hey all,
	Sunil and I just had a discussion on the process of mounting a
"local" filesystem, and I had a couple of thoughts and concerns that I'd
love input on.
	Before we get to local mounts, a little recap on how it works in
a cluster:

  1) mount learns, via -t, fstab, or blkid, that this is an ocfs2
     filesystem and calls mount.ocfs2
  2) mount.ocfs2 reads the superblock and validates the thing
  3) mount.ocfs2 starts the heartbeat
  4) mount.ocfs2 calls sys_mount(2)
  5) ocfs2_fill_super() notices that the heartbeat is running and goes
     about its business

	Ok, and here's how local mounts happen:

  1) mount learns, via -t, fstab, or blkid, that this is an ocfs2
     filesystem and calls mount.ocfs2
  2) mount.ocfs2 reads the superblock and notices the INCOMAT flag for
     local mounts
  3) mount.ocfs2 does NOT start heartbeat
  4) mount.ocfs2 calls sys_mount(2)
  5) ocfs2_fill_super() notices the INCOMPAT flag and doesn't worry
     about checking the heartbeat

	Sunil was bothered by something, though.  There was no way to
determine if an existing mount was local.  So he added a ghost mount
option:

  1) mount learns, via -t, fstab, or blkid, that this is an ocfs2
     filesystem and calls mount.ocfs2
  2) mount.ocfs2 reads the superblock and notices the INCOMAT flag for
     local mounts
  3) mount.ocfs2 does NOT start heartbeat
  4) mount.ocfs2 adds "mount=local" to the options list
  5) mount.ocfs2 calls sys_mount(2) with the additional option
  6) ocfs2_fill_super() notices the INCOMPAT flag and validates it
     against the "mount=local" option.  It still doesn't worry
     about checking the heartbeat

This ghost mount option appears in the output of /proc/mounts and calls
to mount(8) with no arguments.  This allows the user to see "hey, it's a
local mount!"
	This bothered me for two reasons.  First, a "magic" option that
the user never specified is a bit "dirty".  There ought to be a better
way.  More importantly, though, there is no difference to the user that
they tried to mount a local filesystem.  They didn't specify it, so they
may expect it to work clustered.  Or, they may be expecting a local
filesystem, but it is actually a clustered one.
	The point is, the automation took it out of the user's hands
completely, but without obvious notification and/or recourse if it is
the wrong thing.
	My first proposal was to create a new "ocfs2local" fstype.  It
would be a simple register_filesystem, and we'd now have two
fill_super() calls:

    ocfs2_fill_super_real(...., int local);
    ocfs2_fill_super_cluster(....)
    {
        ocfs2_fill_super_real(...., 0);
    }
    ocfs2_fill_super_local(....)
    {
        ocfs2_fill_super_real(...., 1);
    }
    ocfs2_get_sb_cluster(....)
    {
        return get_sb_bdev(...., ocfs2_fill_super_cluster)
    }
    ocfs2_get_sb_local(....)
    {
        return get_sb_bdev(...., ocfs2_fill_super_local)
    }
    ocfs2_fstype = {
        .name = "ocfs2"
        .get_sb = ocfs2_get_sb_cluster
    }
    ocfs2local_fstype = {
        .name = "ocfs2local"
        .get_sb = ocfs2_get_sb_local
    }

	With this setup, the ocfs2_fill_super_real() call can just
switch on the "local" argument.  It can validate it against the INCOMPAT
flag.  Very little kernel code change other than the prototypes I've
defined above.
	This solves Sunil's listing problem, because local mounts show
"ocfs2local" for the fstype in /proc/mounts.
	This solves my "user must be declaritive" delimma, because the
user must say "mount -t ocfs2local" now.  If the user says "mount -t
ocfs2" for a local filesystem, it will fail to mount.  If they say
"mount -t ocfs2local" for a clustered filesystem, it will fail to mount.
Yay, that's cool.
	Oh, bother.  If they don't specify "-t" at all, blkid will still
identify an ocfs2 filesystem and call mount.ocfs2.  Which will now fail.
Oh, wait, that's not bad.  We just need a newer blkid that sees the
INCOMPAT flag and tries to mount an ocfs2local filesystem.
	We then noted that much the same behavior can be driven by
making the user specify Sunil's "-o mount=local" option.  That is,
instead of automatically filling in this ghost option in mount.ocfs2, we
can require the user specify it ("mount -t ocfs2 -o mount=local").
Then, if it isn't passed, the mount can fail.  Similar, though not
identical, behavior to my fstype proposal.
	The biggest drawback to either proposal is that we do require
the user to specify something new on the mount command line.  We don't
automatically pick for them.  I think that's a good thing, because it
help people understand the situation, but it does add complexity and
support questions and so on.  Can we think of a better way to make it
declaritive?  Can we come up with an automated scheme that will never be
contrary to what the user expected?
	If we leave the automation, we will of course field the opposite
support calls.  And we still haven't solved the "preventing two nodes
from mounting a local-only filesystem at the same time" problem.  That's
why I worry.  If the user has to expressly ask for local-only, they are
less likely to think they are mounting a cluster filesystem when they do
it on two nodes.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
