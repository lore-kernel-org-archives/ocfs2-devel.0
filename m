Return-Path: <SRS0=g/kM=J2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709EBC433ED
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 11:58:54 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8EC5A61419
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 11:58:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC5A61419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TBt5qD105512;
	Thu, 29 Apr 2021 11:58:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 385afq45gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Apr 2021 11:58:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TBogla143651;
	Thu, 29 Apr 2021 11:58:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3w51tt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 29 Apr 2021 11:58:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lc5Ji-0006wF-Ba; Thu, 29 Apr 2021 04:58:50 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lc5JF-0006py-Pz
	for ocfs2-devel@oss.oracle.com; Thu, 29 Apr 2021 04:58:21 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13TBor7r062059
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 11:58:21 GMT
Received: from oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 3848f0xw5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 11:58:21 +0000
Received: from userp2030.oracle.com (userp2030.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13TBtD71047110
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 11:58:21 GMT
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45])
	by userp2030.oracle.com with ESMTP id 3870t64y0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 11:58:20 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R591e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UXA-IhL_1619697495; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UXA-IhL_1619697495) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 29 Apr 2021 19:58:15 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <248885ce-6729-dc21-4937-849eb0fe8a45@linux.alibaba.com>
Date: Thu, 29 Apr 2021 19:58:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426220552.45413-1-junxiao.bi@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.45
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=201
	mlxscore=0 bulkscore=0
	phishscore=0 adultscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
	suspectscore=0 priorityscore=143 lowpriorityscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104290082
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH 1/3] fs/buffer.c: add new api to allow eof
 writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290082
X-Proofpoint-ORIG-GUID: bBMN1l9uxu2-C4cC4HsnpTHdhCwyK9Hq
X-Proofpoint-GUID: bBMN1l9uxu2-C4cC4HsnpTHdhCwyK9Hq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1034 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290082



On 4/27/21 6:05 AM, Junxiao Bi wrote:
> When doing truncate/fallocate for some filesytem like ocfs2, it
> will zero some pages that are out of inode size and then later
> update the inode size, so it needs this api to writeback eof
> pages.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>


Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c                 | 14 +++++++++++---
>  include/linux/buffer_head.h |  3 +++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 0cb7ffd4977c..802f0bacdbde 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1709,9 +1709,9 @@ static struct buffer_head *create_page_buffers(struct page *page, struct inode *
>   * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
>   * causes the writes to be flagged as synchronous writes.
>   */
> -int __block_write_full_page(struct inode *inode, struct page *page,
> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
>  			get_block_t *get_block, struct writeback_control *wbc,
> -			bh_end_io_t *handler)
> +			bh_end_io_t *handler, bool eof_write)
>  {
>  	int err;
>  	sector_t block;
> @@ -1746,7 +1746,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>  	 * handle any aliases from the underlying blockdev's mapping.
>  	 */
>  	do {
> -		if (block > last_block) {
> +		if (block > last_block && !eof_write) {
>  			/*
>  			 * mapped buffers outside i_size will occur, because
>  			 * this page can be outside i_size when there is a
> @@ -1871,6 +1871,14 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>  	unlock_page(page);
>  	goto done;
>  }
> +EXPORT_SYMBOL(__block_write_full_page_eof);
> +
> +int __block_write_full_page(struct inode *inode, struct page *page,
> +			get_block_t *get_block, struct writeback_control *wbc,
> +			bh_end_io_t *handler)
> +{
> +	return __block_write_full_page_eof(inode, page, get_block, wbc, handler, false);
> +}
>  EXPORT_SYMBOL(__block_write_full_page);
>  
>  /*
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 6b47f94378c5..5da15a1ba15c 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -221,6 +221,9 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
>  int __block_write_full_page(struct inode *inode, struct page *page,
>  			get_block_t *get_block, struct writeback_control *wbc,
>  			bh_end_io_t *handler);
> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
> +			get_block_t *get_block, struct writeback_control *wbc,
> +			bh_end_io_t *handler, bool eof_write);
>  int block_read_full_page(struct page*, get_block_t*);
>  int block_is_partially_uptodate(struct page *page, unsigned long from,
>  				unsigned long count);
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
