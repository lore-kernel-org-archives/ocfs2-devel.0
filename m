From: piaojun <piaojun@huawei.com>
Date: Thu, 15 Mar 2018 21:02:32 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: clean up unused stack
 variable in dlm_do_local_ast()
In-Reply-To: <1521116681-14602-2-git-send-email-ge.changwei@h3c.com>
References: <1521116681-14602-1-git-send-email-ge.changwei@h3c.com>
	<1521116681-14602-2-git-send-email-ge.changwei@h3c.com>
Message-ID: <5AAA6EE8.7010102@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2018/3/15 20:24, Changwei Ge wrote:
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Acked-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmast.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index fd6bbbb..39831fc 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -224,14 +224,12 @@ void dlm_do_local_ast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  		      struct dlm_lock *lock)
>  {
>  	dlm_astlockfunc_t *fn;
> -	struct dlm_lockstatus *lksb;
>  
>  	mlog(0, "%s: res %.*s, lock %u:%llu, Local AST\n", dlm->name,
>  	     res->lockname.len, res->lockname.name,
>  	     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
>  	     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  
> -	lksb = lock->lksb;
>  	fn = lock->ast;
>  	BUG_ON(lock->ml.node != dlm->node_num);
>  
> 
