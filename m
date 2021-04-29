Return-Path: <SRS0=g/kM=J2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3BCC433ED
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:09:36 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 32CB461057
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32CB461057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TD5kbj088212;
	Thu, 29 Apr 2021 13:09:35 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 385ahbvaay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Apr 2021 13:09:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TD0t4i196095;
	Thu, 29 Apr 2021 13:09:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3848f125u4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 29 Apr 2021 13:09:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lc6Q8-0002wy-Rh; Thu, 29 Apr 2021 06:09:32 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lc6Q6-0002wZ-3p
	for ocfs2-devel@oss.oracle.com; Thu, 29 Apr 2021 06:09:30 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13TD0vVn196269
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 13:09:29 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 3848f125nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 13:09:29 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13TD50Aa002582
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 13:09:29 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by userp2040.oracle.com with ESMTP id 3877qj88mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 13:09:28 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UXAmpys_1619701762; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UXAmpys_1619701762) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 29 Apr 2021 21:09:23 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<20210426220552.45413-2-junxiao.bi@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <3e75d19c-7c9e-c86f-dddf-ae1062811655@linux.alibaba.com>
Date: Thu, 29 Apr 2021 21:09:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426220552.45413-2-junxiao.bi@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxlogscore=999
	spamscore=0 bulkscore=0 clxscore=238 suspectscore=0 priorityscore=154
	adultscore=0 impostorscore=0 mlxscore=0 malwarescore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104290089
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: allow writing back pages out
 of inode size
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290089
X-Proofpoint-GUID: oHykh1uA77f__m9dMQA2XVuoCEe5r7_C
X-Proofpoint-ORIG-GUID: oHykh1uA77f__m9dMQA2XVuoCEe5r7_C
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1034 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290089



On 4/27/21 6:05 AM, Junxiao Bi wrote:
> When fallocate/truncate extend inode size, if the original isize is in
> the middle of last cluster, then the part from isize to the end of the
> cluster needs to be zeroed with buffer write, at that time isize is not
> yet updated to match the new size, if writeback is kicked in, it will
> invoke ocfs2_writepage()->block_write_full_page() where the pages out
> of inode size will be dropped. That will cause file corruption.
> 
> Running the following command with qemu-image 4.2.1 can get a corrupted
> coverted image file easily.
> 
>     qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
>              -O qcow2 -o compat=1.1 $qcow_image.conv
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/aops.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ad20403b383f..7a3e3d59f6a9 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -402,11 +402,28 @@ static void ocfs2_readahead(struct readahead_control *rac)
>   */
>  static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
>  {
> +	struct inode * const inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	const pgoff_t end_index = i_size >> PAGE_SHIFT;
> +	unsigned int offset;
> +
>  	trace_ocfs2_writepage(
>  		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
>  		page->index);
>  
> -	return block_write_full_page(page, ocfs2_get_block, wbc);
> +	/*
> +	 * The page straddles i_size.  It must be zeroed out on each and every
> +	 * writepage invocation because it may be mmapped.  "A file is mapped
> +	 * in multiples of the page size.  For a file that is not a multiple of
> +	 * the  page size, the remaining memory is zeroed when mapped, and
> +	 * writes to that region are not written out to the file."
> +	 */
> +	offset = i_size & (PAGE_SIZE-1);
> +	if (page->index == end_index && offset)
> +		zero_user_segment(page, offset, PAGE_SIZE);
> +
> +	return __block_write_full_page_eof(inode, page, ocfs2_get_block, wbc,
> +			end_buffer_async_write, true);
>  }
>  
>  /* Taken from ext3. We don't necessarily need the full blown
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
