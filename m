From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 1 Jun 2009 18:06:36 -0700
Subject: [Ocfs2-devel] Anything I'm missing for 2.6.31?
Message-ID: <20090602010636.GB32688@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey everyone,
	We're coming up on the next merge window, and I only have a
couple tiny fixes for ocfs2.  I thought I'd list up what I know is
outstanding, and I was hoping to find out if I was missing anything.  If
I am, I need to get it in linux-next and set for the merge window ASAP.

- metaecc-stats
   This is a trivial patch I put together to track errors seen by the
blockcheck code.  No one has reviewed it.  Not a high priority, but I
suspect that if it looks good to a reviewer, we can push it whenever we
want.

- cacheme
   These are the changes that separate out the metadata cache from the
ocfs2_inode.  All metadata I/O and caching is done against the cache
rather than a specific inode.  This is needed for the refcount tree
code.  The code was ready for the 2.6.30 merge window, but we aren't
going to push it until refcount trees are ready.

- refcount
    Support for refcount trees in the filesystem.  The basic code is
quite hashed out.  Tao's done a great job, and Tristan is beating on it.
We're now tracking down major bugs.  It's not quite organized for
mainline submission, and it really warrants some time in linux-next
before we push it, so it won't be making the 2.6.31 merge window.  I'm
expecting 2.6.32 though.

- reflink
   The generic reflink system call patch seems to have evolved as
needed.  I'm ready to push it upstream, but I don't think it goes
without some consumer.  That is, I push it with the refcount tree code.
I'm open to dissenters, though, and I'm going to be asking VFS people
about it.

	That's what I have.  What'd I miss?

Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
