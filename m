From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 21 Aug 2011 20:55:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Disable indexing for directory with
 corrupt index
In-Reply-To: <CAJtY7HUwW2JtS3XK=k69nLcH42Q-p8MnZ1dSEm4mw49Xau_4ZA@mail.gmail.com>
References: <BANLkTimpmS9GKwCvzBdswkzcaAY5YiugSw@mail.gmail.com>
	<20110728092210.GD9495@noexit.corp.google.com>
	<CAJtY7HUwW2JtS3XK=k69nLcH42Q-p8MnZ1dSEm4mw49Xau_4ZA@mail.gmail.com>
Message-ID: <20110822035541.GA31134@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2011 at 06:43:42PM -0500, Goldwyn Rodrigues wrote:
> Hi Joel,
> 
> Thanks for the review.

	No problem.  Sorry I took so long to get back to you.

> >> +static void ocfs2_dx_disable(struct inode *dir, struct buffer_head *di_bh)
> >> +{
> >> + ? ? struct ocfs2_inode_info *oi = OCFS2_I(dir);
> >> + ? ? struct ocfs2_dinode *di;
> >> + ? ? if (!di_bh) {
> >> + ? ? ? ? ? ? mlog(ML_ERROR, "Index directory corruption but unable "
> >> + ? ? ? ? ? ? ? ? ? ? "to disable dx_dir for <%llu>. Please execute "
> >> + ? ? ? ? ? ? ? ? ? ? "fsck.ocfs2\n", OCFS2_I(dir)->ip_blkno);
> >> + ? ? ? ? ? ? return;
> >> + ? ? }
> >> + ? ? di = (struct ocfs2_dinode *)di_bh->b_data;
> >> + ? ? BUG_ON(di->i_blkno != oi->ip_blkno);
> >> + ? ? mlog(ML_ERROR, "Disabling index for directory <%llu> due to"
> >> + ? ? ? ? ? ? " corruption. Please execute fsck.ocfs2\n", oi->ip_blkno);
> >
> > ? ? ? ?Please match the indentation to the open parenthesis.
> 
> You mean quotes, right?

	No, I mean parenthesis.  Both are acceptible, though.  I'd
probably do:

  mlog(ML_ERROR,
       "Disabling ..."
       " corruption...",
       oi->ip_blkno);

It's mostly a matter of taste.  The only wrong answer is an indentation
that doesn't line up with anything ;-)

> >> @@ -4364,11 +4392,17 @@ int ocfs2_prepare_dir_for_insert(struct
> >> ocfs2_super *osb,
> >> ? ? ? if (ocfs2_dir_indexed(dir)) {
> >> ? ? ? ? ? ? ? ret = ocfs2_prepare_dx_dir_for_insert(dir, parent_fe_bh,
> >> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? name, namelen, lookup);
> >> - ? ? ? ? ? ? if (ret)
> >> + ? ? ? ? ? ? if (ret == -EINVAL) {
> >> + ? ? ? ? ? ? ? ? ? ? ocfs2_dx_disable(dir, parent_fe_bh);
> >> + ? ? ? ? ? ? ? ? ? ? /* Reset ret */
> >> + ? ? ? ? ? ? ? ? ? ? ret = 0;
> >> + ? ? ? ? ? ? ? ? ? ? goto no_index;
> >> + ? ? ? ? ? ? } else if (ret)
> >> ? ? ? ? ? ? ? ? ? ? ? mlog_errno(ret);
> >
> > ? ? ? ?See here, you'll disable the index on a bad signature, but you
> > error when ECC fails. ?You should disable the index on both cases. ?I
> > say you return -EIO as I described above, and then disable when ret ==
> > -EIO. ?Yes, we might disable the index upon an actual read error, but
> > that's OK. ?We can rebuild it later.
> >
> 
> I understand why I disable index of a bad signature, but I fail to
> understand why I will err of ECC errors. In any case, I will change
> this to EIO. I chose EINVAL just to make it different from read
> errors. It does make sense to encompass read errors as well.

	Since ECC error returns -EIO, you'll trigger the mlog_errno(ret)
path and reject continuing.  Conversely, if you disable, the directory
can continue to work in non-indexed mode.  The same is true of read
errors for the index; disabling the index allows the directory to
continue to work.

Joel

-- 

 Joel's Second Law:

	If a code change requires additional user setup, it is wrong.

			http://www.jlbec.org/
			jlbec at evilplan.org
