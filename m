From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun Mar  2 18:12:30 2008
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2/dlm: Add missing dlm_lock_put()s
In-Reply-To: <1204409065-10953-2-git-send-email-sunil.mushran@oracle.com>
References: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
	<1204409065-10953-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080303021222.GB6897@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Mar 01, 2008 at 02:04:20PM -0800, Sunil Mushran wrote:
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
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmmaster.c   |    3 +++
>  fs/ocfs2/dlm/dlmrecovery.c |    9 +++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a54d33d..eadf9bf 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2933,6 +2933,9 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
>  				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
>  				list_del_init(&lock->list);
>  				dlm_lock_put(lock);
> +				/* In a normal unlock, we would have added a
> +				 * DLM_UNLOCK_FREE_LOCK action. Force it. */
> +				dlm_lock_put(lock);
>  			}
>  		}
>  		queue++;
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 91f747b..8ef57c2 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2130,11 +2130,16 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  	assert_spin_locked(&dlm->spinlock);
>  	assert_spin_locked(&res->spinlock);
>  
> +	/* We do two dlm_lock_put(). One for removing from list and the other is
> +	 * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
> +
>  	/* TODO: check pending_asts, pending_basts here */
>  	list_for_each_entry_safe(lock, next, &res->granted, list) {
>  		if (lock->ml.node == dead_node) {
>  			list_del_init(&lock->list);
>  			dlm_lock_put(lock);
> +			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> +			dlm_lock_put(lock);
>  			freed++;
>  		}
>  	}
> @@ -2142,6 +2147,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  		if (lock->ml.node == dead_node) {
>  			list_del_init(&lock->list);
>  			dlm_lock_put(lock);
> +			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> +			dlm_lock_put(lock);
>  			freed++;
>  		}
>  	}
> @@ -2149,6 +2156,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  		if (lock->ml.node == dead_node) {
>  			list_del_init(&lock->list);
>  			dlm_lock_put(lock);
> +			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> +			dlm_lock_put(lock);
>  			freed++;
>  		}
>  	}
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
