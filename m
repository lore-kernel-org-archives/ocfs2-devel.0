From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 11 Jun 2010 18:27:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: the mig_request could be for
 recovery
In-Reply-To: <201005251302.o4P6ns6T017115@rcsinet13.oracle.com>
References: <201005251302.o4P6ns6T017115@rcsinet13.oracle.com>
Message-ID: <20100611102734.GC3990@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any comment?

regards,
wengang.
On 10-05-25 21:01, Wengang Wang wrote:
> I hit a bug, it's the BUG_ON() in
> 
> 1780                  * do not allocate a new lock structure. */
> 1781                 if (ml->node == dlm->node_num) {
> 1782                         /* MIGRATION ONLY! */
> 1783                         BUG_ON(!(mres->flags & DLM_MRES_MIGRATION));
> 1784    
> 1785                         spin_lock(&res->spinlock);
> 
> in dlm_process_recovery_data().
> 
> I think it's possible it's a mig_request for recovery in the following case:
> 
> 1) Node A and node  B have ref on lockres A mastered by node C. So on node C
> the is a lock on behalf of A, lock A, on lockres A.
> 2) For umount, node C is migrating lockres A to node B. the migration mle,
> master being node C, new master being node B, is created and added to mle
> hashtable.
> 3) Node B "down". Node A is the recovery master. On node C, lockres A also become
> the object to recovery because it's during migration and the new master is the
> "down" node B.
> 4) Node C send mig_request request(for recovery) to node A for lockres A including
> lock A.
> 5) receiving the mig_request from node C(for recovery), node A BUG()ed because of
> lock A.
> 
> fix:
> removing the BUG_ON() is OK.
> 
> Well, I can't reproduce the bug. So didn't test the fix.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index b4f99de..03f17d5 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1780,7 +1780,6 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>  		 * do not allocate a new lock structure. */
>  		if (ml->node == dlm->node_num) {
>  			/* MIGRATION ONLY! */
> -			BUG_ON(!(mres->flags & DLM_MRES_MIGRATION));
>  
>  			spin_lock(&res->spinlock);
>  			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
> -- 
> 1.6.6.1
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
