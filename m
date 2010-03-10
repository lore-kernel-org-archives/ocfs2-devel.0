From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Mar 2010 10:13:34 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: prints peer node number when
 sending tcp msg failed
In-Reply-To: <201003101313.o2ACClp1019681@acsinet15.oracle.com>
References: <201003101313.o2ACClp1019681@acsinet15.oracle.com>
Message-ID: <4B97E14E.3070902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes knowing the node number will be very useful.

Wondering why not just have the mlog in o2net_send_message_vec().
Fewer changes. Do you see any downside?

Wengang Wang wrote:
> This patch adds prints of the number of peer node to which sending tcp message
> failed. It helps debugging.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/cluster/masklog.h |    9 +++++++++
>  fs/ocfs2/cluster/tcp.c     |    9 +++++++--
>  fs/ocfs2/dlm/dlmast.c      |    2 +-
>  fs/ocfs2/dlm/dlmconvert.c  |    2 +-
>  fs/ocfs2/dlm/dlmunlock.c   |    2 +-
>  5 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index 3dfddbe..2af7e93 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -219,6 +219,15 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
>  		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
>  } while (0)
>  
> +/* "node" is number of the node to which sending tcp msg failed */
> +#define mlog_network_errno(st, node) do {				\
> +	int _st = (st);							\
> +	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
> +	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
> +		mlog(ML_ERROR, "failed to send msg to %u. "		\
> +		     "errno: %lld\n", (u32)(node), (long long)_st);	\
> +} while (0)
> +
>  #if defined(CONFIG_OCFS2_DEBUG_MASKLOG)
>  #define mlog_entry(fmt, args...) do {					\
>  	mlog(ML_ENTRY, "ENTRY:" fmt , ##args);				\
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index d8d0c65..bdc4e9a 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1092,12 +1092,17 @@ EXPORT_SYMBOL_GPL(o2net_send_message_vec);
>  int o2net_send_message(u32 msg_type, u32 key, void *data, u32 len,
>  		       u8 target_node, int *status)
>  {
> +	int ret;
>  	struct kvec vec = {
>  		.iov_base = data,
>  		.iov_len = len,
>  	};
> -	return o2net_send_message_vec(msg_type, key, &vec, 1,
> -				      target_node, status);
> +
> +	ret = o2net_send_message_vec(msg_type, key, &vec, 1,
> +				     target_node, status);
> +	if (ret < 0)
> +		mlog_network_errno(ret, target_node);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(o2net_send_message);
>  
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index dccc439..bc50076 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -453,7 +453,7 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	ret = o2net_send_message_vec(DLM_PROXY_AST_MSG, dlm->key, vec, veclen,
>  				     lock->ml.node, &status);
>  	if (ret < 0)
> -		mlog_errno(ret);
> +		mlog_network_errno(ret, lock->ml.node);
>  	else {
>  		if (status == DLM_RECOVERING) {
>  			mlog(ML_ERROR, "sent AST to node %u, it thinks this "
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index f283bce..ba30234 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -391,7 +391,7 @@ static enum dlm_status dlm_send_remote_convert_request(struct dlm_ctxt *dlm,
>  		} else if (ret != DLM_NORMAL && ret != DLM_NOTQUEUED)
>  			dlm_error(ret);
>  	} else {
> -		mlog_errno(tmpret);
> +		mlog_network_errno(tmpret, res->owner);
>  		if (dlm_is_host_down(tmpret)) {
>  			/* instead of logging the same network error over
>  			 * and over, sleep here and wait for the heartbeat
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 49e29ec..acdc7fc 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -355,7 +355,7 @@ static enum dlm_status dlm_send_remote_unlock_request(struct dlm_ctxt *dlm,
>  			mlog(0, "master was in-progress.  retry\n");
>  		ret = status;
>  	} else {
> -		mlog_errno(tmpret);
> +		mlog_network_errno(tmpret, owner);
>  		if (dlm_is_host_down(tmpret)) {
>  			/* NOTE: this seems strange, but it is what we want.
>  			 * when the master goes down during a cancel or
>   
