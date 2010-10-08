From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 07 Oct 2010 17:33:40 -0700
Subject: [Ocfs2-devel] [PATCH 10/22] ocfs2/cluster: Print messages when
 adding/removing nodes
In-Reply-To: <1286496936-17072-11-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
	<1286496936-17072-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <4CAE66E4.8020807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I am going to change ML_O2CB to ML_CLUSTER.

On 10/07/2010 05:15 PM, Sunil Mushran wrote:
> Prints messages when the user adds or removes nodes.
>
> Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>
> ---
>   fs/ocfs2/cluster/masklog.h     |    3 ++-
>   fs/ocfs2/cluster/nodemanager.c |    5 +++++
>   2 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index fd96e2a..29e7cb6 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -119,7 +119,8 @@
>   #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
>   #define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
>   #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
> -#define	ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
> +#define ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
> +#define ML_O2CB		0x0000001000000000ULL /* o2cb cluster */
>
>   #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
>   #define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index ed0c9f3..e9f1135 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -711,6 +711,8 @@ static struct config_item *o2nm_node_group_make_item(struct config_group *group,
>   	config_item_init_type_name(&node->nd_item, name,&o2nm_node_type);
>   	spin_lock_init(&node->nd_lock);
>
> +	mlog(ML_O2CB, "o2nm: Registering node %s\n", name);
> +
>   	return&node->nd_item;
>   }
>
> @@ -744,6 +746,9 @@ static void o2nm_node_group_drop_item(struct config_group *group,
>   	}
>   	write_unlock(&cluster->cl_nodes_lock);
>
> +	mlog(ML_O2CB, "o2nm: Unregistered node %s\n",
> +	     config_item_name(&node->nd_item));
> +
>   	config_item_put(item);
>   }
>
>    
