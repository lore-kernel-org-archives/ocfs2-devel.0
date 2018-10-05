From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Fri, 5 Oct 2018 10:36:07 -0700
Subject: [Ocfs2-devel] [PATCH 06/15] vfs: strengthen checking of file
 range inputs to clone/dedupe range
In-Reply-To: <CAOQ4uxiVPvNPxTNZ-njeyte6yk3jo3tjNKv78kS9NqA_Xzxc6g@mail.gmail.com>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870031519.29072.18289185889660082318.stgit@magnolia>
	<CAOQ4uxiVPvNPxTNZ-njeyte6yk3jo3tjNKv78kS9NqA_Xzxc6g@mail.gmail.com>
Message-ID: <20181005173607.GW19324@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>

On Fri, Oct 05, 2018 at 09:10:12AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Clone range is an optimization on a regular file write.  File writes
> > that extend the file length are subject to various constraints which are
> > not checked by clonerange.  This is a correctness problem, because we're
> > never allowed to touch ranges that the page cache can't support
> > (s_maxbytes); we're not supposed to deal with large offsets
> > (MAX_NON_LFS) if O_LARGEFILE isn't set; and we must obey resource limits
> > (RLIMIT_FSIZE).
> >
> > Therefore, add these checks to the new generic_clone_checks function so
> > that we curtail unexpected behavior.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mm/filemap.c |   31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 68ec91d05c7b..f74391721234 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3015,6 +3015,37 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
> >                 return -EINVAL;
> >         count = min(count, size_in - (uint64_t)pos_in);
> >
> > +       /* Don't exceed RLMIT_FSIZE in the file we're writing into. */
> > +       if (limit != RLIM_INFINITY) {
> > +               if (pos_out >= limit) {
> > +                       send_sig(SIGXFSZ, current, 0);
> > +                       return -EFBIG;
> > +               }
> > +               count = min(count, limit - (uint64_t)pos_out);
> > +       }
> > +
> > +       /* Don't exceed the LFS limits. */
> > +       if (unlikely(pos_out + count > MAX_NON_LFS &&
> > +                               !(file_out->f_flags & O_LARGEFILE))) {
> > +               if (pos_out >= MAX_NON_LFS)
> > +                       return -EFBIG;
> > +               count = min(count, MAX_NON_LFS - (uint64_t)pos_out);
> > +       }
> > +       if (unlikely(pos_in + count > MAX_NON_LFS &&
> > +                               !(file_in->f_flags & O_LARGEFILE))) {
> > +               if (pos_in >= MAX_NON_LFS)
> > +                       return -EFBIG;
> > +               count = min(count, MAX_NON_LFS - (uint64_t)pos_in);
> > +       }
> > +
> > +       /* Don't operate on ranges the page cache doesn't support. */
> > +       if (unlikely(pos_out >= inode_out->i_sb->s_maxbytes ||
> > +                    pos_in >= inode_in->i_sb->s_maxbytes))
> > +               return -EFBIG;
> > +
> 
> Forget my standards, this doesn't abide by your own standards ;-)
> Please factor out generic_write_checks() and use it instead of
> duplicating the code. The in/out variant doesn't justify not calling
> the helper twice IMO.

Factor generic_write_checks and generic_clone_checks how?  They operate
on very different parameter types.

Or were you suggeseting refactoring just the "Dont' exceed LFS limits"
and "Don't operate on ranges the page cache..." sections of
generic_clone_checks to reduce copy paste?  That I'll do.

--D

> 
> Thanks,
> Amir.
