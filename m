Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BCFECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iG4GaaIrF4TnPJWbNdr4LU4HEjZ7pCPHu0y0tcTvcto=;
 b=bY3n0W4WfWbEAp7Jr2h3TaLcmVsCg1W+f3ZFvtnSojA7oQuSyAfB5DyJQVkvvKHNQw7fnQFouK7R
   Z9fDv2ioUFBOf0A/F2pZbeINmBpizTF9zR0kmNeEE9/KQyXV7hfNf4FRdUOmNDrRy4PrdjCq9uMo
   o2Y0442QYxaR+0+9k/TjOu0Xoi2nAIIRV2d8AmS1fmAm7FVYtdl47K8+RtGBtgT1H5Em+FgtILN/
   hPDBGebsK2nJaMNNBaLa4BtcNTdihUXsJcZvViZgOlZIjTVFcxO1aBiDL6wCcPEJizKdDtgD/GU2
   3qSqy2N7i7J6s74+7Cuy1g09ydrtObulQ9WLrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iG4GaaIrF4TnPJWbNdr4LU4HEjZ7pCPHu0y0tcTvcto=;
 b=h3gnZJPN5AoP0ZSOFOp33af4gr56QkRt7vLnYD47kEVbm8kDQCy0w5GlVjYO8oaVt5r0P03BWOGt
   WCTznwfR8HUJi6DQ+ovm8zJHiz0BIawvb8O/prCsdsz/4qIF2AqIObHCESMDFaOpZhW33eFcgGhn
   Bniqp/A6XPi4VP/Ecs1714O245Tt/2rJnt/GHPScP6aqojrJ2hr0PHaTIQ8p70VJAw9KYAh9ezJ1
   xevgP9bw3CCmpSYCcsFzJF+AY/6JaMEEd4hgSNRCZ1R0lrlLQcwH/fQn7PU1V03YrgzEtFNN+pix
   48ewuydGvmdt7r+4s3CxRKIxlBG+J/efaPtn6w==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH006IJ8MTM710@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:16:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661944551;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oXzaBEvTVV7dbi9myeynRQQFCXVdxVJKtZqX81xMy8k=;
 b=mPbi7U2qKIanPKYVB8sPf2stChvWwJ1COvVr00O/9AJRZvghUomaQbB0KyXkUy4pMnVLKr
 w/6h+8ghNadTMJGE7oK3ErbM4mfCpj2CGsMQK4AHXb36lCPabynaouGuZ/Z5Agk4IDg2j4
 pSdrP2QZlF517bgBQJnIFu8gpi74cQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661944551;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oXzaBEvTVV7dbi9myeynRQQFCXVdxVJKtZqX81xMy8k=;
 b=+8l5+Kxjd5pNwOzZL5ohw7iQDKbEQCrFZuuYixoYezrMKq3W4lXTV40FstJ3qPyZO5S3mg
 Ln5047YJolJZx8Dg==
Date: Wed, 31 Aug 2022 13:15:51 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831111551.pjrcx2ld6wm5trct@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-14-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-14-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=140 impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=169 malwarescore=0 mlxlogscore=545 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310056
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 13/14] ext2: replace bh_submit_read() helper
 with bh_read_locked()
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
X-Proofpoint-GUID: 39DhMgoFo2DZ29C4__zuWCa-3eH-1seG
X-Proofpoint-ORIG-GUID: 39DhMgoFo2DZ29C4__zuWCa-3eH-1seG
Reporting-Meta:
 AAF53XTh6w1dTLx9QZHEKCij/X7zq5u5JDeE5kiqdywg5dbG5K1ZPGiv3gAnuOwG
 aCUVdgb5IS0tnNT2Gd1cyN0cw+5seXK+GbuXLAWkyZg8TDnJq9rL5Np8fqfyK8Ps
 W3T5nS0L+vafMjrIuS1AOjJCqh3f3VKkGhWCOeH9AYHm3mPd1DyCooK3xae2UxKe
 g7McvwnJK7pm2TEOLSEEiMXE8x+T4aVOdNgLD/nbszkUxeC0fi9b/yt7H3WpejcJ
 G3boU8k098QKRCY+5lMj6HkHuBUmRTWOWaQRnL6cU9fvJIzZgq4VFu1KL4NRWVn6
 7TP67c2xVq22xK8yuaHA7rgS/0WQeGEiRGPYmpdLQ6nyDKWMokI18X2/1p3cBcR1
 5TkBBpLle1CpUnBknMbhT+s/UCfGFeGp6zrJahyL2x65V5vBsj1m5kxb8oDMlymm
 u2harVh11OkByEVdD+i1Y371lxr9Y5iNYHkVObkaFwR68iZjtU8cb1kF+K+y0MhK
 XDftk1iX1oCL3wgOUqZaDGNdYDsr2VdUN/J7J0XHWKG0

On Wed 31-08-22 15:21:10, Zhang Yi wrote:
> bh_submit_read() is almost the same as bh_read_locked(), switch to use
> bh_read_locked() in read_block_bitmap(), prepare remove the old one.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
...
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index c17ccc19b938..548a1d607f5a 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -142,7 +142,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  	if (likely(bh_uptodate_or_lock(bh)))
>  		return bh;
>  
> -	if (bh_submit_read(bh) < 0) {
> +	if (bh_read_locked(bh, 0) < 0) {

I would just use bh_read() here and thus remove a bit more of the
boilerplate code (like the bh_uptodate_or_lock() checking).

							Honza

>  		brelse(bh);
>  		ext2_error(sb, __func__,
>  			    "Cannot read block bitmap - "
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
