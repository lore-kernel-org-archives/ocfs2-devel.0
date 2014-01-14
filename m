From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 14 Jan 2014 12:06:29 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: fix NULL pointer dereference
 in o2dlm_blocking_ast_wrapper
In-Reply-To: <1389403153-4220-1-git-send-email-srinivas.eeda@oracle.com>
References: <1389403153-4220-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <52D4B7C5.7040409@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/1/11 9:19, Srinivas Eeda wrote:
> From: Srinivas Eeda <seeda@srini.(none)>
> 
> A tiny race between BAST and unlock message causes the NULL dereference.
> 
> A node sends an unlock request to master and receives a response. Before
> processing the response it receives a BAST from the master. Since both requests
> are processed by different threads it creates a race. While the BAST is being
> processed, lock can get freed by unlock code.
> 
> This patch makes bast to return immediately if lock is found but unlock is
> pending. The code should handle this race. We also have to fix master node to
> skip sending BAST after receiving unlock message.
> 
> Below is the crash stack
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> IP: [<ffffffffa015e023>] o2dlm_blocking_ast_wrapper+0xd/0x16
> [<ffffffffa034e3db>] dlm_do_local_bast+0x8e/0x97 [ocfs2_dlm]
> [<ffffffffa034f366>] dlm_proxy_ast_handler+0x838/0x87e [ocfs2_dlm]
> [<ffffffffa0308abe>] o2net_process_message+0x395/0x5b8 [ocfs2_nodemanager]
> [<ffffffffa030aac8>] o2net_rx_until_empty+0x762/0x90d [ocfs2_nodemanager]
> [<ffffffff81071802>] worker_thread+0x14d/0x1ed
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmast.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index b46278f..dbc6cee 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -385,8 +385,13 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
>  		head = &res->granted;
>  
>  	list_for_each_entry(lock, head, list) {
> -		if (lock->ml.cookie == cookie)
> -			goto do_ast;
> +		/* if lock is found but unlock is pending ignore the bast */
> +		if (lock->ml.cookie == cookie) {
> +			if (lock->unlock_pending)
> +				break;
> +			else
> +				goto do_ast;
> +		}
>  	}
>  
>  	mlog(0, "Got %sast for unknown lock! cookie=%u:%llu, name=%.*s, "
> 
I found you sent a version on Jan 30, 2012.
https://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008469.html
Compared with the old version, this version only saves a little bit CPU,
am I right?
