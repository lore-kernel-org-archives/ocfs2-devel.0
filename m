From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 01 Jun 2009 18:23:39 -0700
Subject: [Ocfs2-devel] Anything I'm missing for 2.6.31?
In-Reply-To: <20090602010636.GB32688@mail.oracle.com>
References: <20090602010636.GB32688@mail.oracle.com>
Message-ID: <4A247F1B.20209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> Hey everyone,
> 	We're coming up on the next merge window, and I only have a
> couple tiny fixes for ocfs2.  I thought I'd list up what I know is
> outstanding, and I was hoping to find out if I was missing anything.  If
> I am, I need to get it in linux-next and set for the merge window ASAP.
>
> - metaecc-stats
>    This is a trivial patch I put together to track errors seen by the
> blockcheck code.  No one has reviewed it.  Not a high priority, but I
> suspect that if it looks good to a reviewer, we can push it whenever we
> want.

I thought I had sob-bed it. Anycase, sob for the following:
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=commitdiff;h=652005955cff547d2a845d5a794ba36e65550774

> - cacheme
>    These are the changes that separate out the metadata cache from the
> ocfs2_inode.  All metadata I/O and caching is done against the cache
> rather than a specific inode.  This is needed for the refcount tree
> code.  The code was ready for the 2.6.30 merge window, but we aren't
> going to push it until refcount trees are ready.
>
> - refcount
>     Support for refcount trees in the filesystem.  The basic code is
> quite hashed out.  Tao's done a great job, and Tristan is beating on it.
> We're now tracking down major bugs.  It's not quite organized for
> mainline submission, and it really warrants some time in linux-next
> before we push it, so it won't be making the 2.6.31 merge window.  I'm
> expecting 2.6.32 though.
>
> - reflink
>    The generic reflink system call patch seems to have evolved as
> needed.  I'm ready to push it upstream, but I don't think it goes
> without some consumer.  That is, I push it with the refcount tree code.
> I'm open to dissenters, though, and I'm going to be asking VFS people
> about it.
>
> 	That's what I have.  What'd I miss?

It probably would be best to hold-off on reflink till 2.6.32.

I can't think of anything else. This will be the fewest number of
patches we've pushed during merge window since... ever.
