From: Gang He <ghe@suse.com>
Date: Sun, 25 Feb 2018 22:39:43 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up two unused functions in
 suballoc.c
In-Reply-To: <1519609595-26229-1-git-send-email-ge.changwei@h3c.com>
References: <1519609595-26229-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5A940E1F020000F9000AB648@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

The code change looks OK, but maybe these code is still useful for temporary debugging?


Thanks
Gang 


>>> 
> The two functions are no longer used.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>  fs/ocfs2/suballoc.c | 49 -------------------------------------------------
>  1 file changed, 49 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 9f0b95a..328be8b 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -79,8 +79,6 @@ static u64 ocfs2_group_from_res(struct 
> ocfs2_suballoc_result *res)
>  	return ocfs2_which_suballoc_group(res->sr_blkno, res->sr_bit_offset);
>  }
>  
> -static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
> -static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
>  static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
>  static int ocfs2_block_group_fill(handle_t *handle,
>  				  struct inode *alloc_inode,
> @@ -2624,53 +2622,6 @@ int ocfs2_release_clusters(handle_t *handle,
>  				    _ocfs2_clear_bit);
>  }
>  
> -static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg)
> -{
> -	printk("Block Group:\n");
> -	printk("bg_signature:       %s\n", bg->bg_signature);
> -	printk("bg_size:            %u\n", bg->bg_size);
> -	printk("bg_bits:            %u\n", bg->bg_bits);
> -	printk("bg_free_bits_count: %u\n", bg->bg_free_bits_count);
> -	printk("bg_chain:           %u\n", bg->bg_chain);
> -	printk("bg_generation:      %u\n", le32_to_cpu(bg->bg_generation));
> -	printk("bg_next_group:      %llu\n",
> -	       (unsigned long long)bg->bg_next_group);
> -	printk("bg_parent_dinode:   %llu\n",
> -	       (unsigned long long)bg->bg_parent_dinode);
> -	printk("bg_blkno:           %llu\n",
> -	       (unsigned long long)bg->bg_blkno);
> -}
> -
> -static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe)
> -{
> -	int i;
> -
> -	printk("Suballoc Inode %llu:\n", (unsigned long long)fe->i_blkno);
> -	printk("i_signature:                  %s\n", fe->i_signature);
> -	printk("i_size:                       %llu\n",
> -	       (unsigned long long)fe->i_size);
> -	printk("i_clusters:                   %u\n", fe->i_clusters);
> -	printk("i_generation:                 %u\n",
> -	       le32_to_cpu(fe->i_generation));
> -	printk("id1.bitmap1.i_used:           %u\n",
> -	       le32_to_cpu(fe->id1.bitmap1.i_used));
> -	printk("id1.bitmap1.i_total:          %u\n",
> -	       le32_to_cpu(fe->id1.bitmap1.i_total));
> -	printk("id2.i_chain.cl_cpg:           %u\n", fe->id2.i_chain.cl_cpg);
> -	printk("id2.i_chain.cl_bpc:           %u\n", fe->id2.i_chain.cl_bpc);
> -	printk("id2.i_chain.cl_count:         %u\n", fe->id2.i_chain.cl_count);
> -	printk("id2.i_chain.cl_next_free_rec: %u\n",
> -	       fe->id2.i_chain.cl_next_free_rec);
> -	for(i = 0; i < fe->id2.i_chain.cl_next_free_rec; i++) {
> -		printk("fe->id2.i_chain.cl_recs[%d].c_free:  %u\n", i,
> -		       fe->id2.i_chain.cl_recs[i].c_free);
> -		printk("fe->id2.i_chain.cl_recs[%d].c_total: %u\n", i,
> -		       fe->id2.i_chain.cl_recs[i].c_total);
> -		printk("fe->id2.i_chain.cl_recs[%d].c_blkno: %llu\n", i,
> -		       (unsigned long long)fe->id2.i_chain.cl_recs[i].c_blkno);
> -	}
> -}
> -
>  /*
>   * For a given allocation, determine which allocators will need to be
>   * accessed, and lock them, reserving the appropriate number of bits.
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
