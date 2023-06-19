Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AB2EB64D9
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jun 2023 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B9XhMQVURJaI8UH3xMfhI5XOiQ3wVYEUU2+UGaeJ9Jw=;
 b=FbHiYZqfpK3/2RtsdF7nP+vVH+VbMPROm7EeOM4Qg0HuCn2ZvUJcbnwLt7jkF3IdIUsisHVZ+wMB
   wrh2PZ2j24KpxonOtsB7Z++pj4Kw4ic14prGrbisDqQFQ6DFnXLMEZl/tuNOzxaSMBTA98ZLcqU5
   V34P232IIe+YQxdlaHWUegkwCzQ4xp6ik94B0QpkuiXnwCfVYUD3tGHquAXCWwCinCVEtECzBtaq
   kXQ1FlJL2o0fXfX1lYSPlsvAYkZDrG6dlUR+/ehMY8LySNBBqqYk+0/Lt6uhjPns86ock1TtTFR6
   dMf4bp5dS9id5WBLxkPW03tuiPfwGMi8FqtG7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B9XhMQVURJaI8UH3xMfhI5XOiQ3wVYEUU2+UGaeJ9Jw=;
 b=tielmDgvDOvFqKevVdWQty6tfa3vmMd3Lr0drCxLTSe+ShkcW1lPhSv5D1GJrhv7hCKpsHhNKM0H
   EOxhw9dIKaMA3iZHXLE+qHYLMO5R1SzVgDcbTGgxwXadeamxIcD20Hz0v/4eet3Zkefk6PKkw9mk
   ulJi1JSEIFJ2MjQU2MF8tLuk0QXt7yjTeWRQMBz4atEsCHcZ0UMKQelvl8aWR7OXRavDSQX5fidr
   MnoF5muQMbZ1KTHhW4akWtlyCFSmcxKbEiZghP2TW4w9MAY6lQaQZQ4X7QMxSLGuPk5hcbDuyH9B
   lEtni070A4OJyEZKfrSEI3nt3uCG+jI6WB0LKw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH00BG2VMQ6F00@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 19 Jun 2023 09:56:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687168565;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hjSIn/gl7eGaq16iD3zKNds5FKdXaWAXy03foKwXdXA=;
 b=iyUnxx0G+hifGpfNQU1q/8CW0Z6azO7T88n3M4sjs6fb9UNJABk2dZjwuP+9Bm8w27gvgZ
 zjJ45j/aJK3nkuQKEO7GzkncTcsU4gJfhOZwO6NDDOIzkFYGufecw/J2Dv2KgNe9C/59SX
 fWulkdHPd58FHJiSEoHfTrbHatluQc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687168565;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hjSIn/gl7eGaq16iD3zKNds5FKdXaWAXy03foKwXdXA=;
 b=VjXJ8b32ZLLPMd2YU/s+D+sxyFhGw26RTgODDJZS82t5iIY52NEERkUnuP5HOE6HMbTXIw
 6LsvITHbDbJYI6Cw==
Date: Mon, 19 Jun 2023 11:56:04 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230619095604.uknf7uovnn2az2wu@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-3-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 priorityscore=120 impostorscore=0 clxscore=193
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=351 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190090
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/5] fs/buffer.c: convert
 block_commit_write to return void
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
X-Proofpoint-GUID: nYUz6wFk3rCuoM4uM-cIyKbuOqxQuSmZ
X-Proofpoint-ORIG-GUID: nYUz6wFk3rCuoM4uM-cIyKbuOqxQuSmZ
Reporting-Meta:
 AAECwKER7PrHS8NZxj0BNn69lpHvxk+CywDh5uWVzqDhZam/46tliCZcz1OCDrHa
 D1RXOBXLCifbI470YH3tF1/MQuL/McYw8mWgn49xwJmk0MpDqBkdUeekDBTZ5aYq
 qQMq4uc5tWgzBb93B4LG273jdh+6UJOmxDM0adcckjF3BIM7E2+lDxGaucX0HmlM
 ohqnHUahnL/pW9HG2lTCQCg4ID0H70KezecLA9STrVPFsfiZjm4lixrNNbmHvAj/
 +xgYK/KtLtCRS7xJf0wY6BlOnwvXON3gKHm2e7FDHqeE+RAyXUUR7IXhh9c7tw3k
 Bi6BYFeXG3VPGV5i6efCtilLmJckxpfJzkiN1gJv/tc/iBt8qR6io2dQMFmhT9KJ
 bu4URoHixnUnFdA64X6rAPjcfLcZyN5mW21EPlxt462DhBg+2rC+dcBMVNJDVT44
 SV/Y7EIdRx/auA2jR4MS7XqwR6UO2mqRgDgIOh/awaNhrwV3/7iVyHEqgxmYOiBP
 MqyCO/J6KHL0sYaM7wj+8hXBoz+hm1hklllypkNVnv4pxg==

On Sun 18-06-23 23:32:47, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> block_commit_write() always returns 0, this patch changes it to
> return void.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me but you'll need to reorder this patch at the end of the
patch series to avoid breaking compilation in the middle of the series.
Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c                 | 11 +++++------
>  include/linux/buffer_head.h |  2 +-
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b88bb7ec38be..fa09cf94f771 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2116,7 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
>  }
>  EXPORT_SYMBOL(__block_write_begin);
>  
> -int block_commit_write(struct page *page, unsigned int from, unsigned int to)
> +void block_commit_write(struct page *page, unsigned int from, unsigned int to)
>  {
>  	unsigned block_start, block_end;
>  	int partial = 0;
> @@ -2151,7 +2151,6 @@ int block_commit_write(struct page *page, unsigned int from, unsigned int to)
>  	 */
>  	if (!partial)
>  		SetPageUptodate(page);
> -	return 0;
>  }
>  EXPORT_SYMBOL(block_commit_write);
>  
> @@ -2577,11 +2576,11 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		end = PAGE_SIZE;
>  
>  	ret = __block_write_begin(page, 0, end, get_block);
> -	if (!ret)
> -		ret = block_commit_write(page, 0, end);
> -
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret))
>  		goto out_unlock;
> +
> +	block_commit_write(page, 0, end);
> +
>  	set_page_dirty(page);
>  	wait_for_stable_page(page);
>  	return 0;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 1520793c72da..873653d2f1aa 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -284,7 +284,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
>  			unsigned, struct page **, void **,
>  			get_block_t *, loff_t *);
>  int generic_cont_expand_simple(struct inode *inode, loff_t size);
> -int block_commit_write(struct page *page, unsigned from, unsigned to);
> +void block_commit_write(struct page *page, unsigned int from, unsigned int to);
>  int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  				get_block_t get_block);
>  /* Convert errno to return value from ->page_mkwrite() call */
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
