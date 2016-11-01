From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 1 Nov 2016 08:22:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean up deadcode in
	dlm_master_request_handler()
In-Reply-To: <58174C91.3040004@huawei.com>
References: <58174C91.3040004@huawei.com>
Message-ID: <5817E045.7040902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/10/31 21:52, piaojun wrote:
> when 'dispatch_assert' is set, 'response' must be DLM_MASTER_RESP_YES,
> and 'res' won't be null, so execution can't reach these two branch.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>

Looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 3f828a1..9a72dd8 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1644,12 +1644,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
>  	 * dlm_assert_master_worker() isn't called, we drop it here.
>  	 */
>  	if (dispatch_assert) {
> -		if (response != DLM_MASTER_RESP_YES)
> -			mlog(ML_ERROR, "invalid response %d\n", response);
> -		if (!res) {
> -			mlog(ML_ERROR, "bad lockres while trying to assert!\n");
> -			BUG();
> -		}
>  		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
>  			     dlm->node_num, res->lockname.len, res->lockname.name);
>  		spin_lock(&res->spinlock);
> 
