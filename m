Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69842EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=46mnlf9VQWYNFAjQZPNGLZhEaRVJWAr8W+MLRgM5Z/M=;
 b=FSUmpMqGFDxxzidG9tzuXxBv3NsMIcQfqjULAvdaA786IToLQ+glU+7aDTHnMxG66mojEtbbw2IG
   4hGOqRe80YxCUgFk0AWfNd/VVqEv39nJTf5UnKDaK0sSei5Exh4KWtAcvIk5oRXtot0TNrMUd15w
   njnCnKvC5NcEwiKKru8zTBIJ3sxN0eJi067HVOctb0zAdVxPPq4EImrrOszIb7hdlkQmygQk4rBy
   JYmU7eaDlsYOGJp47rYD8ecm/uQ8um1IVBB/D9CvgKnfLF/XFZXr26R1Deu+qbPBNViwjBpmlwpV
   1s5kRp4h1Jh9nRc+FmE2Vkuw09JKq9WxYqyQdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=46mnlf9VQWYNFAjQZPNGLZhEaRVJWAr8W+MLRgM5Z/M=;
 b=Mme7jmw9VqdojR3/m6Rwh5lePUU4NWTAyvU31i1NtTTuxtgFICOAhVclYA6ygu9J6hTD6O+MYWCu
   ZafSvTHghBr/GNBGM+ldCVkLKbUUVnx1tC+SwT2iv5nfxZbP1zfmW0+kOsZ44YqyOBw5n1HaRcJB
   0s7bsWpvAjum37aFTXadGWM4ZIMod1oFAU9OAetPm6W15et+FyXX87sCgMm2pcMpBIJPheianwg0
   2nHQeqtHeZLQrlJPufovK03utiQfVuR7Na/gB0RIg6ZSBt0uOm0U39kDRF1ifm2f2b8R20bwstjv
   PtM0CW/hsnNF88q2o5mQfQe3VAZyICWSFf7iXg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV008764QAJO10@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 13:42:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1687786902;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=nvrMGiHpP8dqIjK7zu4WtGJ8NhmqnwYO1zz07P5FzZw=;
 b=Qz7XcL/HzBpS4a3YE/6pzhzqg7KK7Q4L7hdbGwRVSbCl+dpn0ocUdjXQi9X1GneRvrdgrk
 AN/yplnhol1afovIWvUZhfJew9ePCDRiRGD6qhnkZCQznuNmtSaA5gbiq13s/XW5jtu65j
 a5y8zYcSbW6obWcwTd6DsNzF8Wq8Abo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1687786902;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=nvrMGiHpP8dqIjK7zu4WtGJ8NhmqnwYO1zz07P5FzZw=;
 b=DPxKDZF35wYWAhMBk0ccpJVemlJDEbDtIe6K0j0/ug9TkAkt/wkfqpuM1qAOFroSY1u/vq
 SgBSC3yatmAhdwBw==
Date: Mon, 26 Jun 2023 15:41:41 +0200
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <20230626134141.reroeq3hj4tja24d@quack3>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
 <20230626055518.842392-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-2-beanhuo@iokpp.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10753
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=781 bulkscore=0 adultscore=0 clxscore=212 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=178 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260116
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 1/2] fs/buffer: clean up
	block_commit_write
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
X-Proofpoint-GUID: 1bP584m3vorEHJ5aVENJIu7XWeJQwbVu
X-Proofpoint-ORIG-GUID: 1bP584m3vorEHJ5aVENJIu7XWeJQwbVu
Reporting-Meta:
 AAF4BKSLjvdXdCm15N4a/WXj6DDNyqjPeNN801gd2CX6yrbsQm6mF06rSJqRtwql
 E6DusywARhKGkvNEwI+6WfZ6ylBQzPcYZCCzKXSQ7pSewdz+GtWuYSoJJL90Hynn
 bb5nU/saBBmaj5A8kSEctax8Ipe3Lf/ySW+FR2mcNAg4GQZO1VM+5jxY/GOoaXBv
 dWKwDXshj7bRfQu5deQvXTIEGYGonPdwtLWTZREJx/V1wZsj01ufD/EAN/K92e8b
 fk/MmW1L+xRfEwn8Q4Owl/i13y+jzPPF1u4eISUySxd+716PP1eCttpVbqJ4B0f9
 UiLhoaM/4ZFEtI/3znNGggU9gP3OJ0zjeBW4ni9ZG2eXGt6KbnPvUvmdm/lOfZnS
 ib5CVHGAF/1DIBt+sxeaYXj6AxK0KDw0wXOY7SzbKrDEQsxetNnZtza6ZXWEj0qI
 7NqHvbw1ArLKdrjzwrrKUGemPZKakOSwRL9gznlkku843DW2GbGlR6230sZNA3v5
 74fCSCBXWFgLwk2IcWHDQG5DPvzzMH956WbyMMG+Iuhh

On Mon 26-06-23 07:55:17, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Originally inode is used to get blksize, after commit 45bce8f3e343
> ("fs/buffer.c: make block-size be per-page and protected by the page lock"),
> __block_commit_write no longer uses this parameter inode.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index bd091329026c..50821dfb02f7 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2180,8 +2180,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
>  }
>  EXPORT_SYMBOL(__block_write_begin);
>  
> -static int __block_commit_write(struct inode *inode, struct folio *folio,
> -		size_t from, size_t to)
> +static int __block_commit_write(struct folio *folio, size_t from, size_t to)
>  {
>  	size_t block_start, block_end;
>  	bool partial = false;
> @@ -2277,7 +2276,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
>  	flush_dcache_folio(folio);
>  
>  	/* This could be a short (even 0-length) commit */
> -	__block_commit_write(inode, folio, start, start + copied);
> +	__block_commit_write(folio, start, start + copied);
>  
>  	return copied;
>  }
> @@ -2601,8 +2600,7 @@ EXPORT_SYMBOL(cont_write_begin);
>  int block_commit_write(struct page *page, unsigned from, unsigned to)
>  {
>  	struct folio *folio = page_folio(page);
> -	struct inode *inode = folio->mapping->host;
> -	__block_commit_write(inode, folio, from, to);
> +	__block_commit_write(folio, from, to);
>  	return 0;
>  }
>  EXPORT_SYMBOL(block_commit_write);
> @@ -2650,7 +2648,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  
>  	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
>  	if (!ret)
> -		ret = __block_commit_write(inode, folio, 0, end);
> +		ret = __block_commit_write(folio, 0, end);
>  
>  	if (unlikely(ret < 0))
>  		goto out_unlock;
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
