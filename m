From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Feb 2009 23:31:39 -0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Cleanup the lockname print
	in	dlmglue.c
In-Reply-To: <1233693436-29263-2-git-send-email-sunil.mushran@oracle.com>
References: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
	<1233693436-29263-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090211073138.GB9512@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

sobby

On Tue, Feb 03, 2009 at 12:37:14PM -0800, Sunil Mushran wrote:
> The dentry lock has a different format than other locks. This patch fixes
> ocfs2_log_dlm_error() macro to make it print the dentry lock correctly.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 206a237..7219a86 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -320,9 +320,14 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>  					struct ocfs2_lock_res *lockres);
>  static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
>  						int convert);
> -#define ocfs2_log_dlm_error(_func, _err, _lockres) do {			\
> -	mlog(ML_ERROR, "DLM error %d while calling %s on resource %s\n", \
> -	     _err, _func, _lockres->l_name);				\
> +#define ocfs2_log_dlm_error(_func, _err, _lockres) do {					\
> +	if ((_lockres)->l_type != OCFS2_LOCK_TYPE_DENTRY)				\
> +		mlog(ML_ERROR, "DLM error %d while calling %s on resource %s\n",	\
> +		     _err, _func, _lockres->l_name);					\
> +	else										\
> +		mlog(ML_ERROR, "DLM error %d while calling %s on resource %.*s%08x\n",	\
> +		     _err, _func, OCFS2_DENTRY_LOCK_INO_START - 1, (_lockres)->l_name,	\
> +		     (unsigned int)ocfs2_get_dentry_lock_ino(_lockres));		\
>  } while (0)
>  static int ocfs2_downconvert_thread(void *arg);
>  static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
> -- 
> 1.5.6.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
