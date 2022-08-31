Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8363ECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=smNktqI1ZiRKjm2LvvxxRg536GafsWL1Z+CiKmlTZNI=;
 b=ZaaSELZX0U3JckO7h5oqhMS9tZ29qkjP/76bUjyKzo+aMES3S35DOBvtIGG3qAOzF5klLj3oTx96
   bz2hSOu2HMGyL2Ww7xet4wVl/bTboirPw8l35xotj9hnOheHS6Y+8/BUKvPKwL0D56O40KH2URDe
   W0c10tpSc+MtG8EG5gcNrV1QzLx2l269vzt1SGZ07x38tvYxKppzAhP5fbJDbVUVZoCu3+Q7i61Z
   yXoQurcxg2eOlhq9YwT/jz/lRI+ojEqxCQmJT/lpPvQt0xGULRPg85MVn4vDa7pT9mepgjbQu23h
   KnWx69xTkjfeHatSCMj7pa89RhtJzG395Pcn7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=smNktqI1ZiRKjm2LvvxxRg536GafsWL1Z+CiKmlTZNI=;
 b=fGKpy6EBBrF4x3MwsGcHnVs+vFUeXyUvRBRx12Dc5gntjcjdASGu2XgDb9AJdzgajPxgr+79kDx7
   LFfPwgCG7HMc39ShH81N1v8MFVwwoM5syKVklHtu+4DBX3f4LGKcTIVquocvThgPnUHPwKIFBCTE
   DkAAs2tYsAvbALfV0TDk2mWw5rBifef3xqVMKaHrISGbllG1PRwsHLqxOqXvP4N29dRBw51zVo7Y
   rKl0yFWObDlqySVcG/ay6fAPVjNPG4kd5IVLsuovSTuNJHC+SQfDOJQzo4N1pmHILtVpGRS8GCry
   SF0zuv9cHZiIfUlKqHcdu9bZLzfg4hVCp+ftbA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00DGQ6XRCT70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:39:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661942352;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=D/VhxrZABrIw51+gKZ04o+QPEhbTuW7VzunFJgXY7yw=;
 b=a2l6ug+zy4ZO2ZBVuqwRZaCOsD/JBDgWm4vBtnS2p4VqXzNejQqdVXaA/ST/D8KXLkez6H
 QOwXmD2rKYG9+RchfM74zflc74h5E6tozat9dxBD/V6GGio2IrhB4UuYlHiBQA8GuKpc6B
 IX9BBGsSV8qYc3kxPvDVJkw1V7ApYT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661942352;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=D/VhxrZABrIw51+gKZ04o+QPEhbTuW7VzunFJgXY7yw=;
 b=DvvoP4FgqltN7TSp0W4JepFamZL4CCI+xGGNoE56kVvT+VDjiBB8cQOdGEfQEqyIWhezcr
 evs/qv/17UFQOJAg==
Date: Wed, 31 Aug 2022 12:39:11 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831103911.ubrkxc3yf46bdme3@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-2-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-2-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=542 phishscore=0 adultscore=0 spamscore=0 priorityscore=0
 malwarescore=0 clxscore=192 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310053
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 01/14] fs/buffer: remove __breadahead_gfp()
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
X-Proofpoint-GUID: 4LG4pJiijhQW1aQNXrk6TRs6FBqBTwbi
X-Proofpoint-ORIG-GUID: 4LG4pJiijhQW1aQNXrk6TRs6FBqBTwbi
Reporting-Meta:
 AAFKiqAjVTUy3Mzwd9rUUtlaLPAEuDpJyuq8Y9XAtcB19yaZJONFnl+9jL6UipXR
 pSo8A4H/MxOtbXMN2qFmU0eMx1LjI4rnbzrPa0D9iGKGhGxWTGynyECF9rPPS2r2
 v+BBM1uIsI7DKtJNlPlQwuODjF0tWVzHVKpPnbSJ4qfewyZTX7E3tWu/GJUIGqgO
 balJvMPJ7kUZReyZMsnkcYx3zPV8ewKF+Hb0WTaZAkWyJ/HFoGQ9DdzyfSwLr8F2
 WawP7dLdpHzQfdIrtpYNy+MpxiRdaRTCIukOcaEGWDq4iBmX13+OlAEoG1egid2v
 PrDwHUU9I5fvV90M7/oWCbYTTY2kRxXfilIREVWoJY8mB9mNkjt3X1sKThbP8Cyx
 7XZyYwKXPqkUacG3TzsyhRE0JS2KfZWCSQNx6/+98ZrbeTOVVyN6qf9KbVoCTYBM
 eWBd4ALXjkwXzrlQnXOcIF78QDW27u1lzY8PH8QFP7CrJIr0I+s0mkRLuHpxC0CZ
 dOaR6eXG7YpN2WBUOsd7AdNT1qaGquZL8i9raoZM4zo=

On Wed 31-08-22 15:20:58, Zhang Yi wrote:
> No one use __breadahead_gfp() and sb_breadahead_unmovable() any more,
> remove them.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c                 | 11 -----------
>  include/linux/buffer_head.h |  8 --------
>  2 files changed, 19 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 55e762a58eb6..a0b70b3239f3 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1348,17 +1348,6 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
>  }
>  EXPORT_SYMBOL(__breadahead);
>  
> -void __breadahead_gfp(struct block_device *bdev, sector_t block, unsigned size,
> -		      gfp_t gfp)
> -{
> -	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
> -	if (likely(bh)) {
> -		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
> -		brelse(bh);
> -	}
> -}
> -EXPORT_SYMBOL(__breadahead_gfp);
> -
>  /**
>   *  __bread_gfp() - reads a specified block and returns the bh
>   *  @bdev: the block_device to read from
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 089c9ade4325..c3863c417b00 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -214,8 +214,6 @@ struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
>  void __brelse(struct buffer_head *);
>  void __bforget(struct buffer_head *);
>  void __breadahead(struct block_device *, sector_t block, unsigned int size);
> -void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
> -		  gfp_t gfp);
>  struct buffer_head *__bread_gfp(struct block_device *,
>  				sector_t block, unsigned size, gfp_t gfp);
>  void invalidate_bh_lrus(void);
> @@ -340,12 +338,6 @@ sb_breadahead(struct super_block *sb, sector_t block)
>  	__breadahead(sb->s_bdev, block, sb->s_blocksize);
>  }
>  
> -static inline void
> -sb_breadahead_unmovable(struct super_block *sb, sector_t block)
> -{
> -	__breadahead_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
> -}
> -
>  static inline struct buffer_head *
>  sb_getblk(struct super_block *sb, sector_t block)
>  {
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
