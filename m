Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900A7ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OZODj4yY2y/Z4D4UvSwLKCBjOtoQ3yyXsggYYPGFVqI=;
 b=MZkVww3dcMFVFlRFutCJeoA4Jw0cgrO+sf1vIX0kdXRaXLIEpOFX7bHSE7PPheOe0YmMq5LkwnNC
   xi+Iuhhk/99WsaIu+391eG0hU76/LYsO3Sq2YrWZeqy1NvzKoW67KG/A5wdB4ibJg+KfzL1Zxejd
   NGdGrJmHWmVT5AsGwZamh9i0+qA0Cc85HQWhOFFDKAVF53dfV/uoLht81gaEKyaWWTQUFKyLA/xp
   8O9wcNITckOQvjZ8iYn68FmFRF0CpZqgdUhN6Y0AbkNA55+KBySOpUwQY1wiG4rk8BYANafM3Wdt
   awSv0hMcJMSF+6+/8RxGcQb6Vqsl+NcrvwWVyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OZODj4yY2y/Z4D4UvSwLKCBjOtoQ3yyXsggYYPGFVqI=;
 b=cUw0GDVkjOLrtKlaNsDabWH5TdKYWA00N8ZDXAFs8IDzjKzCUq863ZN2jLZGjbcqoNDWAVWzJMG3
   3SeR/uKdX1DVQVDMzuJ/2BPMlywtj2hMRL9/ce02UZg38ZS0hQYiCPgFrnuz1qR3AlIvV9VuDb6l
   e12o6NUKkwBZYNe5zKwAQuwQ/gQVK75EYLQIhBzjD7Ea8FVRNg9MdRIQcZGTYC8vIe6E4DtYIw1/
   2ob0bzQz6A+k2rb+Tn1ZrtO9QI/mjPgqyfhXvYTeGSOpt2tEITHgb5aknom1xz2yPqgYgULdvptg
   AvBghtd+wKSJ0C+tl4uCaciwkxM55A9xXvHsNg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00B507I5DZ10@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:51:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943086;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8KZxa7BkROWFtCJZpT4HFztv+uWtNZCErlyLPEOrTQ4=;
 b=sqmJ9PM0wpZHkNAS85aj9uz518aQ2XnQtkbTq/O+CTY3nfacrgxywR/5cynYnfgirgp9mH
 Mc+/x/hRkOKlr1sZDklZX/YrxZjwAFo4p3eMzt36CDeqygI9aLvHxUWUqnT65uRq802lIS
 1p6vD3j0ryv2VAaez7Shfs81KmCDhX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943086;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8KZxa7BkROWFtCJZpT4HFztv+uWtNZCErlyLPEOrTQ4=;
 b=bHu1UtCzvIt7Rh3BTdHNRRaTnSEFRz0PBvomL6mPmvV1ZkUGR3oA+CEMQxkTi5SFa1noE4
 NpUjHxUvdUsUFCBQ==
Date: Wed, 31 Aug 2022 12:51:25 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831105125.mv2674t37yhns2sf@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-4-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-4-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 priorityscore=60 lowpriorityscore=0 mlxlogscore=595 spamscore=0
 clxscore=181 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208310054
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 03/14] fs/buffer: replace ll_rw_block()
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
X-Proofpoint-GUID: GY64wd1-8FmdNhdOKwuf0CxRel0XzA2L
X-Proofpoint-ORIG-GUID: GY64wd1-8FmdNhdOKwuf0CxRel0XzA2L
Reporting-Meta:
 AAF9huaewlD7iHIV82Ds0EZSoqJ8gdOQqQY1Bou9j+p9Bd5XOhm0ad/5ymmLmhlo
 l5g8x7kA47jAxx8cztxZAwgXf3YThOjzykDereCuCC+tNrfQbqnTN+xsfC4x6aSu
 2JjA89tvdj9aW0A7XZgUAkgMZ24gV8CBT5PQdMJFL4sdUrX3QdUvnoEKmEyRbw3k
 A9CMJKcMgI+o1xzkKzN/2ojez+X5Xj2LhHfg2eUMXgVA14vodCNyJqkI6M3ZSLn+
 UW5RiPEnhu+b9oZ7zDrqGjY8btxtxBZGI3zzdcW3C+QSlwXThU2zwWXzrW78z9gZ
 UC4ewumi9Lb5Ntn7cqQJUZo7Z7DKReMf5p/u3CpTqiMlSNyFJNni4IiB4pnPWrme
 Gf4YG0rK/eZdL02AP7Izkco+moOvPju8Ag2H87n20h4+ZldHTEvIrOjWCl71DHoT
 pv0uY7mrsusj054ZPesOhyfhqy2hkEI/sOSZ0RDHLerkpEbY2fA8sggE5YwoCqeg
 vIwWFagaWPo6zE/u3UIhd32bToz5AYHYdArXWjcRYHc5Gg==

On Wed 31-08-22 15:21:00, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync IO path because it skip buffers
> which has been locked by others, it could lead to false positive EIO
> when submitting read IO. So stop using ll_rw_block(), switch to use new
> helpers which could guarantee buffer locked and submit IO if needed.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/buffer.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a663191903ed..e14adc638bfe 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
...
> @@ -1342,7 +1342,8 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
>  {
>  	struct buffer_head *bh = __getblk(bdev, block, size);
>  	if (likely(bh)) {
> -		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
> +		if (trylock_buffer(bh))
> +			__bh_read(bh, REQ_RAHEAD, false);

I suppose this can be bh_readahead()?

>  		brelse(bh);
>  	}
>  }

Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
