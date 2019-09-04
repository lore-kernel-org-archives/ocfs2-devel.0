From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 3 Sep 2019 21:14:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean up deadcode in
 dlm_master_request_handler()
In-Reply-To: <58174C91.3040004@huawei.com>
References: <58174C91.3040004@huawei.com>
Message-ID: <20190903211412.9fa850ed2c231665e1967e2f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 31 Oct 2016 21:52:17 +0800 piaojun <piaojun@huawei.com> wrote:

> when 'dispatch_assert' is set, 'response' must be DLM_MASTER_RESP_YES,
> and 'res' won't be null, so execution can't reach these two branch.
> 
> ...
>
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

This code is quite different in Linus's current tree.
