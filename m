Return-Path: <SRS0=NURE=N6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13117C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Sep 2021 10:51:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D6C861163
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Sep 2021 10:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D6C861163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188AJ7sM010785;
	Wed, 8 Sep 2021 10:51:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3axcw6a8v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Sep 2021 10:51:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188AoFPw090148;
	Wed, 8 Sep 2021 10:51:47 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axst3mrug-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 08 Sep 2021 10:51:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mNvBB-0003Gj-Vj; Wed, 08 Sep 2021 03:51:45 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mNvB7-0003Ej-R3
	for ocfs2-devel@oss.oracle.com; Wed, 08 Sep 2021 03:51:41 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	188Aoo6P138121
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 10:51:41 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3axcq171sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 10:51:41 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	1886xfwk017125
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 10:51:40 GMT
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57])
	by mx0b-00069f01.pphosted.com with ESMTP id 3axcm9j49g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 10:51:39 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R961e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UngnLi9_1631098292; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UngnLi9_1631098292) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 08 Sep 2021 18:51:33 +0800
To: Chenyuan Mi <cymi20@fudan.edu.cn>, akpm <akpm@linux-foundation.org>
References: <20210908102055.10168-1-cymi20@fudan.edu.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <06d9e055-29b9-731c-5a36-d888f2c83188@linux.alibaba.com>
Date: Wed, 8 Sep 2021 18:51:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210908102055.10168-1-cymi20@fudan.edu.cn>
Content-Language: en-US
X-Source-IP: 115.124.30.57
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	mlxscore=0
	priorityscore=85 adultscore=0 clxscore=303 phishscore=0 malwarescore=0
	lowpriorityscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
	spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109080069 domainage_hfrom=8182
X-Spam: Clean
Cc: Xin Tan <tanxin.ctf@gmail.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        yuanxzhang@fudan.edu.cn, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Fix handle refcount leak in two
 exception handling paths
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080069
X-Proofpoint-GUID: ufZoJlZ7mESq2o50B6sN2FhXLc9XGTaS
X-Proofpoint-ORIG-GUID: ufZoJlZ7mESq2o50B6sN2FhXLc9XGTaS



On 9/8/21 6:20 PM, Chenyuan Mi wrote:
> The reference counting issue happens in two exception handling paths
> of ocfs2_replay_truncate_records(). When executing these two exception
> handling paths, the function forgets to decrease the refcount of handle
> increased by ocfs2_start_trans(), causing a refcount leak.
> 
> Fix this issue by using ocfs2_commit_trans() to decrease the refcount
> of handle in two handling paths.
> 
> Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index f1cc8258d34a..b05fde7edc3a 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5940,6 +5940,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>  		status = ocfs2_journal_access_di(handle, INODE_CACHE(tl_inode), tl_bh,
>  						 OCFS2_JOURNAL_ACCESS_WRITE);
>  		if (status < 0) {
> +			ocfs2_commit_trans(osb, handle);
>  			mlog_errno(status);
>  			goto bail;
>  		}
> @@ -5964,6 +5965,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>  						     data_alloc_bh, start_blk,
>  						     num_clusters);
>  			if (status < 0) {
> +				ocfs2_commit_trans(osb, handle);
>  				mlog_errno(status);
>  				goto bail;
>  			}
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
