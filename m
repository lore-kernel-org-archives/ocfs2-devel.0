Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6985AC4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 14:47:05 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 14E3261101
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 14:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14E3261101
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KEgcBD032015;
	Fri, 20 Aug 2021 14:47:04 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aje2j029t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 14:47:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KEjElE119551;
	Fri, 20 Aug 2021 14:47:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aje12sjd4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 14:47:03 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH5kO-0005OE-Ks; Fri, 20 Aug 2021 07:43:52 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1mH5kM-0005No-E9
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 07:43:50 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KEZStq083951
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:43:50 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3aje12scud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:43:50 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KEffZY026135
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:43:49 GMT
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
	[209.85.166.41])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahs0n03h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:43:48 +0000
Received: by mail-io1-f41.google.com with SMTP id i7so12619579iow.1
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 07:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=zWMM/5S4dFOu/WD5ECEAYdeBKl4z45VntP0JWXoYfUw=;
	b=e+ybJQjU/6m2HEFmrmd3VxI2rrMJP7gEm11t5dneEJSdX+H/JcTn1SwGLvbpDPVTmH
	Bh5tLfu/+Yfn2HWF+X+X11iUz/WRwcR3T2SwwYJolQy1ElVq3nfYmuwZ3VQk6tNyFihX
	A0B7Xhp+0hXHxZuTt274fCWl/z51uF9ES8Lx5UrEiwOYvcXa1q0xE7kUk5ezjXNcfvz/
	TtUM9u3aE3Jt7uIFDZCkkBonEJsUPki/bCHrLhuO/WY2L1ZPeXnFCzf0GUSCuHwGM4q5
	dGcehHuGZvtb+gJUybow+oS/1/C8s2CtVUVMbUmaw9CvDOxQY5jtb7Fiho8M5GpLJQbp
	ZxrQ==
X-Gm-Message-State: AOAM532IcWkloAvWEgf8qWL+Jdoh1jGwnuuReZR6GJ6NZE4v97KOjkl2
	jjzaKasu9xCJhuphfUN6fWBYkhI+krGJFfkWjkU=
X-Google-Smtp-Source: ABdhPJzOk9dUXsN4s4KGdaDemx/wIgj5uCLKt6CfKvzXNaaMS+7QqZjwN6w29MmItaj9l67c72f3RtIl+DIu84YdWEM=
X-Received: by 2002:a02:7a15:: with SMTP id a21mr14609694jac.128.1629470627371;
	Fri, 20 Aug 2021 07:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<CAHc6FU7jz9z9FEu3gY0S2A2Rv6cQJzp7p_5NOnU3b8Zpz+QsVg@mail.gmail.com>
	<d5fbfeff64cee4a2045e4e53abbd205618888044.camel@redhat.com>
In-Reply-To: <d5fbfeff64cee4a2045e4e53abbd205618888044.camel@redhat.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Fri, 20 Aug 2021 16:43:34 +0200
Message-ID: <CAHpGcMJTPfJ3M8SjMgv88xkbJLy8mhXTGEkWy8WjXM0NBcsZ1A@mail.gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
X-Source-IP: 209.85.166.41
X-ServerName: mail-io1-f41.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	bulkscore=0
	mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
	phishscore=0
	spamscore=0 priorityscore=357 clxscore=183 adultscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200082
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 suspectscore=0
	phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200081
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH v6 10/19] gfs2: Introduce
 flag for glock holder auto-demotion
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200082
X-Proofpoint-GUID: eVZ3R-p7lSJaNi9JqAZr15GWm1BJjRcY
X-Proofpoint-ORIG-GUID: eVZ3R-p7lSJaNi9JqAZr15GWm1BJjRcY

Am Fr., 20. Aug. 2021 um 15:49 Uhr schrieb Steven Whitehouse
<swhiteho@redhat.com>:
> We always used to manage to avoid holding fs locks when copying to/from userspace
> to avoid these complications.

I realize the intent, but that goal has never actually been achieved.
Direct I/O has *always* been calling get_user_pages() while holding
the inode glock in deferred mode.

The situation is slightly different for buffered I/O, but we have the
same problem there at least since switching to iomap. (And it's a
fundamental property of iomap that we want to hold the inode glock
across multi-page mappings, not an implementation deficit.)

Here's a slightly outdated version of a test case that makes all
versions of gfs2 prior to this patch queue unhappy:
https://lore.kernel.org/fstests/20210531152604.240462-1-agruenba@redhat.com/

Thanks,
Andreas

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
