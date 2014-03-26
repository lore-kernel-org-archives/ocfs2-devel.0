From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Mar 2014 14:33:03 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if cluster name exists
	before deref
In-Reply-To: <1395768118-21368-1-git-send-email-sasha.levin@oracle.com>
References: <1395768118-21368-1-git-send-email-sasha.levin@oracle.com>
Message-ID: <20140326143303.11d720d90a6388e41bf7b6fe@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 25 Mar 2014 13:21:58 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Commit c74a3bdd9b "ocfs2: add clustername to cluster connection"
> is trying to strlcpy a string which was explicitly passed as NULL
> in the very same patch, triggering a NULL ptr deref.
> 
> [  640.225193] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  640.230224] IP: strlcpy (lib/string.c:388 lib/string.c:151)

Well that was a bit of a screwup.

> As a side note, how the hell was this new code path tested?
> It's obviously broken and there's no way it even passes
> a very basic test.

I was wondering that.

> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 5e4d314..83f1a66 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -346,7 +346,9 @@ int ocfs2_cluster_connect(const char *stack_name,
>  
>  	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
>  	new_conn->cc_namelen = grouplen;
> -	strlcpy(new_conn->cc_cluster_name, cluster_name, CLUSTER_NAME_MAX + 1);
> +	if (cluster_name_len)
> +		strlcpy(new_conn->cc_cluster_name, cluster_name,
> +			CLUSTER_NAME_MAX + 1);
>  	new_conn->cc_cluster_name_len = cluster_name_len;
>  	new_conn->cc_recovery_handler = recovery_handler;
>  	new_conn->cc_recovery_data = recovery_data;

So we end up with the null string for the cluster name.

I suppose we can merge this short-term to avoid the oops, but surely
this isn't what's supposed to happen.

Goldwyn, this needs urgent attention please.
