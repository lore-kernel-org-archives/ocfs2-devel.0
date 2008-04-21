From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon, 21 Apr 2008 10:16:28 -0700
Subject: [Ocfs2-devel] [2.6 patch] ocfs2/dlm/dlmdebug.c: make 2
 functions static
In-Reply-To: <20080421084937.GU26897@cs181133002.pp.htv.fi>
References: <20080421084937.GU26897@cs181133002.pp.htv.fi>
Message-ID: <480CCBEC.3080905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - stringify_lockname()
> - dlm_debug_put()
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>   

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

> ---
>
>  fs/ocfs2/dlm/dlmdebug.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> fec83555cf8467e5c932fa52177b8f567eb84d94 diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 5f6d858..1b81dcb 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -44,7 +44,8 @@
>  #define MLOG_MASK_PREFIX ML_DLM
>  #include "cluster/masklog.h"
>  
> -int stringify_lockname(const char *lockname, int locklen, char *buf, int len);
> +static int stringify_lockname(const char *lockname, int locklen, char *buf,
> +			      int len);
>  
>  void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
>  {
> @@ -251,7 +252,8 @@ EXPORT_SYMBOL_GPL(dlm_errname);
>   *
>   * For more on lockname formats, please refer to dlmglue.c and ocfs2_lockid.h.
>   */
> -int stringify_lockname(const char *lockname, int locklen, char *buf, int len)
> +static int stringify_lockname(const char *lockname, int locklen, char *buf,
> +			      int len)
>  {
>  	int out = 0;
>  	__be64 inode_blkno_be;
> @@ -368,7 +370,7 @@ static void dlm_debug_free(struct kref *kref)
>  	kfree(dc);
>  }
>  
> -void dlm_debug_put(struct dlm_debug_ctxt *dc)
> +static void dlm_debug_put(struct dlm_debug_ctxt *dc)
>  {
>  	if (dc)
>  		kref_put(&dc->debug_refcnt, dlm_debug_free);
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
