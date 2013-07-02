From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 2 Jul 2013 02:53:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix NULL pointer dereference when
 tranverse o2hb_all_regions
In-Reply-To: <51D29637.9050403@huawei.com>
References: <51D29637.9050403@huawei.com>
Message-ID: <20130702095323.GC26307@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 02, 2013 at 04:58:31PM +0800, Xue jiufei wrote:
> There may exist NULL pointer dereference in config_item_name() when
> one volume(say Volume A) unmounts while another(say Volume B) mounting.
> 
>      Volume A                          Volume B
> already Mounted.
> Unmounting, call
> o2hb_heartbeat_group_drop_item()
>   -> config_item_put(item)
>   set reg(A)->item.ci_name to NULL
>   in function config_item_cleanup().
>                                     begin mounting, call
>                                     o2hb_region_pin() and tranverse all
>                                     regions. When reading 
>                                     reg(A)->item.ci_name, it causes
>                                     NULL pointer dereference.
> call o2hb_region_release() and
> del reg(A) from list.
> 
> So we should skip accessing regions that is going to release when
> tranverse o2hb_all_regions.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: joyce <xuejiufei@huawei.com>

Good catch.

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/cluster/heartbeat.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 42252bf..aeafe10 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2389,6 +2389,9 @@ static int o2hb_region_pin(const char *region_uuid)
>  	assert_spin_locked(&o2hb_live_lock);
>  
>  	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> +		if (reg->hr_item_dropped)
> +			continue;
> +
>  		uuid = config_item_name(&reg->hr_item);
>  
>  		/* local heartbeat */
> @@ -2439,6 +2442,9 @@ static void o2hb_region_unpin(const char *region_uuid)
>  	assert_spin_locked(&o2hb_live_lock);
>  
>  	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> +		if (reg->hr_item_dropped)
> +			continue;
> +
>  		uuid = config_item_name(&reg->hr_item);
>  		if (region_uuid) {
>  			if (strcmp(region_uuid, uuid))
> @@ -2654,6 +2660,9 @@ int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
>  
>  	p = region_uuids;
>  	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> +		if (reg->hr_item_dropped)
> +			continue;
> +
>  		mlog(0, "Region: %s\n", config_item_name(&reg->hr_item));
>  		if (numregs < max_regions) {
>  			memcpy(p, config_item_name(&reg->hr_item),
> -- 
> 1.7.9.7
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

			http://www.jlbec.org/
			jlbec at evilplan.org
