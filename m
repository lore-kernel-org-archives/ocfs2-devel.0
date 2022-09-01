Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB89ECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Mw6rerdd2jM/YYzwgkL1qzBj91p1Ee9ghFeq491tSs0=;
 b=v3OeoIZZTDGzWqZ/enmu4FUSokWd5Zd1PvWQcZOdnb9cNzafDpPVSX+PXB+lY9Z+DVXnJdEKmRyO
   IvzhHbta0AEOHYFga6TY1z8I0dbMQ7W60TxRskVzgLRCfBbIJCgBF4PZz0FeL6PZscuZS0FKQqcT
   qWKnPaexqbUceg7LlF3vJqGPvSgJ4tbe8zd3mMGb0nrXQnWKgC0YZNdPdZyeQwkO5ESW8W4TaAZu
   ir3b+rdaopZy/oUDlCJ+SZl3pcTeAtQqbKABu35JWj+Zgp5+uwl4vjAz3J/gdYPOmurwzCBGDT8b
   Kkp+183yTUTnQmJ9sk7zLZcp+EB2Z6KKgzxmCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Mw6rerdd2jM/YYzwgkL1qzBj91p1Ee9ghFeq491tSs0=;
 b=osfIxwRbE9dMPyWjL8pz8xA/3ODvJhAwxqEEWeXsyFCGxQNxppMYLo3eX1h6Erntl2O71LSFTxPJ
   OJTvzlhx0J9R2eiVicxHTj/Yu6e+RhXcpBTGdEnwlNwxVTL+ETV1hytya004hqmBUhC6CNG6FXcm
   9j1NNFt7XXz4OJqS7VTu94N5tZo9O4xFsVji+d6GWAe4ggFesKNhq3+/diMdJnEU+k/t95OEjXnB
   dw8XFHIAbWSjME7B3Nnpb4XIAMrBM/MrZVf9+IlBMLpBTSChzrTToDXV3oxqU7mUH8/JuVESXv+K
   l1L/rXtuMMjck4OzxIZmhX7Z/n0HK9Smtmq59Q==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00BJ9GE5ZG90@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:58:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047919;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=2ZHzkmvovrbUUNg7omW+A+uLbWs5jnT10RXVkkl6wFY=;
 b=p/HoZKGQ+Chf8aIZwmQEIpDzJkxuKlTPTzJLwChS5aMHA/ud76xS+P4Pk8KzIcoW+5/3Eb
 AeK/HYfcVwN5y+svRwYg23MnrmWilnjsmT2vy7Tu/e69J2Og2bFhLCM7z0oy4eGa9LhCt/
 DiwPnrcUrzS6SeDOb1Pux/BZHMN2hkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047919;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=2ZHzkmvovrbUUNg7omW+A+uLbWs5jnT10RXVkkl6wFY=;
 b=9ZRLqgMKoOF3e0PR9VpKkxfW/7/iQpv6TftC2aYuMTvDhiE8g67tMvprr0Hqx4cACz6+I6
 bI5hmGqJGZE9OfBA==
Date: Thu, 1 Sep 2022 17:58:38 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155838.24kdcxwaduc4c7pr@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-11-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-11-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 clxscore=166 impostorscore=0 mlxlogscore=423
 bulkscore=0 suspectscore=0 adultscore=0 priorityscore=250 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 10/14] udf: replace ll_rw_block()
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
X-Proofpoint-GUID: yGEqheZYbMSMFufGz_6tPcXXjYizCbuT
X-Proofpoint-ORIG-GUID: yGEqheZYbMSMFufGz_6tPcXXjYizCbuT
Reporting-Meta:
 AAEvsXxrkCYpKGbRnx3zhEdDS91cssipNXFIGGd1HXl6fVd1DyjQSXTlMaaN51aK
 onUneFj1a5RWMIkFwiuBsrKRJwJCCAoXtkDl29iMCE+J0TaSqRzhm41ZeWAAdqZD
 LR6zf8XwERT78d+IrLHfeeFTNZC2k+QVRku8AQPlarz2jovcFFufhNhEYX8vz2xv
 i9YsETNBYHbsQSRMSWEACkCdyEcz0jp76ApRhcsL6aS47y5xA3R0acQ/LbDbkxhq
 JjXkXaEsp21N328Ma11T7E0+g6I67cQUQYKYPUK/XPVE9Fo2U3o9hcZcmw12Nphr
 eKeHW1NCRwSxwKW6gjV8COWuQ0z3NyBOTlXPhM8PgPOf2CxEoXAvnf9RpcQZRgw5
 bnt/PFJRfGMxR2DvltcqjJEokCvFklvfrC0k7ROZ6ymXJATq4eziWOI8hzCqK6dp
 0327J4WVJ8ydelUnHGsb/+qfQmDJa/8BRHSYvDjg5wXh0bqQwyfObDGzEyrJ8o7E
 EszAUzdTOxJiS7a4YbRQhQcHakw+UZiOyJFKh0EBDAc=

On Thu 01-09-22 21:35:01, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block(). We also switch to
> new bh_readahead_batch() helper for the buffer array readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me.

								Honza

> ---
>  fs/udf/dir.c       | 2 +-
>  fs/udf/directory.c | 2 +-
>  fs/udf/inode.c     | 8 +-------
>  3 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index cad3772f9dbe..be640f4b2f2c 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -130,7 +130,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
>  					brelse(tmp);
>  			}
>  			if (num) {
> -				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
> +				bh_readahead_batch(num, bha, REQ_RAHEAD);
>  				for (i = 0; i < num; i++)
>  					brelse(bha[i]);
>  			}
> diff --git a/fs/udf/directory.c b/fs/udf/directory.c
> index a2adf6293093..16bcf2c6b8b3 100644
> --- a/fs/udf/directory.c
> +++ b/fs/udf/directory.c
> @@ -89,7 +89,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
>  					brelse(tmp);
>  			}
>  			if (num) {
> -				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
> +				bh_readahead_batch(num, bha, REQ_RAHEAD);
>  				for (i = 0; i < num; i++)
>  					brelse(bha[i]);
>  			}
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 8d06daed549f..dce6ae9ae306 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1211,13 +1211,7 @@ struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
>  	if (!bh)
>  		return NULL;
>  
> -	if (buffer_uptodate(bh))
> -		return bh;
> -
> -	ll_rw_block(REQ_OP_READ, 1, &bh);
> -
> -	wait_on_buffer(bh);
> -	if (buffer_uptodate(bh))
> +	if (bh_read(bh, 0) >= 0)
>  		return bh;
>  
>  	brelse(bh);
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
