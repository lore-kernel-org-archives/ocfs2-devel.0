From: piaojun <piaojun@huawei.com>
Date: Wed, 11 Apr 2018 08:42:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean up unused stack variable
 in dlm_do_local_ast()
In-Reply-To: <1523360966-12594-1-git-send-email-ge.changwei@h3c.com>
References: <1523360966-12594-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5ACD59EE.6060903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

This patch had been merged into mainline already.

Please see patch a43d24cb3b0b.

thanks,
Jun

On 2018/4/10 19:49, Changwei Ge wrote:
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
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
