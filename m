Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207EDECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xjshS+lEsilpg2o434jg8Z2FCww02N9J17Yah2ws8ho=;
 b=hIypW/9V568e/peIQ9u+oeAAgY/TLrY6kzkHtCrf9rSdXPrcvh4bTO9lz0B2WXy/jNiC1P4DBLu2
   vozM4wii/CMoBo02bznF/FJfl3hgI5Vk3vI47YFYZDUkD8n88/U+RvnXnp7Mmryps5DchbzLX3Y5
   1v8DkYwkHtRRmMWKBLRriRWqqGxumOpNLDsPsiBQ/bn5+5BGijhmnVpD7bcDA6u+j5uCLvkTC1Ny
   +6sWqCbPrrh6tjrTJxFxoO1GBB223Atw42rhidHQAFbvM3MkxtFLfDu+V7LsbrQvYa+8KY6ZBTfv
   UAuEqAsciSJOrITC+08G+XCZkAi4aJD6bkoa4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xjshS+lEsilpg2o434jg8Z2FCww02N9J17Yah2ws8ho=;
 b=W8FRAFfp7fRi6f+/bLIvUAQEl52/YENvzQSW35FVo3uUX1sd2h5X9bFaOZBkmwByiSQOZJJTsYgl
   uw+/07dLD6SSRMNF87BQAapI42JMJFrOGGY0+DbYG2XPEdSDgXwiKlTMFH23vdu2eiEStcN8nzRG
   6Dse9RMLZks+Bv26EmTCzAtCRLpCSzABMNMFIW4x9BuhQBIv/W34PM2ARbbOasddN+RzxOsDfGG6
   aaa7yisgXcY/nNIh4Br1ObAwYisNm5wIHsnXpACBitbxsmNh1e4HYi2IqPIXbeM30CnB7HzNgeqG
   Xti6dYhsuAAe6ES/P+GQ3mSc4OwfrbhyXY9d3A==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH004KP7V0KIB0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:59:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943553;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7pCrX4rJAh3LXCsMBtJxFA5ygrq1v/RFZEm6VruL38A=;
 b=L9Mc6XUca7WIz22tD7HN+8QnY5trbdMz7pnoo1qimh9zHXmhLdpVrS+1d+15xDppkIm/jg
 HZKW8bB7dZPhMT9IM4JtbWEh1mD1HTkg6P4n1wOHU//s1vZs0lsuMHnyT4T4iGTxO/YDhi
 xAbsrka5InTA++kdfvn58sF5exaiSZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943553;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7pCrX4rJAh3LXCsMBtJxFA5ygrq1v/RFZEm6VruL38A=;
 b=6/tElmIZdAo0spE3ELqBpkQVsZu8tISnju6SykXxSP1E3X8SFlxwnXcITV1hVxWZEnL+7l
 Nq97MlTgY1UVYcBw==
Date: Wed, 31 Aug 2022 12:59:13 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831105913.ges3eatp5buz3bkh@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-8-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-8-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=169 impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=174 malwarescore=0 mlxlogscore=586 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310054
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 07/14] ntfs3: replace ll_rw_block()
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
X-Proofpoint-GUID: Y6iglaQReHpSJB2o3y31mUsdqbPtRp_H
X-Proofpoint-ORIG-GUID: Y6iglaQReHpSJB2o3y31mUsdqbPtRp_H
Reporting-Meta:
 AAFKiqAjVTUy3Mzwd9rUUtlaLPAEuDpJyuq8Y9XAtcB19yaZJONFnl+9jL6UipXR
 pSo8A4H/MxOtbXMN2qG9VEeMx1LjI4rnbzoIZhiEFZKM+a2H8iCsFs2mhkQhVkKT
 jz2ySJY+74gmlIGuaPkHK7KPFRXNTXS/7/zNf29ELU+ZzMqca5dcxGqE4Xau7lNr
 Rm+vjrB3nyefateFLrXfPQ3rSPvKZgBx2u6W/IgKZnjgGWnqTC+GQDe0dgrK6bVb
 VVS5efIAyLPy/1A7BDc8e03wMpqDnaZWGY9zbx6oODz47/Erprv+e+xr0flFeDBW
 DWyWKpTdYb08Hnm3OCeB0CFNA+nl3Yln4bXDXx9KIsg1RSiOVqobl6lO+H3MvdKN
 vW1CTWHVHfki7zEQkbM/NerNVVmZny+nfW2t9BXm9TdZddWNSb/2CdcorGZU/JUy
 RB2fg/LwVxoh3eqrWuaK9ujRtgLZ0dwydJIdV9fH26/O22xQfevvTgjUsjSRRhkK
 Xlw61GfqJ3DDXLfynyVRwTJS5+jeF6cCVrfh9+OKv1tz

On Wed 31-08-22 15:21:04, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in
> ntfs_get_block_vbo().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ntfs3/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 51363d4e8636..bbe7d4ea1750 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -630,12 +630,9 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
>  			bh->b_size = block_size;
>  			off = vbo & (PAGE_SIZE - 1);
>  			set_bh_page(bh, page, off);
> -			ll_rw_block(REQ_OP_READ, 1, &bh);
> -			wait_on_buffer(bh);
> -			if (!buffer_uptodate(bh)) {
> -				err = -EIO;
> +			err = bh_read(bh, 0);
> +			if (err)
>  				goto out;
> -			}
>  			zero_user_segment(page, off + voff, off + block_size);
>  		}
>  	}
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
