From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Feb 27 18:55:23 2008
Subject: [Ocfs2-devel] [PATCH] Use dlm_print_one_lock_resource for lock
	reason.
In-Reply-To: <20080228024155.GA9569@tma-pc1.cn.oracle.com>
References: <20080228024155.GA9569@tma-pc1.cn.oracle.com>
Message-ID: <47C6225E.5020107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Actually this is already in the last set of dlm patches. The one I missed
was dlm_lock_add_to_array().

http://oss.oracle.com/pipermail/ocfs2-devel/2008-February/001847.html

Make a patch just for that and we can add that in the checkin queue.

Tao Ma wrote:
> __dlm_print_one_lock_resource must be called with spin_lock
> the res->spinlock. While in some cases, we use it without this
> precondition and lead to the failure of assert_spin_locked.
> So call dlm_print_one_lock_resource instead.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>
> ---
>
>  fs/ocfs2/dlm/dlmconvert.c  |    2 +-
>  fs/ocfs2/dlm/dlmmaster.c   |    4 ++--
>  fs/ocfs2/dlm/dlmrecovery.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> e24386850ba5540d084e1aa0b7934116ff587165
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index ecb4d99..75997b4 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -487,7 +487,7 @@ int dlm_convert_lock_handler(struct o2ne
>  			       "cookie=%u:%llu\n",
>  		     dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
>  		     dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
> -		__dlm_print_one_lock_resource(res);
> +		dlm_print_one_lock_resource(res);
>  		goto leave;
>  	}
>  
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a54d33d..fe6b3ef 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2348,7 +2348,7 @@ int dlm_deref_lockres_handler(struct o2n
>  			mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
>  		     	"but it is already dropped!\n", dlm->name,
>  		     	res->lockname.len, res->lockname.name, node);
> -			__dlm_print_one_lock_resource(res);
> +			dlm_print_one_lock_resource(res);
>  		}
>  		ret = 0;
>  		goto done;
> @@ -2408,7 +2408,7 @@ static void dlm_deref_lockres_worker(str
>  		mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
>  		     "but it is already dropped!\n", dlm->name,
>  		     res->lockname.len, res->lockname.name, node);
> -		__dlm_print_one_lock_resource(res);
> +		dlm_print_one_lock_resource(res);
>  	}
>  
>  	dlm_lockres_put(res);
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 91f747b..550d4e6 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1191,7 +1191,7 @@ static int dlm_add_lock_to_array(struct 
>  			    (ml->type == LKM_EXMODE ||
>  			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
>  				mlog(ML_ERROR, "mismatched lvbs!\n");
> -				__dlm_print_one_lock_resource(lock->lockres);
> +				dlm_print_one_lock_resource(lock->lockres);
>  				BUG();
>  			}
>  			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
>   
