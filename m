From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 18 Nov 2013 15:39:22 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] Add clustername to cluster connection
In-Reply-To: <20131112140627.GA3928@shrek.lan>
References: <20131112140627.GA3928@shrek.lan>
Message-ID: <20131118233922.GW29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 12, 2013 at 08:06:31AM -0600, Goldwyn Rodrigues wrote:
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/dlmglue.c   |  2 ++
>  fs/ocfs2/ocfs2.h     |  1 +
>  fs/ocfs2/stackglue.c | 11 ++++++++---
>  fs/ocfs2/stackglue.h |  7 +++++++
>  fs/ocfs2/super.c     |  8 +++++---
>  5 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 3a44a64..7c57de3 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2996,6 +2996,8 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  
>  	/* for now, uuid == domain */
>  	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
> +				       osb->osb_cluster_name,
> +				       strlen(osb->osb_cluster_name),
>  				       osb->uuid_str,
>  				       strlen(osb->uuid_str),
>  				       &lproto, ocfs2_do_node_down, osb,
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 3a90347..553f53c 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -387,6 +387,7 @@ struct ocfs2_super
>  	u8 osb_stackflags;
>  
>  	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
> +	char osb_cluster_name[OCFS2_CLUSTER_NAME_LEN + 1];
>  	struct ocfs2_cluster_connection *cconn;
>  	struct ocfs2_lock_res osb_super_lockres;
>  	struct ocfs2_lock_res osb_rename_lockres;
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 39abf89..58b53f9 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -309,6 +309,8 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
>  EXPORT_SYMBOL_GPL(ocfs2_plock);
>  
>  int ocfs2_cluster_connect(const char *stack_name,
> +			  const char *cluster_name,
> +			  int cluster_name_len,
>  			  const char *group,
>  			  int grouplen,
>  			  struct ocfs2_locking_protocol *lproto,
> @@ -342,8 +344,10 @@ int ocfs2_cluster_connect(const char *stack_name,
>  		goto out;
>  	}
>  
> -	memcpy(new_conn->cc_name, group, grouplen);
> +	strlcpy(new_conn->cc_name, group, grouplen + 1);
>  	new_conn->cc_namelen = grouplen;
> +	strlcpy(new_conn->cc_cluster_name, cluster_name, cluster_name_len + 1);
> +	new_conn->cc_cluster_name_len = cluster_name_len;

Ok, so strlcpy says the length argument is 'size of destination buffer'.
Here you use cluster_name_len + 1 but cc_cluster_name is defined as having
CLUSTER_NAME_MAX. Possibly this is just confusing because I'm seeing the
other char array declarations in this patch, but shouldn't that be
CLUSTER_NAME_MAX+1 for the definition of cc_cluster_name ?
	--Mark

--
Mark Fasheh
