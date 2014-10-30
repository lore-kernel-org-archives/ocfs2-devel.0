From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 29 Oct 2014 22:16:39 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2net: fix connect expired
In-Reply-To: <1414633271-20389-1-git-send-email-junxiao.bi@oracle.com>
References: <1414633271-20389-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <5451C9B7.7080802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Junxiao,

can you please describe under what circumstances you saw this problem? 
My understanding is o2net_connect_expired is only queued when connection 
actually broke and ENOTCONN is the right error in that case.

Thanks,
--Srini

On 10/29/2014 06:41 PM, Junxiao Bi wrote:
> Set nn_persistent_error to -ENOTCONN will stop reconnect since the
> "stop" condition in o2net_start_connect() will be true.
>
> stop = (nn->nn_sc ||
> 		(nn->nn_persistent_error &&
> 		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));
>
> This will make connection never be established if the first connection request
> is lost.
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/cluster/tcp.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 97de0fb..4d6b645 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1736,7 +1736,7 @@ static void o2net_connect_expired(struct work_struct *work)
>   		     o2net_idle_timeout() / 1000,
>   		     o2net_idle_timeout() % 1000);
>   
> -		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
> +		o2net_set_nn_state(nn, NULL, 0, 0);
>   	}
>   	spin_unlock(&nn->nn_lock);
>   }
