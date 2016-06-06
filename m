From: Hannes Reinecke <hare@suse.de>
Date: Mon, 6 Jun 2016 08:46:47 +0200
Subject: [Ocfs2-devel] [PATCH 28/45] target: use bio op accessors
In-Reply-To: <1465155145-10812-29-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-29-git-send-email-mchristi@redhat.com>
Message-ID: <57551C57.5090507@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/05/2016 09:32 PM, mchristi at redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> Separate the op from the rq_flag_bits and have the target layer
> set/get the bio using bio_set_op_attrs/bio_op.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_iblock.c | 29 ++++++++++++++---------------
>  drivers/target/target_core_pscsi.c  |  2 +-
>  2 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index c25109c..22af12f 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
[ .. ]
> @@ -689,18 +690,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  		 * Force writethrough using WRITE_FUA if a volatile write cache
>  		 * is not enabled, or if initiator set the Force Unit Access bit.
>  		 */
> +		op = REQ_OP_WRITE;
>  		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
>  			if (cmd->se_cmd_flags & SCF_FUA)
> -				rw = WRITE_FUA;
> +				op_flags = WRITE_FUA;
>  			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> -				rw = WRITE_FUA;
> -			else
> -				rw = WRITE;
> -		} else {
> -			rw = WRITE;
> +				op_flags = WRITE_FUA;
>  		}
Wrong intendation.

>  	} else {
> -		rw = READ;
> +		op = REQ_OP_READ;
>  	}
>  
>  	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
> @@ -714,7 +712,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  		return 0;
>  	}
>  
> -	bio = iblock_get_bio(cmd, block_lba, sgl_nents, rw);
> +	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
>  	if (!bio)
>  		goto fail_free_ibr;
>  
> @@ -738,7 +736,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  				bio_cnt = 0;
>  			}
>  
> -			bio = iblock_get_bio(cmd, block_lba, sg_num, rw);
> +			bio = iblock_get_bio(cmd, block_lba, sg_num, op,
> +					     op_flags);
>  			if (!bio)
>  				goto fail_put_bios;
>  
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index de18790..81564c8 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -922,7 +922,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  					goto fail;
>  
>  				if (rw)
> -					bio->bi_rw |= REQ_WRITE;
> +					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>  
>  				pr_debug("PSCSI: Allocated bio: %p,"
>  					" dir: %s nr_vecs: %d\n", bio,
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare at suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N?rnberg
GF: F. Imend?rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N?rnberg)
