From: Wengang <wen.gang.wang@oracle.com>
Date: Wed, 29 Oct 2014 09:42:17 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: fix a race between purge and
 master query
In-Reply-To: <1414535056-30193-1-git-send-email-srinivas.eeda@oracle.com>
References: <1414535056-30193-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <545045F9.2000704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>

? 2014?10?29? 06:24, Srinivas Eeda ??:
> Node A sends master query request to node B which is the master. At this time
> lockres happens to be on purgelist. dlm_master_request_handler gets the dlm
> spinlock, finds the resource and releases the dlm spin lock. Right at this
> dlm_thread on this node could purge the lockres. dlm_master_request_handler
> can then acquire lockres spinlock and reply to Node A that node B is the
> master even though lockres on node B is purged.
>
> The above scenario will now make node A falsely think node B is the master
> which is inconsistent. Further if another node C tries to master the same
> resource, every node will respond they are not the master. Node C then masters
> the resource and sends assert master to all nodes. This will now make node A
> crash with the following message.
>
> dlm_assert_master_handler:1831 ERROR: DIE! Mastery assert from 9, but current
> owner is 10!
>
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmmaster.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 215e41a..3689b35 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1460,6 +1460,18 @@ way_up_top:
>   
>   		/* take care of the easy cases up front */
>   		spin_lock(&res->spinlock);
> +
> +		/*
> +		 * Right after dlm spinlock was released, dlm_thread could have
> +		 * purged the lockres. Check if lockres got unhashed. If so
> +		 * start over.
> +		 */
> +		if (hlist_unhashed(&res->hash_node)) {
> +			spin_unlock(&res->spinlock);
> +			dlm_lockres_put(res);
> +			goto way_up_top;
> +		}
> +
>   		if (res->state & (DLM_LOCK_RES_RECOVERING|
>   				  DLM_LOCK_RES_MIGRATING)) {
>   			spin_unlock(&res->spinlock);
