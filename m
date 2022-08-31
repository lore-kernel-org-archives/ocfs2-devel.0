Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E47FECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eIW7Iz3g8WqXSKIYPTriBtFWeOqEXRuiq78pwb69dKM=;
 b=Uw/1SjEs2RdIPp31HYnjvOKgKDR7DVyUIv94Z0FGI8zYdsD+wCybNEXORTE43YqBUndaaHbw/6JH
   h4JChwfRKAP5cNPB0ZAWYRcascC//iiylnrY2uNxp0pUQM3MgsdanSWgYn9/wcsaxyV9KgEug0iG
   2/CKbc9bp91F8Fk0lUAnPOO5FfktHWWX3gtJ38LsRLkUHGfCWvXcr13qD9+jhLGjrLqZWHjNXvgg
   br4Y/gsz5+BzDqTZMjjlmoFGmg9NB5drTLWXQyC3kv7u9g+xt3vH/ppnjLN064KV4QFvAhGS+Zam
   v2a/pUNcfhaUOYFE533BNFTewEfUryCc4U98SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eIW7Iz3g8WqXSKIYPTriBtFWeOqEXRuiq78pwb69dKM=;
 b=YQ7TtkoSDGvHvP0/OoP8lehhv0UnaHuG99uQiNuXIgrfb0u0pRs++9lfx2MRhchmAm4HnF0+oCAW
   T6t3lI8iJYJlD10Q+e7raEQDKzGGacd3SeGHghufvPrqiYtusCBdl8CaqiGiWqYjRwZIF7666QYW
   mrQQ4nf/DklY05KUZA9TLKoOU7L1bvJKg68RSWbWwpW5E2IMAje7BHlADisZSwvKaMmnqyTwBwPN
   LsDRAtkQ3piuQ2OjNmcoZ0Z2wjo5IkXCBM4czn+kGI1qvCqcsgE2ukWbgbOjXZ1X571+/eBcrUJE
   T/9elO2W5TLlYaY9O3OpeaZfFS+io1JO1kRCmQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00BTW85UDZ10@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:05:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943941;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wjFNeuDmnSdi4atjC35RmIYpin0KTe8MFHXFLhg136I=;
 b=eh/mtM7OvdKM100QKHqjnEnIeTvSh7jPvX6F39ozEjvde8Dd+ndhdMppBWba/sJ1tnzFdf
 ewlMfhj5VaCXrOBwKGzIXCxnxFIrtVFY4CivK/tntKqVIuBTKX4Zo2E2eFXyxxJABECRKz
 Lgneaa/EaYURl2bbQylWiSQIGnw4t/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943941;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wjFNeuDmnSdi4atjC35RmIYpin0KTe8MFHXFLhg136I=;
 b=/X6EjebPK/nXjdXs0OkjNJJCQa9lrq6MrM4FOvrkmtBBl0K4x7HHQHNTru+hzyjfCCPSAp
 cFjSgDUKZJqweqBA==
Date: Wed, 31 Aug 2022 13:05:41 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831110541.gq4pqyb2b2kc5avt@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-11-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-11-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=462 impostorscore=0 lowpriorityscore=0 priorityscore=173
 adultscore=0 phishscore=0 clxscore=171 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310055
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 10/14] udf: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: HNZUi8vDPnOqNwk8tDsfQGxrfyQ98Mlk
X-Proofpoint-GUID: HNZUi8vDPnOqNwk8tDsfQGxrfyQ98Mlk
Reporting-Meta:
 AAGQFvKx+XiQyPyh/dvZbMlb7fLwp46eNiHZ5bn9YiirTVluXT13PrvMJGEIMGGT
 3pBwA9Z2R1swzkOzct0+g0KtSpl5SQhe4nfoTTONIKJmCR37zl39Em70fqKWZ72h
 FtOLZ17FsE47vZKh787eM8V+doh1Dzxe0rkD54BxQYI3ddNMP9c1kTWv4XnmJXCZ
 HhFECKDrW1um6XQKpq2w7CVDORxoWdWyCTcVfInckgCguYT5l6wXXZbZ6xs2sEZZ
 BhUonkMG37s/RiHqmWyTrLtMyfaBAEHD4HPK31JKj3gMuaoAwnbYYWC6Cj7gQkzl
 nqV3Gk7e8jQyYk/jBVnOOIVYqEPu1ltZjzhYqWZ4VbpzztH0wB46shoLNHWqXB9Z
 +Luug4X0AFDw6e/M6ysjZ50Iz+wnFSoEWA+H/kZk4N3nQg1HDwWq025mKMx/Hv3M
 brdNHIybtvNXWSqlCbpdDcpo2P5DfVzMc1Oen34ApwTHEPU9sgo6pG5F8iANFpu+
 Wu7WHIvY6j8axNXb0EEdHUr5hon2LDBoEe5sMIgF7n1h

On Wed 31-08-22 15:21:07, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block(). We also switch to
> new bh_readahead_batch() helper for the buffer array readahead path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/dir.c       | 2 +-
>  fs/udf/directory.c | 2 +-
>  fs/udf/inode.c     | 5 +----
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index cad3772f9dbe..15a98aa33aa8 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -130,7 +130,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
>  					brelse(tmp);
>  			}
>  			if (num) {
> -				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
> +				bh_readahead_batch(bha, num, REQ_RAHEAD);
>  				for (i = 0; i < num; i++)
>  					brelse(bha[i]);
>  			}
> diff --git a/fs/udf/directory.c b/fs/udf/directory.c
> index a2adf6293093..469bc22d6bff 100644
> --- a/fs/udf/directory.c
> +++ b/fs/udf/directory.c
> @@ -89,7 +89,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
>  					brelse(tmp);
>  			}
>  			if (num) {
> -				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
> +				bh_readahead_batch(bha, num, REQ_RAHEAD);
>  				for (i = 0; i < num; i++)
>  					brelse(bha[i]);
>  			}
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 8d06daed549f..0971f09d20fc 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1214,10 +1214,7 @@ struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
>  	if (buffer_uptodate(bh))
>  		return bh;
>  
> -	ll_rw_block(REQ_OP_READ, 1, &bh);
> -
> -	wait_on_buffer(bh);
> -	if (buffer_uptodate(bh))
> +	if (!bh_read(bh, 0))
>  		return bh;
>  
>  	brelse(bh);
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
