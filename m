Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096ABECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CrGXR2HII7zFwohgw6ovuQXVEWlmmtBq/hGJG2GRIfo=;
 b=Rcr50/hNXsBvzikj5EWPJVkFFWWtkNJUFdIbPqNDDr0zZKqRpJkmkxrmFGdPgiAU5V8tCCAUhAvv
   KxL8Uzj5nEqwXnpzKWFUJc5pIROik9dSVRmIgOUxCu7OAibO9KKP37KP7GEyIq3G+5TjNpkFz8Kt
   z6O/BwAMcCAJVSab2iGPk9hkAo0zFmU8ZP8W1dL9nQG46YPZNYRC5BR+PWOjiyVaLgXMaMd2enH7
   LB48N3l1Elz/QgBSQWaVbwXc9KoI5Lk99Ezr/OMDZ9fiuyPGn4sH0YTQVL0hcpKl03iJgqBeEODQ
   5iikCsKr3go6Pt9lYqpxnZzDo9VSoaY43D91Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CrGXR2HII7zFwohgw6ovuQXVEWlmmtBq/hGJG2GRIfo=;
 b=RRXSxxue46beHcrgxiYG0EN5sQZ3jKCcTtspmOy339neMMT48GW0i6UkvZE9DB944m4YEmVAAqD3
   XOOBnEZmuAc86f6cbQcbMohZFtRtAyI/sUtGfj4cobQ7tLqyvmxuv2p+axLyAHmjKBRgKCRITl8b
   bAljNQk/e9yyGWUxSY2cxBrVHOh16a+FGEBWDai8zsDCVXtMAx8RLr56s+6iBYjhGC9yvUkpd+bI
   ol4w/bS4MZEgSChbc4X1UPwfRLVt/a22G6TfSVdySXjaBetnqEHz80s/8e09yHWSHbxY2E2i46z3
   zENUbG93px/MmTniE7SLBp5x2YP9UlXzJZgAKg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH004AT7KZKIB0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:53:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943189;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/2pG6/a9zSBeRGL1WuKMWpcsrfg2/SfPKOsUMFRSTMc=;
 b=WpBBNGvW05bAioDBgYLss3gyUrn8Cs9nfEQNB9M1LclJIIzDofmZcTGrUV6jf6FYB2ppKx
 JvXiSyv18HY57ebkPeUtX1RJLCSIejNAVkkVc0KmE6bhjjvUvM4U7QZPU5AB44Y2Y5DfzV
 5RBtyUMS6ABlZKCCP6qqwjcs/BMPuHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943189;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/2pG6/a9zSBeRGL1WuKMWpcsrfg2/SfPKOsUMFRSTMc=;
 b=BKm/rmA15SUC2af3CeYD8OSCnxEJjrIo9ju9hbO97uiUZqoIEY5Osl8V3pT3S9jb7fEd58
 Qp4AnD/tvpyD2tDw==
Date: Wed, 31 Aug 2022 12:53:09 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831105309.hbsyydkusk2w5hob@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-6-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-6-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 phishscore=0 clxscore=201 adultscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=552 impostorscore=0
 priorityscore=168 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310054
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 05/14] isofs: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: jOVd9Hzst8UYLpoRbFiQuADUZNKq7ONh
X-Proofpoint-GUID: jOVd9Hzst8UYLpoRbFiQuADUZNKq7ONh
Reporting-Meta:
 AAFwbXTTvq75se05lY8F2uGOjiQ6GXU3JZt96abPKla+rIvu5ECX4ejwxASPzis9
 VAlAgqQg71oQnT3Awgym9pStZIwCb97iY9DZuESDYAD6WmLvasGOaJf470VlCpxw
 pKnKrjp9f3yMjrN82nnFHA3NRpAfwnDyw9m5jsAY1O+NZktc1EDw704ON5PJHqxQ
 /peJxUCkUA+uOgAtDFEgfyuS1xEmMakiIG4hDMmcsG/1pfGsIoh/paFCrdqKFJOq
 ZzvAXQVsmiBgFVyG3JTONeoBlZbs8rs7b6SOg+gBQDFEZJaTjBAQC0GFFIjfEwD9
 ATcFrNSw/87c63eghO8Jq17pQJQRgL844Vgvr+WQ/e+o0j+oKFKq647wB8T+Jrur
 4SsOFw0j+YFkq87B4bCHk8b3YBGmPUwbJTNMiuA5MXZd5RJKgI2YFR4T6F26oD4K
 HwU6mFKngd1cDttIRU+L1O0kni5/RzCtxKWQ9UbjP+kNMMu56tSzajkw2p/70r/6
 vfw1kIX4NjycA06o9fqGe66l5fBVObImT9e4UTgC4yA=

On Wed 31-08-22 15:21:02, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO return from zisofs_uncompress_block() if
> he buffer has been locked by others. So stop using ll_rw_block(),
> switch to sync helper instead.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/isofs/compress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
> index b466172eec25..ac35eddff29c 100644
> --- a/fs/isofs/compress.c
> +++ b/fs/isofs/compress.c
> @@ -82,7 +82,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
>  		return 0;
>  	}
>  	haveblocks = isofs_get_blocks(inode, blocknum, bhs, needblocks);
> -	ll_rw_block(REQ_OP_READ, haveblocks, bhs);
> +	bh_read_batch(bhs, haveblocks);
>  
>  	curbh = 0;
>  	curpage = 0;
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
