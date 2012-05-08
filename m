From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 May 2012 17:05:33 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: new structure to implment
 discontiguous local alloc bitmap
In-Reply-To: <1336432890-18638-2-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<1336432890-18638-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20120508000532.GC4713@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 07, 2012 at 04:21:28PM -0700, Srinivas Eeda wrote:
> Current local alloc handles single contiguous free chunk of clusters. This
> patch enhances local alloc to handle discontigous free chunks. It adds a new
> ocfs2_local_alloc_rec structure which tracks single contiguous free chunk. An
> array of these sit in the bitmap itself and track discontiguous chunks. In
> best case there is only one record and increases as the filesystem gets
> fragmented. Number of records at a time are limited depending on the size
> of the bitmap and the max limit is defined by OCFS2_MAX_LOCAL_ALLOC_RECS.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |   10 ++++++++++
>  fs/ocfs2/ocfs2.h      |    8 ++++++++
>  fs/ocfs2/ocfs2_fs.h   |   48 ++++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 210c352..4190e53 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -48,6 +48,16 @@
>  
>  #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
>  
> +#define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
> +					 sizeof(struct ocfs2_local_alloc_rec))
> +#define OCFS2_LOCAL_ALLOC_BITMAP(la)    ((char *)(&(la->la_recs)) +\
> +					 OCFS2_LOCAL_ALLOC_REC_SZ(la))
> +#define OCFS2_LOCAL_ALLOC_BITS_PER_REC (sizeof(struct ocfs2_local_alloc_rec)*8)
> +
> +/* Maximum number of local alloc records */
> +#define OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT	128
> +
> +
>  static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
>  
>  static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index d355e6e..d4c36d2 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -367,6 +367,7 @@ struct ocfs2_super
>  							 * by osb_lock */
>  
>  	struct buffer_head *local_alloc_bh;
> +	struct inode	   *local_alloc_inode;
>  
>  	u64 la_last_gd;
>  
> @@ -522,6 +523,13 @@ static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
>  	return 0;
>  }
>  
> +static inline int ocfs2_supports_discontig_la(struct ocfs2_super *osb)
> +{
> +	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
> +		return 1;
> +	return 0;
> +}
> +
>  static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
>  {
>  	if (ocfs2_supports_indexed_dirs(osb))
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 938387a..6a0fe02 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -102,7 +102,8 @@
>  					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
>  					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
>  					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
> -					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
> +					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO \
> +					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA)
>  #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
>  					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
>  					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
> @@ -177,6 +178,9 @@
>   */
>  #define OCFS2_FEATURE_INCOMPAT_CLUSTERINFO	0x4000
>  
> +/* Discontiguous local alloc */
> +#define OCFS2_FEATURE_INCOMPAT_DISCONTIG_LA	0x8000

	I really wish this could be an RO_COMPAT flag, but I think that
recovery on RO mounts will break with this.  Mark, please confirm, but I
think it has to be INCOMPAT.

> @@ -664,14 +668,19 @@ struct ocfs2_super_block {
>   * Local allocation bitmap for OCFS2 slots
>   * Note that it exists inside an ocfs2_dinode, so all offsets are
>   * relative to the start of ocfs2_dinode.id2.
> + * Each ocfs2_local_alloc_rec tracks one contigous chunk of clusters.
>   */
> +struct ocfs2_local_alloc_rec {
> +	__le32 la_start;	/* 1st cluster in this extent */
> +	__le32 la_clusters;	/* Number of contiguous clusters */
> +};
> +
>  struct ocfs2_local_alloc
>  {
>  /*00*/	__le32 la_bm_off;	/* Starting bit offset in main bitmap */
>  	__le16 la_size;		/* Size of included bitmap, in bytes */
> -	__le16 la_reserved1;
> -	__le64 la_reserved2;
> -/*10*/	__u8   la_bitmap[0];
> +	__le16 la_rec_count;	/* Number of discontiguous records */
> +	struct ocfs2_local_alloc_rec la_recs[0]; /* Localalloc records */
>  };

	You can't delete la_bitmap.  Any filesystem without DISCONTIG_LA
will be expecting the inline bitmap to start there.

> @@ -1380,11 +1389,24 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
>  	u16 size;
>  
>  	size = sb->s_blocksize -
> -		offsetof(struct ocfs2_dinode, id2.i_lab.la_bitmap);
> +		offsetof(struct ocfs2_dinode, id2.i_lab.la_recs);
> +	size -= sizeof(struct ocfs2_local_alloc_rec);

	You can't do this without checking for DISCONTIG_LA.  Again,
filesystems without DISCONTIG_LA will be starting at la_bitmap.

Joel


-- 

"If at first you don't succeed, cover all traces that you tried."
                                                        -Unknown

			http://www.jlbec.org/
			jlbec at evilplan.org
