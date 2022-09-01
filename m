Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3040AECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mbd0nuE5FmvHlICPXsJ6Gwk0D9dGJQqnuzyif6yXBgw=;
 b=pM7SktjNNBMe3lT0JKg7jfMr5tgQ/0khQ8gDBeCBe9BPWGXf12bDFifEQjORLtoQ7qgiT1eRPFm2
   HPKATrKOa/KGoRCwxMxs6NePLi9BsnNyrSFVHXLlqyMYKt3XDIroMbohoWWIONV3EDMyKwbNe7or
   lYYQOUqUzepgP9h6+3YLMfHvyqn6USOZChV5gKInTqcmQh4m0qxq+CQRgxpUgB71eZgI1NmExo7h
   had9PlwVAAYUNl7D6OuGsMnm1Yg4f4wy090p2yZMvW4Rh5rMAI2if685IDVkmcDAZ7G5jhBxSxjS
   YHz927phSft02z4SE0Yy1WeQFWDHFwTreg6QgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mbd0nuE5FmvHlICPXsJ6Gwk0D9dGJQqnuzyif6yXBgw=;
 b=daXehgjArOE2/hfaW+dhnktLymafSp4UQYT8Ehe3oLSdu0k/qa3mQm9e1iFbx4NPi/TgvleW/HSg
   Q12hsx3ZsUjnv/4TBEUFSd1b3MuRWj9Bgd9edHq/R1Hv5AKwBlyhEomwgy5Fs5A7fbyv3rm7+GCc
   vtikuSiUB2ScZ19LMyloFFBacPAyV87rD19sYbgl59SOnlbBIQ//2smyLUP5gqmdpv1F+lC3edUE
   iwJavoAroHMqRQ0MpJuH3QS4m9yNRjhNkQEOzZlqjgCyZw9jmx/+bHLzPQIi414pq+y016WqN8aw
   ZDsPkGfmuMgrbJmG9s88ed7sux6LqbNdWKqmJA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00KTYFU8OBD0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:46:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047204;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ER5/wzctY1JkhCLGtz3EQTHmS/rSylXbZsr8bP56n58=;
 b=pYpvEB1TmGjm8w9ZO025ZJi1mKJ5APp3kAmy6ytuh7FOsOF4aT2GnAY5QPFTbV78lJf3i6
 S6owfPABPJ7q8tVDcvQhOhAD9xrqNabulW59Ye+JNuQPSEu3Hc/F5Fm+XiXmcXqODVUWQg
 QBCOoh/GgMlVi4vLG7nrbaTVJuZHykU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047204;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ER5/wzctY1JkhCLGtz3EQTHmS/rSylXbZsr8bP56n58=;
 b=CQHn61+Ymblc4OV77OAZiRc+28mY55tAzplOZrHAIEIhFvwR7MSOVwzpIrthiIC6RR5nTj
 AZXQC1qsdzYhkRCw==
Date: Thu, 1 Sep 2022 17:46:44 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901154644.uxxzwa7gvzlnbw7j@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-5-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-5-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=120 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=647 spamscore=0 mlxscore=0 adultscore=0 clxscore=189
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 04/14] gfs2: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: 9u5tlKqJg2mZwljKyobcQ7y34AiuPD3L
X-Proofpoint-GUID: 9u5tlKqJg2mZwljKyobcQ7y34AiuPD3L
Reporting-Meta:
 AAFjn6CVIe2MO2Cc9nzGBqSepC0sBvlvj3/pzwBru75gVtPCOs1xbEqJiGTW6dH/
 2z3TUUU9199uON2INdDj5jHrE00cvrmmN4KcQZZvPnIreA+R00mTyZsM7mc46j36
 o27lHrBeP2x5qXoQXstwIEPnPEbUIf2ebj5dsvwgPaTBT8AphvBlZ2o31iwqWNYs
 v3g55y/w4IwdwLfffNkYyhFkDLC2/Fzbgp3nrE72hgnJ/+RK7AZuiuKK0Dd7tiym
 rcH89rwJzpcmGQH9kvagPgBKM/fpBNFNmkqqrME6mpI8Lk2yrCyDqPEtKi44LqCU
 zhgmN4bnqCgpQAqbYmcZFRttmZyl8g8irDC45TUot5ezvPZSZfNNoIZW15vtzvZe
 okKiB/Jyy3PvccGFwJ07M2K1gnivQF0mTfeuDZ7OxXB7XN1SAqOrBMNC9QbTOVZB
 b11UBvpLoAwr8aNAwoHgiiVMaUi84pg4aIogqHbtrxLAGoRmi+Bbsaizk7L2mUFB
 bg4zLsdC5TaX7Kx3AyBnVeXkANLViXv5H493/jiSuvA=

On Thu 01-09-22 21:34:55, Zhang Yi wrote:
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
>  fs/gfs2/meta_io.c | 7 ++-----
>  fs/gfs2/quota.c   | 8 ++------
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index 7e70e0ba5a6c..6ed728aae9a5 100644
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
> @@ -534,9 +533,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>  	while (extlen) {
>  		bh = gfs2_getbuf(gl, dblock, CREATE);
>  
> -		if (!buffer_uptodate(bh) && !buffer_locked(bh))
> -			ll_rw_block(REQ_OP_READ | REQ_RAHEAD | REQ_META |
> -				    REQ_PRIO, 1, &bh);
> +		bh_readahead(bh, REQ_RAHEAD | REQ_META | REQ_PRIO);
>  		brelse(bh);
>  		dblock++;
>  		extlen--;
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index f201eaf59d0d..1ed17226d9ed 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -745,12 +745,8 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
>  		}
>  		if (PageUptodate(page))
>  			set_buffer_uptodate(bh);
> -		if (!buffer_uptodate(bh)) {
> -			ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &bh);
> -			wait_on_buffer(bh);
> -			if (!buffer_uptodate(bh))
> -				goto unlock_out;
> -		}
> +		if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
> +			goto unlock_out;
>  		if (gfs2_is_jdata(ip))
>  			gfs2_trans_add_data(ip->i_gl, bh);
>  		else
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
