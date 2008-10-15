From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 15 Oct 2008 16:07:45 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Release jbd inode for
	system	inodes before journal shutdown
In-Reply-To: <1224108896-6603-2-git-send-email-sunil.mushran@oracle.com>
References: <1224108896-6603-1-git-send-email-sunil.mushran@oracle.com>
	<1224108896-6603-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20081015230745.GB23396@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 15, 2008 at 03:14:56PM -0700, Sunil Mushran wrote:
> JBD2 expects clear inode to also release the corresponding jbd inode.
> OCFS2 has a set of system inodes that includes the journal inode that
> are cleared after the journal is shutdown. This is problematic as the
> jbd inode needs to be released while the journal is still up.
> 
> This patch fixes this issue by making the fs explicitly release the jbd
> inode for all system inodes before the journal shutdown.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/inode.c |    7 +++++--
>  fs/ocfs2/super.c |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 4903688..20f93fd 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1023,6 +1023,7 @@ void ocfs2_clear_inode(struct inode *inode)
>  {
>  	int status;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	struct ocfs2_journal *journal;
>  
>  	mlog_entry_void();
>  
> @@ -1106,8 +1107,10 @@ void ocfs2_clear_inode(struct inode *inode)
>  	oi->ip_last_trans = 0;
>  	oi->ip_dir_start_lookup = 0;
>  	oi->ip_blkno = 0ULL;
> -	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
> -				       &oi->ip_jinode);
> +
> +	journal = OCFS2_SB(inode->i_sb)->journal;
> +	BUG_ON(journal->j_state != OCFS2_JOURNAL_LOADED);
> +	jbd2_journal_release_jbd_inode(journal->j_journal, &oi->ip_jinode);

	This can't be right - clear_inode() will be called by
release_system_inodes() just as before, and journal->j_state will be
JOURNAL_FREE.  The BUG_ON() will always trigger.
	Shouldn't this be more like:

	if (!(op->ip_flags & OCFS2_INODE_SYSTEM_FILE) ||
	    (journal->j_state != OCFS2_JOURNAL_FREE)
		jbd2_journal_release_jbd_inode(journal->j_journal, &oi->ip_jinode);

	The problem with this is, what about cleaning up mount errors?
System files are allocated *before* we start the journal, and we need to
clean that up too.  In the error paths of init_*_system_inodes(), you
need to call your ocfs2_release_system_inodes_jbd_inode() function right
before calling ocfs2_release_system_inodes().  And that call has to do
the right thing.
	Come to that, we can't clean that up safely, because we don't
have a journal yet.
	Ok, let's ignore allocation.  We were worried about releasing
any allocation done by init_jbd_inode(), but we can't handle that
safely.  It doesn't do it today, and if they ever add it, we can yell at
them.
	So, don't call ocfs2_release_system_inodes_jbd_inode() in the
error paths of init_*_system_inodes().  Leave that out.  Change
clean_inode() to:

	if (op->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
		if (journal->j_state != OCFS2_JOURNAL_FREE)
			jbd2_journal_release_jbd_inode(journal->j_journal,
						       &oi->ip_jinode);
	} else {
		BUG_ON(journa->j_state == OCFS2_JOURNAL_FREE);
		jbd2_journal_release_jbd_inode(journal->j_journal,
					       &oi->ip_jinode);
	}

Joel

>  
>  bail:
>  	mlog_exit_void();
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 304b63a..5f40d7c 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -324,6 +324,36 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
>  	mlog_exit(0);
>  }
>  
> +static void ocfs2_release_system_inodes_jbd_inode(struct ocfs2_super *osb)
> +{
> +	int i;
> +	struct inode *inode;
> +	struct ocfs2_journal *journal;
> +
> +	for (i = 0; i < NUM_SYSTEM_INODES; i++) {
> +		inode = osb->system_inodes[i];
> +		if (!inode)
> +			continue;
> +		journal = OCFS2_SB(inode->i_sb)->journal;
> +		jbd2_journal_release_jbd_inode(journal->j_journal,
> +					       OCFS2_I(inode)->ip_jinode);
> +	}
> +
> +	inode = osb->sys_root_inode;
> +	if (inode) {
> +		journal = OCFS2_SB(inode->i_sb)->journal;
> +		jbd2_journal_release_jbd_inode(journal->j_journal,
> +					       OCFS2_I(inode)->ip_jinode);
> +	}
> +
> +	inode = osb->root_inode;
> +	if (inode) {
> +		journal = OCFS2_SB(inode->i_sb)->journal;
> +		jbd2_journal_release_jbd_inode(journal->j_journal,
> +					       OCFS2_I(inode)->ip_jinode);
> +	}
> +}
> +
>  /* We're allocating fs objects, use GFP_NOFS */
>  static struct inode *ocfs2_alloc_inode(struct super_block *sb)
>  {
> @@ -1310,6 +1340,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	/* This will disable recovery and flush any recovery work. */
>  	ocfs2_recovery_exit(osb);
>  
> +	/* Release jbd inode for system inodes before journal shutdown */
> +	ocfs2_release_system_inodes_jbd_inode(osb);
> +
>  	ocfs2_journal_shutdown(osb);
>  
>  	ocfs2_sync_blockdev(sb);
> -- 
> 1.5.6.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Glory is fleeting, but obscurity is forever."  
         - Napoleon Bonaparte

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
