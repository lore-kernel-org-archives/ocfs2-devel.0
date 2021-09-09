Return-Path: <SRS0=mf1/=N7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C736CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 11:12:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6750F61100
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 11:12:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6750F61100
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189AavRk023501;
	Thu, 9 Sep 2021 11:12:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aydrsgqvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 11:12:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189B6JnV035921;
	Thu, 9 Sep 2021 11:12:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axst589vb-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 09 Sep 2021 11:12:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mOHyR-00021N-9p; Thu, 09 Sep 2021 04:12:07 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from
	<BATV+ab606af41e2b6213a0ed+6591+infradead.org+hch@casper.srs.infradead.org>)
	id 1mOHyI-000211-GF
	for ocfs2-devel@oss.oracle.com; Thu, 09 Sep 2021 04:11:58 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	189B67BJ097219
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 11:11:58 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3axcpnjy1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 11:11:55 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	1897JS2H002336
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 11:11:55 GMT
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ay7es6meu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 11:11:54 +0000
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat
	Linux)) id 1mOHwN-009kWU-38; Thu, 09 Sep 2021 11:10:05 +0000
Date: Thu, 9 Sep 2021 12:09:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YTnrh2AUzActMoxl@infradead.org>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-2-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210827164926.1726765-2-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Source-IP: 90.155.50.34
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxscore=0 clxscore=296
	malwarescore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
	bulkscore=0
	spamscore=0 priorityscore=242 suspectscore=0 mlxlogscore=779
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001 definitions=main-2109090068
X-Spam: Clean
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 01/19] iov_iter: Fix
 iov_iter_get_pages{, _alloc} page fault return value
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090068
X-Proofpoint-GUID: ar2DVhCB21mcud4kqq5xfrlISuhypmN4
X-Proofpoint-ORIG-GUID: ar2DVhCB21mcud4kqq5xfrlISuhypmN4

On Fri, Aug 27, 2021 at 06:49:08PM +0200, Andreas Gruenbacher wrote:
> Both iov_iter_get_pages and iov_iter_get_pages_alloc return the number
> of bytes of the iovec they could get the pages for.  When they cannot
> get any pages, they're supposed to return 0, but when the start of the
> iovec isn't page aligned, the calculation goes wrong and they return a
> negative value.  Fix both functions.
> 
> In addition, change iov_iter_get_pages_alloc to return NULL in that case
> to prevent resource leaks.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
