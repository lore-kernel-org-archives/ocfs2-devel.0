From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 14:39:45 2008
Subject: [Ocfs2-devel] [PATCH 03/18] ocfs2_dlm: Add missing dlm_lock_put()s
In-Reply-To: <1203970862-8790-4-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080228223834.GF23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:47PM -0800, Sunil Mushran wrote:
> Normally locks for remote nodes are freed when that node sends an UNLOCK
> message to the master. The master node tags an DLM_UNLOCK_FREE_LOCK action
> to do an extra put on the lock at the end.
> 
> However, there are times when the master node has to free the locks for the
> remote nodes forcibly.
> 
> Two cases when this happens are:
> 1. When the master has migrated the lockres plus all locks to another node.
> 2. When the master is clearing all the locks of a dead node.
> 
> It was in the above two conditions that the dlm was missing the extra put.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c   |    2 ++
>  fs/ocfs2/dlm/dlmrecovery.c |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 939b863..8e3c40e 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2973,6 +2973,8 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
>  				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
>  				list_del_init(&lock->list);
>  				dlm_lock_put(lock);
> +				/* DLM_UNLOCK_FREE_LOCK put */
> +				dlm_lock_put(lock);

	Good description in the patch, but it's opaque here.  Can we
have a comment like:

				/* Can't schedule DLM_UNLOCK_FREE_LOCK,
				 * do it here. */
 
Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
