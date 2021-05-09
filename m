Return-Path: <SRS0=njLK=KE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC355C433B4
	for <ocfs2-devel@archiver.kernel.org>; Sun,  9 May 2021 23:26:55 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2BDC861352
	for <ocfs2-devel@archiver.kernel.org>; Sun,  9 May 2021 23:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BDC861352
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 149NQqn0025845;
	Sun, 9 May 2021 23:26:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38dk9n9j4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 May 2021 23:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 149NPtN0008770;
	Sun, 9 May 2021 23:26:52 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38e4dr8ar8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 09 May 2021 23:26:52 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lfsly-0001S5-58; Sun, 09 May 2021 16:23:42 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <akpm@linux-foundation.org>) id 1lfslS-0001R7-H7
	for ocfs2-devel@oss.oracle.com; Sun, 09 May 2021 16:23:10 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	149NLe0B032524
	for <ocfs2-devel@oss.oracle.com>; Sun, 9 May 2021 23:23:10 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38dfrub5u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 09 May 2021 23:23:10 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 149NEpGt004159
	for <ocfs2-devel@oss.oracle.com>; Sun, 9 May 2021 23:23:09 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2040.oracle.com with ESMTP id 38dh8u1ru6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 09 May 2021 23:23:09 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F89C6023B;
	Sun,  9 May 2021 23:23:07 +0000 (UTC)
Date: Sun, 9 May 2021 16:23:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-Id: <20210509162306.9de66b1656f04994f3cb5730@linux-foundation.org>
In-Reply-To: <20210426220552.45413-1-junxiao.bi@oracle.com>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 ip4:198.145.29.99
	include:_spf.google.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=149 lowpriorityscore=0
	suspectscore=0 impostorscore=0 spamscore=0 mlxlogscore=841 adultscore=0
	bulkscore=0 clxscore=258 mlxscore=0 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105090184
X-Spam: Clean
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105090186
X-Proofpoint-ORIG-GUID: ws9YxVtBPXkjPE7eeN3u_-QZLp1W_exK
X-Proofpoint-GUID: ws9YxVtBPXkjPE7eeN3u_-QZLp1W_exK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1034 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105090186

On Mon, 26 Apr 2021 15:05:50 -0700 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> When doing truncate/fallocate for some filesytem like ocfs2, it
> will zero some pages that are out of inode size and then later
> update the inode size, so it needs this api to writeback eof
> pages.

Seems reasonable.  But can we please update the
__block_write_full_page_eof() comment?  It now uses the wrong function
name and doesn't document the new `eof' argument.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
