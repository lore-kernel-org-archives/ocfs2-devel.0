From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 22 Aug 2012 10:10:14 -0700
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2:
	s/o2hb_hearbeat_xxx/o2hb_heartbeat_xxx/g at heartbeat.c
In-Reply-To: <5034A88E.9060008@oracle.com>
References: <5034A88E.9060008@oracle.com>
Message-ID: <CAEeiSHWteZop__HrSxbg9wsBVfSha+kk6QO44ZXAYE43Ljda1Q@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@gmail.com>

On Wed, Aug 22, 2012 at 2:38 AM, Jeff Liu <jeff.liu@oracle.com> wrote:

> Not sure if this patch does make sense or not, but it could make the
> signature of those routines
> in a consistent manner with others for heartbeating.
>
> CC: Sunil Mushran <sunil.mushran@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>  fs/ocfs2/cluster/heartbeat.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1b6ce53..d193679 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -176,7 +176,7 @@ static void o2hb_dead_threshold_set(unsigned int
> threshold)
>         }
>  }
>
> -static int o2hb_global_hearbeat_mode_set(unsigned int hb_mode)
> +static int o2hb_global_heartbeat_mode_set(unsigned int hb_mode)
>  {
>         int ret = -1;
>
> @@ -2290,7 +2290,7 @@ ssize_t o2hb_heartbeat_group_mode_store(struct
> o2hb_heartbeat_group *group,
>                 if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
>                         continue;
>
> -               ret = o2hb_global_hearbeat_mode_set(i);
> +               ret = o2hb_global_heartbeat_mode_set(i);
>                 if (!ret)
>                         printk(KERN_NOTICE "o2hb: Heartbeat mode set to
> %s\n",
>                                o2hb_heartbeat_mode_desc[i]);
> @@ -2323,7 +2323,7 @@ static struct configfs_attribute
> *o2hb_heartbeat_group_attrs[] = {
>         NULL,
>  };
>
> -static struct configfs_item_operations o2hb_hearbeat_group_item_ops = {
> +static struct configfs_item_operations o2hb_heartbeat_group_item_ops = {
>         .show_attribute         = o2hb_heartbeat_group_show,
>         .store_attribute        = o2hb_heartbeat_group_store,
>  };
> @@ -2335,7 +2335,7 @@ static struct configfs_group_operations
> o2hb_heartbeat_group_group_ops = {
>
>  static struct config_item_type o2hb_heartbeat_group_type = {
>         .ct_group_ops   = &o2hb_heartbeat_group_group_ops,
> -       .ct_item_ops    = &o2hb_hearbeat_group_item_ops,
> +       .ct_item_ops    = &o2hb_heartbeat_group_item_ops,
>         .ct_attrs       = o2hb_heartbeat_group_attrs,
>         .ct_owner       = THIS_MODULE,
>  };
> --
> 1.7.4.1
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120822/919b72f1/attachment.html 
