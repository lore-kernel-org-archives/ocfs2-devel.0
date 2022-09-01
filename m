Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6059EECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ThV2Ls9qgVkovyRlLY0sUqGw495Oxw6YGX3qX2n3aIo=;
 b=Nk6EWtkVrrjibm5g03u+qylSW8AyxWO+ph/ivT0qoZhaF2Yo50hpugYpxTbvQL34ym8HhNdQP74P
   a2B2kRNQvBr1WLOn5ohfTgZOYlB065MkxwUDqJXxZWgik7EmJ6PfWDs89OFgsC/5WHohmoAPPDxv
   FVlK4VWA5/HtPiTBsMFyj3n52ViBx8g9axg2OYQnwtnZtOr686J5X8zIhei4xt6LOELYa4kaHdtN
   LE2g4LqfvoHwlemLj6L9qgQo8JmLAGqyLWe4tvaChaD7RXlo64UOwyPx2GNmOC4NRu6v7FAPXrao
   K3SbcVsaWnJQ0oR74HBF0Yhxf2Z+A7GnFYWlhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ThV2Ls9qgVkovyRlLY0sUqGw495Oxw6YGX3qX2n3aIo=;
 b=OXtrr+l0NX0B4JsWDzjLxbqbNzzZrdO2/ksJ3wKl8UkSyr8c1t22FBZDtdhNLOif09hm9pK5cLeh
   kwgNwXgENdjg0NQ+5DTi61bdx5USieDdrceieBjN5kDzDE2wuTm0t2pj0jr2uXfS8n0VkZzYc5eB
   IStgWTiK6Q5hrX+uiSIxlI8yfbN9g+sOBqUbKdTYclN7g4DoKj77g0pO9W7UV4J4N9RkMFUtCdHY
   7SZoBu69xdCbDUloknX4zNWbQ8F66a6Z6d0iFAKwxGHsdKZyz8jjcPSHebJ7Rad//IAiPq9d2b/4
   qOKI3UUS3FZroFYT8j5uadaEpMvwYq0bLByS4g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00NS9FVRY040@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:47:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047258;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=peOjY+qH/acfnYJmHx1YRVDMdJv9R64hwm8Pmaa0lFE=;
 b=rc5JraMEONNabeyE/eWQdGR9l2bhyHcEvaCTH7da6qgpRryhdZ2horY0ZO0nbPl5wR5apB
 LSadiiEXMpz7u7e4vw2MEK+FRq2D7vgplUwdcjEUFBc58CCNwxP82cjZQqVyGNOwQPGKgH
 ENrRcNH86XZQxwpAwSZsss0tIdOUB5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047258;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=peOjY+qH/acfnYJmHx1YRVDMdJv9R64hwm8Pmaa0lFE=;
 b=lHHvX7qWz+dxQf+Jx4+FQrtDcN8aJLRk0wdWYaGsd477gh8eQUeNBFBoy60w0LGTBaLHrS
 1r+WjBl4PQh8QmBQ==
Date: Thu, 1 Sep 2022 17:47:38 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901154738.6b5gti2w2y2f4see@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-8-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-8-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=203 phishscore=0 lowpriorityscore=0
 clxscore=176 suspectscore=0 bulkscore=0 mlxlogscore=574 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 07/14] ntfs3: replace ll_rw_block()
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
X-Proofpoint-GUID: TfLn4iMB1f2Ti7-h5ALpVyvVwMloGtMm
X-Proofpoint-ORIG-GUID: TfLn4iMB1f2Ti7-h5ALpVyvVwMloGtMm
Reporting-Meta:
 AAGget+z2y3n5AJWPMKt9Vx89Z4av01mzOuJa6BuSZ431hRXNLFD0TXPecjZ8FqF
 dwpUxCwn25rQAmHv39ynWyx51vtOPYV0FFfKhSuDIinhb2gddqCYiOQCZP1qbYiD
 2ZIWOpJLE1OT4R+xLVwgFVe/QlIe4qfYzJds82IZ5ciHS2ZCUAXVKA20dg7dem/y
 VMuVg8rkN6TX9jyQ0WJ46/n7Q/Uh7oDpo44omVrmx2ZLvIzjOdNPacetC9dKNGHJ
 8EmM01EpL1SZPg8oeq05/6zhZNFio0hkKJHzfosnoCh/lT6nt8v0jRw1DhAYzuHy
 KAdyjVQ8YXRfO7YJ63Qf5QmcqznxIgsvf1W2FYiq42nDfHuSpt72hI8/en/wctnF
 ItLxuT092tZQNjMMjFZTXKPLyqgEVE3bNNECrps8uunx5szDGpKn0KGIVAOIQenE
 KPcdfdiW4ANxJ5WZYrH9eSGi/aTQgXR9wnDnqLLSoHLXRn1/hz0k6t2WFupakOnQ
 k2jnnoDEnYRNL+E/aDObIQbCSP2+f1mOtLCw1YSPFyw=

On Thu 01-09-22 21:34:58, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in
> ntfs_get_block_vbo().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ntfs3/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 51363d4e8636..cadbfa111539 100644
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
> +			if (err < 0)
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
