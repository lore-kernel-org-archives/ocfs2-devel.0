From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Thu Jun 17 16:20:58 2004
Subject: [Ocfs2-devel] OCFS2 final on-disk format changes are going in
Message-ID: <20040617212054.GA1343@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

We just finished up the last of the work to change the on-disk format of
ocfs2 and we are about to move this from the branch into trunk in svn.
We tried very hard to make every conceivable change that we would want
in this last pass so that this would be the final on-disk change.

What this means for any of you who are tracking this project is that you
will need to reformat before picking up the most current ocfs2.  The
ocfs-tools svn package has been split into "ocfs" and "ocfs2"
subdirectories, so just "svn update" that package and you will see the
new userland mkfs2.  We will be coming out with new versions of the rest
of the tools shortly, so these aren't final.  The mkfs2 that is there is
in a fairly rough state, meaning it won't warn you if you try to format
a mounted device, or warn you if the cluster size you choose is so small
that bitmap operations are unbearably slow, so just be careful.

The only upcoming on-disk change that we forsee at this point is to do a
last pass of le##_to_cpu/cpu_to_le## macros around everything in user
and kernel.  As of this release, we actually seem to work on 2.4 and 2.6,
little and big endian, 32- and 64-bit, and hard sector sizes from 512 to
4096.  :)

For any of you interested enough to know the details of what changed, we
will be coming up with a document soon about the ocfs->ocfs2 changes (it
can be found at http://oss.oracle.com/projects/ocfs2/documentation/) and 
some new documentation on all of the on-disk structures and how they
are laid out now.  Until then, please first take a look at super.c (in
ocfs_initialize_osb mostly) to see how the new bootstrapping differs
from before to get a good idea of what is going on.  (Basically, all of
the "hard" offsets and sizes that we stored on the former superblock are
now "soft" and dynamically allocated by mkfs or tunefs).  Nearly all of
our former limits (total volume size, total on-disk bitmap size, total
number of nodes in the cluster, etc) are now either gone or expanded to
huge limits.

We'd really like to thank all of you for your patience as we have been
making these pretty drastic changes lately.  Your bug reports/fixes are
invaluable to us and we'd love to see even more.  We're going to go on a
long stability run for awhile now, so you can hopefully expect better
turnaround time on getting your patches in.  Thanks for sticking with
us, we really think that the new format will pay off in the end.

-kurt
