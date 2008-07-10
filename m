From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Jul 2008 16:00:03 -0700
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag for
	extended attribute v2
In-Reply-To: <1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080710230002.GA32459@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:27:36PM +0800, Tiger Yang wrote:
> This patch add incompatible flag for extended attribute support.
> This flag could protect EAs not destroyed by previous ocfs2-tools
> or kernel modules.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/ocfs2.h    |    7 +++++++
>  fs/ocfs2/ocfs2_fs.h |   16 ++++++++++------
>  fs/ocfs2/super.c    |    3 ++-
>  fs/ocfs2/xattr.c    |   12 ++++++++++++
>  4 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 1a7394c..76f20a8 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -330,6 +330,13 @@ static inline int ocfs2_supports_inline_data(struct ocfs2_super *osb)
>  	return 0;
>  }
>  
> +static inline int ocfs2_supports_xattr(struct ocfs2_super *osb)
> +{
> +	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR)
> +		return 1;
> +	return 0;
> +}
> +
>  /* set / clear functions because cluster events can make these happen
>   * in parallel so we want the transitions to be atomic. this also
>   * means that any future flags osb_flags must be protected by spinlock
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index a4ebee3..51ce87e 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -91,7 +91,8 @@
>  					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
>  					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
>  					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
> -					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
> +					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
> +					 | OCFS2_FEATURE_INCOMPAT_XATTR)

Why can't we make XATTR an RO_COMPAT feature?


Hmm, I guess if an ro mount has to recover orphans, we could lose space
devoted to external attributes...



>  #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
>  
>  /*
> @@ -128,10 +129,6 @@
>  /* Support for data packed into inode blocks */
>  #define OCFS2_FEATURE_INCOMPAT_INLINE_DATA	0x0040
>  
> -/* Support for the extended slot map */
> -#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
> -
> -
>  /*
>   * Support for alternate, userspace cluster stacks.  If set, the superblock
>   * field s_cluster_info contains a tag for the alternate stack in use as
> @@ -143,6 +140,12 @@
>   */
>  #define OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK	0x0080
>  
> +/* Support for the extended slot map */
> +#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
> +
> +/* Support for extended attributes */
> +#define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
> +
>  /*
>   * backup superblock flag is used to indicate that this volume
>   * has backup superblocks.
> @@ -564,7 +567,8 @@ struct ocfs2_super_block {
>  /*40*/	__le16 s_max_slots;		/* Max number of simultaneous mounts
>  					   before tunefs required */
>  	__le16 s_tunefs_flag;
> -	__le32 s_reserved1;
> +	__le32 s_xattr_inline_size;	/* extended attribute inline size
> +					   for this fs*/

Does this need to be 32 bits wide? I think a __le16 would suffice...
	--Mark

--
Mark Fasheh
