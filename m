Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E28CECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rsNxC1ceFH5QJyZqmY2o3U4KR2vthQg8AkE4goMH2nk=;
 b=FnC6QIATWqHJZ+3qdlGyUkgTHojIycBkMhuVYV/EYdxDiEJEa1Yo2SvgB6MdqHzIeaomCIpWzei2
   1DNqq/6oHEAH4aTUVvKWuymvPRaOqFVKH0gbSvZnbMSpw8gj27DdVcdNIPhz/fS9BEnkd11olG/4
   TN3L5mCzlamerdEaRzfhyIcxKOGUTB1VZzN5TGGTJ40Xs2xrqGhYep7Utfp329M3ouPdpHTIjmdK
   1PFHrUcIotS3oTdT0U+5KMg6HZtLlP1ScY2/DqS4Lq8Xt+Qtqrze7ICGUwEY8TetfJBBELEVTzu9
   mXVULrNn22Cl2p/PopGYHHac90ZiEw7pdcoN7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rsNxC1ceFH5QJyZqmY2o3U4KR2vthQg8AkE4goMH2nk=;
 b=ivmic3iF36Vz3o4v6UZfhL7Oi1AKbXOZ+KVHMczJFiwYVHl9L7aCE/yTY8yziUU43Trhg871Sj38
   fpkUtxRN8rl7H6Y0npiCjQqPlj32OzeENQekXRpXJ7DZddf7gGX0aFXFv+OzPxgoipU9JYk2Euz7
   VNZ/kHER+eVY4GlvmDLYERJNQKqYTLY/dLmGq7/uSXlmAv2Ynqd5rls3JpiU1S6U+1/066y1Se62
   MMIZJMF0E4ioaFKUt9E/hNeu2jdTFQxIsWe8BXZ6Ou/leeJuYjdBbInBbjrlYhAxHfUpZrRPR67/
   cjmWeeJ5cXj/DE5ilawjSZ4c2p+pV2mykK190w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00LNCGG66SD0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 16:00:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047994;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZK4oZT3eX4MCCX8IazaYP0RSu4rfgk2J8j6ZUW7BNNQ=;
 b=E3nk9ZCJ+K7uP41n+0vRUy8iAPK5M8OOMb+p9FTE2tblF2YL8Ta9YBFkODTy/xWP/MgtZ3
 fGAK+0LXUnxizhLGJl2OLP1xWcEQRoEXjaAKeE1bn11JYsUtLmTVpXmDJC3Sw3DxyzRbC3
 ongtssh+hysa68Ajd6I7nQU1v6OuWCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047994;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZK4oZT3eX4MCCX8IazaYP0RSu4rfgk2J8j6ZUW7BNNQ=;
 b=YgVsMkTjvVYCKIhV6xfBz4gDRGLSOsQtRqfWaytR8J/zyWr/i8fWJx4b/q2uHHWjjSEmrZ
 bSuo9XE0F4M0evAA==
Date: Thu, 1 Sep 2022 17:59:54 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155954.4xwvu25bkhgz4uro@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=230 phishscore=0 lowpriorityscore=0
 clxscore=171 suspectscore=0 bulkscore=0 mlxlogscore=542 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 13/14] ext2: replace bh_submit_read()
 helper with bh_read_locked()
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
X-Proofpoint-ORIG-GUID: ty8Y0t_9C93xT5LqsZic61tZpt27XfcT
X-Proofpoint-GUID: ty8Y0t_9C93xT5LqsZic61tZpt27XfcT
Reporting-Meta:
 AAF55idWRfbxPozgKQ8TMIUHlDoYw8FeqJaVSOKzo6F8/PWC3EIgXdDEuV1xrAIb
 WQiHDn7HizP8/T/XB6zMnx7C43Runt2Zy2V3PbYPfzhFayFzszZvrsZpJA5y05q0
 GNrTlNJHcirXhGpd96wkph7rzA63Bq1qRddwR2fnuMSod4Q1TQ0U7U6mRTl703xJ
 p36chaRwjzklv2BBQxth2AgPDcqWp4QyoRf754FJnTrQKYCsYv006uOUTWZwT2K+
 XoB535pArdWfxnyxtOopS7q7dxF60j9CMhRqoIgoY3KlJ4TJ/Rb/VWx6RO9ukz6L
 WWTYVgZ5VZEyxs0CiXnej6YLIr1sPWbVSPUzLMZNI+EkwyMFatg9GDP5v9OPZ4Lj
 Rn59OfU/aVgfd0PNUeUvDaofb3YWMsP2H/jR7JXB3+BCcNddTa05YyHh+E2gaD1C
 b92hWdX9eFzc6tp0N4E9mg5V+JsIw06Fo8N1jydoujhtAmTZRMs90nq4A7xim9s7
 Y1HMNYjDwKzTK2h2oKn2jfoAuRMYGkAh6K5mpslTIA2S

On Thu 01-09-22 21:35:04, Zhang Yi wrote:
> bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
> has been integrated in bh_read() helper, so switch to use it directly.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/balloc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index c17ccc19b938..5dc0a31f4a08 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -126,6 +126,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  	struct ext2_group_desc * desc;
>  	struct buffer_head * bh = NULL;
>  	ext2_fsblk_t bitmap_blk;
> +	int ret;
>  
>  	desc = ext2_get_group_desc(sb, block_group, NULL);
>  	if (!desc)
> @@ -139,10 +140,10 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  			    block_group, le32_to_cpu(desc->bg_block_bitmap));
>  		return NULL;
>  	}
> -	if (likely(bh_uptodate_or_lock(bh)))
> +	ret = bh_read(bh, 0);
> +	if (ret > 0)
>  		return bh;
> -
> -	if (bh_submit_read(bh) < 0) {
> +	if (ret < 0) {
>  		brelse(bh);
>  		ext2_error(sb, __func__,
>  			    "Cannot read block bitmap - "
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
