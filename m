From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 May 2012 17:22:58 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: implement discontiguous
	localalloc bitmap
In-Reply-To: <1336432890-18638-3-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<1336432890-18638-3-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20120508002256.GD4713@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 07, 2012 at 04:21:29PM -0700, Srinivas Eeda wrote:
> This patch adds supporting functions and modifies localalloc code to implement
> discontiguous localalloc bitmap.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |  523 ++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 342 insertions(+), 181 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 4190e53..f63381e 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -48,6 +48,9 @@
>  
>  #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
>  
> +/* defines minimum contiguous required */
> +#define OCFS2_LOCAL_ALLOC_MIN_BITS	2
> +
>  #define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
>  					 sizeof(struct ocfs2_local_alloc_rec))
>  #define OCFS2_LOCAL_ALLOC_BITMAP(la)    ((char *)(&(la->la_recs)) +\
> @@ -58,7 +61,8 @@
>  #define OCFS2_MAX_LOCAL_ALLOC_REC_LIMIT	128
>  
>  
> -static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
> +static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
> +					struct ocfs2_dinode *alloc);
>  
>  static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
>  					     struct ocfs2_dinode *alloc,
> @@ -82,8 +86,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
>  					handle_t *handle,
>  					struct ocfs2_alloc_context *ac);
>  
> -static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
> -					  struct inode *local_alloc_inode);
> +static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb);

	I noted that you moved local_alloc_inode into ocfs2_super in the
previous patch.  Lifting that into the super should be one distinct
patch.  It should add the field to ocfs2_super and change the function
signatures at the same time.  Munging it with other patches confuses the
issue.
 
> @@ -202,6 +205,74 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
>  	return la_mb;
>  }
>  
> +static u32 ocfs2_local_bitmap_to_cluster(struct ocfs2_local_alloc *la, u32 bit)
> +{
> +	u32 start, prev, offset;
> +	int rec;
> +
> +	rec = start = prev = 0;
> +	for (rec = 0; rec < le16_to_cpu(la->la_rec_count); rec++) {
> +		prev = start;
> +		start += le32_to_cpu(la->la_recs[rec].la_clusters);
> +		if (bit < start)
> +			break;
> +	}
> +	offset = le32_to_cpu(la->la_recs[rec].la_start) + (bit - prev);
> +
> +	return offset;
> +}

	This can't work for non-DISCONTIG_LA filesystems.  I looked, and
you call this regardless of the feature bits.  Old filesystems will
crash, because they have bitmap bits instead of la_rec_count.  This is
why I said you couldn't remove la_bitmap.

> +/*
> + * This function is called before allocating a new chunk for the localalloc
> + * bitmap to make sure there is enough space in the bitmap for the new record
> + */
> +static u32 ocfs2_local_alloc_adjust_bits_wanted(struct ocfs2_local_alloc *la,
> +						struct ocfs2_alloc_context *ac)
> +{
> +	u32 required, available, cluster_cnt;
> +
> +	if (ac->ac_bits_given == ac->ac_bits_wanted)
> +		return 0;
> +
> +	/* total bits available in bitmap */
> +	available   = le16_to_cpu(la->la_size) << 3;
> +	cluster_cnt = ocfs2_local_alloc_cluster_count(la);
> +
> +	/*
> +	 * Wanted shouldn't be greater than bitmap size and given should be
> +	 * equal to cluster count
> +	 */
> +	BUG_ON(ac->ac_bits_given > ac->ac_bits_wanted);
> +	BUG_ON(ac->ac_bits_wanted > available);
> +	BUG_ON(ac->ac_bits_given != cluster_cnt);
> +
> +	/* reduce bits taken by each record structure */
> +	available -= (le16_to_cpu(la->la_rec_count) *
> +		      OCFS2_LOCAL_ALLOC_BITS_PER_REC);

	Again, no check for DISCONTIG_LA.  I'm going to stop mentioning
this.  Just assume that every place you want to touch la_rec_count, you
need to make sure you have a DISCONTIG_LA filesystem.

> @@ -348,21 +421,21 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  	}
>  
>  	/* do a little verification. */
> -	num_used = ocfs2_local_alloc_count_bits(alloc);
> +	num_used = ocfs2_local_alloc_count_bits(osb, alloc);
>  
>  	/* hopefully the local alloc has always been recovered before
>  	 * we load it. */
>  	if (num_used
>  	    || alloc->id1.bitmap1.i_used
>  	    || alloc->id1.bitmap1.i_total
> -	    || la->la_bm_off)
> +	    || la->la_rec_count)

	I lied.  You can't trust la_rec_count for non-DISCONTIG_LA
filesystems, so you can't have a naked check here.  Conversely,
la_bm_off is the valid check for those filesystems.  You need to
alternate based on the feature.

> @@ -690,8 +739,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  		le32_to_cpu(alloc->id1.bitmap1.i_used);
>  	if (bits_wanted > free_bits) {
>  		/* uhoh, window change time. */
> -		status =
> -			ocfs2_local_alloc_slide_window(osb, local_alloc_inode);
> +		status = ocfs2_local_alloc_slide_window(osb);

	This is what I mean about osb->local_alloc_inode.  There should
be a first patch that does these changes only.

> @@ -745,7 +792,7 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
>  {
>  	int status, start;
>  	struct inode *local_alloc_inode;
> -	void *bitmap;
> +	u8 *bitmap;

	I'm not sure about this.  Do you have a reason?

>  	struct ocfs2_dinode *alloc;
>  	struct ocfs2_local_alloc *la;
>  
> @@ -764,8 +811,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> -	bitmap = la->la_bitmap;
> -	*bit_off = le32_to_cpu(la->la_bm_off) + start;
> +	bitmap = OCFS2_LOCAL_ALLOC_BITMAP(la);
> +	*bit_off = ocfs2_local_bitmap_to_cluster(la, start);

	Here is the call that assumes a DISCONTIG_LA filesystem.

>  	*num_bits = bits_wanted;
>  
>  	status = ocfs2_journal_access_di(handle,
> @@ -792,16 +839,29 @@ bail:
>  	return status;
>  }
>  
> -static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
> +static u32 ocfs2_local_alloc_count_bits(struct ocfs2_super *osb,
> +					struct ocfs2_dinode *alloc)
>  {
>  	int i;
> -	u8 *buffer;
> +	u8 *bitmap;
>  	u32 count = 0;
>  	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
>  
> -	buffer = la->la_bitmap;
> -	for (i = 0; i < le16_to_cpu(la->la_size); i++)
> -		count += hweight8(buffer[i]);
> +	/*
> +	 * if discontig is not enabled then lets update the first localalloc
> +	 * record with the current bitmap block info. We are doing this because
> +	 * old disk formats are not aware of the records.
> +	 */
> +	if (!ocfs2_supports_discontig_la(osb) && la->la_bm_off) {
> +		la->la_rec_count = cpu_to_le16(1);
> +		la->la_recs[0].la_start = la->la_bm_off;
> +		la->la_recs[0].la_clusters = alloc->id1.bitmap1.i_total;
> +	}

	OH MY DOG NO.  NEVER EVER DO THIS.  You cannot update an old
filesystem on the fly!  What about other nodes that are running older
versions of the software?  They will crash or corrupt data!  The entire
point of feature bits is to make sure all nodes are speaking the same
code.

NAK NAK NAK

	This explains why you trusted la_rec_count earlier.  But that is
broken.  When your patches are done, the code should use la_bm_off and
la_bitmap when !DISCONTIG_LA and then use la_rec_count, etc when
DISCONTIG_LA.  The only way to transition between them is a tunefs.ocfs2
operation that walks the filesystem, flushes the bitmap, and then
sets/clears la_rec_count appropriately depending on the direction..

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."

			http://www.jlbec.org/
			jlbec at evilplan.org
