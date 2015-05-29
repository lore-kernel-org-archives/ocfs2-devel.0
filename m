From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 29 May 2015 15:41:34 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] BUG_ON(goal == 0 && clen == 0)
 tripped due to unreturned bits in local alloc at mount time
In-Reply-To: <1428080082-24370-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1428080082-24370-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <5568182E.4060202@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tariq,

On 2015/4/4 0:54, Tariq Saeed wrote:
> Orabug: 19578339
> 
> mount.ocfs2,105474,48):ocfs2_load_local_alloc:353 ERROR:
> Local alloc hasn't been recovered!.found = 35, set = 35, taken = 3476, off =
>  [4550538.075344] (mount.ocfs2,105474,48):ocfs2_load_local_alloc:353 ERROR:
>  Local alloc hasn't been recovered!.found = 35, set = 35, taken = 3476, off =
>  205530150
> 
> The mount did not fail but latter on ...
> 
> fs/ocfs2/reservations.c:507!
> ...
>  @ ption RIP: __ocfs2_resv_find_window+780]
>     RIP: ffffffffa0523bac  RSP: ffff88001cd27498  RFLAGS: 00010246
>     RAX: 0000000000000000  RBX: ffffffffa059b6dc  RCX: 0000000000000000
>     RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000000
>     RBP: ffff88001cd27528   R8: ffff88001cd274f4   R9: ffff88001cd274f0
>     R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
>     R13: 0000000000000000  R14: 0000000000000001  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  [ffff88001cd27490] __ocfs2_resv_find_window at ffffffffa0523b32 [ocfs2]
> @  #8 [ffff88001cd27530] ocfs2_resmap_resv_bits at ffffffffa0523fc3 [ocfs2]
> @  #9 [ffff88001cd27580] ocfs2_local_alloc_find_clear_bits at ffffffffa050b11d
> @ [ocfs2]
> @ #10 [ffff88001cd27640] ocfs2_claim_local_alloc_bits at ffffffffa050b368
> @ [ocfs2]
> @ #11 [ffff88001cd276c0] __ocfs2_claim_clusters at ffffffffa052dac5 [ocfs2]
> @ #12 [ffff88001cd27740] ocfs2_add_clusters_in_btree at ffffffffa04d3e15
> @ [ocfs2]
> @ #13 [ffff88001cd277d0] ocfs2_add_inode_data at ffffffffa04f9701 [ocfs2]
> @ #14 [ffff88001cd27860] ocfs2_write_cluster at ffffffffa04dda0a [ocfs2]
> @ #15 [ffff88001cd27940] ocfs2_write_begin_nolock at ffffffffa04de9da [ocfs2]
> @ #16 [ffff88001cd27ae0] ocfs2_write_begin at ffffffffa04deed6 [ocfs2]
> ...
> 
> The way this is supposed to work is this.  At mount time, we initialize
> osb->osb_la_resmap of type struct ocfs2_reservation_map to NULL, in
> particlur, m_bitmap_len = 0 (local alloc inode is expected to have 0
> bits after CLEAN umount). Upon first allocation, since local alloc has
> no bits, slide window is triggerd, which grabs a chunk from the global
> bmap and sets the ocfs2_reservation_map m_bitmap_len.
> 
> The events leading to the panic were caused by continuing the mount
> when local alloc had bits  -- see above message from log.  Then,
> at first allocation, slide window was NOT req'd because local alloc
> inode had sufficient bits (this is root of the event chain that lead
> to the assert). Down the road, in __ocfs2_resv_find_window(), we find
> that ocfs2_reservation_map has no bits we can allocate even though
> resmap->m_reservations rb-tree is empty, that is, we have not reserved
> anything for any inode yet after the mount.  This leads to the assertion
> failure.
> 
> So how come local alloc ended up with bits after clean unmount. In the
> log, I see plenty of i/o errors AFTER the unmount command is issued.
> 
> Aug 12 03:05:21 laguna kernel: ocfs2: Unmounting device (252,39) on (node local)
> ...
> Aug 12 03:05:21 laguna kernel: device-mapper: table: 252:39: multipath: error getting device
> Aug 12 03:06:52 laguna kernel: Buffer I/O error on device dm-39, logical block 393215998
> ...
> 
> It looks as though during journal shutdown checkpoint phase, the zeroed out local alloc
> inode buffer did not make it to its home location on disk due to i/o error. Looking at
> Checking jbd2_journal_flush(), I see:
>                  err = jbd2_log_do_checkpoint(journal);
> And err is ignored. May be that is what happened.
>        return 0; << does not return err
> Has ocfs2 seen an error during shutdown, it would not have marked the journal clean.
> 
> The fix I have made is to print a 'full fsck req'd' to the log and fail
> the mount with EINVAL.
> 
> Aside: I found forced fsck does not clear out local alloc inode. A separate fix
> is submitted to ocfs2.tools for that.
> 
> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 0440134..b0819e0 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -345,13 +345,18 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  	if (num_used
>  	    || alloc->id1.bitmap1.i_used
>  	    || alloc->id1.bitmap1.i_total
> -	    || la->la_bm_off)
> +	    || la->la_bm_off) {
>  		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
> -		     "found = %u, set = %u, taken = %u, off = %u\n",
> +		     "found = %u, set = %u, taken = %u, off = %u\n"
> +		     "umount left unclean filesystem. run ocfs2.fsck -f\n",
>  		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>  		     le32_to_cpu(alloc->id1.bitmap1.i_total),
>  		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
>  
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>  	osb->local_alloc_bh = alloc_bh;
>  	osb->local_alloc_state = OCFS2_LA_ENABLED;
>  
> 
In this case, journal dirty flag not set, but in fact localalloc needs
recovery.
So how about check this case after journal initialized and set journal
dirty? Then it will do the local recovery as an unclean umount.
If so, we don't have to do the offline fsck.
