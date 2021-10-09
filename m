Return-Path: <SRS0=bArw=O5=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EC8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Oct 2021 03:50:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C94E60EE2
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Oct 2021 03:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C94E60EE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1991VSFw026054;
	Sat, 9 Oct 2021 03:50:12 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bk1gbr946-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Oct 2021 03:50:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1993epmH074020;
	Sat, 9 Oct 2021 03:50:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bk06sx5tj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 09 Oct 2021 03:50:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mZ3K8-0004al-Mr; Fri, 08 Oct 2021 20:47:00 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jiangqi903@gmail.com>) id 1mZ3Ji-0004Zs-7C
	for ocfs2-devel@oss.oracle.com; Fri, 08 Oct 2021 20:46:34 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1993ept6073995
	for <ocfs2-devel@oss.oracle.com>; Sat, 9 Oct 2021 03:46:33 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bk06sx3h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 09 Oct 2021 03:46:33 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19930Eku017472
	for <ocfs2-devel@oss.oracle.com>; Sat, 9 Oct 2021 03:46:32 GMT
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
	[209.85.215.173])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bk2sxrde2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 09 Oct 2021 03:46:32 +0000
Received: by mail-pg1-f173.google.com with SMTP id r201so4956900pgr.4
	for <ocfs2-devel@oss.oracle.com>; Fri, 08 Oct 2021 20:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Q5tGBj/tS7feR/instIzbphplBYZMO5DVuMWJ87aguA=;
	b=jZwFMxChGTrfp1FWNADQ7nIE5Fhv0X0tgcgiQtecptaVgLO+1ARrzXdMeFp0O8cP08
	uqFyyEVG0ronFAGoDlSdxba9rZhusr251uoYFKaXLnD7oUc0Pm4X8s7CB5HUDQ/u5UA1
	4zGZt004mw4POnA7BArrWit5fBL3yssGhULQDUz1OS0He/2HnGmaVGno6Ft2xtun+Bh6
	xdbhKWfpsCToNPeMQNkr3o0VkNlhnEETmnHk61LkwyNn0w+xCWGyMhR1UxY0wHn/+WfN
	Q05dNpiPNDxstGii0+a0B/C4H0RFXopWQldG7RgkrLnFRHVYG2qZxm58IpejDkRB0f8b
	519g==
X-Gm-Message-State: AOAM530piU9PF4j4Q8pE8Tdw+C1peaM34MF4/vAFXN2q44GZJ5BDHkiF
	etfpU+96ELImRRE7y9fQ7pU=
X-Google-Smtp-Source: ABdhPJzwXKQSrc4sW9qu3vVxQuhUkAmjf93bRkpDrgto41F/QgYg+p7cPKVh19fEG/NLNQxslTfvlw==
X-Received: by 2002:a63:40f:: with SMTP id 15mr7852351pge.328.1633751190973;
	Fri, 08 Oct 2021 20:46:30 -0700 (PDT)
Received: from B-D1K7ML85-0059.local ([47.246.98.148])
	by smtp.gmail.com with ESMTPSA id c24sm790425pgj.63.2021.10.08.20.46.28
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 08 Oct 2021 20:46:30 -0700 (PDT)
To: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>
References: <20210930095405.21433-1-jack@suse.cz>
From: Joseph Qi <jiangqi903@gmail.com>
Message-ID: <b2f712c2-c46d-4bf6-7867-88d81f49087f@gmail.com>
Date: Sat, 9 Oct 2021 11:46:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930095405.21433-1-jack@suse.cz>
Content-Language: en-US
X-Source-IP: 209.85.215.173
X-ServerName: mail-pg1-f173.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	spamscore=0 bulkscore=0
	mlxlogscore=999 priorityscore=354 phishscore=0 impostorscore=0
	malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
	clxscore=128
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110090023
X-Spam: Clean
Cc: "Markov, Andrey" <Markov.Andrey@Dell.com>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix data corruption after
 conversion from inline format
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110090022
X-Proofpoint-ORIG-GUID: _-kxeily6dedRaArL8OexbUbvQxOiEW4
X-Proofpoint-GUID: _-kxeily6dedRaArL8OexbUbvQxOiEW4



On 9/30/21 5:54 PM, Jan Kara wrote:
> Commit 6dbf7bb55598 ("fs: Don't invalidate page buffers in
> block_write_full_page()") uncovered a latent bug in ocfs2 conversion
> from inline inode format to a normal inode format. The code in
> ocfs2_convert_inline_data_to_extents() attempts to zero out the whole
> cluster allocated for file data by grabbing, zeroing, and dirtying all
> pages covering this cluster. However these pages are beyond i_size, thus
> writeback code generally ignores these dirty pages and no blocks were
> ever actually zeroed on the disk. This oversight was fixed by commit
> 693c241a5f6a ("ocfs2: No need to zero pages past i_size.") for standard
> ocfs2 write path, inline conversion path was apparently forgotten; the
> commit log also has a reasoning why the zeroing actually is not needed.
> After commit 6dbf7bb55598, things became worse as writeback code stopped
> invalidating buffers on pages beyond i_size and thus these pages end up
> with clean PageDirty bit but with buffers attached to these pages being
> still dirty. So when a file is converted from inline format, then
> writeback triggers, and then the file is grown so that these pages
> become valid, the invalid dirtiness state is preserved,
> mark_buffer_dirty() does nothing on these pages (buffers are already
> dirty) but page is never written back because it is clean. So data
> written to these pages is lost once pages are reclaimed.
> 
> Simple reproducer for the problem is:
> 
> xfs_io -f -c "pwrite 0 2000" -c "pwrite 2000 2000" -c "fsync" \
>   -c "pwrite 4000 2000" ocfs2_file
> 
> After unmounting and mounting the fs again, you can observe that end of
> 'ocfs2_file' has lost its contents.
> 
> Fix the problem by not doing the pointless zeroing during conversion
> from inline format similarly as in the standard write path.
> 
> CC: stable@vger.kernel.org
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/alloc.c | 46 ++++++++++++----------------------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index f1cc8258d34a..12aead0dabe2 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7045,7 +7045,7 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
>  int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  					 struct buffer_head *di_bh)
>  {
> -	int ret, i, has_data, num_pages = 0;
> +	int ret,has_data, num_pages = 0;

Should leave a space between 'ret' and 'has_data'.

Other looks good to me.
Reviewed-and-Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Cc Gang and Andrey Markov who have encountered the same issue before. 

>  	int need_free = 0;
>  	u32 bit_off, num;
>  	handle_t *handle;
> @@ -7054,26 +7054,17 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  	struct ocfs2_alloc_context *data_ac = NULL;
> -	struct page **pages = NULL;
> -	loff_t end = osb->s_clustersize;
> +	struct page *page = NULL;
>  	struct ocfs2_extent_tree et;
>  	int did_quota = 0;
>  
>  	has_data = i_size_read(inode) ? 1 : 0;
>  
>  	if (has_data) {
> -		pages = kcalloc(ocfs2_pages_per_cluster(osb->sb),
> -				sizeof(struct page *), GFP_NOFS);
> -		if (pages == NULL) {
> -			ret = -ENOMEM;
> -			mlog_errno(ret);
> -			return ret;
> -		}
> -
>  		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
>  		if (ret) {
>  			mlog_errno(ret);
> -			goto free_pages;
> +			goto out;
>  		}
>  	}
>  
> @@ -7093,7 +7084,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  	}
>  
>  	if (has_data) {
> -		unsigned int page_end;
> +		unsigned int page_end = min_t(unsigned, PAGE_SIZE,
> +							osb->s_clustersize);
>  		u64 phys;
>  
>  		ret = dquot_alloc_space_nodirty(inode,
> @@ -7117,15 +7109,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  		 */
>  		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
>  
> -		/*
> -		 * Non sparse file systems zero on extend, so no need
> -		 * to do that now.
> -		 */
> -		if (!ocfs2_sparse_alloc(osb) &&
> -		    PAGE_SIZE < osb->s_clustersize)
> -			end = PAGE_SIZE;
> -
> -		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
> +		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
> +					   &num_pages);
>  		if (ret) {
>  			mlog_errno(ret);
>  			need_free = 1;
> @@ -7136,20 +7121,15 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  		 * This should populate the 1st page for us and mark
>  		 * it up to date.
>  		 */
> -		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
> +		ret = ocfs2_read_inline_data(inode, page, di_bh);
>  		if (ret) {
>  			mlog_errno(ret);
>  			need_free = 1;
>  			goto out_unlock;
>  		}
>  
> -		page_end = PAGE_SIZE;
> -		if (PAGE_SIZE > osb->s_clustersize)
> -			page_end = osb->s_clustersize;
> -
> -		for (i = 0; i < num_pages; i++)
> -			ocfs2_map_and_dirty_page(inode, handle, 0, page_end,
> -						 pages[i], i > 0, &phys);
> +		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
> +					 &phys);
>  	}
>  
>  	spin_lock(&oi->ip_lock);
> @@ -7180,8 +7160,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  	}
>  
>  out_unlock:
> -	if (pages)
> -		ocfs2_unlock_and_free_pages(pages, num_pages);
> +	if (page)
> +		ocfs2_unlock_and_free_pages(&page, num_pages);
>  
>  out_commit:
>  	if (ret < 0 && did_quota)
> @@ -7205,8 +7185,6 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  out:
>  	if (data_ac)
>  		ocfs2_free_alloc_context(data_ac);
> -free_pages:
> -	kfree(pages);
>  	return ret;
>  }
>  
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
