Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3B8C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 20:26:44 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EA4060E09
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 20:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EA4060E09
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OKBvoL027767;
	Sat, 24 Jul 2021 20:26:43 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a0afrrrex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 20:26:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OKOh0L137057;
	Sat, 24 Jul 2021 20:26:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ysr3sx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 20:26:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7OEK-0003rd-Vt; Sat, 24 Jul 2021 13:26:40 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1m7OEJ-0003rH-8F
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 13:26:39 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OKQZqv027617
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:26:38 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a0a6mjay8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:26:37 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OKEBQD031322
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:26:36 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0c4ecab9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:26:35 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1m7OC1-003eaC-FU; Sat, 24 Jul 2021 20:24:17 +0000
Date: Sat, 24 Jul 2021 20:24:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YPx28cEvrVl6YrDk@zeniv-ca.linux.org.uk>
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	bulkscore=0 phishscore=0
	mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
	impostorscore=0
	priorityscore=78 mlxlogscore=788 spamscore=0 clxscore=249
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
	definitions=main-2107240122 domainage_hfrom=9123
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxlogscore=842
	phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240123
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
 iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240123
X-Proofpoint-ORIG-GUID: w5ub7siehEfS5WewrcbwC1IpAvo9ntlF
X-Proofpoint-GUID: w5ub7siehEfS5WewrcbwC1IpAvo9ntlF

On Sat, Jul 24, 2021 at 12:52:34PM -0700, Linus Torvalds wrote:
> ...
> > +                       if (fault_in_user_pages(start, len, true) != len)
> > +                               return -EFAULT;
> 
> Looking at this once more, I think this is likely wrong.
> 
> Why?
> 
> Because any user can/should only care about at least *part* of the
> area being writable.
> 
> Imagine that you're doing a large read. If the *first* page is
> writable, you should still return the partial read, not -EFAULT.

Agreed.

> So I think the code needs to return 0 if _any_ fault was successful.

s/any/the first/...

The same goes for fault-in for read, of course; I've a half-baked conversion
to such semantics (-EFAULT vs. 0; precise length is unreliable anyway,
especially if you have sub-page failure areas), need to finish and post
it...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
