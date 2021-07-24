Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47619C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 21:57:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C14F360E0C
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 21:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C14F360E0C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OLvk07020096;
	Sat, 24 Jul 2021 21:57:46 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a09f1gv94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 21:57:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OLuiFo093065;
	Sat, 24 Jul 2021 21:57:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ysu5ck-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 21:57:43 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7PeQ-0008Ku-MC; Sat, 24 Jul 2021 14:57:42 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1m7PeM-0008KV-W4
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 14:57:39 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OLuZvu175775
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 21:57:38 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a0a6mmyrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 21:57:38 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OLrA8Q028873
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 21:57:37 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0850nxt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 21:57:37 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1m7PeC-003gMt-NK; Sat, 24 Jul 2021 21:57:28 +0000
Date: Sat, 24 Jul 2021 21:57:28 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YPyMyPCpZKGlfAGk@zeniv-ca.linux.org.uk>
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
	<YPx28cEvrVl6YrDk@zeniv-ca.linux.org.uk>
	<CAHc6FU5nGRn1_oc-8rSOCPfkasWknH1Wb3FeeQYP29zb_5fFGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5nGRn1_oc-8rSOCPfkasWknH1Wb3FeeQYP29zb_5fFGQ@mail.gmail.com>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	mlxscore=0 adultscore=0
	lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
	impostorscore=0 priorityscore=269 clxscore=269 mlxlogscore=732
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000
	definitions=main-2107240132 domainage_hfrom=9123
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxlogscore=778
	phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240133
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
 definitions=main-2107240133
X-Proofpoint-GUID: MaF_QCkvY5pmnxdh1tEGjodJRUD0N9fz
X-Proofpoint-ORIG-GUID: MaF_QCkvY5pmnxdh1tEGjodJRUD0N9fz

On Sat, Jul 24, 2021 at 11:38:20PM +0200, Andreas Gruenbacher wrote:

> Hmm, how could we have sub-page failure areas when this is about if
> and how pages are mapped? If we return the number of bytes that are
> accessible, then users will know if they got nothing, something, or
> everything, and they can act accordingly.

What I'm saying is that in situation when you have cacheline-sized
poisoned areas, there's no way to get an accurate count of readable
area other than try and copy it out.

What's more, "something" is essentially useless information - the
pages might get unmapped right as your function returns; the caller
still needs to deal with partial copies.  And that's a slow path
by definition, so informing them of a partial fault-in is not
going to be useful.

As far as callers are concerned, it's "nothing suitable in the
beginning of the area" vs. "something might be accessible".

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
