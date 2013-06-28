From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Jun 2013 16:12:09 -0700
Subject: [Ocfs2-devel] [PATCH] unlink performance: wait for open lock in
 case of dirs
In-Reply-To: <20130615020510.GA4487@shrek.cartoons>
References: <20130615020510.GA4487@shrek.cartoons>
Message-ID: <20130628161209.95b024c90df90188a8367c8f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 14 Jun 2013 21:05:10 -0500 Goldwyn Rodrigues <rgoldwyn@gmail.com> wrote:

> This patch is to improve the unlink performance. Here is the scenario:
> 
> On node A, create multiple directories say d1-d8, and each have 3
> files under it f1, f2 and f3.
> On node B, delete all directories using rm -Rf d*
> 
> The FS first unlinks f1, f2 and f3. However, when it performs
> ocfs2_evict_inode() -> ocfs2_delete_inode() ->
> ocfs2_query_inode_wipe() -> ocfs2_try_open_lock() on d1, it fails
> with -EAGAIN. The open lock fails because on the remote node
> a PR->EX convert takes longer than a simple EX grant.
> 
> This starts a checkpoint because OCFS2_INODE_DELETED flag is not set
> on the directory inode. Now, a checkpoint interferes with the journaling
> of the inodes deleted in the following unlinks, in our case,
> directories d2-d8 and the files contained in it.
> 
> With this patch, We wait on a directory EX lock only if we already
> have an open_lock in PR mode. This way we will avoid the ABBA locking.
> 
> By waiting for the open_lock on the directory, I am getting a unlink
> performance improvement of a rm -Rf of 50-60% in the usual case.
> 
> Also, folded ocfs2_open_lock and ocfs2_try_open_lock into one.
> 
> Let me know if you would like to see the test case.

We need some more review and test of this patch, please.

The patch doesn't apply to current kernels - please redo, retest and
resend it.

In particular, the kernel you're patching doesn't have the
ocfs2_is_hard_readonly() tests in ocfs2_open_lock() and
ocfs2_try_open_lock().

And looking at those tests, I wonder about ocfs2_open_lock().

: int ocfs2_open_lock(struct inode *inode)
: {
: 	int status = 0;
: 	struct ocfs2_lock_res *lockres;
: 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
: 
: 	BUG_ON(!inode);
: 
: 	mlog(0, "inode %llu take PRMODE open lock\n",
: 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
: 
: 	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
: 		goto out;
: 
: 	lockres = &OCFS2_I(inode)->ip_open_lockres;
: 
: 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
: 				    DLM_LOCK_PR, 0, 0);
: 	if (status < 0)
: 		mlog_errno(status);
: 
: out:
: 	return status;
: }

It will return zero if ocfs2_is_hard_readonly().  Is that correct? 
Should it return -EROFS for writes?  After your patch, this code does
know whether the attempt was for a write.

Please check all that.
