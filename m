Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AF3ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Yr+/i6TQ2rzvDoYIkzvDMqJe4rKjqTq41iQwr7LlJgI=;
 b=ttdKzdaE+UmJhLKsGmC26rAbhKOAomOuuZ30NFWzQrRSyO8CtSOd7JWIKLidJSdRtJugYOcSKqVF
   28njWm98LiKc0UVcd/9XOUz1op4SwGkCmYjdqny5IM/g64ckOdmshsmHArsYkaH+k3nUd4V3w1f4
   YF7eQ7jwDXuznBVbFwX2G0nJIrmhQj8vANry8GtyjmNntQRgdmqUTXJpoDIXhAVmEg3YLAfpLsrJ
   IGZ7IXYIisAjxr40szJoeYQJhUMhYLiIkR3sl77Os3mU8CE+6wkBKSghz7e+LBXgLdM2qRE9Emli
   +rGsOrzhaS7Bvbv7hxDN/fdy+5aUdhojYPiM2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Yr+/i6TQ2rzvDoYIkzvDMqJe4rKjqTq41iQwr7LlJgI=;
 b=oSwC4jABKPzZLXOWvIiZBEXxm8Zy3WokOuYRwlrkwC5wBF1zd9rv/Xn2VjO6Dk2T+fbHco3qE0VX
   keg49cot2Zfz//C+lQv02bxEAmd5A7hhrV805Ap3l9ZUDz8bpOLRC8RI4yQSP7hdnLh7RNvpl9/S
   dzGpkpogGlMgUFefcVTcCTNPTroJ9Okdfg1kuqF8lOZzY/DsRQPxjaEXrQbVZppd67/qPMAq4WSk
   O5G0lIsTUnBYik4hE4dJFCDw0NRA7O/ttNzVDmntkRTin2lPdeLjUnFovv00MUBY4dDHxkZR/htc
   wnPf46GVl5Lzmd5Zvkt3dE9Xc31xx3Am7KNReA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ007OHGF68XB0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:59:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047952;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KBfsBLjkBk+MOp0nQfi/nmYmADNsHmXsxHUoLjnY3bA=;
 b=eTkuxs55IxFpE7hDRb6Zude0PNe42Rg2iDMXK6ovgOmLJ8ol+1hu0xPXSwQoqG9TGCaDc3
 i42+WNdKtbB6Lfrn3L5KkY4OhWhqvQdspBys/xSEJGbnPDDd/Ub0fAQLxecq4hpNU8HyuG
 G6/KF4WT3KI1yrz/XlU9iNhXieN8XTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047952;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KBfsBLjkBk+MOp0nQfi/nmYmADNsHmXsxHUoLjnY3bA=;
 b=Z4hcUx2ha2YSNK1fJxrz+uxnK+d2neX9kSNscLfnZg2OLnp020u8KVt2k2u2P+l6DPBLZE
 LGa6Pt9b/QN5juCQ==
Date: Thu, 1 Sep 2022 17:59:11 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155911.fbdsdn26kaj7ehjb@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-12-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-12-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=278 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=560 spamscore=0 mlxscore=0 adultscore=0 clxscore=172
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 11/14] ufs: replace ll_rw_block()
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
X-Proofpoint-GUID: 25O1zbGgkqmaU_mc1JwFGOifIxNt2uAY
X-Proofpoint-ORIG-GUID: 25O1zbGgkqmaU_mc1JwFGOifIxNt2uAY
Reporting-Meta:
 AAF55idWRfbxPozgKQ8TMIUHlDoYw8FeqJaVSOKzo6F8/PWC3EIgXdDEuV1xrAIb
 WQiHDn7HizP8/T/XB6yrnx7C43Runt2Zy2UnigPkTh4YYAVuflcOn+QtmnHPoPMD
 XBQV51ItLKBfN0iBZ4aEDmPch0WPEV0eng7bJbgoBVlPjYG2EHynb4qfy4MCkJtz
 XszCamrU7WeDUcgAEqYpUoW3Z29965bYozYh9EFSHwvbiJdb6RPrT3DVyzxTfAan
 3IFfEvC30pCEtZLy0h29J+d8z7QUEqqZ9EPR1KY/GRB5iSyOgm5ZQqK1BXisFEnf
 3nLotQ1PCseiXgULzFAEc4oFT1XRLwFB4rWQiOFFR6McCVAk65xZBHfVs/BxSLkT
 4MmFoIW+pYkvI9YtPWEprqdxj2JXqwwYJrsuVvVt/4LGGeR5spT5q1ZPm47C086u
 B3+yawNKZRFeQH2zokYOlVQvogau6nON/5vmmuNgk2EH+6b1DaNe8v9lpsHFOcap
 0SnpzO2v5UEzUhfxw5ao1akAw4C+ws742rzkAXyAqUDh

On Thu 01-09-22 21:35:02, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in ufs.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ufs/balloc.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
> index bd810d8239f2..2436e3f82147 100644
> --- a/fs/ufs/balloc.c
> +++ b/fs/ufs/balloc.c
> @@ -295,14 +295,10 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
>  
>  			if (!buffer_mapped(bh))
>  					map_bh(bh, inode->i_sb, oldb + pos);
> -			if (!buffer_uptodate(bh)) {
> -				ll_rw_block(REQ_OP_READ, 1, &bh);
> -				wait_on_buffer(bh);
> -				if (!buffer_uptodate(bh)) {
> -					ufs_error(inode->i_sb, __func__,
> -						  "read of block failed\n");
> -					break;
> -				}
> +			if (bh_read(bh, 0) < 0) {
> +				ufs_error(inode->i_sb, __func__,
> +					  "read of block failed\n");
> +				break;
>  			}
>  
>  			UFSD(" change from %llu to %llu, pos %u\n",
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
