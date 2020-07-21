From: Changwei Ge <chge@linux.alibaba.com>
Date: Tue, 21 Jul 2020 10:24:49 +0800
Subject: [Ocfs2-devel] [PATCH] dlmfs: add a newline when printing
 'capabilities' by sysfs
In-Reply-To: <20200720082433.164311-1-wangxiongfeng2@huawei.com>
References: <20200720082433.164311-1-wangxiongfeng2@huawei.com>
Message-ID: <5ee49484-1a8f-d4ed-c4b3-0d1d0cef4f52@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi?

I am afraid that doing so might introduce a compatible risk into exited 
systems which reply ocfs2/dlmfs.

We can't guarantee that no system management tools is using the 
information reported from this file.

Basically, ocfs2-tools works of top of it. But after a quick glance at 
the source, I didn't see side effect if this path applied. Better you 
can do some test if this patch breaks ocfs2-tools.

Still my suggestion is that we don't try to touch this file as what I 
explained above.

Thanks,
Changwei


On 7/20/20 4:24 PM, Xiongfeng Wang wrote:
> When I cat module parameter 'capabilities' by sysfs, it displays as
> follows. It's better to add a newline for easy reading.
> 
> root at syzkaller:~# cat /sys/module/ocfs2_dlmfs/parameters/capabilities
> bast stackglueroot at syzkaller:~#
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>   fs/ocfs2/dlmfs/dlmfs.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index ea868c6f9800..1f9c864ec09b 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -82,8 +82,13 @@ static int param_set_dlmfs_capabilities(const char *val,
>   static int param_get_dlmfs_capabilities(char *buffer,
>   					const struct kernel_param *kp)
>   {
> -	return strlcpy(buffer, DLMFS_CAPABILITIES,
> +	int cnt;
> +
> +	cnt = strlcpy(buffer, DLMFS_CAPABILITIES,
>   		       strlen(DLMFS_CAPABILITIES) + 1);
> +	cnt += sprintf(buffer + cnt, "\n");
> +
> +	return cnt;
>   }
>   module_param_call(capabilities, param_set_dlmfs_capabilities,
>   		  param_get_dlmfs_capabilities, NULL, 0444);
> 
