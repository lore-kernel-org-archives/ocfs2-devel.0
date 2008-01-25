From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Jan 25 16:04:49 2008
Subject: [Ocfs2-devel] ocfs2: Negotiate locking protocol versions.
In-Reply-To: <20080125031730.GC16755@mail.oracle.com>
References: <20080125031730.GC16755@mail.oracle.com>
Message-ID: <20080126000313.GA23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 24, 2008 at 07:17:30PM -0800, Joel Becker wrote:
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index e90b92f..5e10d42 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -142,6 +142,12 @@ struct dlm_ctxt
>  	spinlock_t work_lock;
>  	struct list_head dlm_domain_handlers;
>  	struct list_head	dlm_eviction_callbacks;
> +
> +	/* The filesystem specifies this at domain registration.  We
> +	 * cache it here to know what to tell other nodes. */
> +	struct dlm_protocol_version fs_locking_proto;
> +	/* This is the inter-dlm communication version */
> +	struct dlm_protocol_version dlm_locking_proto;
>  };
>  
>  static inline struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned i)
> @@ -589,10 +595,24 @@ struct dlm_proxy_ast
>  #define DLM_PROXY_AST_MAX_LEN  (sizeof(struct dlm_proxy_ast)+DLM_LVB_LEN)
>  
>  #define DLM_MOD_KEY (0x666c6172)
> -enum dlm_query_join_response {
> +enum dlm_query_join_response_code {
>  	JOIN_DISALLOW = 0,
>  	JOIN_OK,
>  	JOIN_OK_NO_MAP,
> +	JOIN_PROTOCOL_MISMATCH,
> +};
> +
> +union dlm_query_join_response {
> +	int intval;

I think we want 'u32 intval' for uniformity here. Oh, hmm... I suppose you
were trying to match up with o2net_send_message()?


> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index c365206..d346e52 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -252,6 +252,31 @@ static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
>  	.flags		= 0,
>  };
>  
> +/*
> + * This is the filesystem locking protocol version.
> + *
> + * Whenever the filesystem does new things with locks (adds or removes a
> + * lock, orders them differently, does different things underneath a lock),
> + * the version must be changed.  The protocol is negotiated when joining
> + * the dlm domain.  A node may join the domain if its major version is
> + * identical to all other nodes and its minor version is greater than
> + * or equal to all other nodes.  When its minor version is greater than
> + * the other nodes, it will run at the minor version specified by the
> + * other nodes.
> + *
> + * If a locking change is made that will not be compatible with older
> + * versions, the major number must be increased and the minor version set
> + * to zero.  If a change merely adds a behavior that can be disabled when
> + * speaking to older versions, the minor version must be increased.  If a
> + * change adds a fully backwards compatible change (eg, LVB changes that
> + * are just ignored by older versions), the version does not need to be
> + * updated.
> + */
> +static const struct dlm_protocol_version ocfs2_locking_protocol = {
> +	.pv_major = 1,
> +	.pv_minor = 0,
> +};
> +
>  static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
>  {
>  	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
> @@ -2239,7 +2264,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  	dlm_key = crc32_le(0, osb->uuid_str, strlen(osb->uuid_str));
>  
>  	/* for now, uuid == domain */
> -	dlm = dlm_register_domain(osb->uuid_str, dlm_key);
> +	osb->osb_locking_proto = ocfs2_locking_protocol;

Can we please initialize this in ocfs2_initialize_osb()?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
