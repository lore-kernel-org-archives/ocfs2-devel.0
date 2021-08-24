Return-Path: <SRS0=WDpM=NP=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5065C4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 24 Aug 2021 08:03:19 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 916EB61246
	for <ocfs2-devel@archiver.kernel.org>; Tue, 24 Aug 2021 08:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 916EB61246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O7MDDo025089;
	Tue, 24 Aug 2021 08:03:19 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amu7vr8ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 08:03:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O7tW3I178836;
	Tue, 24 Aug 2021 08:03:17 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkwu4rr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 24 Aug 2021 08:03:17 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mIRLq-0004SO-Sc; Tue, 24 Aug 2021 01:00:06 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <swhiteho@redhat.com>) id 1mIRLJ-0004Kr-ME
	for ocfs2-devel@oss.oracle.com; Tue, 24 Aug 2021 00:59:33 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17O7tO7j187871
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 07:59:32 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8u98jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 07:59:32 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17O7jmS7007335
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 07:59:31 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3amvnhg3x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 07:59:30 +0000
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
	[209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-SPVK7EojM1WCCXwuEwTeDQ-1; Tue, 24 Aug 2021 03:59:28 -0400
X-MC-Unique: SPVK7EojM1WCCXwuEwTeDQ-1
Received: by mail-wr1-f72.google.com with SMTP id
	b7-20020a5d4d87000000b001575d1053d2so686199wru.23
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 00:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:organization:user-agent:mime-version
	:content-transfer-encoding;
	bh=LJy4JqwQsWHwjFHrTAXgfzWwLoN0LGrnWV2wmHdwLfo=;
	b=Z13UADR99aU629US/IeQv60afYF62Ekvf49nXF81cURDACy2XSlEgAkZ3T7NXiWs3R
	Bs+Xq5VxiYC3ZyW2GkOH47NGPFYywsv7op5UOC/mCRt6uhXz99tTdG/O56wdAqEQ9iyn
	mY9hP2wuDWF6TXBNBrLo03AdhtXYWJwIT8XWXgaJOtWY9E3P6IU6acDsQzqRqqDA0g6+
	ZVmPdWhmPvOOG/xZ3KEvezHhAUTAw0qy6usk52VKUONsvlFzM2/WzK1OKJSUyfLRyg6s
	YokMlvmU8vjCMoCr5ul6mnLPyFshdCkpBWXV6ysrn/TwNZgeLt8n7nWMMLu85jIQlP74
	mCJg==
X-Gm-Message-State: AOAM531/Oxer+e6HNNS7ce0BgLsrTBZSUSV3sqt6Ho0i7wkVzwTAK2t1
	zN/eCuIo4v7W5cY6ckJLCBdG6V5kjix1EY8Dx0DHY+eQqCdyfakx8dY6AdrbsGdxOhzUyq1OEeT
	Q5wRsCBN3oaEhAF+WWHBiUA==
X-Received: by 2002:a1c:40c:: with SMTP id 12mr2733044wme.158.1629791966866;
	Tue, 24 Aug 2021 00:59:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzj0PhJgg4JTvuFLgnwv/kAZGzTP9BXAmE0J1/y6sKtGk33rcQwpzh4xhgOENzEg5F5zC0g7A==
X-Received: by 2002:a1c:40c:: with SMTP id 12mr2733027wme.158.1629791966569;
	Tue, 24 Aug 2021 00:59:26 -0700 (PDT)
Received: from
	0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa
	(0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa.
	[2001:8b0:ffda:0:2059:8730:b2:c370])
	by smtp.gmail.com with ESMTPSA id r1sm428715wmn.46.2021.08.24.00.59.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Aug 2021 00:59:25 -0700 (PDT)
Message-ID: <2c0fbb32e7668844f148b12cb4711abc76f50fe4.camel@redhat.com>
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 24 Aug 2021 08:59:24 +0100
In-Reply-To: <CAHc6FU5uHJSXD+CQk3W9BfZmnBCd+fqHt4Bd+=uVH18rnYCPLg@mail.gmail.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
	<CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
	<8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
	<CAHc6FU5uHJSXD+CQk3W9BfZmnBCd+fqHt4Bd+=uVH18rnYCPLg@mail.gmail.com>
Organization: Red Hat UK Ltd
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=swhiteho@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108240054
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Bob Peterson <rpeterso@redhat.com>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240054
X-Proofpoint-GUID: WwFW3alo_qTmzBOc8l8G1y1XTpR8DH0X
X-Proofpoint-ORIG-GUID: WwFW3alo_qTmzBOc8l8G1y1XTpR8DH0X

Hi,

On Mon, 2021-08-23 at 17:18 +0200, Andreas Gruenbacher wrote:
> On Mon, Aug 23, 2021 at 10:14 AM Steven Whitehouse <
> swhiteho@redhat.com> wrote:
> > On Fri, 2021-08-20 at 17:22 +0200, Andreas Gruenbacher wrote:
> > > On Fri, Aug 20, 2021 at 3:11 PM Bob Peterson <rpeterso@redhat.com
> > > >
> > > wrote:
> > [snip]
> > > > You can almost think of this as a performance enhancement. This
> > > > concept
> > > > allows a process to hold a glock for much longer periods of
> > > > time,
> > > > at a
> > > > lower priority, for example, when gfs2_file_read_iter needs to
> > > > hold
> > > > the
> > > > glock for very long-running iterative reads.
> > > 
> > > Consider a process that allocates a somewhat large buffer and
> > > reads
> > > into it in chunks that are not page aligned. The buffer initially
> > > won't be faulted in, so we fault in the first chunk and write
> > > into
> > > it.
> > > Then, when reading the second chunk, we find that the first page
> > > of
> > > the second chunk is already present. We fill it, set the
> > > HIF_MAY_DEMOTE flag, fault in more pages, and clear the
> > > HIF_MAY_DEMOTE
> > > flag. If we then still have the glock (which is very likely), we
> > > resume the read. Otherwise, we return a short result.
> > > 
> > > Thanks,
> > > Andreas
> > > 
> > 
> > If the goal here is just to allow the glock to be held for a longer
> > period of time, but with occasional interruptions to prevent
> > starvation, then we have a potential model for this. There is
> > cond_resched_lock() which does this for spin locks.
> 
> This isn't an appropriate model for what I'm trying to achieve here.
> In the cond_resched case, we know at the time of the cond_resched
> call
> whether or not we want to schedule. If we do, we want to drop the
> spin
> lock, schedule, and then re-acquire the spin lock. In the case we're
> looking at here, we want to fault in user pages. There is no way of
> knowing beforehand if the glock we're currently holding will have to
> be dropped to achieve that. In fact, it will almost never have to be
> dropped. But if it does, we need to drop it straight away to allow
> the
> conflicting locking request to succeed.
> 
> Have a look at how the patch queue uses gfs2_holder_allow_demote()
> and
> gfs2_holder_disallow_demote():
> 
> https://listman.redhat.com/archives/cluster-devel/2021-August/msg00128.html
> https://listman.redhat.com/archives/cluster-devel/2021-August/msg00134.html
> 
> Thanks,
> Andreas
> 

Ah, now I see! Apologies if I've misunderstood the intent here,
initially. It is complicated and not so obvious - at least to me!

You've added a lot of context to this patch in your various replies on
this thread. The original patch description explains how the feature is
implemented, but doesn't really touch on why - that is left to the
other patches that you pointed to above. A short paragraph or two on
the "why" side of things added to the patch description would be
helpful I think.

Your message on Friday (20 Aug 2021 15:17:41 +0200 (20/08/21 14:17:41))
has a good explanation in the second part of it, which with what you've
said above (or similar) would be a good basis.

Apologies again for not understanding what is going on,

Steve.



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
