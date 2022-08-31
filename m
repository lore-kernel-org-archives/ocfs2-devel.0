Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A8B2ECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eAXPQW5Fn3MDXOgnwxdAJSb6W8e2HUTthjescBaA5C4=;
 b=wP+BH4LoWWlXHPHQhVRgbI2FUijznxkbTabWrZmWPH9BqHeXs/gNVzBL2aEqlf7jaNhS0mWcZn+R
   of3nxYS+kYG3Uo8sEcpi/Z1+u3r7+krUYKuqa5a63peN6bGUqjnH62Z4ulkCTI/K9RU168RxtGJW
   79aVyaNbz6AnvGZ7T2iI8Kbc7xM5q7lt6xQNT5p6hyXis9KAX7vgRj/dmoKGmAETx2v2APQQ+vjz
   18KMVSnmUl7bkjFmEAJou928rq+/PsPJcejNvdUJrLwz0ixqFWggCcL50p3ghxjsYVBnFvv8W/nZ
   dItkjNqNwELdMN4xoj2emUvYrTnxRriXbsJFIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eAXPQW5Fn3MDXOgnwxdAJSb6W8e2HUTthjescBaA5C4=;
 b=B4X5fX48YsSWnguJz59OCstShTLkPla/HCN24nFxmIgs1tnwjPggCtmTq7Pu+lKExBG3FZqr3Rmc
   7Z/57muuDloElHOadbk4MBrnu8W45uQ0D3S3toUrIrQ7Vu/pg/8pbpJNTYFQO8yzgGnyn77XDLGL
   kiD9N0Se86VnxWV7XHqiCsfYzbPi9Q0jTzsDawhoT7K2UNhHOY3M1+Eb0Yv8UdxLZB2ZX+OJPSsJ
   PAWe0otdAcQ3IQqAKC3qLid6IRGDU3UjkcVktsKHhM3G0YHw9cp0v4DmurJUbNiTHNKNccRMuphQ
   hqoLH99pvsZTVW6dSy4cg4m8n2SqbZcOASKRBQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00B6C7K0DZ10@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:52:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943155;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=aV4GbEJHv4GUiycGvXX9VQqqdKb3fSgUfwxaOPsIBF4=;
 b=PRYWzd/0V29rFD/lWsz52Lt0OuT2f9LO3aKmg3FNGDjcIWECgNVeiUKviDDEgU9FQ1f0S7
 tBcH5xPN5Vvsv1CHdQ36ejgJV00plIjLpXu5HEytDKcazrypMPm2bWt2i+N17xwihsoTDp
 Kftx+Qdml/EOZW5sbd0MeaeVIcopkCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943155;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=aV4GbEJHv4GUiycGvXX9VQqqdKb3fSgUfwxaOPsIBF4=;
 b=awjqDxapgMdgRxiPhamh5PF4pAsLYLJcaoyapMEqNq4rUetRfMnPJj7syOzPUqu5raEHle
 Vplg3xbSnI95jNDw==
Date: Wed, 31 Aug 2022 12:52:34 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831105234.suazqjzqnb2r65ow@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-5-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-5-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=633 clxscore=161
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=60 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310054
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 04/14] gfs2: replace ll_rw_block()
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
X-Proofpoint-GUID: TWoyWr7J3v2A36svFz-Lu0SAG0AqHmRo
X-Proofpoint-ORIG-GUID: TWoyWr7J3v2A36svFz-Lu0SAG0AqHmRo
Reporting-Meta:
 AAEU0Khsq18RzQmWXzT03zFmokvicD4SD6ENfJ+fIb5qD+bjJtUtyfYMHMMk/cVY
 65RcXWb4NvQUlRr0TvYW00K6Noe/iqMauRHU9OPawMyU30pQ2qpYTQ+oWBhLWqCH
 yMtcLHq6UQfipt37S/U0jFe5bAUZtbETpSQ34IC9yflUmvD9gJomZyutspRNovPw
 FaNGgr5BLDrCjy3IOaimYyj8NU2o7DoC3v3sd7Qsj6hcFgpEPtAhbZQUX5w4VgMi
 yCgAo+TyRzxItk68VaqObNYWkZ0huV6mdsqlclQhNKwhwvDua3EdlVjY03A7HEu2
 CfFCJnO2pDdYWRSB0llSRHwKl18PXaDAQtnqfN64tWc9ZqvwlFYjXmvkHa3fwhqY
 w2vBKzkSpdXyGOT4/NkGxizVGxwNEUTi65D/cQANYZKGwtOZ+0wMvNQba/RVyBVQ
 mjvQr4b7GUo4/2vYRYeNfpu/k8sKIjrFkqBZiWtZ2pE3Lg6NjvngUf4XW2nvxdwF
 CRVvb0h5933dDnl0a5xOp+/RjNZKzU3qQwNsWyCfjIIb

On Wed 31-08-22 15:21:01, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that always submitting read IO if the buffer has been locked,
> so stop using it. We also switch to new bh_readahead() helper for the
> readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/gfs2/meta_io.c | 6 ++----
>  fs/gfs2/quota.c   | 4 +---
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index 7e70e0ba5a6c..07e882aa7ebd 100644
> --- a/fs/gfs2/meta_io.c
> +++ b/fs/gfs2/meta_io.c
> @@ -525,8 +525,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>  
>  	if (buffer_uptodate(first_bh))
>  		goto out;
> -	if (!buffer_locked(first_bh))
> -		ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &first_bh);
> +	bh_read_nowait(first_bh, REQ_META | REQ_PRIO);
>  
>  	dblock++;
>  	extlen--;
> @@ -535,8 +534,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>  		bh = gfs2_getbuf(gl, dblock, CREATE);
>  
>  		if (!buffer_uptodate(bh) && !buffer_locked(bh))
> -			ll_rw_block(REQ_OP_READ | REQ_RAHEAD | REQ_META |
> -				    REQ_PRIO, 1, &bh);
> +			bh_readahead(bh, REQ_RAHEAD | REQ_META | REQ_PRIO);
>  		brelse(bh);
>  		dblock++;
>  		extlen--;
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index f201eaf59d0d..0c2ef4226aba 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -746,9 +746,7 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
>  		if (PageUptodate(page))
>  			set_buffer_uptodate(bh);
>  		if (!buffer_uptodate(bh)) {
> -			ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &bh);
> -			wait_on_buffer(bh);
> -			if (!buffer_uptodate(bh))
> +			if (bh_read(bh, REQ_META | REQ_PRIO))
>  				goto unlock_out;
>  		}
>  		if (gfs2_is_jdata(ip))
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
