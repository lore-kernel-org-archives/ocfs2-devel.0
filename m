Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933DBECAAD5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ktuk8/KMJW3d5TnlWb8s8u8DRwj3b+JwedrYbl8HYCo=;
 b=C/lyMzAihj4nXAdqY9sKwLPhz9ONKUkaM5fjC+OVBIxT8M2LvwDevS0g+6hMRZEmubSA9SlGbiqs
   wry2Sz4nnFe+6lU/UWyi5BU3XbkWkJXexamJ6cFmVgB6WeVOu9HVlFIk56Wj4WjzH8dX1/W6GTrQ
   RBrdS4UVZzyMRvC7LW3XPqV6IqL8wuFwuH73qKAmCnVoQ1RtKfyYstzkuMl5VXwvHNBm8WC1HJvR
   NqGlZOiBgNPwIeaWPsGKbDKkZkOIMsTSq/WwHAM9M7vsrVHe4Xo1CRqdUzq+rA9r/OpYAYZXNL0U
   qgrGxTIUikwD15pG2aRjNViRflwOGPmjYOm2kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ktuk8/KMJW3d5TnlWb8s8u8DRwj3b+JwedrYbl8HYCo=;
 b=rlg0gpFu0sKMuAQR5hdGYTzXXx69lVF8E2URAXfqPV+xmfBUFabl0StKdS23aKULuJoBiYB7iFNo
   FwoSGW0DMGSIyLBYD1sHu6lD/HQfa1FdFsKKYO4akGtA26IU0gTbpF2MQMkUbGKHBYehk4PZmf2K
   5+yi5h3Eg1o/U7h04s71gdCxxjhf+NqB1+6G2k0efxbo3P8eD+Go9EZI0xRwvurM81NjhP3XjIeC
   lg9dABAPvurJRnhC2uj9RkanI55ZRVjgBzsgJBPwqJKPMOS6WdddleANcX7lvrSmV0BcrJDRDddL
   TOUAQMD7knayvR20cjdSIK5jsri2bUtZ93KOCg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00I9X84FPMD0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:05:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943888;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7rUfy2mjgKSZvW8Hv+C3XQ3MWeegbpsZkXWtmcFePxA=;
 b=cN2bfJUKQAFYmP5lfcBq7Xllkrj98P3EGVrNed2TEDWPt+4B+jNWMWMPYksfasqywozxQl
 mL8EMZ6a66b5xJbd4UlfD2MNL6uTjYXxHO/9CYo89r7wcfHQeaKVaHhcVHojSU+ksOT0kk
 +7K2U+exV2KwTs7YfMEcA1DAIvKh6uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943888;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7rUfy2mjgKSZvW8Hv+C3XQ3MWeegbpsZkXWtmcFePxA=;
 b=IfQPklv0XIl0V4DwmvZuLeaWytRl8KT5euyQIi2kPBMZ6NVEGmXYMwS1+tudUmennmbg5a
 OAGjG2rZvG7tIWCQ==
Date: Wed, 31 Aug 2022 13:04:47 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831110447.4qm5cme3kenfa5cd@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-10-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-10-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 priorityscore=190 lowpriorityscore=0 mlxlogscore=406 spamscore=0
 clxscore=177 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208310055
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 09/14] reiserfs: replace ll_rw_block()
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
X-Proofpoint-GUID: K5pvXT3bRmhhKa-CukNniZeGDzfyj4VS
X-Proofpoint-ORIG-GUID: K5pvXT3bRmhhKa-CukNniZeGDzfyj4VS
Reporting-Meta:
 AAF+4IQWEwwoLdoJS98mKMXemR+qHhzdL1ropj1T8wFeuMkAdXHtENUStOLFU2U0
 GpH+60JZ2vByvvDpdYcUj4sdlB+FLpYNZ3TCvFfg6Ys+v2jW2DUT7hQTvuShLRU3
 Rg+jPzxWbS9um9iapQ4k/+/CYk7xQPfaf8cpfKNIe0WJMFU8IWX5stj83oU6Jaov
 cDQOsxGbgkTRIU7wAQ+QqMXKLPoFCWSkuOx/qPRN42a0FU8ICdp43s0+poweY9Ud
 hpFJEDTi1N0qobpBfybTltpQ8hxoxZNxs8+icwdpVHkNSASG2SVDQKVH1pXFWrC4
 dkWYBUghnibKmbNaDYd/gU3ZoSq/XsQxXHXp84jaYHWkEHOw8hRJ8qvDDd0NkEIp
 yYdVmndEbKMN5cysRtMMBr/L0fSD1HSIYFg9YSh6HOXtz4x5SneMXtGTCewL5D6Z
 5+CBFT6gfQxGh/kmopaTNBeehj+jGjudpKh5ww52j4o75Ow5dR4rkerDWqusDNO+
 nhP27irH+smvpKN1j5xNZFaQHKCkpdLqQDflDSGDQFer

On Wed 31-08-22 15:21:06, Zhang Yi wrote:
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
> index 94addfcefede..699b1b8d5b73 100644
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
> +	bh_read_batch(log_blocks, get_desc_trans_len(desc));
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
> +	bh_readahead_batch(&bhlist[1], j - 1, 0);
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
> index c88cd2ce0665..8b1db82b6949 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -1702,9 +1702,7 @@ static int read_super_block(struct super_block *s, int offset)
>  /* after journal replay, reread all bitmap and super blocks */
>  static int reread_meta_blocks(struct super_block *s)
>  {
> -	ll_rw_block(REQ_OP_READ, 1, &SB_BUFFER_WITH_SB(s));
> -	wait_on_buffer(SB_BUFFER_WITH_SB(s));
> -	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
> +	if (bh_read(SB_BUFFER_WITH_SB(s), 0)) {
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
