Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8710ECAAD8
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AoTAKjL2lGwfZq4NKCyRjv0qRL9txfJAGeuQ8Hp7fII=;
 b=jrHAeJigGgNirnk6tw9x0sZUEl1M83N4aza/RyzSF0KIUNrX6FWRQxjSU/i57/foRoEyJg+KY/20
   gAMYOwt92bgsgIhuxENAshAdyo0shbz894OeILffa6w027ozYRpTUD7eM5Ij91MFWIANpGe+fO8+
   0IWveDRc2EYbZPeLdxAzgTF72rOqloW7dcypFTzHl/US7ryysC3326NTZWgQHfOeyy32zSJQ6bIX
   zFzIhAVQSt0GbvRjMstIJKdTLBk2gc13zhn9Q00K/+2P0ngUt2PWg+Px7wa2IlVLSKt0aEmiOcZz
   gjdyXrWThvWB0qaeCrH4TM57Uo5FsT0dGLc4eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AoTAKjL2lGwfZq4NKCyRjv0qRL9txfJAGeuQ8Hp7fII=;
 b=HHJ6Y+5QCMG+tI32nW1EnJB6vR8u9hL8dTLZ3LevkmQD01f2rNRB1JwgAISMNnIUw7HZDiAnGw6i
   EhJop4/QJTx6k06w4BH+YkGfNDegA5fWAI1SVQaBNGv4I7Y2AkO0/fteW+Z3AjaPA3e9/AOI6In6
   mnTEmI9HrfkOqsi1xnOGnvyEFexKSrOdKydbmnTKEvOI+S+l5M/3SAbyu8E2KD6hghE+mrIwyuoU
   POGCARtnwUNUqA9DCEtUrN1WaTmqEiQkK4MMqdFirhyfc2KX+128qpDwyfPWcpbR4dzimGBmRULQ
   EmlGVqz76lYPlQhm0FpV1LY3rHODXc5J2aJHtw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00CBJFQ9MU90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:44:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047050;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TGEgeznG1OoqVsgqPHcmjmzJchioOiRQWcLMKbDIADU=;
 b=GzQ+klQQDOdWcjHI5r+lAUp2Ag3z01KKum2xL7StbzBok+bSdye/U7ssW9yNFC3aqdTx1m
 oiQ7Fh+lKd3DjRk9w4CsCVJ8en5rkUeSNrxAXN2HmE3SL7nDTKv4P205h0fOgjvkWOmw8E
 x5EG13mtEAubS2BecOAbcG3KfvFBL+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047050;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TGEgeznG1OoqVsgqPHcmjmzJchioOiRQWcLMKbDIADU=;
 b=QU8vQex5JACf7t/hD5Hxjs9xjgVbBQa/3Nu6SioXWo1GISEc1O7xoaa3poqXvqNX/1sA0G
 m57O89aZVG+xSPBw==
Date: Thu, 1 Sep 2022 17:44:09 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901154409.dcyvtknzzdjhuzas@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-3-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-3-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=136 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=476 spamscore=0 mlxscore=0 adultscore=0 clxscore=175
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010070
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 02/14] fs/buffer: add some new buffer	read
 helpers
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
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: VpBY0oaHPbNtqq9_DZPl0DJj8uBzNnJF
X-Proofpoint-GUID: VpBY0oaHPbNtqq9_DZPl0DJj8uBzNnJF
Reporting-Meta:
 AAF55idWRfbxPozgKQ8TMIUHlDoYw8FeqJaVSOKzo6F8/PWC3EIgXdDEuV1xrAIb
 WQiHDn7HizP8/T/XB6x2nR7C43Runt2Zy2U++GKZSpzpWB/D62/tCzMo6+vtACqj
 iG0kyBj+/WVWsHhxMvs2mIk+TcrLSwdHye9DCUvKqViWS3sySI8EpvIYV/d0U3qH
 3ErFKw+of+le2PMeJLvjHme8jfuMHpAcpbKS9VBuDxH7Tf5V3sq9bEt4OfQ1o8Yr
 SPnFKyojRUS53Q2GcIsU76dTyQEU9A0uPII/QaC5p2AzIEkxpAJOf6Cm6Z42Zkpp
 kYGG2YhUDxWdDHa8mKWDOvzbP2dOHDlcyFA5xzoWrbXQmkONVHY6OyhfP2/pZYZu
 FDsfv14/ISooOd5PNoACTgCUXLQBll/sCAdvS+QsKC0xjjwRqfpZS1qxMjpZ+QLu
 0MH1uRhsnsxpd/HbpPL8crn4Zh0dAXosAh9QOCZgFrMEqB1ettHKcvlJ9mS/AakR
 fIcSiuItsDKWg7pXhSpIVqcrhazt2oOa7IrzIR7xAzF8

On Thu 01-09-22 21:34:53, Zhang Yi wrote:
> Current ll_rw_block() helper is fragile because it assumes that locked
> buffer means it's under IO which is submitted by some other who holds
> the lock, it skip buffer if it failed to get the lock, so it's only
> safe on the readahead path. Unfortunately, now that most filesystems
> still use this helper mistakenly on the sync metadata read path. There
> is no guarantee that the one who holds the buffer lock always submit IO
> (e.g. buffer_migrate_folio_norefs() after commit 88dbcbb3a484 ("blkdev:
> avoid migration stalls for blkdev pages"), it could lead to false
> positive -EIO when submitting reading IO.
> 
> This patch add some friendly buffer read helpers to prepare replacing
> ll_rw_block() and similar calls. We can only call bh_readahead_[]
> helpers for the readahead paths.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c                 | 65 +++++++++++++++++++++++++++++++++++++
>  include/linux/buffer_head.h | 38 ++++++++++++++++++++++
>  2 files changed, 103 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a0b70b3239f3..a6bc769e665d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3017,6 +3017,71 @@ int bh_uptodate_or_lock(struct buffer_head *bh)
>  }
>  EXPORT_SYMBOL(bh_uptodate_or_lock);
>  
> +/**
> + * __bh_read - Submit read for a locked buffer
> + * @bh: struct buffer_head
> + * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
> + * @wait: wait until reading finish
> + *
> + * Returns zero on success or don't wait, and -EIO on error.
> + */
> +int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
> +{
> +	int ret = 0;
> +
> +	BUG_ON(!buffer_locked(bh));
> +
> +	get_bh(bh);
> +	bh->b_end_io = end_buffer_read_sync;
> +	submit_bh(REQ_OP_READ | op_flags, bh);
> +	if (wait) {
> +		wait_on_buffer(bh);
> +		if (!buffer_uptodate(bh))
> +			ret = -EIO;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(__bh_read);
> +
> +/**
> + * __bh_read_batch - Submit read for a batch of unlocked buffers
> + * @nr: entry number of the buffer batch
> + * @bhs: a batch of struct buffer_head
> + * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
> + * @force_lock: force to get a lock on the buffer if set, otherwise drops any
> + *              buffer that cannot lock.
> + *
> + * Returns zero on success or don't wait, and -EIO on error.
> + */
> +void __bh_read_batch(int nr, struct buffer_head *bhs[],
> +		     blk_opf_t op_flags, bool force_lock)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr; i++) {
> +		struct buffer_head *bh = bhs[i];
> +
> +		if (buffer_uptodate(bh))
> +			continue;
> +
> +		if (force_lock)
> +			lock_buffer(bh);
> +		else
> +			if (!trylock_buffer(bh))
> +				continue;
> +
> +		if (buffer_uptodate(bh)) {
> +			unlock_buffer(bh);
> +			continue;
> +		}
> +
> +		bh->b_end_io = end_buffer_read_sync;
> +		get_bh(bh);
> +		submit_bh(REQ_OP_READ | op_flags, bh);
> +	}
> +}
> +EXPORT_SYMBOL(__bh_read_batch);
> +
>  /**
>   * bh_submit_read - Submit a locked buffer for reading
>   * @bh: struct buffer_head
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index c3863c417b00..6d09785bed9f 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -232,6 +232,9 @@ void write_boundary_block(struct block_device *bdev,
>  			sector_t bblock, unsigned blocksize);
>  int bh_uptodate_or_lock(struct buffer_head *bh);
>  int bh_submit_read(struct buffer_head *bh);
> +int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
> +void __bh_read_batch(int nr, struct buffer_head *bhs[],
> +		     blk_opf_t op_flags, bool force_lock);
>  
>  extern int buffer_heads_over_limit;
>  
> @@ -399,6 +402,41 @@ static inline struct buffer_head *__getblk(struct block_device *bdev,
>  	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>  }
>  
> +static inline void bh_readahead(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	if (!buffer_uptodate(bh) && trylock_buffer(bh)) {
> +		if (!buffer_uptodate(bh))
> +			__bh_read(bh, op_flags, false);
> +		else
> +			unlock_buffer(bh);
> +	}
> +}
> +
> +static inline void bh_read_nowait(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	if (!bh_uptodate_or_lock(bh))
> +		__bh_read(bh, op_flags, false);
> +}
> +
> +/* Returns 1 if buffer uptodated, 0 on success, and -EIO on error. */
> +static inline int bh_read(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	if (bh_uptodate_or_lock(bh))
> +		return 1;
> +	return __bh_read(bh, op_flags, true);
> +}
> +
> +static inline void bh_read_batch(int nr, struct buffer_head *bhs[])
> +{
> +	__bh_read_batch(nr, bhs, 0, true);
> +}
> +
> +static inline void bh_readahead_batch(int nr, struct buffer_head *bhs[],
> +				      blk_opf_t op_flags)
> +{
> +	__bh_read_batch(nr, bhs, op_flags, false);
> +}
> +
>  /**
>   *  __bread() - reads a specified block and returns the bh
>   *  @bdev: the block_device to read from
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
