Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7AD1ECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gQsTbmsShVVkLP0m77grXWE+xZRgUPxDcI5yzsQdWMQ=;
 b=r4n7GV/BdS6bhGbnpqtY90qULzi+WuSAha9VyG59ZUEduIdvYMvlfAR0JdahYHL59sXKJShCs4Ci
   xmcma8NjzIAZQrvBC8/D/v9DgyFXKBfYa04fU5CqCw1qW5b73sa3FGZJeitu3exA/fl0emeSecy1
   ErsLOL1a+Qw7S+5DkcNX8N1WU3eUcoTIuyY+fiISOL9ZzyO35zkfx9/Hli+JcOEIEdqR4gigqnoi
   J0VZkga6w2Uo/Q4DJh1bigF5j/pPRk59c3Lh1vR21j9Up9fqekeBHOSqlyBrx/7YvfkiyRvaMH3x
   jG1wuHx3KoJ5hwI0vpx8RUEmZ2K/5XQ3GRwx9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gQsTbmsShVVkLP0m77grXWE+xZRgUPxDcI5yzsQdWMQ=;
 b=trf/GuyetAlNPq8wSMuKVIQNS2e8sS+RgnOvuFr14BR/RveAEKf1c6ROa/G4BmVbTPAcd8lD74b/
   1mezfnQaL3LpvFYgP1bTRsAFLSDqHTj8yBgxpU13xxZ5B/BgBogHnAzWhKX+RZEX3wx9xFKErdwr
   Y0nZ1d/b9faj9n5DyLUOxTXG0ulEaUMKz4GaqmeP7GqYiG+5+B4Z1HVxPpeTPmSx0tRyFvTAjzXF
   XVa8J4JymC+9+t+HN0boyjD5h0l0dLrc4CC2doUxznoClq9QzwSNxugU4Br0n7vl6AJxk2IWa4HJ
   rSJgqjMvTE7DMDwQrEWPA0pEIGvhuPOaJ+SzfA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00BQFFRZZG80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:45:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047123;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ooz3dCva7w6jx/i3dpZqqR47QA7PhzwOtiLya/TEJY0=;
 b=C6Lpcd7xASxf1cssBBMPcpooT8fI7+WWu1lp17jzmswseiWsUsSDpVLmYp+aytuaVPKGJV
 zBlbet/HYxzWqJ8islEoE8uoBdB495OdcWxvOjdBA6guagzH/ONpmsCfdImj7QjwvhJIfa
 1Y3W/9Mtiot7rG2cI1eGzxQO9qbz5QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047123;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ooz3dCva7w6jx/i3dpZqqR47QA7PhzwOtiLya/TEJY0=;
 b=UERgtbcz5w5Rq640BVo73B/v9AGy87UcJRye91hKPcs95E0D5kauEfPg5cnHzSGsCqQu3Y
 nYEW6NAJM4kNLLCA==
Date: Thu, 1 Sep 2022 17:45:22 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901154522.r37xszonxutm6bsk@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-4-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-4-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=108 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=699 spamscore=0 mlxscore=0 adultscore=0 clxscore=161
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 03/14] fs/buffer: replace ll_rw_block()
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
X-Proofpoint-GUID: uRsHRM5wDx8dllBmMx6urZVifaCoCkOY
X-Proofpoint-ORIG-GUID: uRsHRM5wDx8dllBmMx6urZVifaCoCkOY
Reporting-Meta:
 AAHVWVYdSUOyzjUI/oa8N5CG18YqmUKGEWxFyahWHEYAGxGDTdaHQGZq+NRdwC8U
 Nq4qa8sdXSy/08AHby1KqcuB+sqa0cuTOJDoQSwgR7sltHFQHv9Uh4keWFQ4FH9M
 iHJTpoEt430p85PzdTblWh2K7hO0Xq+51rPdwfiUNwbOPdAlim8mrW3mAedK4AW3
 ycsMp0djc/Om5Y9tkNSV89px7dgMgORhemQJuYh/dv4haL/TA1mSLVq0KVrj7Oa/
 51z5WU6hYLp4mCUAOgy85lKiL6yU7ylr8s8Rs3XODbCRpb7JsFSJ5gUyrjaVzvSt
 wX3SkTyql5/3AKu9/tIoSI0J+iH+T9KHA5ffdVnPwO4uDYJZH2McfZwmVaiLaUsY
 ogQINIDC+tUisxsIbEryeRF18Yq/1FCtBvuKVuTIy5Tosx0AZ+hfh2ybCyDFSlti
 SkZ+L43N8on67bVAeqLTc8YpYHEOLIMB2LqYAlqfats7ISorRroh5ISWl3PV3f1b
 8EWRA+qO5y1fr6n0TqWB7UOe6zKUenXLI7eqIBPYi+0=

On Thu 01-09-22 21:34:54, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync IO path because it skip buffers
> which has been locked by others, it could lead to false positive EIO
> when submitting read IO. So stop using ll_rw_block(), switch to use new
> helpers which could guarantee buffer locked and submit IO if needed.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a6bc769e665d..aec568b3ae52 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -562,7 +562,7 @@ void write_boundary_block(struct block_device *bdev,
>  	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
>  	if (bh) {
>  		if (buffer_dirty(bh))
> -			ll_rw_block(REQ_OP_WRITE, 1, &bh);
> +			write_dirty_buffer(bh, 0);
>  		put_bh(bh);
>  	}
>  }
> @@ -1342,7 +1342,7 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
>  {
>  	struct buffer_head *bh = __getblk(bdev, block, size);
>  	if (likely(bh)) {
> -		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
> +		bh_readahead(bh, REQ_RAHEAD);
>  		brelse(bh);
>  	}
>  }
> @@ -2022,7 +2022,7 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
>  		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
>  		    !buffer_unwritten(bh) &&
>  		     (block_start < from || block_end > to)) {
> -			ll_rw_block(REQ_OP_READ, 1, &bh);
> +			bh_read_nowait(bh, 0);
>  			*wait_bh++=bh;
>  		}
>  	}
> @@ -2582,11 +2582,9 @@ int block_truncate_page(struct address_space *mapping,
>  		set_buffer_uptodate(bh);
>  
>  	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
> -		err = -EIO;
> -		ll_rw_block(REQ_OP_READ, 1, &bh);
> -		wait_on_buffer(bh);
> +		err = bh_read(bh, 0);
>  		/* Uhhuh. Read error. Complain and punt. */
> -		if (!buffer_uptodate(bh))
> +		if (err < 0)
>  			goto unlock;
>  	}
>  
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
