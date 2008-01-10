From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 10 15:18:50 2008
Subject: [Ocfs2-devel] [PATCH 1/1] Clear joining_node no matter whether
	it is in the domain map or not.
In-Reply-To: <20080110072055.GA7911@tma-pc1.cn.oracle.com>
References: <20080110072055.GA7911@tma-pc1.cn.oracle.com>
Message-ID: <20080110231701.GN23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 10, 2008 at 03:20:55PM +0800, tao.ma wrote:
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 2fde7bf..3502bec 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2270,6 +2270,12 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
>  		}
>  	}
>  
> +	/* Clean up join state on node death. */
> +	if (dlm->joining_node == idx) {
> +		mlog(0, "Clearing join state for node %u\n", idx);
> +		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
> +	}
> +
>  	/* check to see if the node is already considered dead */
>  	if (!test_bit(idx, dlm->live_nodes_map)) {
>  		mlog(0, "for domain %s, node %d is already dead. "
> @@ -2288,12 +2294,6 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
>  
>  	clear_bit(idx, dlm->live_nodes_map);
>  
> -	/* Clean up join state on node death. */
> -	if (dlm->joining_node == idx) {
> -		mlog(0, "Clearing join state for node %u\n", idx);
> -		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
> -	}
> -

Ahh ok - we *did* have this code, it was just never being executed. Good
catch Tao. I'll throw this in ocfs2.git.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
