Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACBAC3DA7A
	for <ocfs2-devel@archiver.kernel.org>; Mon,  2 Jan 2023 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vuCoeyH47HevbnTb6+SNJ1HLuvTbAhZ7JevScleFD90=;
 b=XQQ/2uiX00YfZPJTYCe3wMgjdzZkBEheLRrWDS4Cz9hj1k8glwq84d3PJkiXVRCQ0nJpIiJprGyN
   EC8+bDrv8XEDLv3Qv7rDdTGoqf30I4P0xv07S98xIRtLr1gi1lP5uXRmDb8Suu6iBil6s7FcWav4
   QfvIQeADt1OKAgKifHLe8h2XobGZtSokEs0qbEO6g5oS3JLOA3uYyn6SMv2GVVnm4IPAlv9ShVkt
   rAVAmfmbLiGa/cyChsBCf7c2aXgXb3ydx41EAsL0Z1rwfqoorIZBR8EndB6svPDLV4Z/LOcQ66/g
   deIAaRZu5AOV2QIE6PigT9TY4fYdMEuLYIhnTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vuCoeyH47HevbnTb6+SNJ1HLuvTbAhZ7JevScleFD90=;
 b=exhjq3lkNaGkPB3mNQVI+KrfOLbvS+B6kfJ8LGVRYTzmz5/k35wh7ZkJ6ETnMEv513AIhS2OcHNf
   p0dOST/vDKvpccXoNUMe+X3y2mN8AWSQhPtZabVC7m9rcLgmizt/KjZRLzkI1o5aqUa2RFJmRxOQ
   Vcpgt7Fn6tFaNP2ajGV7+bSBTfkE9vlzUXMMCg4mOWbTMJrpZkPmYjRdyBT/nOtmnB/hXYaKYSFA
   gByULly/zmnKMckwfaBarR2nBR7WMtc+hNUeVai+p2VaWlwz2qiaYfj//Uv0tqA1wrODH6DrUZ8P
   XjUJRYzk/7W1hfFqtjLDM4dJSacegh/5WAsIZA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNU00B2CY3NIR20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 02 Jan 2023 12:16:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1672661783;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lciet8dBeNbENoER71MTYvm/0HjOnWjldfsc9ARRDjA=;
 b=Z2NfHHv8LQE8LGsksDyHiOW7ia0MxN09WJmswZ/kTFOS9aQr05c15gzVV/IvmXU24Rwb14
 KGNk1inL0Kpw9jyq9NoyxsV2RaNf5qc5JQNdH0gSmdAdTCyaK0ev9XAYtOofDkyWz/bwCW
 Wp3j6L60XelvZ9arl4vmM28F0XQJ8wQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1672661783;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lciet8dBeNbENoER71MTYvm/0HjOnWjldfsc9ARRDjA=;
 b=4H/d29qLIAm2FxBDK6Y9UKKprqkrOYEYiJO0Koqjk75JTdj9yWFNV8XncwVRN6n+qczRl2
 2zu2+S4+7i/16qAA==
Date: Mon, 2 Jan 2023 13:16:22 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230102121622.4xq4mn6gvqa2ksjx@quack3>
References: <20221229161031.391878-1-hch@lst.de>
 <20221229161031.391878-7-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221229161031.391878-7-hch@lst.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10577
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=90 malwarescore=0
 spamscore=0 clxscore=150 impostorscore=0 mlxlogscore=367 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301020112
Cc: ntfs3@lists.linux.dev, Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 6/6] mm: remove generic_writepages
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
X-Proofpoint-ORIG-GUID: enz67YNEeDTEeXm1qoCGyLvOZQpyoey9
X-Proofpoint-GUID: enz67YNEeDTEeXm1qoCGyLvOZQpyoey9
Reporting-Meta:
 AAH81Tmpz7EiURFNDG+dXpekV9J0tPXuFOdfawKCoo1ID+2NUUXQ/qMF9Li+xZdA
 zD0xLvMnjTFaKZBVTCTQe5PiyOLXd9CnefHQrSWBcsBI9tbiCIf/YyE1ol0h7d2t
 8is+dvhAgAWjwjRu1hNtb8w/yJRYi8M064sE71CXHPAyoGF3z8s+J5YLYA+AHcxY
 yEMAVTAtNGN+ORHAwgT/FlwYuVksC52VJmt5IBzFqDw7BRQ+HHszEtP5yzV3s7RG
 VFfDFaNGIRC66ocVWVr7d6L03DsCN9e6MjEqOZksMm+f15mI4XX3XwLsyzicpHcb
 3hU9nOvnyL4GWFPuuueMXvg63iVnAGdNFMeu3BDBObllkDwMYKhXqgQCWNTsWJ9t
 9pb0E72Un7pm7R1WtFtc2686rfWlJ6KEddiy610PgUiMkH9XD9waqmgHUwVyGmx7
 eyTENQzv3ZJKOQxVwQhb0fRDxmeMllwN35iW2e1FtncB3Vci69E4iVgRYwd6iEne
 p8iPeTk0CEm+vYJ/67VSlHs7xYtq+TKGJi9mlFG0ECI=

On Thu 29-12-22 06:10:31, Christoph Hellwig wrote:
> Now that all external callers are gone, just fold it into do_writepages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  include/linux/writeback.h |  2 --
>  mm/page-writeback.c       | 53 +++++++++++----------------------------
>  2 files changed, 15 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 06f9291b6fd512..2554b71765e9d0 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -369,8 +369,6 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
>  typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
>  				void *data);
>  
> -int generic_writepages(struct address_space *mapping,
> -		       struct writeback_control *wbc);
>  void tag_pages_for_writeback(struct address_space *mapping,
>  			     pgoff_t start, pgoff_t end);
>  int write_cache_pages(struct address_space *mapping,
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ad608ef2a24365..dfeeceebba0ae0 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2526,12 +2526,8 @@ int write_cache_pages(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(write_cache_pages);
>  
> -/*
> - * Function used by generic_writepages to call the real writepage
> - * function and set the mapping flags on error
> - */
> -static int __writepage(struct page *page, struct writeback_control *wbc,
> -		       void *data)
> +static int writepage_cb(struct page *page, struct writeback_control *wbc,
> +		void *data)
>  {
>  	struct address_space *mapping = data;
>  	int ret = mapping->a_ops->writepage(page, wbc);
> @@ -2539,34 +2535,6 @@ static int __writepage(struct page *page, struct writeback_control *wbc,
>  	return ret;
>  }
>  
> -/**
> - * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
> - * @mapping: address space structure to write
> - * @wbc: subtract the number of written pages from *@wbc->nr_to_write
> - *
> - * This is a library function, which implements the writepages()
> - * address_space_operation.
> - *
> - * Return: %0 on success, negative error code otherwise
> - */
> -int generic_writepages(struct address_space *mapping,
> -		       struct writeback_control *wbc)
> -{
> -	struct blk_plug plug;
> -	int ret;
> -
> -	/* deal with chardevs and other special file */
> -	if (!mapping->a_ops->writepage)
> -		return 0;
> -
> -	blk_start_plug(&plug);
> -	ret = write_cache_pages(mapping, wbc, __writepage, mapping);
> -	blk_finish_plug(&plug);
> -	return ret;
> -}
> -
> -EXPORT_SYMBOL(generic_writepages);
> -
>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	int ret;
> @@ -2577,11 +2545,20 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  	wb = inode_to_wb_wbc(mapping->host, wbc);
>  	wb_bandwidth_estimate_start(wb);
>  	while (1) {
> -		if (mapping->a_ops->writepages)
> +		if (mapping->a_ops->writepages) {
>  			ret = mapping->a_ops->writepages(mapping, wbc);
> -		else
> -			ret = generic_writepages(mapping, wbc);
> -		if ((ret != -ENOMEM) || (wbc->sync_mode != WB_SYNC_ALL))
> +		} else if (mapping->a_ops->writepage) {
> +			struct blk_plug plug;
> +
> +			blk_start_plug(&plug);
> +			ret = write_cache_pages(mapping, wbc, writepage_cb,
> +						mapping);
> +			blk_finish_plug(&plug);
> +		} else {
> +			/* deal with chardevs and other special files */
> +			ret = 0;
> +		}
> +		if (ret != -ENOMEM || wbc->sync_mode != WB_SYNC_ALL)
>  			break;
>  
>  		/*
> -- 
> 2.35.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
