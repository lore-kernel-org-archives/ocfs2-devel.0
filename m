Return-Path: <SRS0=dMzQ=NU=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60801C432BE
	for <ocfs2-devel@archiver.kernel.org>; Sun, 29 Aug 2021 13:24:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3FBF6023F
	for <ocfs2-devel@archiver.kernel.org>; Sun, 29 Aug 2021 13:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3FBF6023F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17T6AvN8014937;
	Sun, 29 Aug 2021 13:24:35 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aqd1a1hs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 29 Aug 2021 13:24:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17TDA5ol195396;
	Sun, 29 Aug 2021 13:24:33 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aqa8vm11m-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 29 Aug 2021 13:24:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mKKnY-0008Ip-M6; Sun, 29 Aug 2021 06:24:32 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mKKn5-0008Hu-24
	for ocfs2-devel@oss.oracle.com; Sun, 29 Aug 2021 06:24:03 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17TD9Wgx171774
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 13:24:02 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aqcy1f2g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 13:24:02 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17SNMIab018602
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 13:24:01 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqxrpv5vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 13:24:01 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UmS9Nax_1630243433; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UmS9Nax_1630243433) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 29 Aug 2021 21:23:54 +0800
To: CGEL <cgel.zte@gmail.com>, Mark Fasheh <mark@fasheh.com>,
        akpm <akpm@linux-foundation.org>
References: <20210828010432.11100-1-deng.changcheng@zte.com.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <2800786e-dba1-c1fe-158d-92bee8f06acf@linux.alibaba.com>
Date: Sun, 29 Aug 2021 21:23:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210828010432.11100-1-deng.changcheng@zte.com.cn>
Content-Language: en-US
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	clxscore=66 mlxscore=0
	lowpriorityscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
	phishscore=0 impostorscore=0 priorityscore=0 bulkscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108290081 domainage_hfrom=8172
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0
	phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108290081
Cc: Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH linux-next] ocfs2: fix bugon.cocci warnings
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108290081
X-Proofpoint-ORIG-GUID: APaHHDmQclwqnQb_N9Pi3W4T_vBbeSsx
X-Proofpoint-GUID: APaHHDmQclwqnQb_N9Pi3W4T_vBbeSsx



On 8/28/21 9:04 AM, CGEL wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Use BUG_ON instead of if condition followed by BUG.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

BTW, could you send out a series to clean all in ocfs2?

> ---
>  fs/ocfs2/journal.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 4f15750..2305aa5 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -974,8 +974,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  		goto done;
>  
>  	/* need to inc inode use count - jbd2_journal_destroy will iput. */
> -	if (!igrab(inode))
> -		BUG();
> +	BUG_ON(!igrab(inode));
>  
>  	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
>  	trace_ocfs2_journal_shutdown(num_running_trans);
> @@ -1656,8 +1655,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	status = jbd2_journal_load(journal);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		if (!igrab(inode))
> -			BUG();
> +		BUG_ON(!igrab(inode));
>  		jbd2_journal_destroy(journal);
>  		goto done;
>  	}
> @@ -1686,8 +1684,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
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
