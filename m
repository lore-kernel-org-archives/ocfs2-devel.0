Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE75ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=51XTYv8VcAnFuVUWlkO+fWiaIAmpcTA2ciOuwvAaKT0=;
 b=MpX/plBDFV9vyiG+UmWbKxhHj9oslXPnXcagkvG97i3cK+a75LX6xmV4Vy53Y4BkP6JA9Px8fw+f
   Lobw4cCyVGzKBKExU1t+6EydGzbUd6qJZHNZ9uS+Iv+BURoi+aWjMRWDLwSsWlKRmHpUyQ2k/4Ps
   +8jwicvbUwupJvfQdjPR36BsKp5dQX6p4RTyoC5glZsI3eMlg9CZ41WSfk2NoEvwQo4lKDEhfUD6
   rHAIJ/DSVcB8+fS6wDxu+V/hqvzXsmvO4pGWYjXfj2A+mqA9RudDLJ2PYLA7guSTE36vCxl3z/xZ
   Xxq3BsgFRPMjqp4c/f+3pdt19QMjYhoYhaj6nQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=51XTYv8VcAnFuVUWlkO+fWiaIAmpcTA2ciOuwvAaKT0=;
 b=J+4WwsLbDYuol0M5fzGFXPx2mQ+sU+UwiS0HxxSGrWTkBiZSTb4CsplYb7gdEM7NZZ0V0CRHH1u9
   s/cCbONLco7OREW7glv1wyvinhZRbU+sB53yqR91DtdjqBZyozilI2qTkDMjNH/aBKfowtkRqtOw
   JjV9vjF13VtmdwhpfPkqYcPxvOGWYu4CiOVW6DVnc2CxgXxkRBMIXhRZAfqdsbDOb0WN4kM6cEOI
   YafDLEPqliUM7aTFXpAqzn2rbpHRrQYtiprKXtpjspGMye5kbgO6RiCRF/rczNdQcFmgFeC7EYJz
   vETbrZV9KkMZUjrBi+U8RaRFp6Ck7QlY3eGnrQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00E7SG412F10@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:52:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047556;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=q8YiT/4hwzXdCPEllSvmSZIP1os1aETg6NXJXjqiNLQ=;
 b=TLpk4ShhamaRL4KgNMoHEEhUn6Xc/7/VQ+0qhUMC/fEDGJcS2uL2TFP4zk+sewHUuOX6/R
 I8aKXWdJjiLgRa03S70GA9TeJSg0JubIAx6aYusSvpNG3XD7dozCrkU4bEmBJXAnNOpAfo
 1mo1ZgegfbwQy3PsGx0EtqxywkND9io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047556;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=q8YiT/4hwzXdCPEllSvmSZIP1os1aETg6NXJXjqiNLQ=;
 b=vqi1oY9XAS6f7xHgj0gG1kt2ZLSWqQcw6ydnfegz3HXi3vYh164/XPX0q4KSEVH0sKNtHp
 gL8CVMxOkD6OQnBw==
Date: Thu, 1 Sep 2022 17:52:35 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155235.4m3hrnxk65wbimco@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-10-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-10-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=180
 mlxscore=0 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=239
 mlxlogscore=407 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 09/14] reiserfs: replace ll_rw_block()
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
X-Proofpoint-GUID: s2caPzBgesnG_VRmvrcak3Slqwgz1Sdw
X-Proofpoint-ORIG-GUID: s2caPzBgesnG_VRmvrcak3Slqwgz1Sdw
Reporting-Meta:
 AAFhIL9osApPi7UksGXL1GQG+vidYEuoct09fcoEATI2HwVSW8p4UIhvnt6QMrC2
 cNDr13HVEPLSg7boejOUL/zi8yEZ0Q5/AFKZobQ8h3eZ/9VJSHAvy2qAxbiDAclb
 Qjn2JnuStKTx3zzne8/jIDNzRWfXPb3wIUKu8OZawcPWaUlcDj+1ZlE5wn/ewv02
 1mD5oWDp6ujwz26um3e4sg3QZy+bKRlvBSotBif9emacSmNpgpzKEECvTSlQQ8vP
 7oJp64tNpBk/rVgK7C/mwGrGqzYqw0lIDTiqu6lzWrXTFL+oeE+rc2tlXSc3F1tz
 xOMlbhS75iemJ2fCQEfkesq9o8wgIkNT4iHZ56E37u4cM6lgpKyeeuWLvV6emlHf
 cnCJrDC+kGfTYoDO508VtP9Bj/Az0sFeudIMyIMMXbTW2SO/OmshkbGeH7G0Cq/m
 6qnpnzceMOe4L0boye2f3CaSoAKakC/gNvSAfCOu7QzLn3U4Z+ybyDfhZoJvDfGu
 0SrolI4189NjuDyQqXOE7Of15LSQT5Z2atXmeixGmIFp

On Thu 01-09-22 21:35:00, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read/write path because it cannot
> guarantee that submitting read/write IO if the buffer has been locked.
> We could get false positive EIO after wait_on_buffer() in read path if
> the buffer has been locked by others. So stop using ll_rw_block() in
> reiserfs. We also switch to new bh_readahead_batch() helper for the
> buffer array readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>


Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/reiserfs/journal.c | 11 ++++++-----
>  fs/reiserfs/stree.c   |  4 ++--
>  fs/reiserfs/super.c   |  4 +---
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> index 94addfcefede..9f62da7471c9 100644
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -868,7 +868,7 @@ static int write_ordered_buffers(spinlock_t * lock,
>  		 */
>  		if (buffer_dirty(bh) && unlikely(bh->b_page->mapping == NULL)) {
>  			spin_unlock(lock);
> -			ll_rw_block(REQ_OP_WRITE, 1, &bh);
> +			write_dirty_buffer(bh, 0);
>  			spin_lock(lock);
>  		}
>  		put_bh(bh);
> @@ -1054,7 +1054,7 @@ static int flush_commit_list(struct super_block *s,
>  		if (tbh) {
>  			if (buffer_dirty(tbh)) {
>  		            depth = reiserfs_write_unlock_nested(s);
> -			    ll_rw_block(REQ_OP_WRITE, 1, &tbh);
> +			    write_dirty_buffer(tbh, 0);
>  			    reiserfs_write_lock_nested(s, depth);
>  			}
>  			put_bh(tbh) ;
> @@ -2240,7 +2240,7 @@ static int journal_read_transaction(struct super_block *sb,
>  		}
>  	}
>  	/* read in the log blocks, memcpy to the corresponding real block */
> -	ll_rw_block(REQ_OP_READ, get_desc_trans_len(desc), log_blocks);
> +	bh_read_batch(get_desc_trans_len(desc), log_blocks);
>  	for (i = 0; i < get_desc_trans_len(desc); i++) {
>  
>  		wait_on_buffer(log_blocks[i]);
> @@ -2342,10 +2342,11 @@ static struct buffer_head *reiserfs_breada(struct block_device *dev,
>  		} else
>  			bhlist[j++] = bh;
>  	}
> -	ll_rw_block(REQ_OP_READ, j, bhlist);
> +	bh = bhlist[0];
> +	bh_read_nowait(bh, 0);
> +	bh_readahead_batch(j - 1, &bhlist[1], 0);
>  	for (i = 1; i < j; i++)
>  		brelse(bhlist[i]);
> -	bh = bhlist[0];
>  	wait_on_buffer(bh);
>  	if (buffer_uptodate(bh))
>  		return bh;
> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
> index 9a293609a022..84c12a1947b2 100644
> --- a/fs/reiserfs/stree.c
> +++ b/fs/reiserfs/stree.c
> @@ -579,7 +579,7 @@ static int search_by_key_reada(struct super_block *s,
>  		if (!buffer_uptodate(bh[j])) {
>  			if (depth == -1)
>  				depth = reiserfs_write_unlock_nested(s);
> -			ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, bh + j);
> +			bh_readahead(bh[j], REQ_RAHEAD);
>  		}
>  		brelse(bh[j]);
>  	}
> @@ -685,7 +685,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,
>  			if (!buffer_uptodate(bh) && depth == -1)
>  				depth = reiserfs_write_unlock_nested(sb);
>  
> -			ll_rw_block(REQ_OP_READ, 1, &bh);
> +			bh_read_nowait(bh, 0);
>  			wait_on_buffer(bh);
>  
>  			if (depth != -1)
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index c88cd2ce0665..a5ffec0c7517 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -1702,9 +1702,7 @@ static int read_super_block(struct super_block *s, int offset)
>  /* after journal replay, reread all bitmap and super blocks */
>  static int reread_meta_blocks(struct super_block *s)
>  {
> -	ll_rw_block(REQ_OP_READ, 1, &SB_BUFFER_WITH_SB(s));
> -	wait_on_buffer(SB_BUFFER_WITH_SB(s));
> -	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
> +	if (bh_read(SB_BUFFER_WITH_SB(s), 0) < 0) {
>  		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
>  		return 1;
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
