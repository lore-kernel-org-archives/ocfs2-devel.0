From: Joseph Qi <jiangqi903@gmail.com>
Date: Sun, 28 Apr 2019 09:32:05 +0800
Subject: [Ocfs2-devel] [PATCH] fs: ocfs: fix spelling mistake
 "heartbeart" -> "heartbeat"
In-Reply-To: <1556367755-118120-1-git-send-email-cg.chen@huawei.com>
References: <1556367755-118120-1-git-send-email-cg.chen@huawei.com>
Message-ID: <cee2552d-3a57-418b-1c17-91bb714370f1@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ChenGang <cg.chen@huawei.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, ocfs2-devel@oss.oracle.com, "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>

Hi ChenGang,
Could you please fold these four patches into one?

Thanks,
Joseph

On 19/4/27 20:22, ChenGang wrote:
> There is a spelling mistake in o2hb_do_disk_heartbeat debug message.Fix it.
> 
> Signed-off-by: ChenGang <cg.chen@huawei.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index f3c20b2..e4e7df1 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1198,7 +1198,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
>  	if (atomic_read(&reg->hr_steady_iterations) != 0) {
>  		if (atomic_dec_and_test(&reg->hr_unsteady_iterations)) {
>  			printk(KERN_NOTICE "o2hb: Unable to stabilize "
> -			       "heartbeart on region %s (%s)\n",
> +			       "heartbeat on region %s (%s)\n",
>  			       config_item_name(&reg->hr_item),
>  			       reg->hr_dev_name);
>  			atomic_set(&reg->hr_steady_iterations, 0);
> 
