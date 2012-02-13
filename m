From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 13 Feb 2012 11:39:27 -0800
Subject: [Ocfs2-devel] [patch] ocfs2: cleanup error handling in
	o2hb_alloc_hb_set()
In-Reply-To: <20120213135047.GA10683@elgon.mountain>
References: <20120213135047.GA10683@elgon.mountain>
Message-ID: <4F3966EF.9070405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hmm... I would say NAK because config_group_item_type_name() could
change in the future. And there is nothing wrong with the current
code.

On 02/13/2012 05:50 AM, Dan Carpenter wrote:
> If "ret" is NULL, then "hs" is also NULL, so there is no need to free
> it.  config_group_init_type_name() can't fail if the name ("heartbeat"
> in this case) is less than CONFIGFS_ITEM_NAME_LEN (20) characters long
> so we can just remove this error handling code.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
>
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index f3f2d95..0bca51b 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2306,20 +2306,14 @@ static struct config_item_type o2hb_heartbeat_group_type = {
>   struct config_group *o2hb_alloc_hb_set(void)
>   {
>   	struct o2hb_heartbeat_group *hs = NULL;
> -	struct config_group *ret = NULL;
>
>   	hs = kzalloc(sizeof(struct o2hb_heartbeat_group), GFP_KERNEL);
>   	if (hs == NULL)
> -		goto out;
> +		return NULL;
>
>   	config_group_init_type_name(&hs->hs_group, "heartbeat",
>   				&o2hb_heartbeat_group_type);
> -
> -	ret =&hs->hs_group;
> -out:
> -	if (ret == NULL)
> -		kfree(hs);
> -	return ret;
> +	return&hs->hs_group;
>   }
>
>   void o2hb_free_hb_set(struct config_group *group)
