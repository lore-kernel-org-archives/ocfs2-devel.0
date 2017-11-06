From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 6 Nov 2017 17:37:06 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/cluster: unlock the
 o2hb_live_lock before the o2nm_depend_item()
In-Reply-To: <59FAB46C.9050703@huawei.com>
References: <59FAB46C.9050703@huawei.com>
Message-ID: <aa4bf9f5-d58f-9338-96df-d552ce003643@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

For local heartbeat mode, I understand that if the region is not found,
o2hb_live_lock won't be released. And if the region is found, it doesn't
have to iterate the next region. So I agree with your fix in this case.

But I still don't get how to make sure the safe iteration in case of
global heartbeat mode.

Thanks,
Joseph

On 17/11/2 14:00, alex chen wrote:
> In the following situation, the down_write() will be called under
> the spin_lock(), which may lead a soft lockup:
> o2hb_region_inc_user
>  spin_lock(&o2hb_live_lock)
>   o2hb_region_pin
>    o2nm_depend_item
>     configfs_depend_item
>      inode_lock
>       down_write
>       -->here may sleep and reschedule
> 
> So we should unlock the o2hb_live_lock before the o2nm_depend_item(), and
> get item reference in advance to prevent the region to be released.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index d020604..07b2fdc 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2399,8 +2399,15 @@ static int o2hb_region_pin(const char *region_uuid)
>  		if (reg->hr_item_pinned || reg->hr_item_dropped)
>  			goto skip_pin;
> 
> +		config_item_get(&reg->hr_item);
> +		spin_unlock(&o2hb_live_lock);
> +
>  		/* Ignore ENOENT only for local hb (userdlm domain) */
>  		ret = o2nm_depend_item(&reg->hr_item);
> +
> +		config_item_put(&reg->hr_item);
> +		spin_lock(&o2hb_live_lock);
> +
>  		if (!ret) {
>  			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
>  			reg->hr_item_pinned = 1;
> 
