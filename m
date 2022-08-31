Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89CCECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v+vI4BqZOfO5ffJ96qfqVfMKXKt2x6OtmN3+37ihLcY=;
 b=Cc0nklCvvEfZp9mgQeL87ifnG8dgzprXSrw67ghnz/nik7mBGAPnoO4OctGpb2hOxsoyu6HiCIIg
   7zAOk1PwbsAmLulay/4bnQUWYuxa+AvrDKgqpIuINJH6/QqrPQW/j+Hng1bmxM2yJB03BCdfJkDP
   g728lTCS89zGTuhWfzZvt98ZWIBLrek1gFeKzjlzGuftu1RDf8BITKrUtJmoEU2hss3oSLHva3BK
   V17Sl85trzF/gQVdS0PDmHComVdEFOabgRA2+u3e5psArYYwTfsyoJvN1HpzA9GoFy4kqtv5f8Q0
   MTHJRPCeiH9uS4HNV9FY1W/K8FBxGlbNmn4Xkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v+vI4BqZOfO5ffJ96qfqVfMKXKt2x6OtmN3+37ihLcY=;
 b=hAZptTNuaxPLqDCsCpNNVn7nxvl5Q9c6rOQVmWLDCg5cKis/YvDEp8w6AdNtAFap+qh5Rl+HSLpi
   bs7ydSzATcV90vzZE/TqatkBGKX7O+gE58TqdxUctNlraS0Uj/ipLIaQIiIvphJpXPDtAa8W0nLS
   OLzkphQ6U7tcxm30Yt5AktFUw2OgMfgFlfvfTBiOixqOmvj0ySXAoa4R+2NcyGz6RuUh83/AfTSz
   KuLJn68snoz0WOG/CuB9kNxv2f8fRr5qSfg0Yx1JEZ2SHIDlx4Pu5goyJPj+IAB9DhtoohjlQIQB
   1gEgOa21u789yrdznb4uOus7/9xSFHzfpTq5PA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00B449BAML70@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:30:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661945430;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5+rM2lTGNhrVO3gYxx12OLcCQeOaRRJa6UF4G+0StiQ=;
 b=04NEVHOFZri3hSNR2yS12QiAErrSKNGIA9ZWdZEGs7Sp+GMmDn3CLx//O24C3oq981u6BH
 XDSCXEG74YLC5kEtzFaJFMBtKHxaqs0vEc78hI/jUKXmgDZ81L366ack9Fuvy16u71GpbM
 05IOIyiOJ5FmVAb/ja2cMNkbFFCVmX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661945430;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5+rM2lTGNhrVO3gYxx12OLcCQeOaRRJa6UF4G+0StiQ=;
 b=Mz8bJYjnB3rmMLQHxxFP16ARjDoHDeBdyNwNgZJmdcnaQ3TpHNikSo7lV0y8w8pCUFOqIz
 Iqau2cagQXoKGJCg==
Date: Wed, 31 Aug 2022 13:30:29 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831113029.fsywbjzk4qw24qdc@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-3-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-3-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=7 clxscore=184
 mlxscore=7 malwarescore=0 phishscore=0 mlxlogscore=115 priorityscore=260
 suspectscore=0 spamscore=7 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310057
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 02/14] fs/buffer: add some new buffer read
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
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: _z5Vgufb599YbrInrqlMCFBOSYc49o5O
X-Proofpoint-GUID: _z5Vgufb599YbrInrqlMCFBOSYc49o5O
Reporting-Meta:
 AAFwbXTTvq75se05lY8F2uGOjiQ6GXU3JZt96abPKla+rIvu5ECX4ejwxASPzis9
 VAlAgqQg71oQnT3Awgw0+pStZIwCb97iY9CPNWQDdhPAFrIaEOIi1YtkbExvE/Du
 TXQmCIeKZ7Syfv6VOTXEthC7ULvYGRUhdTnPKAcz8hUtf8+azrXSlloW0JLFRk+5
 gwvwF2GaRUx64ISx0QJhIt953IKToGP2Hm/94/NQ5Y7KIlF7egmu6xPC52wHZ94m
 tDl/taRMthsFb/Tm1TeNrLCtIbhr6aDF7qpb9HGY0mIfmGmIX/lv7kNGoaV6f4Nz
 BxkFEw3WV0RcSu2ucEHE3Ct64VxwfwxIvmjirTaLIu8ENCEXxypJ+B/yVDW9n6Ok
 hcwsPy5FSTfVIeq0yo2ZBXFGvWInasnim28hfRC24ENhaygAC1dUhc4Nj1HpUiNw
 IHpdNtxPz6Kaix3qStMDPSGfpZu+BpA78/W0KqeQY9fAGyvLKoIG01y0xF4S3Iq7
 TPNTD4fc2XRDqIjoRpFloqaMl8HP9i4k6nkJX8FkEfA=

On Wed 31-08-22 15:20:59, Zhang Yi wrote:
> Current ll_rw_block() helper is fragile because it assumes that locked
> buffer means it's under IO which is submitted by some other who hold
> the lock, it skip buffer if it failed to get the lock, so it's only
> safe on the readahead path. Unfortunately, now that most filesystems
> still use this helper mistakenly on the sync metadata read path. There
> is no guarantee that the one who hold the buffer lock always submit IO
> (e.g. buffer_migrate_folio_norefs() after commit 88dbcbb3a484 ("blkdev:
> avoid migration stalls for blkdev pages"), it could lead to false
> positive -EIO when submitting reading IO.
> 
> This patch add some friendly buffer read helpers to prepare replace
> ll_rw_block() and similar calls. We can only call bh_readahead_[]
> helpers for the readahead paths.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

This looks mostly good. Just a few small nits below.

> diff --git a/fs/buffer.c b/fs/buffer.c
> index a0b70b3239f3..a663191903ed 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3017,6 +3017,74 @@ int bh_uptodate_or_lock(struct buffer_head *bh)
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
> +	if (buffer_uptodate(bh)) {
> +		unlock_buffer(bh);
> +		return ret;
> +	}
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
> + * @bhs: a batch of struct buffer_head
> + * @nr: number of this batch
> + * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
> + * @force_lock: force to get a lock on the buffer if set, otherwise drops any
> + *              buffer that cannot lock.
> + *
> + * Returns zero on success or don't wait, and -EIO on error.
> + */
> +void __bh_read_batch(struct buffer_head *bhs[],
> +		     int nr, blk_opf_t op_flags, bool force_lock)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr; i++) {
> +		struct buffer_head *bh = bhs[i];
> +
> +		if (buffer_uptodate(bh))
> +			continue;
> +		if (!trylock_buffer(bh)) {
> +			if (!force_lock)
> +				continue;
> +			lock_buffer(bh);
> +		}

This would be a bit more efficient for the force_lock case like:

		if (force_lock)
			lock_buffer(bh);
		else
			if (!trylock_buffer(bh))
				continue;

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
> index c3863c417b00..8a01c07c0418 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -232,6 +232,9 @@ void write_boundary_block(struct block_device *bdev,
>  			sector_t bblock, unsigned blocksize);
>  int bh_uptodate_or_lock(struct buffer_head *bh);
>  int bh_submit_read(struct buffer_head *bh);
> +int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
> +void __bh_read_batch(struct buffer_head *bhs[],
> +		     int nr, blk_opf_t op_flags, bool force_lock);
>  
>  extern int buffer_heads_over_limit;
>  
> @@ -399,6 +402,40 @@ static inline struct buffer_head *__getblk(struct block_device *bdev,
>  	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>  }
>  
> +static inline void bh_readahead(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	if (trylock_buffer(bh))
> +		__bh_read(bh, op_flags, false);
> +}
> +
> +static inline void bh_read_nowait(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	lock_buffer(bh);
> +	__bh_read(bh, op_flags, false);
> +}
> +
> +static inline int bh_read(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	lock_buffer(bh);
> +	return __bh_read(bh, op_flags, true);
> +}

I would use bh_uptodate_or_lock() helper in the above two functions to
avoid locking the buffer in case it is already uptodate.

> +
> +static inline int bh_read_locked(struct buffer_head *bh, blk_opf_t op_flags)
> +{
> +	return __bh_read(bh, op_flags, true);
> +}

I would just drop this helper. Both ext2 and ocfs2 which use it can avoid
it very easily (by using bh_read()). 

> +
> +static inline void bh_read_batch(struct buffer_head *bhs[], int nr)
> +{
> +	__bh_read_batch(bhs, nr, 0, true);
> +}
> +
> +static inline void bh_readahead_batch(struct buffer_head *bhs[], int nr,
> +				      blk_opf_t op_flags)
> +{
> +	__bh_read_batch(bhs, nr, op_flags, false);
> +}
> +

It is more common to have number of elements in the array as the first
argument and the array as the second one in the kernel. So rather:

static inline void bh_read_batch(int nr, struct buffer_head *bhs[])

and similarly for bh_readahead_batch().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
