From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 26 Jun 2017 17:44:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free 'dummy_sc' in
 sc_fop_release() in case of memory leak
In-Reply-To: <594FB0A4.2050105@huawei.com>
References: <594FB0A4.2050105@huawei.com>
Message-ID: <7d3b370d-8d93-8419-6c09-284259d85287@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: piaojun <piaojun@huawei.com>, mfasheh@versity.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>



On 17/6/25 20:46, piaojun wrote:
> 'sd->dbg_sock' is malloc in sc_common_open(), but not freed at the end
> of sc_fop_release().
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
Looks good.
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

Thanks,
Joseph

> ---
>  fs/ocfs2/cluster/netdebug.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> index 564c504..74a21f6 100644
> --- a/fs/ocfs2/cluster/netdebug.c
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -426,6 +426,7 @@ static int sc_fop_release(struct inode *inode, struct file *file)
>  	struct o2net_sock_container *dummy_sc = sd->dbg_sock;
> 
>  	o2net_debug_del_sc(dummy_sc);
> +	kfree(dummy_sc);
>  	return seq_release_private(inode, file);
>  }
> 
