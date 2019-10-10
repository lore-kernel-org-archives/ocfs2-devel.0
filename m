From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 10 Oct 2019 09:32:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2:fix potential Null Ptr Dereference
In-Reply-To: <20191010010752.25941-1-yzhai003@ucr.edu>
References: <20191010010752.25941-1-yzhai003@ucr.edu>
Message-ID: <76706fdf-6758-991c-de94-fe823251a3a3@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yizhuo <yzhai003@ucr.edu>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ChenGang <cg.chen@huawei.com>, Richard Fontana <rfontana@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jia Guo <guojia12@huawei.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 19/10/10 09:07, Yizhuo wrote:
> Inside function o2hb_region_blocks_store(), to_o2hb_region()
> could return NULL but there's no check before its dereference,
> which is potentially unsafe.

As I described before, this won't happen IMHO.
configfs item is initialized after loading module, so region should
be valid here.


Thanks,
Joseph

> 
> Signed-off-by: Yizhuo <yzhai003@ucr.edu>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index a368350d4c27..93f2b540f245 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1628,7 +1628,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  	unsigned long tmp;
>  	char *p = (char *)page;
>  
> -	if (reg->hr_bdev)
> +	if (!reg || reg->hr_bdev)
>  		return -EINVAL;
>  
>  	tmp = simple_strtoul(p, &p, 0);
> 
