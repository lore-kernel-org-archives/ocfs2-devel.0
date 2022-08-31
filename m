Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A4AECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t69MaAHsfXRDh1ww2u99susADUtW9BLnqMdwxUICPGQ=;
 b=nwMpyDaFkHBDKIvMgxX1EO7AC1Z1DykGxt74ysfPt5bEpvtRECmTbC9lpf+NkObogBM8T/T/7FRl
   bsmfDzgBMPD+YWlMLPcHJj2Cyp1WM/F8mL7Jbxhk0jKKvjlDcMcQfbueP/K8Xc/BnhrEcf9q3xqo
   QPMvfcdXBRKBm9s0UG5dqsJyf7i7KN+xrfkntE9Bqybvr129z2X3AE+JXsyhTIPmJ21XfHwcItUY
   Gf0Vd7GvWJ9tLNSnG0QmTGsZqb1GpJwhvUt6fQbW3fQ9VR9Noif200gnw2F8dLFmvqLXj3E9dQSk
   eJOlWz1d07rqAnfsqNpPwMfhorHg+JwQjkUs9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t69MaAHsfXRDh1ww2u99susADUtW9BLnqMdwxUICPGQ=;
 b=XrTNmCoIOUIjd098Zpu91FWfBdtmRvQuVoYRxeN3BH7ahyICEgEVPPQNKTWCGsWYzbbgCHTAgg3i
   5wOXI0UlUiYFRhranICyAj9lcPwHiPtD9NzTD4RZrfaA+9jxL8VTVuL0LJTfAOOdgNzOMpO2PgiM
   Np7D2SkEBQwJq2atApd6DYnQnlfxjw2Pux1UYcdsHUmHp01JHOIPaFiVugQa3XFOHoZJYeS3YME8
   RHID+gSD+1CBFK2VGIOK4QqWnEe/TkMYl2fiKgzHl0vbkYnvKqc7dSFs0o9f9xO5vFtBC0+dGchm
   5upPbtKKAujoLTSscDrAEFyVxYz6RjE5bxpI7w==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00B2387NYH40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:06:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661944005;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fC4OsrDuMtbzIR8fy3GPw0L2C+sIfBr0jgJX1os99Vs=;
 b=Qvi5DTM5JTCd/NhhRucaM9fjv9H1gMQRnFZifm0fcH5/Xd2AD+glMerR3xN6Af1vymjs37
 McgUNgIZiP+PbSEmML7vWDdbzNqyTVabCvNvXGd3CgQEeYsemdMnmFdvijhoaaI5ly/N5z
 TTHLyoO0zjGfiiY/k+Y//YDI9sNI5Qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661944005;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fC4OsrDuMtbzIR8fy3GPw0L2C+sIfBr0jgJX1os99Vs=;
 b=Jb/2ggDXSejJB0kon6Yb0PMewboZVPK+kdjnLZyvZfHqaRQZxPMdVhN7IbMNRN5bpPnSk3
 EFf+NCtBc1SHbeAg==
Date: Wed, 31 Aug 2022 13:06:44 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831110644.id62rsymhziex2ch@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-13-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-13-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 suspectscore=0 clxscore=171 impostorscore=0 spamscore=0 priorityscore=215
 mlxlogscore=656 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310055
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 12/14] fs/buffer: remove ll_rw_block()	helper
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: JISKDqtMQ3uiHq-EosssEaOr8y-fGz30
X-Proofpoint-ORIG-GUID: JISKDqtMQ3uiHq-EosssEaOr8y-fGz30
Reporting-Meta:
 AAH3JjHg1QsB0ewMkzcY8pq6pNDxohtbLCDiet+d7tW30DLuO6QGlmuWHbJcBJND
 fitV0uJZ0BMTb73g4x/9Cw6JjKs0miO9TPMFErsfEQQDIzg+6/uEvkoKYz6gcUbM
 heroo1VxUR7yI4OX2Gj4wOyAsBvxqaVBVmKLnYCB6KF/J/h/uk0diDpoimvkWSVz
 vttBceYp4k7bf+oGkkouIh5ikCxROp9R+9khtqTEFLkjLTfy+X5YAPQEjQWqONMK
 T5mAk5h9brxX2JV1mvOc8vFsrOi42+ztkFul4QS3ZRU+BZLb4bswq1NT62mD6uMT
 +MfFiVF8OPfVgYHTAcV8S3uqD/SUDgcH34tZKOEAqrehXj3/ZHujIcx6i/cEdzMG
 /9z8C1h0v7I8GOw/Kkulqk99Cvc+N4whwiuu/F1RAqe7t6yRqUVW4rtlPM6ybYGz
 wrRN4TQatSJsP3d2i4tamWhlaiqFEm+UbXARfStzaAjcYcyQl94gnyB9DVYEK7Y+
 023DpWbswdUZ0yVw5GVQSOYZzFSLs/FoJ8PIbGV7ueTh

On Wed 31-08-22 15:21:09, Zhang Yi wrote:
> Now that all ll_rw_block() users has been replaced to new safe helpers,
> we just remove it here.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c                 | 63 +++----------------------------------
>  include/linux/buffer_head.h |  1 -
>  2 files changed, 4 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index e14adc638bfe..d1d09e2dacc2 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -152,7 +152,7 @@ static void __end_buffer_read_notouch(struct buffer_head *bh, int uptodate)
>  
>  /*
>   * Default synchronous end-of-IO handler..  Just mark it up-to-date and
> - * unlock the buffer. This is what ll_rw_block uses too.
> + * unlock the buffer.
>   */
>  void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
>  {
> @@ -491,8 +491,8 @@ int inode_has_buffers(struct inode *inode)
>   * all already-submitted IO to complete, but does not queue any new
>   * writes to the disk.
>   *
> - * To do O_SYNC writes, just queue the buffer writes with ll_rw_block as
> - * you dirty the buffers, and then use osync_inode_buffers to wait for
> + * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
> + * as you dirty the buffers, and then use osync_inode_buffers to wait for
>   * completion.  Any other dirty buffers which are not yet queued for
>   * write will not be flushed to disk by the osync.
>   */
> @@ -1807,7 +1807,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>  		/*
>  		 * The page was marked dirty, but the buffers were
>  		 * clean.  Someone wrote them back by hand with
> -		 * ll_rw_block/submit_bh.  A rare case.
> +		 * write_dirty_buffer/submit_bh.  A rare case.
>  		 */
>  		end_page_writeback(page);
>  
> @@ -2714,61 +2714,6 @@ int submit_bh(blk_opf_t opf, struct buffer_head *bh)
>  }
>  EXPORT_SYMBOL(submit_bh);
>  
> -/**
> - * ll_rw_block: low-level access to block devices (DEPRECATED)
> - * @opf: block layer request operation and flags.
> - * @nr: number of &struct buffer_heads in the array
> - * @bhs: array of pointers to &struct buffer_head
> - *
> - * ll_rw_block() takes an array of pointers to &struct buffer_heads, and
> - * requests an I/O operation on them, either a %REQ_OP_READ or a %REQ_OP_WRITE.
> - * @opf contains flags modifying the detailed I/O behavior, most notably
> - * %REQ_RAHEAD.
> - *
> - * This function drops any buffer that it cannot get a lock on (with the
> - * BH_Lock state bit), any buffer that appears to be clean when doing a write
> - * request, and any buffer that appears to be up-to-date when doing read
> - * request.  Further it marks as clean buffers that are processed for
> - * writing (the buffer cache won't assume that they are actually clean
> - * until the buffer gets unlocked).
> - *
> - * ll_rw_block sets b_end_io to simple completion handler that marks
> - * the buffer up-to-date (if appropriate), unlocks the buffer and wakes
> - * any waiters. 
> - *
> - * All of the buffers must be for the same device, and must also be a
> - * multiple of the current approved size for the device.
> - */
> -void ll_rw_block(const blk_opf_t opf, int nr, struct buffer_head *bhs[])
> -{
> -	const enum req_op op = opf & REQ_OP_MASK;
> -	int i;
> -
> -	for (i = 0; i < nr; i++) {
> -		struct buffer_head *bh = bhs[i];
> -
> -		if (!trylock_buffer(bh))
> -			continue;
> -		if (op == REQ_OP_WRITE) {
> -			if (test_clear_buffer_dirty(bh)) {
> -				bh->b_end_io = end_buffer_write_sync;
> -				get_bh(bh);
> -				submit_bh(opf, bh);
> -				continue;
> -			}
> -		} else {
> -			if (!buffer_uptodate(bh)) {
> -				bh->b_end_io = end_buffer_read_sync;
> -				get_bh(bh);
> -				submit_bh(opf, bh);
> -				continue;
> -			}
> -		}
> -		unlock_buffer(bh);
> -	}
> -}
> -EXPORT_SYMBOL(ll_rw_block);
> -
>  void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
>  {
>  	lock_buffer(bh);
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 8a01c07c0418..1c93ff8c8f51 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -223,7 +223,6 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
>  void free_buffer_head(struct buffer_head * bh);
>  void unlock_buffer(struct buffer_head *bh);
>  void __lock_buffer(struct buffer_head *bh);
> -void ll_rw_block(blk_opf_t, int, struct buffer_head * bh[]);
>  int sync_dirty_buffer(struct buffer_head *bh);
>  int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
>  void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
