From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 25 Sep 2010 16:11:40 +0800
Subject: [Ocfs2-devel] [PATCH 01/20] ocfs2/cluster: Add heartbeat mode
 configfs parameter
In-Reply-To: <1284504656-2434-2-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100925081140.GA3950@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-09-14 15:50, Sunil Mushran wrote:
> Add heartbeat mode parameter to the configfs tree. This will be used
> to set/show the heartbeat mode. The user is free to toggle the mode
> between local and global as long as there is no active heartbeat region.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c |   70 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 70 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 41d5f1f..57cc715 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -77,7 +77,19 @@ static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
>  
> +static
> +ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
> +					const char *page, size_t count)
> +{
> +	unsigned int i;
> +	int ret;
> +	size_t len;
> +
> +	len = (page[count - 1] == '\n') ? count - 1 : count;

How about adding
 
+	if (!len)
+		return -EINVAL;

In case len is 0(though userspace should take care of this), strnicmp() returns "match".
And the mode will be set to O2HB_HEARTBEAT_LOCAL unexpectedly.

regards,
wengang.
> +
> +	for (i = 0; i < O2HB_HEARTBEAT_NUM_MODES; ++i) {
> +		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
> +			continue;
> +
> +		ret = o2hb_global_hearbeat_mode_set(i);
> +		if (!ret)
> +			printk(KERN_NOTICE "ocfs2: Heartbeat mode set to %s\n",
> +			       o2hb_heartbeat_mode_desc[i]);
> +		return count;
> +	}
> +
> +	return -EINVAL;
> +
> +}
