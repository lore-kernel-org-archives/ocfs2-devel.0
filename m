Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAA4EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jun 2023 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VSnXzWgzVOl7LpA2oNUl0ALeAyETT+EGVzsclk2m8aM=;
 b=EkEXOgyDYQp5F2ji8eilCiw49aT4Nh7ktSAq1tbwDWeiHgdyo9Mw09GWIJW4NI3bE0riLUhhhY55
   OZzh9IrhD+Xd80RLDHRI3SajlXzibLJtAh2PJUpLNqPLduULWsuA7bLCYn9HOb/+EmFtvLXv0T0c
   EkocXB5rVyBdvLuEIYSmIjL+bTLjReXphWLAtORZuY1Xvhn7kQUqk0trDTOY2LMJVUGf+I744pxl
   VZZonnJGEnyxIk54UoAJs3Hk/KsTocc6uRFFei1lndVBeMgXviBx5Pju0DgTo1qtNuLEzt3av8Gc
   i7QdcXV8ioprdne5g1b3CtdP0t9duPiorMEOBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VSnXzWgzVOl7LpA2oNUl0ALeAyETT+EGVzsclk2m8aM=;
 b=iz855wzX5xrX0Fg9fnoEMkCzgXK8hmyl9lrAnWKiRmmVPa4f9DnFhj0ixCGulx98ApYoBDdDKRHD
   SeVRSd3H+0kyWSpAvTafZ9lPm5rmE/DzYwPtvHuys/iafeP5cBk6OKdRAAbB5EUldyBxcXegpCRa
   bcPDAlmAQ2+YrU0ZZpaJq7QYNRxXx1ZcBvAUjItYlWMTNDjUBSM3mhoLLsWhv1x4gAo3P8+t+g5p
   d1RCdpOAvSQAt4RdI/fC/cl/shex4Snh+WORCm7VKngnYxUn/3EURw65V7WqWhmEiEqhdRqLWq8n
   /Lux41NXcRRkWQOK5hLXGeURwOSFl4JFbnRapg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH004EHVFZFHB0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 19 Jun 2023 09:52:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687168351;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DxIJDuuYClXmgqYM4N1lEgYI6VAbXG1zZ254H2n4+qw=;
 b=cfNES0tRgRt0IZv0nqHW23+HqATlwNpQKXeKBshiiYxpUWvkGCDRZ+Xv/27M4Oas5e7Am3
 SGaDzkXL1/aWl/XjXWpwAP3yJUyAa0getdW6KZzTkY31VyFlS0WWeYjvFZdOrGyi4BJ6js
 Kqe0majp2iBdXrYARIc++DT8QhLXOBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687168351;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DxIJDuuYClXmgqYM4N1lEgYI6VAbXG1zZ254H2n4+qw=;
 b=7kExUx51RD0vHom4H8oJKaZpf32mIjedU88Fjzph254nHGLgby4ShOkk2dzXoePKpxwLt0
 kRtpzEJMEkigAKDw==
Date: Mon, 19 Jun 2023 11:52:30 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230619095230.undchckir57stooe@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-2-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=397 lowpriorityscore=0 suspectscore=0
 bulkscore=0 clxscore=224 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306190089
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 1/5] fs/buffer: clean up	block_commit_write
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
X-Proofpoint-GUID: 9uSZySrE4y_vMAAn4aMKxStk6l6PyivW
X-Proofpoint-ORIG-GUID: 9uSZySrE4y_vMAAn4aMKxStk6l6PyivW
Reporting-Meta:
 AAEHk3+ysrEGrnm8piARytKPO1QsYGxbE9beoPDw5u6Ags5T7RHNqY8mqNm9+zRz
 9e1jTUA8qONduiF+QWI7B1zFE75mSGDLwJpKchELKUajs5THHAlgdLqnh3MzlJ+f
 II7sKv87KxfoV2gz+FKj9Mo+dkI1wNav33h7SVHuZh3B0XFGz4/sQT5cLgwpHOUp
 7My/X8KQCB7MmvVQhZUasdvcJgev5xcc9F2je9cA2NeaoU5Ws9W70xKyf3OWbJIg
 S8jQRlrk3aNaBlZGPhBl+sYa02BPXg/8IKkLG7qCear6GUvjoFqTyC6oRNARAn7N
 f5HiIRmI//W9X9zf6bvLbMidLghFBiFyyrDQvh6N88VmpjpYDXISvBITuDCbTQHB
 il0lXRYOhlF2akbtYemAXtZtjh3CAjJl4pSrzGFVeByRDeddf85kNGlOueDdPeRb
 GK3OVShZwGShGA7GVXLhsu0JCwEAZjcQxzjdc5rwdh2FCXKeJ9yxM87HcXOcFSMb
 YBMxhJpwsat8/DWO9EZVc5YWhUv/cNWd3cr2UJ8h5as=

On Sun 18-06-23 23:32:46, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Originally inode is used to get blksize, after commit 45bce8f3e343
> ("fs/buffer.c: make block-size be per-page and protected by the page lock"),
> __block_commit_write no longer uses this parameter inode, this patch is to
> remove inode and clean up block_commit_write.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Nice! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a7fc561758b1..b88bb7ec38be 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2116,8 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
>  }
>  EXPORT_SYMBOL(__block_write_begin);
>  
> -static int __block_commit_write(struct inode *inode, struct page *page,
> -		unsigned from, unsigned to)
> +int block_commit_write(struct page *page, unsigned int from, unsigned int to)
>  {
>  	unsigned block_start, block_end;
>  	int partial = 0;
> @@ -2154,6 +2153,7 @@ static int __block_commit_write(struct inode *inode, struct page *page,
>  		SetPageUptodate(page);
>  	return 0;
>  }
> +EXPORT_SYMBOL(block_commit_write);
>  
>  /*
>   * block_write_begin takes care of the basic task of block allocation and
> @@ -2188,7 +2188,6 @@ int block_write_end(struct file *file, struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct page *page, void *fsdata)
>  {
> -	struct inode *inode = mapping->host;
>  	unsigned start;
>  
>  	start = pos & (PAGE_SIZE - 1);
> @@ -2214,7 +2213,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
>  	flush_dcache_page(page);
>  
>  	/* This could be a short (even 0-length) commit */
> -	__block_commit_write(inode, page, start, start+copied);
> +	block_commit_write(page, start, start+copied);
>  
>  	return copied;
>  }
> @@ -2535,14 +2534,6 @@ int cont_write_begin(struct file *file, struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(cont_write_begin);
>  
> -int block_commit_write(struct page *page, unsigned from, unsigned to)
> -{
> -	struct inode *inode = page->mapping->host;
> -	__block_commit_write(inode,page,from,to);
> -	return 0;
> -}
> -EXPORT_SYMBOL(block_commit_write);
> -
>  /*
>   * block_page_mkwrite() is not allowed to change the file size as it gets
>   * called from a page fault handler when a page is first dirtied. Hence we must
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
