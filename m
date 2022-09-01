Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC660ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mPDwV6jD1T1EipBZnSk3cm7DmkXUNvXFzc2JYd1s1SQ=;
 b=ILuRltIRkrKG7iuqGwo4TEXY0QRhD5L1yJeTUf22L3lVU1KH6Z7d1495AxcyrdmvcTpoDWtadUBD
   IPVxuXzLp79SbwqsMiMSdYkYqKSouUGtklUedXhbQH4PUZNlC/4xqhSmYbxEJWT+/0w1DxTFtlBC
   5aZ/m7bUBtEYBiJfqA4AMrQ0GzBOU9+Tfw9LYw/Fnh2UgXtYbv5BP2ZieQ4Qk3ZBv+7tIVlNS6jh
   +P8xPYvm1SwwyJvEj7KYlASswm6gVVClru3qJIHX4332HLNAPsKwCK4g97G0GMmGI8DpqfdIxJfX
   BMgiLHSo95WmiKU50nezVzIilQpysDsOpyub9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mPDwV6jD1T1EipBZnSk3cm7DmkXUNvXFzc2JYd1s1SQ=;
 b=c4Bue9D2sFSog9U+0TYU9afxL3nQ+qlEYwOV4du+rQUJ3lrer8OgM9ZNzo+UKxnWHAtGnPziAvK/
   V2j+vb5GAh4CbT5I9E/TJSclLkxgVsOLBGH/FQw/0b1BStPCaaYsdvAq6tqXKOrNWAvbxzAZnSn8
   o82ugwjCBxBunvXTuhhBy+2VOyqM5kQUOQCitL7GeAtvwjL+LM0FbFZeiWOAlchQrtqEA5mhZduc
   l6YQYlPhZgmHe4qFY0BYEUR0wqhcf6rewskOsz2fbDLFRLFktRjtcOfQYSbSCyQZBsQR+tdIMMWJ
   LdpybTAjMvQWTY5NN5Icdi+iIDKAmLyvKtsShg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00C4BFZXMUA0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:50:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047407;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bXMDzUM1+Lt+ZSThjbm8wHTNDhe4lR0BR+Ul6jNDnQY=;
 b=r2VkLAGYBaA3EXSjbYzVFWa0a3q9G3jNT1VA5Q5q+PLMIplLvHZYU+J/o0bDa6fTlrv/4E
 kPIsESDfM8PcjgIFbTcUev0LSzfC73s2/3CVX0KwWrtKBCitp4Fua7WdH5LeQxrH6dGF9x
 s2DuS2A42c0kFwgmPfLC9xQ5x0uEShQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047407;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bXMDzUM1+Lt+ZSThjbm8wHTNDhe4lR0BR+Ul6jNDnQY=;
 b=9e+lUWyXfrhZq9IsidiFG7B+edpO4waAl3VP49sIY2S+GyZpK13iobmYheYlScUM9tNFam
 S3fvNh+6dnywIXCw==
Date: Thu, 1 Sep 2022 17:50:07 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155007.nelecqohvd4plqqy@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-7-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-7-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 adultscore=0 mlxlogscore=685 mlxscore=0 bulkscore=0 spamscore=0 clxscore=180
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=222
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 06/14] jbd2: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: vC0nrWh3OScxBw-Z4UmRg3haalSQj2Ju
X-Proofpoint-GUID: vC0nrWh3OScxBw-Z4UmRg3haalSQj2Ju
Reporting-Meta:
 AAG2PgX2LJ4NDKl48Ua6u1yId5BXvou5qdhDKF40KF7WTUvbpcXK7fFZkMnNoNWk
 4w+yJsLiBE2j4IG+e8a65YYsBh3LRUfDSLwUli1CiIqDdpxOtRJ0YsOfNm81W7OJ
 /ARol/6yXfrqne8sVCr00o6vPGvI3NvjWABTNIeQm+4Uf5S9FtZ5EFLlgaIt8Lha
 R9xVzHV8lI30LJ2W4T330SiFvZ5y3V4CEDCvaGWNUj+MTuZdQ8vIGzwyrcDdJdb3
 y133uPIvWnhAYRdQ2JURdfNfbQPMoOz0Ig657EjnA2gfiAZeVPW3xUvSk95mc+TX
 7RNZnq1kOkiwzQgBDPO98PX5A4v+MHzUgt9JIq4ISJj95o0POymjdsLIkS1Z8Zae
 MbJ0m07l1i+ApCDM0KcFr9V08PUCMct3osTjtPOEC6HYXsFEeqwosh2xWQAZg4il
 DKxqHJETAFtO1pZ27tWdYCRhAIMxhywoUyswhtf0Rd6iUX7eMBSWC0/R/WQuQgwD
 esELLywz6pdKqkd59Itj6d2NHSkMRH8cQQPbdeCv0Q1b

On Thu 01-09-22 21:34:57, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in
> journal_get_superblock(). We also switch to new bh_readahead_batch()
> for the buffer array readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c  | 15 ++++++---------
>  fs/jbd2/recovery.c | 16 ++++++++++------
>  2 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 6350d3857c89..140b070471c0 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1893,19 +1893,16 @@ static int journal_get_superblock(journal_t *journal)
>  {
>  	struct buffer_head *bh;
>  	journal_superblock_t *sb;
> -	int err = -EIO;
> +	int err;
>  
>  	bh = journal->j_sb_buffer;
>  
>  	J_ASSERT(bh != NULL);
> -	if (!buffer_uptodate(bh)) {
> -		ll_rw_block(REQ_OP_READ, 1, &bh);
> -		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh)) {
> -			printk(KERN_ERR
> -				"JBD2: IO error reading journal superblock\n");
> -			goto out;
> -		}
> +	err = bh_read(bh, 0);
> +	if (err < 0) {
> +		printk(KERN_ERR
> +			"JBD2: IO error reading journal superblock\n");
> +		goto out;
>  	}
>  
>  	if (buffer_verified(bh))
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index f548479615c6..1f878c315b03 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -100,7 +100,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
>  		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
>  			bufs[nbufs++] = bh;
>  			if (nbufs == MAXBUF) {
> -				ll_rw_block(REQ_OP_READ, nbufs, bufs);
> +				bh_readahead_batch(nbufs, bufs, 0);
>  				journal_brelse_array(bufs, nbufs);
>  				nbufs = 0;
>  			}
> @@ -109,7 +109,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
>  	}
>  
>  	if (nbufs)
> -		ll_rw_block(REQ_OP_READ, nbufs, bufs);
> +		bh_readahead_batch(nbufs, bufs, 0);
>  	err = 0;
>  
>  failed:
> @@ -152,9 +152,14 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
>  		return -ENOMEM;
>  
>  	if (!buffer_uptodate(bh)) {
> -		/* If this is a brand new buffer, start readahead.
> -                   Otherwise, we assume we are already reading it.  */
> -		if (!buffer_req(bh))
> +		/*
> +		 * If this is a brand new buffer, start readahead.
> +		 * Otherwise, we assume we are already reading it.
> +		 */
> +		bool need_readahead = !buffer_req(bh);
> +
> +		bh_read_nowait(bh, 0);
> +		if (need_readahead)
>  			do_readahead(journal, offset);
>  		wait_on_buffer(bh);
>  	}
> @@ -687,7 +692,6 @@ static int do_one_pass(journal_t *journal,
>  					mark_buffer_dirty(nbh);
>  					BUFFER_TRACE(nbh, "marking uptodate");
>  					++info->nr_replays;
> -					/* ll_rw_block(WRITE, 1, &nbh); */
>  					unlock_buffer(nbh);
>  					brelse(obh);
>  					brelse(nbh);
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
