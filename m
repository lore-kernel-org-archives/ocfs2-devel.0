Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF95ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 10:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6CU7pGLBRV0lI3u1SItijPhbgYhrCUNiCCL5djmoStE=;
 b=1Zmp+z2fWPu3zNmYshZnfatFjHZX3PwwXnprvZG25UWAUvoam+PzWklgm83TAA956KUsz2psDqXn
   y1nEdCH0KFoIEd5xxgIWphZGIYW+UlRlVurB2NJVvYk7lHYUzMM5/iDADjxFKii0vFp/4UDBGFKM
   W7mouGVm0usdtzsHbc2XSbOwVXPyhpu2JLFdg5TNXCI9/eJxj8fxv68F16FemzhDyVwn+AZZyYLA
   oLEn6wYoLKZunr0pgaaJNpWwVDd1mhhHSagho/lcdMQZzoKPQtNmDDPhs0v3pFt42b9bnT8unKjG
   RpZoahJUnSP/edT7YMenUXDO+Pzrq1WD4awJng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6CU7pGLBRV0lI3u1SItijPhbgYhrCUNiCCL5djmoStE=;
 b=JcXUiJnRgjuwAWEzjyU840LPyP/U0Kp8GVhKvyP+3HNGj7ReTb4a8hzbdmiRXnNqrfLcCyQUVOhL
   +mNFKc4iPEeslIeOZFrkRui72wuF3ycWtMxUZAlczFilFe9MMrsej7dhMdwDFYgOGH/YLhOMFkC+
   GbfEHktEYqjyDXY+wyRG/8gLRdeUfub4z39Ih07MVKqvl5Zo9nOeSIE2fJqGzrIOfQaavt3UNcUG
   o1SoK3QCKKqn79j0VNq53gCvpopnyGmDkWlh5i5+AtcnGRxOq0VgKzCekVtUJOP9D2EWVdatfA/H
   spukiot9UD3JXH4AI7nKx8K9ktIXX/4EqBFFHw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH000Y17UBKL50@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 10:58:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943525;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HxNI+0U0e7Zv/ZQHFt2fp30OwTNw2GytjeLFyfJkdIU=;
 b=1Rkdwb83KNKvKUChKM30xnpI9fdc070PjGzSDpFKJ9pFkPivo3n7huQ5Y/108sFshlV/X6
 zFQjUao1mx5Qt3nEwSLNw0PDPgLJ5OR8RlVkGyMOYxBCGErOztR/lcxLLJbzroBtOHQY2o
 lrUNBRNdwYPfqFM+YuvV4im5BBN3Fao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943525;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HxNI+0U0e7Zv/ZQHFt2fp30OwTNw2GytjeLFyfJkdIU=;
 b=V7Ur8DkjErbMDQRtHW0w61RoZg4YjQhUNRZuOOsXbxACyBWNaFnCBi4IchRNFWWSX1ZoZf
 9yj5numh7SEw5EAA==
Date: Wed, 31 Aug 2022 12:58:45 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831105845.mwfkh2prb557ajyr@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-7-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-7-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=673 clxscore=165
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=120 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310054
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 06/14] jbd2: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: _UvgexGYiIOAWGd8DgPQbT1yM8b7kDzb
X-Proofpoint-GUID: _UvgexGYiIOAWGd8DgPQbT1yM8b7kDzb
Reporting-Meta:
 AAH3JjHg1QsB0ewMkzcY8pq6pNDxohtbLCDiet+d7tW30DLuO6QGlmuWHbJcBJND
 fitV0uJZ0BMTb73g4x+8Cg6JjKs0miO9TPNAYZQvVIUEwyDnviBITmkbBewNNbqG
 L/LM1SA4PQ/s1A8KzP9QJVFoWioFzc6Oz8iqabWxKlUoM2X/s90C4/Pr5P8RqWz1
 6YLJBYQ5ZE7RY1vFIb/vy7Ea7FPCue72JlukvbBk5qlFh7u384FTb0Vxn4JdFRkv
 M0/vWyHYDnn4E+hN93K5BqTWMgMeiSfJHdgQ/oWHnosNwDhESVZdpGZ0gSiCqdJM
 lW0qxFKe8psKhzqiChqFWwOJFq2vZwPgUaEjmdkGHwBiin9ii+kIdB6TFBhcWkCr
 JLNv7QU54ADACJs1zJC5ecbZ0t2tLKrIYaE50SVMPVVQnpMB2hrECXC8rQCKU4cM
 oTXjdQxPHwFaCAyKq+oihZz9rsl0v1oMXUNoiLCG0htfJTUna9eRQND5/vrg8sIQ
 XuiH51oq3D1EtJEEA9yIiarlB/dg2DDV8iYuKhXub4g=

On Wed 31-08-22 15:21:03, Zhang Yi wrote:
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
>  fs/jbd2/journal.c  |  7 +++----
>  fs/jbd2/recovery.c | 16 ++++++++++------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 6350d3857c89..5a903aae6aad 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1893,15 +1893,14 @@ static int journal_get_superblock(journal_t *journal)
>  {
>  	struct buffer_head *bh;
>  	journal_superblock_t *sb;
> -	int err = -EIO;
> +	int err;
>  
>  	bh = journal->j_sb_buffer;
>  
>  	J_ASSERT(bh != NULL);
>  	if (!buffer_uptodate(bh)) {
> -		ll_rw_block(REQ_OP_READ, 1, &bh);
> -		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh)) {
> +		err = bh_read(bh, 0);
> +		if (err) {
>  			printk(KERN_ERR
>  				"JBD2: IO error reading journal superblock\n");
>  			goto out;
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index f548479615c6..ee56a30b71cf 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -100,7 +100,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
>  		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
>  			bufs[nbufs++] = bh;
>  			if (nbufs == MAXBUF) {
> -				ll_rw_block(REQ_OP_READ, nbufs, bufs);
> +				bh_readahead_batch(bufs, nbufs, 0);
>  				journal_brelse_array(bufs, nbufs);
>  				nbufs = 0;
>  			}
> @@ -109,7 +109,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
>  	}
>  
>  	if (nbufs)
> -		ll_rw_block(REQ_OP_READ, nbufs, bufs);
> +		bh_readahead_batch(bufs, nbufs, 0);
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
