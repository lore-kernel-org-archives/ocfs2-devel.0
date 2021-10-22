Return-Path: <SRS0=RLPq=PK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEB9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:38:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A11EC61163
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A11EC61163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LNiWac020379;
	Fri, 22 Oct 2021 02:38:55 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkw51m3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 02:38:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2VfHE064429;
	Fri, 22 Oct 2021 02:38:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkv2ykmt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 22 Oct 2021 02:38:53 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdkSK-0000yI-Rn; Thu, 21 Oct 2021 19:38:52 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mdkSI-0000y1-V8
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 19:38:51 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2UvWf011014
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:50 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bqmsk7g58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:50 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19M26EFg013382
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:49 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bum7d08nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:38:49 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R391e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UtCtqMD_1634870323; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UtCtqMD_1634870323) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 22 Oct 2021 10:38:44 +0800
To: Andrew Morton <akpm@linux-foundation.org>
References: <1634820718-6043-1-git-send-email-gautham.ananthakrishna@oracle.com>
	<47e7ddf7-8d0b-0101-69ca-eaecc5fa1813@linux.alibaba.com>
	<20211021193320.c27376a50d364c1a66a2a0f1@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <f0852834-69a1-dfe0-ecca-634ace3fbb0e@linux.alibaba.com>
Date: Fri, 22 Oct 2021 10:38:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211021193320.c27376a50d364c1a66a2a0f1@linux-foundation.org>
Content-Language: en-US
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=284
	lowpriorityscore=0
	phishscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
	mlxlogscore=999 suspectscore=0 bulkscore=0 priorityscore=141
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220013
	domainage_hfrom=8226
X-Spam: Clean
Cc: rajesh.sivaramasubramaniom@oracle.com,
        Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH V2 RFC 1/1] ocfs2: race between searching
 chunks and release journal_head from buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220012
X-Proofpoint-GUID: buAHw-Oa4kjdw_mMR2pevWiZeoMoIhlP
X-Proofpoint-ORIG-GUID: buAHw-Oa4kjdw_mMR2pevWiZeoMoIhlP



On 10/22/21 10:33 AM, Andrew Morton wrote:
> On Fri, 22 Oct 2021 09:35:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>
>>
>> On 10/21/21 8:51 PM, Gautham Ananthakrishna wrote:
>>> Encountered a race between ocfs2_test_bg_bit_allocatable() and
>>> jbd2_journal_put_journal_head() resulting in the below vmcore.
>>>
>>
>> ...
>>
>>>
>>> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
>>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> I added a cc:stable to this to ensure backporting.
> 

Thanks for this.
And I suggest add 'fix' to the subject would be better:
ocfs2: fix race between searching chunks and release journal_head from buffer_head
Sorry for your inconvenience, I would have pointed out earlier.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
