From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 02 Sep 2009 18:45:47 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use MAY_CREATE in
	ocfs2_permission()
In-Reply-To: <1251940014-20963-3-git-send-email-joel.becker@oracle.com>
References: <1251940014-20963-1-git-send-email-joel.becker@oracle.com>
	<1251940014-20963-3-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9F1FCB.5020406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, ocfs2-devel@oss.oracle.com, linux-fsdevel@kernel.org

Joel Becker wrote:
> ocfs2 has a problem with open(O_CREAT|O_EXCL).  Once you've created the
> file, you can't restart the open(), because O_CREAT|O_EXCL will trigger
> -EEXIST.
>
> The problem is that ocfs2 is catching the signal ->permission(), called
> by may_open().  This happens after ->create() has successfully created
> the file.  ocfs2_permission() has to get a cluster lock, and this is
> what can be interrupted by a signal.  Now, obviously we want to block
> signals in the O_CREAT|O_EXCL case, but ocfs2_permission() has no way of
> knowing it just got called from open_namei_create().
>
> We key on the MAY_CREATE flag passed to permission to block signals.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/file.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index aa501d3..508a2db 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1095,9 +1095,18 @@ bail:
>  int ocfs2_permission(struct inode *inode, int mask)
>  {
>  	int ret;
> +	sigset_t oldset;
>  
>  	mlog_entry_void();
>  
> +	/*
> +	 * If this inode was just created by open(O_CREAT|O_EXCL), we
> +	 * can't allow signal restarting.  So we need to block signals
> +	 * around the cluster locking.
> +	 */
> +	if (mask & MAY_CREATE)
> +		ocfs2_block_signals(&oldset);
> +
>  	ret = ocfs2_inode_lock(inode, NULL, 0);
>  	if (ret) {
>  		if (ret != -ENOENT)
> @@ -1108,6 +1117,10 @@ int ocfs2_permission(struct inode *inode, int mask)
>  	ret = generic_permission(inode, mask, ocfs2_check_acl);
>  
>  	ocfs2_inode_unlock(inode, 0);
> +
> +	if (mask & MAY_CREATE)
> +		ocfs2_unblock_signals(&oldset);
> +
>  out:
>  	mlog_exit(ret);
>  	return ret;
>   

Maybe I am missing something but shouldn't we be unblocking the signal
after the out label.
