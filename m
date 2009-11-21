From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:25:29 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return -EAGAIN instead of
	EAGAIN in dlm
In-Reply-To: <1258597066-9227-1-git-send-email-tiger.yang@oracle.com>
References: <4B0474A7.9020506@oracle.com>
	<1258597066-9227-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <4B074189.2050108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ack

Tiger Yang wrote:
> We used to return positive EAGAIN to indicate a retry action
> is needed in dlm_begin_reco_handler(). Now we return negative
> -EAGAIN to erase the confusion caused by this error code.
>
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index d9fa3d2..2f9e4e1 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2589,6 +2589,14 @@ retry:
>  			     "begin reco msg (%d)\n", dlm->name, nodenum, ret);
>  			ret = 0;
>  		}
> +		if (ret == -EAGAIN) {
> +			mlog(0, "%s: trying to start recovery of node "
> +			     "%u, but node %u is waiting for last recovery "
> +			     "to complete, backoff for a bit\n", dlm->name,
> +			     dead_node, nodenum);
> +			msleep(100);
> +			goto retry;
> +		}
>  		if (ret < 0) {
>  			struct dlm_lock_resource *res;
>  			/* this is now a serious problem, possibly ENOMEM 
> @@ -2608,14 +2616,6 @@ retry:
>  			 * another ENOMEM */
>  			msleep(100);
>  			goto retry;
> -		} else if (ret == EAGAIN) {
> -			mlog(0, "%s: trying to start recovery of node "
> -			     "%u, but node %u is waiting for last recovery "
> -			     "to complete, backoff for a bit\n", dlm->name,
> -			     dead_node, nodenum);
> -			/* TODO Look into replacing msleep with cond_resched() */
> -			msleep(100);
> -			goto retry;
>  		}
>  	}
>  
> @@ -2639,7 +2639,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  		     dlm->name, br->node_idx, br->dead_node,
>  		     dlm->reco.dead_node, dlm->reco.new_master);
>  		spin_unlock(&dlm->spinlock);
> -		return EAGAIN;
> +		return -EAGAIN;
>  	}
>  	spin_unlock(&dlm->spinlock);
>  
>   
