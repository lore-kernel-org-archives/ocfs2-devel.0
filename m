Return-Path: <SRS0=lQMM=NO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFD1C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 19:13:24 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D1C261214
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 19:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D1C261214
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NHLiQ7005556;
	Mon, 23 Aug 2021 19:13:23 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3akuswjg39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Aug 2021 19:13:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NJ5Rv9061383;
	Mon, 23 Aug 2021 19:13:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkvskx6-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 23 Aug 2021 19:13:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mIFNo-00077u-Fk; Mon, 23 Aug 2021 12:13:20 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mIFNj-00077T-7O
	for ocfs2-devel@oss.oracle.com; Mon, 23 Aug 2021 12:13:15 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17NJ5Odo082618
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 19:13:14 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8t90t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 19:13:13 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17NHXM6a032695
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 19:13:11 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3amg65s4uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 19:13:06 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-260-jY5f6kyNMBOQBG7m-5G33w-1; Mon, 23 Aug 2021 15:13:04 -0400
X-MC-Unique: jY5f6kyNMBOQBG7m-5G33w-1
Received: by mail-wm1-f70.google.com with SMTP id
	y188-20020a1c7dc5000000b002e80e0b2f87so104165wmc.1
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 12:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=jhaMcYrw2lrnaBdCd+giUeZH7Ccr515F+el79Rmo7nk=;
	b=A2x5nCfQHbkq3SIW6uXNjXMub+ZGfqppdrNBli3imAeCm6djj1oUjE8wQPU9WZWeBH
	JlCtqwZMWrvw7jU09Qc0lC6g3QtZtH/kp+K8Ivuv97YSWMw2wDVurABa5QC7B0ZYJRiE
	YzQkD1rcSK3O3G9byTD8qJET5u0EgRtkiEdaZsW3w244HIsxpQ4NBM5HBffJjsUOAxpe
	eIb9i+LGlCiokmnXarJgXxokCTScgUwu9C4q7A27wZskhXbKjEQo+3S4LfAjIsiApGE1
	LiM1DOUqMyS+hboCIeyJ8mnoxeuh/blFnUjhrKgS0dUKUQQqBUkfur2QERCJ9BFzSs/n
	VYPg==
X-Gm-Message-State: AOAM5336sYQ7rhDFe+zjjuYszWE2Jw9krGzqI9DgWFpUx60yHSy23h0n
	oHBDWzaCLDoehchbfab9y5/FljEttmd8YBi0FfWemF6Yf8UcySdCY3Pklmisa81r4P9d2L7cH89
	ef/Wew0ulimhMrp5BepNLRrBDNr3KzvkJOM5EpA==
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr7629138wrb.329.1629745983163;
	Mon, 23 Aug 2021 12:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOwVKSkOsp25StuMxS8Ul0aw4mKnHx9V9RP7lUqsGktvPh3lqSJ/b7aud/VYi5l7IjlqGElaqaSmdZHcnMVNk=
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr7629112wrb.329.1629745982984;
	Mon, 23 Aug 2021 12:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
	<CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
	<8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
	<CAHc6FU5uHJSXD+CQk3W9BfZmnBCd+fqHt4Bd+=uVH18rnYCPLg@mail.gmail.com>
	<YSPHR7EL/ujG0Of7@casper.infradead.org>
In-Reply-To: <YSPHR7EL/ujG0Of7@casper.infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 23 Aug 2021 21:12:51 +0200
Message-ID: <CAHc6FU4Qay6v8gRQN_ZWz0AwtuOD-BH6+Ahkgimk0L4GkWLbrQ@mail.gmail.com>
To: Matthew Wilcox <willy@infradead.org>
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
	engine=8.12.0-2107140000 definitions=main-2108230131
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Bob Peterson <rpeterso@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com
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
 definitions=main-2108230131
X-Proofpoint-ORIG-GUID: n97elATAqA7fbkCS_OnSW51r44ioOpFn
X-Proofpoint-GUID: n97elATAqA7fbkCS_OnSW51r44ioOpFn

On Mon, Aug 23, 2021 at 6:06 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, Aug 23, 2021 at 05:18:12PM +0200, Andreas Gruenbacher wrote:
> > On Mon, Aug 23, 2021 at 10:14 AM Steven Whitehouse <swhiteho@redhat.com> wrote:
> > > If the goal here is just to allow the glock to be held for a longer
> > > period of time, but with occasional interruptions to prevent
> > > starvation, then we have a potential model for this. There is
> > > cond_resched_lock() which does this for spin locks.
> >
> > This isn't an appropriate model for what I'm trying to achieve here.
> > In the cond_resched case, we know at the time of the cond_resched call
> > whether or not we want to schedule. If we do, we want to drop the spin
> > lock, schedule, and then re-acquire the spin lock. In the case we're
> > looking at here, we want to fault in user pages. There is no way of
> > knowing beforehand if the glock we're currently holding will have to
> > be dropped to achieve that. In fact, it will almost never have to be
> > dropped. But if it does, we need to drop it straight away to allow the
> > conflicting locking request to succeed.
>
> It occurs to me that this is similar to the wound/wait mutexes
> (include/linux/ww_mutex.h & Documentation/locking/ww-mutex-design.rst).
> You want to mark the glock as woundable before faulting, and then discover
> if it was wounded after faulting.  Maybe sharing this terminology will
> aid in understanding?

I've looked at the ww_mutex documentation. A "transaction" wounds
another "transaction" and that other transaction then "dies", or it
"heals" and restarts. In the glock case, a process sets and clears the
HIF_MAY_DEMOTE flag on one of its own glock holder contexts. After
clearing the flag, it either still holds the glock or it doesn't;
nothing needs to be done to "die" or to "heal". So I'm not sure we
want to conflate two concepts.

One of the earlier terms we've used was "stealing", with a
HIF_MAY_STEAL flag. That works, but it's slightly less obvious what
happens to a glock holder when the glock is stolen from it. (The
holder gets dequeued, __gfs2_glock_dq.) The glock code already uses
the terms promote/demote, acquire/release, enqueue/dequeue, and
_nq/_dq for various forms of acquiring and releasing a glock, so we're
not in a shortage or names right now apparently.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
