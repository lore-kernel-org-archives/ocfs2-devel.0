Return-Path: <SRS0=R4zn=PY=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72845C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:55:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B5DB603E7
	for <ocfs2-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B5DB603E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A50a13j007578;
	Fri, 5 Nov 2021 01:55:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7br9b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 01:55:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A51oNIM177046;
	Fri, 5 Nov 2021 01:55:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c4t60jctu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 05 Nov 2021 01:55:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mioRf-0004LT-Mk; Thu, 04 Nov 2021 18:55:07 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mioRd-0004L3-6K
	for ocfs2-devel@oss.oracle.com; Thu, 04 Nov 2021 18:55:05 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A51oO9G177192
	for <ocfs2-devel@oss.oracle.com>; Fri, 5 Nov 2021 01:55:04 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3c4t60jcr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 05 Nov 2021 01:55:04 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A50QqXe005019
	for <ocfs2-devel@oss.oracle.com>; Fri, 5 Nov 2021 01:55:03 GMT
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c4t2yryef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 05 Nov 2021 01:55:02 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0Uv5DzfM_1636077294; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Uv5DzfM_1636077294) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 05 Nov 2021 09:54:55 +0800
To: cgel.zte@gmail.com, mark@fasheh.com, akpm <akpm@linux-foundation.org>
References: <20211105014424.75372-1-zhang.mingyu@zte.com.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <58841188-72eb-bde9-12f7-4a3c7ff3e4c4@linux.alibaba.com>
Date: Fri, 5 Nov 2021 09:54:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211105014424.75372-1-zhang.mingyu@zte.com.cn>
Content-Language: en-US
X-Source-IP: 115.124.30.54
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	lowpriorityscore=0
	bulkscore=0 phishscore=0 mlxlogscore=930 spamscore=0 clxscore=254
	adultscore=0 priorityscore=30 malwarescore=0 suspectscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111050009
	domainage_hfrom=8240
X-Spam: Clean
Cc: Zeal Robot <zealci@zte.com.cn>, Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2:Use BUG_ON instead of if condition
	followed by BUG.
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111050009
X-Proofpoint-GUID: ztOAnskfbEFEVtxP-sKlWB_Zp0dCg630
X-Proofpoint-ORIG-GUID: ztOAnskfbEFEVtxP-sKlWB_Zp0dCg630



On 11/5/21 9:44 AM, cgel.zte@gmail.com wrote:
> From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> 
> This issue was detected with the help of Coccinelle.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index dbf9b9e97d74..1887a2708709 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1669,8 +1669,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	status = jbd2_journal_load(journal);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		if (!igrab(inode))
> -			BUG();
> +		BUG_ON(!igrab(inode));
>  		jbd2_journal_destroy(journal);
>  		goto done;
>  	}
> @@ -1699,8 +1698,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	if (status < 0)
>  		mlog_errno(status);
>  
> -	if (!igrab(inode))
> -		BUG();
> +	BUG_ON(!igrab(inode));
>  
>  	jbd2_journal_destroy(journal);
>  
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
