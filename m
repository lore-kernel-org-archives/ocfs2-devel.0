From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Aug 23 14:16:36 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after
	some operation
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840542F8CE@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840542F8CE@pdsmsx403>
Message-ID: <20040823191631.GE1165@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 23, 2004 at 04:05:57PM +0800, Ling, Xiaofeng wrote:
> before umount, all the lock shall be released first.
> this patch can resolve the problem
This isn't the way we want to handle this. The way it's supposed to work is
that the umount process sends a signal to the commit thread to shutdown and
then waits on it's last set of checkpoints / releases. I'd much rather fix
what's broken than patch over it :)

I'm actually looking at this bug right now and I think it's due to our
signal handling code...
	--Mark

> 
> ------------------------------------------------
> Index: super.c
> ===================================================================
> --- super.c (revision 1370)
> +++ super.c (working copy)
> @@ -224,6 +224,7 @@
>     tid_t target;
> 
>     sb->s_dirt = 0;
> +   ocfs_commit_cache(OCFS2_SB(sb));
>     target = log_start_commit(OCFS2_SB(sb)->journal->k_journal, NULL);
>     log_wait_commit(OCFS2_SB(sb)->journal->k_journal, target);
>     return 0;
> @@ -234,6 +235,7 @@
>     tid_t target;
> 
>     sb->s_dirt = 0;
> +   ocfs_commit_cache(OCFS2_SB(sb));
>     if (journal_start_commit(OCFS2_SB(sb)->journal->k_journal, &target))
> {
>         if (wait)
>             log_wait_commit(OCFS2_SB(sb)->journal->k_journal,
> Index: journal.c
> ===================================================================
> --- journal.c   (revision 1370)
> +++ journal.c   (working copy)
> @@ -61,7 +61,7 @@
>                    struct inode *inode);
>  static int ocfs_recover_node(struct _ocfs_super *osb, int node_num);
>  static int __ocfs_recovery_thread(void *arg);
> -static int ocfs_commit_cache (ocfs_super * osb);
> +int ocfs_commit_cache (ocfs_super * osb);
>  static int ocfs_wait_on_mount(ocfs_super *osb);
>  static void ocfs_handle_move_locks(ocfs_journal *journal,
>                    ocfs_journal_handle *handle);
> @@ -149,7 +149,7 @@
>   * This is in journal.c for lack of a better place.
>   *
>   */
> -static int ocfs_commit_cache(ocfs_super *osb)
> +int ocfs_commit_cache(ocfs_super *osb)
>  {
>     int status = 0, tmpstat;
>     ocfs_journal * journal = NULL;
> 
> 
> -------------------
> Ling Xiaofeng(Daniel)
> 
> Intel China Software Lab.
> iNet: 8-752-1243
> 8621-52574545-1243(O)
> 
> xfling@users.sourceforge.net
> Opinions are my own and don't represent those of my employer 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
