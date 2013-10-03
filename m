From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 3 Oct 2013 13:24:32 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] Add clustername to cluster connection
In-Reply-To: <20131003054907.GA12884@shrek.lan>
References: <20131003054907.GA12884@shrek.lan>
Message-ID: <20131003132432.c47353ad1681cf4f122ec6d7@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 3 Oct 2013 00:49:12 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 3a44a64..7c57de3 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
>
> ...
>
> @@ -344,6 +346,8 @@ int ocfs2_cluster_connect(const char *stack_name,
>  
>  	memcpy(new_conn->cc_name, group, grouplen);
>  	new_conn->cc_namelen = grouplen;
> +	memcpy(new_conn->cc_cluster_name, cluster_name, cluster_name_len);
> +	new_conn->cc_cluster_name_len = cluster_name_len;

I don't know what prevents buffer overflows or lack of null-termination
here.  Can we use something safer like strlcpy()?

>  	new_conn->cc_recovery_handler = recovery_handler;
>  	new_conn->cc_recovery_data = recovery_data;
>  
> ...
>
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2237,6 +2237,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			status = -EINVAL;
>  			goto bail;
>  		}
> +		memcpy(osb->osb_cluster_name,
> +			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> +			OCFS2_CLUSTER_NAME_LEN);

Ditto.

>
> ...
>
