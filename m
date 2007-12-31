From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 31 17:09:58 2007
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: De-magic the in-memory slot map.
In-Reply-To: <1197004787-15344-6-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-6-git-send-email-joel.becker@oracle.com>
Message-ID: <20080101010929.GC23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 06, 2007 at 09:19:45PM -0800, Joel Becker wrote:
> The in-memory slot map uses the same magic as the on-disk one.  There is
> a special value to mark a slot as invalid.  It relies on the size of
> certain types and so on.
> 
> Write a new in-memory map that keeps validity as a separate field.  Outside
> of the I/O functions, OCFS2_INVALID_SLOT now means what it is supposed to.
> It also is no longer tied to the type size.
> 
> This also means that only the I/O functions refer to 16bit quantities.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/journal.c  |    2 +-
>  fs/ocfs2/ocfs2.h    |    6 +-
>  fs/ocfs2/slot_map.c |  131 ++++++++++++++++++++++++++++-----------------------
>  fs/ocfs2/slot_map.h |    2 +-
>  4 files changed, 77 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 89c275e..884ebd9 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -71,7 +71,7 @@ static int ocfs2_commit_thread(void *arg);
>   */
>  
>  struct ocfs2_recovery_map {
> -	int rm_used;
> +	unsigned int rm_used;
>  	unsigned int *rm_entries;
>  };
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index dcb9120..5bb5b07 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -214,10 +214,10 @@ struct ocfs2_super
>  	unsigned long s_mount_opt;
>  	unsigned int s_atime_quantum;
>  
> -	u16 max_slots;
> +	unsigned int max_slots;
>  	s16 node_num;
> -	s16 slot_num;
> -	s16 preferred_slot;
> +	int slot_num;
> +	int preferred_slot;
>  	int s_sectsize_bits;
>  	int s_clustersize;
>  	int s_clustersize_bits;
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index fd08592..b7d592a 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -42,6 +42,12 @@
>  
>  #include "buffer_head_io.h"
>  
> +
> +struct ocfs2_slot {
> +	int sl_valid;
> +	unsigned int sl_node_num;
> +};
> +
>  struct ocfs2_slot_info_real {
>  	spinlock_t si_lock;
>  
> @@ -49,8 +55,7 @@ struct ocfs2_slot_info_real {
>  	unsigned int si_blocks;
>  	struct buffer_head **si_bh;
>  	unsigned int si_num_slots;
> -	unsigned int si_size;
> -	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
> +	struct ocfs2_slot *si_slots;
>  };
>  
>  static inline struct ocfs2_slot_info_real *to_slot_info(struct ocfs2_super *osb)
> @@ -59,11 +64,26 @@ static inline struct ocfs2_slot_info_real *to_slot_info(struct ocfs2_super *osb)
>  }
>  
>  
> -static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info_real *si,
> -				    s16 global);
> -static void __ocfs2_fill_slot(struct ocfs2_slot_info_real *si,
> -			      s16 slot_num,
> -			      s16 node_num);
> +static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info_real *si,
> +				    unsigned int node_num);
> +
> +static void ocfs2_invalidate_slot(struct ocfs2_slot_info_real *si,
> +				  int slot_num)
> +{
> +	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
> +	si->si_slots[slot_num].sl_valid = 0;
> +}
> +
> +static void ocfs2_set_slot(struct ocfs2_slot_info_real *si,
> +			   int slot_num, unsigned int node_num)
> +{
> +	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
> +	BUG_ON((node_num == O2NM_INVALID_NODE_NUM) ||
> +	       (node_num >= O2NM_MAX_NODES));
> +
> +	si->si_slots[slot_num].sl_valid = 1;
> +	si->si_slots[slot_num].sl_node_num = node_num;
> +}
>  
>  /* post the slot information on disk into our slot_info struct. */
>  static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
> @@ -76,8 +96,12 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
>  	spin_lock(&si->si_lock);
>  	disk_info = (__le16 *) si->si_bh[0]->b_data;
>  
> -	for (i = 0; i < si->si_size; i++)
> -		si->si_global_node_nums[i] = le16_to_cpu(disk_info[i]);
> +	for (i = 0; i < si->si_num_slots; i++) {
> +		if (le16_to_cpu(disk_info[i]) == (u16)OCFS2_INVALID_SLOT)
> +			ocfs2_invalidate_slot(si, i);
> +		else
> +			ocfs2_set_slot(si, i, le16_to_cpu(disk_info[i]));
> +	}
>  
>  	spin_unlock(&si->si_lock);
>  }
> @@ -118,8 +142,13 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
>  	__le16 *disk_info = (__le16 *) si->si_bh[0]->b_data;
>  
>  	spin_lock(&si->si_lock);
> -	for (i = 0; i < si->si_size; i++)
> -		disk_info[i] = cpu_to_le16(si->si_global_node_nums[i]);
> +	for (i = 0; i < si->si_num_slots; i++) {
> +		if (si->si_slots[i].sl_valid)
> +			disk_info[i] =
> +				cpu_to_le16(si->si_slots[i].sl_node_num);
> +		else
> +			disk_info[i] = cpu_to_le16(OCFS2_INVALID_SLOT);
> +	}
>  	spin_unlock(&si->si_lock);
>  
>  	status = ocfs2_write_block(osb, si->si_bh[0], si->si_inode);
> @@ -140,7 +169,7 @@ static int ocfs2_slot_map_physical_size(struct ocfs2_super *osb,
>  	unsigned long long bytes_needed;
>  
>  	bytes_needed = osb->max_slots * sizeof(__le16);
> -	if (bytes_needed < i_size_read(inode)) {
> +	if (bytes_needed > i_size_read(inode)) {

Why wasn't this just fixed in the previous patch?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
