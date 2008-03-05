From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 11:08:57 2008
Subject: [Ocfs2-devel] [PATCH 07/12] ocfs2/dlm: Move struct
	dlm_master_list_entry to dlmcommon.h
In-Reply-To: <1204678200-26237-8-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-8-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080305190846.GF799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 04:49:55PM -0800, Sunil Mushran wrote:
> This patch moves some mle related definitions from dlmmaster.c
> to dlmcommon.h.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Can we add a reason the patch header?

   This patch moves some mle related definitions from dlmmaster.c to
   dlmcommon.h.  Future patches need these definitions to dump mle
   debugging information.

Something like that.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmcommon.h |   35 +++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmmaster.c |   37 -------------------------------------
>  2 files changed, 35 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index c772a7f..3a59fdc 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -49,6 +49,41 @@
>  /* Intended to make it easier for us to switch out hash functions */
>  #define dlm_lockid_hash(_n, _l) full_name_hash(_n, _l)
>  
> +enum dlm_mle_type {
> +	DLM_MLE_BLOCK,
> +	DLM_MLE_MASTER,
> +	DLM_MLE_MIGRATION
> +};
> +
> +struct dlm_lock_name {
> +	u8 len;
> +	u8 name[DLM_LOCKID_NAME_MAX];
> +};
> +
> +struct dlm_master_list_entry {
> +	struct list_head list;
> +	struct list_head hb_events;
> +	struct dlm_ctxt *dlm;
> +	spinlock_t spinlock;
> +	wait_queue_head_t wq;
> +	atomic_t woken;
> +	struct kref mle_refs;
> +	int inuse;
> +	unsigned long maybe_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	unsigned long vote_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	unsigned long response_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	unsigned long node_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	u8 master;
> +	u8 new_master;
> +	enum dlm_mle_type type;
> +	struct o2hb_callback_func mle_hb_up;
> +	struct o2hb_callback_func mle_hb_down;
> +	union {
> +		struct dlm_lock_resource *res;
> +		struct dlm_lock_name name;
> +	} u;
> +};
> +
>  enum dlm_ast_type {
>  	DLM_AST = 0,
>  	DLM_BAST,
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 9713346..94cadcb 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -52,43 +52,6 @@
>  #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
>  #include "cluster/masklog.h"
>  
> -enum dlm_mle_type {
> -	DLM_MLE_BLOCK,
> -	DLM_MLE_MASTER,
> -	DLM_MLE_MIGRATION
> -};
> -
> -struct dlm_lock_name
> -{
> -	u8 len;
> -	u8 name[DLM_LOCKID_NAME_MAX];
> -};
> -
> -struct dlm_master_list_entry
> -{
> -	struct list_head list;
> -	struct list_head hb_events;
> -	struct dlm_ctxt *dlm;
> -	spinlock_t spinlock;
> -	wait_queue_head_t wq;
> -	atomic_t woken;
> -	struct kref mle_refs;
> -	int inuse;
> -	unsigned long maybe_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> -	unsigned long vote_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> -	unsigned long response_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> -	unsigned long node_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> -	u8 master;
> -	u8 new_master;
> -	enum dlm_mle_type type;
> -	struct o2hb_callback_func mle_hb_up;
> -	struct o2hb_callback_func mle_hb_down;
> -	union {
> -		struct dlm_lock_resource *res;
> -		struct dlm_lock_name name;
> -	} u;
> -};
> -
>  static void dlm_mle_node_down(struct dlm_ctxt *dlm,
>  			      struct dlm_master_list_entry *mle,
>  			      struct o2nm_node *node,
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
