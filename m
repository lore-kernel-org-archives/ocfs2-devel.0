From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Mar 2014 16:41:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix dead lock risk when kmalloc
 failed in dlm_query_region_handler
In-Reply-To: <532A6DAA.9020707@huawei.com>
References: <532A6DAA.9020707@huawei.com>
Message-ID: <20140320164112.df1aa9b451527b1493eef799@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 20 Mar 2014 12:25:14 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> From: Zhonghua Guo <guozhonghua@h3c.com>
> 
> In dlm_query_region_handler(), once kmalloc failed, it will unlock
> dlm_domain_lock without lock first, then dead lock happens.
> This patch adds a flag domain_locked to fix this issue.
> 
> ...
>
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1124,6 +1124,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
>  	char *local = NULL;
>  	int status = 0;
>  	int locked = 0;
> +	int domain_locked = 0;
>  
>  	qr = (struct dlm_query_region *) msg->buf;
>  
> @@ -1140,6 +1141,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
>  	status = -EINVAL;
>  
>  	spin_lock(&dlm_domain_lock);
> +	domain_locked = 1;
>  	dlm = __dlm_lookup_domain_full(qr->qr_domain, qr->qr_namelen);
>  	if (!dlm) {
>  		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
> @@ -1171,7 +1173,8 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
>  bail:
>  	if (locked)
>  		spin_unlock(&dlm->spinlock);
> -	spin_unlock(&dlm_domain_lock);
> +	if (domain_locked)
> +		spin_unlock(&dlm_domain_lock);
>  
>  	kfree(local);

That makes the code messier, by adding another local and testing it.

We can instead make the code cleaner by adopting conventional error
unwinding techniques:


--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1123,7 +1123,6 @@ static int dlm_query_region_handler(stru
 	struct dlm_ctxt *dlm = NULL;
 	char *local = NULL;
 	int status = 0;
-	int locked = 0;
 
 	qr = (struct dlm_query_region *) msg->buf;
 
@@ -1132,10 +1131,8 @@ static int dlm_query_region_handler(stru
 
 	/* buffer used in dlm_mast_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
-	if (!local) {
-		status = -ENOMEM;
-		goto bail;
-	}
+	if (!local)
+		return -ENOMEM;
 
 	status = -EINVAL;
 
@@ -1144,16 +1141,15 @@ static int dlm_query_region_handler(stru
 	if (!dlm) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "before join domain\n", qr->qr_node, qr->qr_domain);
-		goto bail;
+		goto out_domain_lock;
 	}
 
 	spin_lock(&dlm->spinlock);
-	locked = 1;
 	if (dlm->joining_node != qr->qr_node) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "but joining node is %d\n", qr->qr_node, qr->qr_domain,
 		     dlm->joining_node);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	/* Support for global heartbeat was added in 1.1 */
@@ -1163,14 +1159,14 @@ static int dlm_query_region_handler(stru
 		     "but active dlm protocol is %d.%d\n", qr->qr_node,
 		     qr->qr_domain, dlm->dlm_locking_proto.pv_major,
 		     dlm->dlm_locking_proto.pv_minor);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	status = dlm_match_regions(dlm, qr, local, sizeof(qr->qr_regions));
 
-bail:
-	if (locked)
-		spin_unlock(&dlm->spinlock);
+out_dlm_lock:
+	spin_unlock(&dlm->spinlock);
+out_domain_lock:
 	spin_unlock(&dlm_domain_lock);
 
 	kfree(local);

Please review and test this then send it back at me?
