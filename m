From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 3 Dec 2019 09:05:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove redundant assignment to
	ret
In-Reply-To: <20191202164833.62865-1-colin.king@canonical.com>
References: <20191202164833.62865-1-colin.king@canonical.com>
Message-ID: <787d96be-b750-9fa2-19c6-30c1af86cc3c@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org



On 19/12/3 00:48, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never
> read and it is being updated later with a new value.  The initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 064ce5bbc3f6..2734867473a6 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1668,7 +1668,7 @@ static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
>  int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  			  u8 nodenum, u8 *real_master)
>  {
> -	int ret = -EINVAL;
> +	int ret;
>  	struct dlm_master_requery req;
>  	int status = DLM_LOCK_RES_OWNER_UNKNOWN;
>  
> 
