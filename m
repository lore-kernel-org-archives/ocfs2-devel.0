Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2572ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RyQH8qNv5biZ9DsU7Asya0IOBL8vV/LnI0GIol9r5z0=;
 b=ZK8qRm5vJqWMJjQ6QLD0BEKpsAgVMcv8Gt2vYPq9Vu0K2m0RjwsvrpzmZFZdAp2iHVJW5DGtBi+e
   HckwwJApHF+od/aUX9E728EUkI2QT7jEbogVkurqz9OmbmKXJUIsdJ00fm875VXL+ICQaPqVtFDM
   1JRNNWFhB1+c4v+3yNjm9Ehn68A3DyVhfHtUnfyiVjtnna2HQi7aIGX1euYxF8Zko7Y0zw32UsQb
   /LGVbGNEE6o4EdovFI1aNrRp7GwEpEWoMk8G2g16oZ2CFk7J0SVAp8ddQMfZATcScEfKO9i0VYMP
   UzLjZljrAYlGj268niBVT8M87d/+26pLfGDf7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RyQH8qNv5biZ9DsU7Asya0IOBL8vV/LnI0GIol9r5z0=;
 b=f3wyqSgMlqw9L83uRIgcnPbUN0TR3GOukBK+MN18UJ9cg8sBvEer+wo9k3LO57+HUogCNKpR878U
   b0a1+9c9UGYUTHccohSQHHddWtVkhC04AY7Juf51SjB+nPSAwn7RYViqRJlKuHZWJ3q08+Oo2rxH
   eaj0pQL/Y8un94Pw+woYd4bukCpjx8+e+9lMQvfzJPFEPWwot+YBPRStYSCuz5l5SjxEdFFv88Qx
   FTib5RiV/puerJrlkG8htp42UKSFw5IahVKWS+b4q1+cPsZukaPSY/GmHoIkyBq7hb7rtdDInhSZ
   478UdavYMu5nD3si/Lmxdm9hk3ZYBvcxdNhxTA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00BFN8NJML60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:16:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661944574;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MRx8k6tf8EVQNjQIGFIame1sUsAVK8et6tEwceGHhl8=;
 b=fcAZulnTmQlOSJvI1I+O69n65WHnKJQoTQni0s3w0evX2OjfFfA1lUD3THM8aQ6sZy6buX
 sUI1QMIH53X9RNqtvnDe+cg+u3DjTpdXbtH3rf89ToZFCL1len1mAcbiGYQD+0jv4AkOLs
 uiCCa9V5KYewjz5kRySfD3uPQiNEd4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661944574;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MRx8k6tf8EVQNjQIGFIame1sUsAVK8et6tEwceGHhl8=;
 b=nwJRLnbywsNsLJBX+JGxDAcgG32zFks8rfoSXE7B10XV49QHCPI6z6DuG9+e4PJVIjbxaD
 BGMQPW8vEnBKu8Bw==
Date: Wed, 31 Aug 2022 13:16:14 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831111614.z5pfchnj5mzqug6s@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-15-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-15-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=171
 mlxscore=0 malwarescore=0 phishscore=0 mlxlogscore=561 priorityscore=233
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310056
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 14/14] fs/buffer: remove bh_submit_read()
	helper
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
X-Proofpoint-ORIG-GUID: J2VzKHInWWVPbVYQ5IrH-53XENnzuIoS
X-Proofpoint-GUID: J2VzKHInWWVPbVYQ5IrH-53XENnzuIoS
Reporting-Meta:
 AAF+4IQWEwwoLdoJS98mKMXemR+qHhzdL1ropj1T8wFeuMkAdXHtENUStOLFU2U0
 GpH+60JZ2vByvvDpdYcfkIsdlB+FLpYNZ3TdDtGcwyP6RsP4nkY+CvSc4S3V680/
 S1iYOvZXROovVTD83jJetAlGZWkM/YvT7oDEBUAKnerswFcUqWzBHGoNXlfM/fLr
 yEC+LrTUwiLms89DbPr6LIhWG2RdfzkeOH3fKTjNZc1QCKy2r4AJDlDEiiAp9HPx
 7kczoOwBndMEXafzVokrADVWNUMC8RvcvNWJ10kN1FmkWvYg+qbVnaiK0/tZwRrI
 OtrDcK7urcDyIAMfglmxyqflCL4mtlkqJ//xcCXbO/Y/QnepzpL8xrtYjEb8mevs
 JiDu4Y6gzlY7jOokbRSQXGU4l9n5y+rs/vN1ZMWbWi6W92AjnMwpmYSBLjqy21JV
 JDT+ou7T1bE9m6HslvbYbYWlm0PTJwu9jpOpaejawT4yoNfcXdlwbxZWA6VNqahC
 tfagZ4YHIBh6D20KyT2Jdtgn44PId74bS6X07ZkAybX9

On Wed 31-08-22 15:21:11, Zhang Yi wrote:
> bh_submit_read() has no user anymore, just remove it.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c                 | 25 -------------------------
>  include/linux/buffer_head.h |  1 -
>  2 files changed, 26 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index d1d09e2dacc2..fa7c2dbcef4c 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3029,31 +3029,6 @@ void __bh_read_batch(struct buffer_head *bhs[],
>  }
>  EXPORT_SYMBOL(__bh_read_batch);
>  
> -/**
> - * bh_submit_read - Submit a locked buffer for reading
> - * @bh: struct buffer_head
> - *
> - * Returns zero on success and -EIO on error.
> - */
> -int bh_submit_read(struct buffer_head *bh)
> -{
> -	BUG_ON(!buffer_locked(bh));
> -
> -	if (buffer_uptodate(bh)) {
> -		unlock_buffer(bh);
> -		return 0;
> -	}
> -
> -	get_bh(bh);
> -	bh->b_end_io = end_buffer_read_sync;
> -	submit_bh(REQ_OP_READ, bh);
> -	wait_on_buffer(bh);
> -	if (buffer_uptodate(bh))
> -		return 0;
> -	return -EIO;
> -}
> -EXPORT_SYMBOL(bh_submit_read);
> -
>  void __init buffer_init(void)
>  {
>  	unsigned long nrpages;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 1c93ff8c8f51..576f3609ac4e 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -230,7 +230,6 @@ int submit_bh(blk_opf_t, struct buffer_head *);
>  void write_boundary_block(struct block_device *bdev,
>  			sector_t bblock, unsigned blocksize);
>  int bh_uptodate_or_lock(struct buffer_head *bh);
> -int bh_submit_read(struct buffer_head *bh);
>  int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
>  void __bh_read_batch(struct buffer_head *bhs[],
>  		     int nr, blk_opf_t op_flags, bool force_lock);
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
