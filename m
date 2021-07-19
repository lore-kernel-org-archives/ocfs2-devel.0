Return-Path: <SRS0=S1qZ=ML=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BD1C07E9B
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 20:23:17 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0C346024A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 20:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0C346024A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JKC0Z3009884;
	Mon, 19 Jul 2021 20:23:15 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfs1t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jul 2021 20:23:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JKGEqi003984;
	Mon, 19 Jul 2021 20:23:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39v8ytcw5t-1;
	Mon, 19 Jul 2021 20:23:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5ZkB-0000tK-CP; Mon, 19 Jul 2021 13:20:03 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1m5Zk8-0000no-6L
	for ocfs2-devel@oss.oracle.com; Mon, 19 Jul 2021 13:20:00 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16JKF3l2160397
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 20:20:00 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 39uq15c85v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 20:19:59 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16JKCIqW022234
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 20:19:58 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 39w4k7xcvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 20:19:58 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1m5Zhu-0027kw-64; Mon, 19 Jul 2021 20:17:42 +0000
Date: Mon, 19 Jul 2021 20:17:42 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YPXd5gKCjhr3thJ/@zeniv-ca.linux.org.uk>
References: <20210718223932.2703330-1-agruenba@redhat.com>
	<20210718223932.2703330-6-agruenba@redhat.com>
	<CAHk-=wh3p41a-=7FFf36sYBQP750ys6CKi0S7JNiCSatY5-7og@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wh3p41a-=7FFf36sYBQP750ys6CKi0S7JNiCSatY5-7og@mail.gmail.com>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	adultscore=0
	mlxlogscore=999 mlxscore=0 priorityscore=70 malwarescore=0
	lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=228 phishscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190115
	domainage_hfrom=9118
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	malwarescore=0
	mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190115
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 5/6] iov_iter: Introduce
	ITER_FLAG_FAST_ONLY flag
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190115
X-Proofpoint-GUID: 9_y60r9DTDmGVhI23Dn_wsxfYnjbED1b
X-Proofpoint-ORIG-GUID: 9_y60r9DTDmGVhI23Dn_wsxfYnjbED1b

On Mon, Jul 19, 2021 at 12:29:35PM -0700, Linus Torvalds wrote:
> On Sun, Jul 18, 2021 at 3:40 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> >
> > Introduce a new ITER_FLAG_FAST_ONLY flag
> 
> I think the code is fine, but I think it might be best to call this
> "ITER_FLAG_NOIO" or something like that.
> 
> The "FAST_ONLY" name makes sense in the context of
> "get_user_pages_fast()" where we have that "fast" naming (and the long
> history too). But I don't think it makes much sense as a name in the
> context of iov_iter.

This code has never been tested with current lib/iov_iter.c as it is
in mainline.  Or had been in -next during the last cycle.  It won't
apply at all.

Sure, I can try to port that series over to the current mainline, but
I'd rather see that done (and tested) by the series author...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
