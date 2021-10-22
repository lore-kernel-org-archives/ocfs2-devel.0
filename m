Return-Path: <SRS0=RLPq=PK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF36AC433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:33:30 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C328613BD
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 02:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C328613BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LNif7L010959;
	Fri, 22 Oct 2021 02:33:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqyprptd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 02:33:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2VfkZ112864;
	Fri, 22 Oct 2021 02:33:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gx4n86-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 22 Oct 2021 02:33:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdkN4-0000qK-M0; Thu, 21 Oct 2021 19:33:26 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <akpm@linux-foundation.org>) id 1mdkN3-0000pv-HD
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 19:33:25 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M2VI7d110473
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:33:25 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bqpj9uv0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:33:25 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19M0f5qP022211
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:33:24 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bujyfgyg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 02:33:24 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BC35613B5;
	Fri, 22 Oct 2021 02:33:22 +0000 (UTC)
Date: Thu, 21 Oct 2021 19:33:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-Id: <20211021193320.c27376a50d364c1a66a2a0f1@linux-foundation.org>
In-Reply-To: <47e7ddf7-8d0b-0101-69ca-eaecc5fa1813@linux.alibaba.com>
References: <1634820718-6043-1-git-send-email-gautham.ananthakrishna@oracle.com>
	<47e7ddf7-8d0b-0101-69ca-eaecc5fa1813@linux.alibaba.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 ip4:198.145.29.99
	include:_spf.google.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	priorityscore=130
	adultscore=0 spamscore=0 clxscore=224 lowpriorityscore=0 phishscore=0
	mlxscore=0 impostorscore=0 bulkscore=0 mlxlogscore=811 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110220012 domainage_hfrom=5421
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220012
X-Proofpoint-ORIG-GUID: KPkymsOmI3NqVa55Wxi0kItOBCtHiT4c
X-Proofpoint-GUID: KPkymsOmI3NqVa55Wxi0kItOBCtHiT4c

On Fri, 22 Oct 2021 09:35:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 10/21/21 8:51 PM, Gautham Ananthakrishna wrote:
> > Encountered a race between ocfs2_test_bg_bit_allocatable() and
> > jbd2_journal_put_journal_head() resulting in the below vmcore.
> > 
>
> ...
>
> > 
> > Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

I added a cc:stable to this to ensure backporting.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
