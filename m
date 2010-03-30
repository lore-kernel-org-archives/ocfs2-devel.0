From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 30 Mar 2010 15:05:55 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: print node # when tcp fails -v4
In-Reply-To: <201003300411.o2U3l0gx029151@acsinet15.oracle.com>
References: <201003300411.o2U3l0gx029151@acsinet15.oracle.com>
Message-ID: <4BB275C3.5050707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Wengang Wang wrote:
> #I resend the patch as V4 for a reminder. And I cleaned up some problems that
> #checkpatch.pl points out.
>
> This patch adds prints of the number of peer node to which sending tcp message
> failed. It helps debugging.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmast.c      |    4 +++-
>  fs/ocfs2/dlm/dlmconvert.c  |    4 +++-
>  fs/ocfs2/dlm/dlmdomain.c   |   19 +++++++++++++------
>  fs/ocfs2/dlm/dlmlock.c     |    4 +++-
>  fs/ocfs2/dlm/dlmmaster.c   |   12 +++++++++---
>  fs/ocfs2/dlm/dlmrecovery.c |   27 ++++++++++++++++++---------
>  fs/ocfs2/dlm/dlmunlock.c   |    3 ++-
>  7 files changed, 51 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index dccc439..390a887 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -453,7 +453,9 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	ret = o2net_send_message_vec(DLM_PROXY_AST_MSG, dlm->key, vec, veclen,
>  				     lock->ml.node, &status);
>  	if (ret < 0)
> -		mlog_errno(ret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", ret, DLM_PROXY_AST_MSG, dlm->key,
> +		     lock->ml.node);
>  	else {
>  		if (status == DLM_RECOVERING) {
>  			mlog(ML_ERROR, "sent AST to node %u, it thinks this "
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index f283bce..3028d05 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -391,7 +391,9 @@ static enum dlm_status dlm_send_remote_convert_request(struct dlm_ctxt *dlm,
>  		} else if (ret != DLM_NORMAL && ret != DLM_NOTQUEUED)
>  			dlm_error(ret);
>  	} else {
> -		mlog_errno(tmpret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", tmpret, DLM_CONVERT_LOCK_MSG, dlm->key,
> +		     res->owner);
>  		if (dlm_is_host_down(tmpret)) {
>  			/* instead of logging the same network error over
>  			 * and over, sleep here and wait for the heartbeat
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 988c905..eb50be0 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -565,7 +565,9 @@ static int dlm_send_one_domain_exit(struct dlm_ctxt *dlm,
>  	status = o2net_send_message(DLM_EXIT_DOMAIN_MSG, dlm->key,
>  				    &leave_msg, sizeof(leave_msg), node,
>  				    NULL);
> -
> +	if (status < 0)
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", status, DLM_EXIT_DOMAIN_MSG, dlm->key, node);
>  	mlog(0, "status return %d from o2net_send_message\n", status);
>  
>  	return status;
> @@ -962,7 +964,9 @@ static int dlm_send_one_join_cancel(struct dlm_ctxt *dlm,
>  				    &cancel_msg, sizeof(cancel_msg), node,
>  				    NULL);
>  	if (status < 0) {
> -		mlog_errno(status);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", status, DLM_CANCEL_JOIN_MSG, DLM_MOD_KEY,
> +		     node);
>  		goto bail;
>  	}
>  
> @@ -1029,10 +1033,11 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
>  	byte_copymap(join_msg.node_map, dlm->live_nodes_map, O2NM_MAX_NODES);
>  
>  	status = o2net_send_message(DLM_QUERY_JOIN_MSG, DLM_MOD_KEY, &join_msg,
> -				    sizeof(join_msg), node,
> -				    &join_resp);
> +				    sizeof(join_msg), node, &join_resp);
>  	if (status < 0 && status != -ENOPROTOOPT) {
> -		mlog_errno(status);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", status, DLM_QUERY_JOIN_MSG, DLM_MOD_KEY,
> +		     node);
>  		goto bail;
>  	}
>  	dlm_query_join_wire_to_packet(join_resp, &packet);
> @@ -1103,7 +1108,9 @@ static int dlm_send_one_join_assert(struct dlm_ctxt *dlm,
>  				    &assert_msg, sizeof(assert_msg), node,
>  				    NULL);
>  	if (status < 0)
> -		mlog_errno(status);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", status, DLM_ASSERT_JOINED_MSG, DLM_MOD_KEY,
> +		     node);
>  
>  	return status;
>  }
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 7333377..f1fba2a 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -329,7 +329,9 @@ static enum dlm_status dlm_send_remote_lock_request(struct dlm_ctxt *dlm,
>  			BUG();
>  		}
>  	} else {
> -		mlog_errno(tmpret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", tmpret, DLM_CREATE_LOCK_MSG, dlm->key,
> +		     res->owner);
>  		if (dlm_is_host_down(tmpret)) {
>  			ret = DLM_RECOVERING;
>  			mlog(0, "node %u died so returning DLM_RECOVERING "
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a659606..3114de2 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1666,7 +1666,9 @@ again:
>  		tmpret = o2net_send_message(DLM_ASSERT_MASTER_MSG, dlm->key,
>  					    &assert, sizeof(assert), to, &r);
>  		if (tmpret < 0) {
> -			mlog(0, "assert_master returned %d!\n", tmpret);
> +			mlog(ML_ERROR, "Error %d when sending message %u (key "
> +			     "0x%x) to node %u\n", tmpret,
> +			     DLM_ASSERT_MASTER_MSG, dlm->key, to);
>  			if (!dlm_is_host_down(tmpret)) {
>  				mlog(ML_ERROR, "unhandled error=%d!\n", tmpret);
>  				BUG();
> @@ -2207,7 +2209,9 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  	ret = o2net_send_message(DLM_DEREF_LOCKRES_MSG, dlm->key,
>  				 &deref, sizeof(deref), res->owner, &r);
>  	if (ret < 0)
> -		mlog_errno(ret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", ret, DLM_DEREF_LOCKRES_MSG, dlm->key,
> +		     res->owner);
>  	else if (r < 0) {
>  		/* BAD.  other node says I did not have a ref. */
>  		mlog(ML_ERROR,"while dropping ref on %s:%.*s "
> @@ -2977,7 +2981,9 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
>  					 &migrate, sizeof(migrate), nodenum,
>  					 &status);
>  		if (ret < 0) {
> -			mlog(0, "migrate_request returned %d!\n", ret);
> +			mlog(ML_ERROR, "Error %d when sending message %u (key "
> +			     "0x%x) to node %u\n", ret, DLM_MIGRATE_REQUEST_MSG,
> +			     dlm->key, nodenum);
>  			if (!dlm_is_host_down(ret)) {
>  				mlog(ML_ERROR, "unhandled error=%d!\n", ret);
>  				BUG();
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index b4f99de..f8b75ce 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -803,7 +803,9 @@ static int dlm_request_all_locks(struct dlm_ctxt *dlm, u8 request_from,
>  
>  	/* negative status is handled by caller */
>  	if (ret < 0)
> -		mlog_errno(ret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key "
> +		     "0x%x) to node %u\n", ret, DLM_LOCK_REQUEST_MSG,
> +		     dlm->key, request_from);
>  
>  	// return from here, then
>  	// sleep until all received or error
> @@ -955,10 +957,10 @@ static int dlm_send_all_done_msg(struct dlm_ctxt *dlm, u8 dead_node, u8 send_to)
>  	ret = o2net_send_message(DLM_RECO_DATA_DONE_MSG, dlm->key, &done_msg,
>  				 sizeof(done_msg), send_to, &tmpret);
>  	if (ret < 0) {
> +		mlog(ML_ERROR, "Error %d when sending message %u (key "
> +		     "0x%x) to node %u\n", ret, DLM_RECO_DATA_DONE_MSG,
> +		     dlm->key, send_to);
>  		if (!dlm_is_host_down(ret)) {
> -			mlog_errno(ret);
> -			mlog(ML_ERROR, "%s: unknown error sending data-done "
> -			     "to %u\n", dlm->name, send_to);
>  			BUG();
>  		}
>  	} else
> @@ -1126,7 +1128,9 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
>  	if (ret < 0) {
>  		/* XXX: negative status is not handled.
>  		 * this will end up killing this node. */
> -		mlog_errno(ret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key "
> +		     "0x%x) to node %u\n", ret, DLM_MIG_LOCKRES_MSG,
> +		     dlm->key, send_to);
>  	} else {
>  		/* might get an -ENOMEM back here */
>  		ret = status;
> @@ -1642,7 +1646,9 @@ int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  				 &req, sizeof(req), nodenum, &status);
>  	/* XXX: negative status not handled properly here. */
>  	if (ret < 0)
> -		mlog_errno(ret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key "
> +		     "0x%x) to node %u\n", ret, DLM_MASTER_REQUERY_MSG,
> +		     dlm->key, nodenum);
>  	else {
>  		BUG_ON(status < 0);
>  		BUG_ON(status > DLM_LOCK_RES_OWNER_UNKNOWN);
> @@ -2640,7 +2646,7 @@ retry:
>  		if (dlm_is_host_down(ret)) {
>  			/* node is down.  not involved in recovery
>  			 * so just keep going */
> -			mlog(0, "%s: node %u was down when sending "
> +			mlog(ML_NOTICE, "%s: node %u was down when sending "
>  			     "begin reco msg (%d)\n", dlm->name, nodenum, ret);
>  			ret = 0;
>  		}
> @@ -2660,11 +2666,12 @@ retry:
>  		}
>  		if (ret < 0) {
>  			struct dlm_lock_resource *res;
> +
>  			/* this is now a serious problem, possibly ENOMEM
>  			 * in the network stack.  must retry */
>  			mlog_errno(ret);
>  			mlog(ML_ERROR, "begin reco of dlm %s to node %u "
> -			    " returned %d\n", dlm->name, nodenum, ret);
> +			     "returned %d\n", dlm->name, nodenum, ret);
>  			res = dlm_lookup_lockres(dlm, DLM_RECOVERY_LOCK_NAME,
>  						 DLM_RECOVERY_LOCK_NAME_LEN);
>  			if (res) {
> @@ -2789,7 +2796,9 @@ stage2:
>  		if (ret >= 0)
>  			ret = status;
>  		if (ret < 0) {
> -			mlog_errno(ret);
> +			mlog(ML_ERROR, "Error %d when sending message %u (key "
> +			     "0x%x) to node %u\n", ret, DLM_FINALIZE_RECO_MSG,
> +			     dlm->key, nodenum);
>  			if (dlm_is_host_down(ret)) {
>  				/* this has no effect on this recovery
>  				 * session, so set the status to zero to
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 49e29ec..2c1f306 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -355,7 +355,8 @@ static enum dlm_status dlm_send_remote_unlock_request(struct dlm_ctxt *dlm,
>  			mlog(0, "master was in-progress.  retry\n");
>  		ret = status;
>  	} else {
> -		mlog_errno(tmpret);
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", tmpret, DLM_UNLOCK_LOCK_MSG, dlm->key, owner);
>  		if (dlm_is_host_down(tmpret)) {
>  			/* NOTE: this seems strange, but it is what we want.
>  			 * when the master goes down during a cancel or
>   
