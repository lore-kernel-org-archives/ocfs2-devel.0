From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 6 Dec 2010 17:13:25 -0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Remove j_trans_barrier
In-Reply-To: <4CEF554E.2060608@oracle.com>
References: <4CBE8751.1060606@oracle.com>
	<20101125100822.GA28616@mail.oracle.com>
	<4CEF554E.2060608@oracle.com>
Message-ID: <20101207011325.GE12309@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 26, 2010 at 02:35:58PM +0800, Tao Ma wrote:
> Hi Joel,
> 
> On 11/25/2010 06:08 PM, Joel Becker wrote:
> > On Wed, Oct 20, 2010 at 02:08:17PM +0800, Tao Ma wrote:
> >> 	j_trans_barrier in ocfs2 is used to protect some journal operations
> >> in ocfs2. So normally, it is used as belows:
> >> 1. In journal transaction. When we start a transaction, We will
> >> down_read it and j_num_trans will be increased accordingly(in case
> >> of a cluster environment). It will be up_read when we do
> >> ocfs2_commit_trans.
> >> 2. In ocfs2_commit_cache, we will down_write it and then call
> >> jbd2_journal_flush, increase j_trans_id, reset j_num_trans and
> >> finally call up_write. This function is used by thread ocfs2cmt.
> >
> > <snip>  slow filesystem...</snip>
> >
> >> My solution is that:
> >> 1. remove j_trans_barrier
> >> 2. Add a flag ci_checkpointing in ocfs2_caching_info:
> >>     1) When we find this caching_info needs checkpoint, set this flag
> >> and start the checkpointing(in ocfs2_ci_checkpointed). And the
> >> downconvert request will be requeued so that we can check and clear
> >> this flag next time it is handled.
> >>     2) Clear the flag when there is no need for checkpointing this
> >> ci(also in ocfs2_ci_checkpointed) during check_downconvert.
> >> 3. make sure when we journal_access some blocks, the caching_info
> >> can't be in the state of checkpointing. I think if we are
> >> checkpointing an caching_info, we shouldn't be able to
> >> journal_access it since it is just required to downconvert and we
> >> shouldn't have the lock now? So perhaps a BUG_ON should work?

A couple thoughts.

- Journal-wise, the following code provides any barrier
  we need to ensure that a transaction can't be around when we're
  checkpointing:

	jbd2_journal_lock_updates(journal->j_journal);
	status = jbd2_journal_flush(journal->j_journal);
	jbd2_journal_unlock_updates(journal->j_journal);

- Please be sure that we don't lose any improvement the check 
  for zero transactions gives us.

- Joel mentioned to me that you actually saw a performance improvement?
  That's interesting, I would have assumed that we wouldn't get any such
  improvement as the journal code would be blocking us anyway in all the
  places we use j_trans_barrier.

> >
> > Tao,
> > 	I'm sorry I haven't responded sooner.  This proposal didn't
> > strike me as quite right, and I didn't have time to think about it.
> > I have a couple of concerns.
> Never mind. I knew you had a lot of stuff to handle with these days.
> > 	First, we don't always checkpoint from a downconvert.  We do it
> > in clear_inode() as well, when we are flushing an inode from cache.
> > This may not have anything to do with the lock we're caring about, eg on
> > other inodes.  What I mean is, the caching info for the inode we care
> > about may not be checkpointing, but the journal as a whole is.  We need
> > to stop all action while that is happening.
> Sorry I don't get your last sentense. Could you please describe it in 
> detail? Yes, clear_inode does do checkpointing, but actually the whole 
> thing is self-contained. In ocfs2_checkpoint_inode, it can checkpoint 
> the inode by itself and has no relationship with downconvert.
> > 	Second, there is the flip side.  How do we wait until all open
> > transactions are complete before checkpointing?  The down_write() in
> > ocfs2_commit_cache() blocks until all open transactions up_read().  In
> > your scheme, there is no care taken for open transactions against the
> > journal.  Remember, the journal is global to the node.
> yes, I was thinking of that too. But finally I got that we don't need to 
> care for it. As we have agreed above, there are 2 places we do 
> checkpoint for an inode. As for clear_inode, we don't care since it is 
> going to be cleared and no transaction could be opened against that. 
> Another is downconvert, in which case we shouldn't be able to open a 
> transaction and access that caching_info(we should always get the 
> cluster lock before we do access it). We can add a BUG_ON to 
> journal_access which can facilitate us to find the case that we don't 
> have the lock while accessing it.



> btw, I have some draft patch for it, I haven't tested it much these 
> days. But if you are interested, I can send it to the mail list for more 
> review.

Post it, with some numbers showing the performance difference :)
	--Mark

--
Mark Fasheh
