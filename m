Return-Path: <SRS0=lQMM=NO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B65EC4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 08:15:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3905961372
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 08:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3905961372
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17N87tco008761;
	Mon, 23 Aug 2021 08:15:34 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3akwcf8r4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Aug 2021 08:15:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17N8BRej007966;
	Mon, 23 Aug 2021 08:15:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkus8ws-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 23 Aug 2021 08:15:32 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mI57D-0000RU-GA; Mon, 23 Aug 2021 01:15:31 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <swhiteho@redhat.com>) id 1mI56f-0000QP-LO
	for ocfs2-devel@oss.oracle.com; Mon, 23 Aug 2021 01:14:57 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17N8BLlR005504
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 08:14:57 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8s887f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 08:14:56 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17N4ahcq006804
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 08:14:55 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3akrex6s72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 08:14:55 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-43-fEgozZifNCG6KO7v7B3vdw-1; Mon, 23 Aug 2021 04:14:52 -0400
X-MC-Unique: fEgozZifNCG6KO7v7B3vdw-1
Received: by mail-wm1-f70.google.com with SMTP id
	r11-20020a05600c35cb00b002e706077614so3894674wmq.5
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 01:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:organization:user-agent:mime-version
	:content-transfer-encoding;
	bh=sAS3UII3BoCLendYghwp+E5/qpLsis2DFPR6GELCxPg=;
	b=BtO4c5LxOlD6JEiM3LQyc75br6/Sj4PegWIYTrN4kSA7qxDLxGw5H8rTFzA3kI3231
	dFtRvjoxppnOER6MKqap9XRwglK06nRYRG599y6YaY5D58Du4cVnHW8CfRENLahzWW7V
	Rohu/ZiW3eKwUJTM4KzXLpORvITB8JmmqC97wMgb/r5R73oKZ16vEBHpKWxMfwW8G4Du
	APK4p9/rONuOMGDlEXoK1T6QOqx/V7j/MLy5NeoQ13xNNAySU/GCqKsLAhKZHZj5B9Fa
	d4eifL2G0xjgqZkyw6i90OvfFKAzyoS6Fw5AG6DmCfCAXm0BtmH9QxbDNiy0hD+uh1Ib
	4EjA==
X-Gm-Message-State: AOAM53361rhOuxIOYjb5U+2H2LoKD27nRuuX/fIQNilo2NsQOajYrrDf
	EctxSi31XtojbjbaUOdaC1dm/JDEtmvol3dYnN4K4qffJXGqCYbvOfm8WPazrNLqUbpS8ib54JD
	XPQCVsCAWDb92J6iNR/ZsvQ==
X-Received: by 2002:adf:e910:: with SMTP id f16mr6700313wrm.393.1629706491886; 
	Mon, 23 Aug 2021 01:14:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9tWYyiX6YvxpM93MetANrNoX2lZvyAZMJH8SnDUJVD31ZiO7K1OFWJvibdiL9k2vCA5llew==
X-Received: by 2002:adf:e910:: with SMTP id f16mr6700299wrm.393.1629706491736; 
	Mon, 23 Aug 2021 01:14:51 -0700 (PDT)
Received: from
	0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa
	(0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa.
	[2001:8b0:ffda:0:2059:8730:b2:c370])
	by smtp.gmail.com with ESMTPSA id
	f2sm14085343wru.31.2021.08.23.01.14.51
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 23 Aug 2021 01:14:51 -0700 (PDT)
Message-ID: <8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson
	<rpeterso@redhat.com>
Date: Mon, 23 Aug 2021 09:14:50 +0100
In-Reply-To: <CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
	<CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10084
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10084
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108230055
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10084 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230055
X-Proofpoint-GUID: Hw_JGrnUEGr9Q6JJLio1Df7NTLRJZ_Jx
X-Proofpoint-ORIG-GUID: Hw_JGrnUEGr9Q6JJLio1Df7NTLRJZ_Jx

On Fri, 2021-08-20 at 17:22 +0200, Andreas Gruenbacher wrote:
> On Fri, Aug 20, 2021 at 3:11 PM Bob Peterson <rpeterso@redhat.com>
> wrote:
> > 
[snip]
> > 
> > You can almost think of this as a performance enhancement. This
> > concept
> > allows a process to hold a glock for much longer periods of time,
> > at a
> > lower priority, for example, when gfs2_file_read_iter needs to hold
> > the
> > glock for very long-running iterative reads.
> 
> Consider a process that allocates a somewhat large buffer and reads
> into it in chunks that are not page aligned. The buffer initially
> won't be faulted in, so we fault in the first chunk and write into
> it.
> Then, when reading the second chunk, we find that the first page of
> the second chunk is already present. We fill it, set the
> HIF_MAY_DEMOTE flag, fault in more pages, and clear the
> HIF_MAY_DEMOTE
> flag. If we then still have the glock (which is very likely), we
> resume the read. Otherwise, we return a short result.
> 
> Thanks,
> Andreas
> 

If the goal here is just to allow the glock to be held for a longer
period of time, but with occasional interruptions to prevent
starvation, then we have a potential model for this. There is
cond_resched_lock() which does this for spin locks. So perhaps we might
do something similar:

/**
 * gfs2_glock_cond_regain - Conditionally drop and regain glock
 * @gl: The glock
 * @gh: A granted holder for the glock
 *
 * If there is a pending demote request for this glock, drop and 
 * requeue a lock request for this glock. If there is no pending
 * demote request, this is a no-op. In either case the glock is
 * held on both entry and exit.
 *
 * Returns: 0 if no pending demote, 1 if lock dropped and regained
 */
int gfs2_glock_cond_regain(struct gfs2_glock *gl, struct gfs2_holder
*gh);

That seems more easily understood, and clearly documents places where
the lock may be dropped and regained. I think that the implementation
should be simpler and cleaner, compared with the current proposed
patch. There are only two bit flags related to pending demotes, for
example, so the check should be trivial.

It may need a few changes depending on the exact circumstances, but
hopefully that illustrates the concept,

Steve.




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
