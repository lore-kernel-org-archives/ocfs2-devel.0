Return-Path: <SRS0=lQMM=NO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA1AC432BE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:18:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A82E560F92
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A82E560F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEclu3024913;
	Mon, 23 Aug 2021 15:18:40 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm1u5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Aug 2021 15:18:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NFFUBD031034;
	Mon, 23 Aug 2021 15:18:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkvdra0-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 23 Aug 2021 15:18:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mIBie-0003qq-LE; Mon, 23 Aug 2021 08:18:36 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mIBiY-0003qW-Qs
	for ocfs2-devel@oss.oracle.com; Mon, 23 Aug 2021 08:18:30 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17NFFUD8031126
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 15:18:30 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3ajpkvdr2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 15:18:30 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17NCmrWj027601
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 15:18:29 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3akrf4k3fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 15:18:28 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-357-AoAPFD_pPWS2XOckW28GWA-1; Mon, 23 Aug 2021 11:18:25 -0400
X-MC-Unique: AoAPFD_pPWS2XOckW28GWA-1
Received: by mail-wm1-f70.google.com with SMTP id
	y23-20020a7bcd97000000b002e6e4a2a332so3107297wmj.0
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 08:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=8UQPHdxCvb0Ewfa1Oz5Y/LDOGEQHYeTGsDvKMf5nPfA=;
	b=gNdbGIuhQaFOrU6KQh5+GJfb8j4lcsQC3AEoE8jwLqwH0DNhpTGOGYwZZPsRKm/n+a
	Cwc47NQC1vZPexs2XhsgjLjm4+gZkfg3EmTFcB9Tzaeo/53TmnQSYYJudT121VekN+GJ
	7li6CF+GElVrLbIW3efHvKw3AKYY9giWCsAZGS9rTLuB1W00i7EgrLmIRu8LgJHINgxU
	Wx6I9xk2rY76+Ft11pOqfyFYlLpyYD82gFPEtxNnLfgPVgA4rjaovD6YLRss+0lRDUYD
	B7R0QFeFUp5rQ2QlFJbx4fp1vTfH2cMPX5Pb4ekTsmspM8zvoP+BlKOhQnZcRNwL2/DY
	UFFw==
X-Gm-Message-State: AOAM532tI4XweQAGqk9c0SdmLzZhQ17r0t3URm1kjT/iBrbPRLQGo+pC
	3Ut9itm0FXHQ2GpmhKvotLSk8cwHVn2wKJKkrdNC4RbENTkZtuB0vR/DObE69n1vhys+m0X9+9J
	UcTnPSm15P0HIEn27VSNGJV9gjdm8q9/Uga/AMA==
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr6615041wrb.329.1629731904222;
	Mon, 23 Aug 2021 08:18:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP18KupeQocqPi7pOs/GkS6DYQwd2BMjtkeQW4SttZsY2aCuhDw4kt4ORRQF7kvquqp7Y+qyQBLWafEIaQ/7o=
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr6615019wrb.329.1629731904039;
	Mon, 23 Aug 2021 08:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
	<CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
	<8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
In-Reply-To: <8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 23 Aug 2021 17:18:12 +0200
Message-ID: <CAHc6FU5uHJSXD+CQk3W9BfZmnBCd+fqHt4Bd+=uVH18rnYCPLg@mail.gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
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
X-Source-IP: 216.205.24.124
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108230106
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
 definitions=main-2108230106
X-Proofpoint-ORIG-GUID: cougSisVysxH6x9jUxPnNatvtTdte1ap
X-Proofpoint-GUID: cougSisVysxH6x9jUxPnNatvtTdte1ap

On Mon, Aug 23, 2021 at 10:14 AM Steven Whitehouse <swhiteho@redhat.com> wrote:
> On Fri, 2021-08-20 at 17:22 +0200, Andreas Gruenbacher wrote:
> > On Fri, Aug 20, 2021 at 3:11 PM Bob Peterson <rpeterso@redhat.com>
> > wrote:
> > >
> [snip]
> > >
> > > You can almost think of this as a performance enhancement. This
> > > concept
> > > allows a process to hold a glock for much longer periods of time,
> > > at a
> > > lower priority, for example, when gfs2_file_read_iter needs to hold
> > > the
> > > glock for very long-running iterative reads.
> >
> > Consider a process that allocates a somewhat large buffer and reads
> > into it in chunks that are not page aligned. The buffer initially
> > won't be faulted in, so we fault in the first chunk and write into
> > it.
> > Then, when reading the second chunk, we find that the first page of
> > the second chunk is already present. We fill it, set the
> > HIF_MAY_DEMOTE flag, fault in more pages, and clear the
> > HIF_MAY_DEMOTE
> > flag. If we then still have the glock (which is very likely), we
> > resume the read. Otherwise, we return a short result.
> >
> > Thanks,
> > Andreas
> >
>
> If the goal here is just to allow the glock to be held for a longer
> period of time, but with occasional interruptions to prevent
> starvation, then we have a potential model for this. There is
> cond_resched_lock() which does this for spin locks.

This isn't an appropriate model for what I'm trying to achieve here.
In the cond_resched case, we know at the time of the cond_resched call
whether or not we want to schedule. If we do, we want to drop the spin
lock, schedule, and then re-acquire the spin lock. In the case we're
looking at here, we want to fault in user pages. There is no way of
knowing beforehand if the glock we're currently holding will have to
be dropped to achieve that. In fact, it will almost never have to be
dropped. But if it does, we need to drop it straight away to allow the
conflicting locking request to succeed.

Have a look at how the patch queue uses gfs2_holder_allow_demote() and
gfs2_holder_disallow_demote():

https://listman.redhat.com/archives/cluster-devel/2021-August/msg00128.html
https://listman.redhat.com/archives/cluster-devel/2021-August/msg00134.html

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
