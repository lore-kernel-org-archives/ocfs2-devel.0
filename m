From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Nov 2010 02:08:23 -0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Remove j_trans_barrier
In-Reply-To: <4CBE8751.1060606@oracle.com>
References: <4CBE8751.1060606@oracle.com>
Message-ID: <20101125100822.GA28616@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 20, 2010 at 02:08:17PM +0800, Tao Ma wrote:
> 	j_trans_barrier in ocfs2 is used to protect some journal operations
> in ocfs2. So normally, it is used as belows:
> 1. In journal transaction. When we start a transaction, We will
> down_read it and j_num_trans will be increased accordingly(in case
> of a cluster environment). It will be up_read when we do
> ocfs2_commit_trans.
> 2. In ocfs2_commit_cache, we will down_write it and then call
> jbd2_journal_flush, increase j_trans_id, reset j_num_trans and
> finally call up_write. This function is used by thread ocfs2cmt.

<snip> slow filesystem... </snip>

> My solution is that:
> 1. remove j_trans_barrier
> 2. Add a flag ci_checkpointing in ocfs2_caching_info:
>    1) When we find this caching_info needs checkpoint, set this flag
> and start the checkpointing(in ocfs2_ci_checkpointed). And the
> downconvert request will be requeued so that we can check and clear
> this flag next time it is handled.
>    2) Clear the flag when there is no need for checkpointing this
> ci(also in ocfs2_ci_checkpointed) during check_downconvert.
> 3. make sure when we journal_access some blocks, the caching_info
> can't be in the state of checkpointing. I think if we are
> checkpointing an caching_info, we shouldn't be able to
> journal_access it since it is just required to downconvert and we
> shouldn't have the lock now? So perhaps a BUG_ON should work?

Tao,
	I'm sorry I haven't responded sooner.  This proposal didn't
strike me as quite right, and I didn't have time to think about it.
I have a couple of concerns.
	First, we don't always checkpoint from a downconvert.  We do it
in clear_inode() as well, when we are flushing an inode from cache.
This may not have anything to do with the lock we're caring about, eg on
other inodes.  What I mean is, the caching info for the inode we care
about may not be checkpointing, but the journal as a whole is.  We need
to stop all action while that is happening.
	Second, there is the flip side.  How do we wait until all open
transactions are complete before checkpointing?  The down_write() in
ocfs2_commit_cache() blocks until all open transactions up_read().  In
your scheme, there is no care taken for open transactions against the
journal.  Remember, the journal is global to the node.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
