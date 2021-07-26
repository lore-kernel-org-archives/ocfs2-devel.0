Return-Path: <SRS0=4BH1=MS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EF4C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:09:01 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E16F60F6F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E16F60F6F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QI1qMr004573;
	Mon, 26 Jul 2021 18:09:00 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a1qkqsqhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 18:09:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QI6qC9123940;
	Mon, 26 Jul 2021 18:08:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07yvyt1p-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 18:08:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m8529-00058C-HH; Mon, 26 Jul 2021 11:08:57 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1m8526-00057v-FV
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 11:08:54 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QI6iGO040568
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:08:54 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3a0vmtfntu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:08:53 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QI5DtQ010621
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:08:52 GMT
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1rxsngcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:08:52 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 8688121F57;
	Mon, 26 Jul 2021 18:08:49 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.200.198])
	by relay2.suse.de (Postfix) with ESMTP id 2EF7DA3B81;
	Mon, 26 Jul 2021 18:08:49 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 064B31E3B13; Mon, 26 Jul 2021 20:08:48 +0200 (CEST)
Date: Mon, 26 Jul 2021 20:08:48 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Message-ID: <20210726180847.GO20621@quack2.suse.cz>
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-6-agruenba@redhat.com>
	<20210726171940.GM20621@quack2.suse.cz>
	<CAHpGcMLtQ1=WOT1mTUS4=iWBwHLQ-EBzY=+XuSGJfu4gVPYTLw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHpGcMLtQ1=WOT1mTUS4=iWBwHLQ-EBzY=+XuSGJfu4gVPYTLw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.28
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	clxscore=282
	malwarescore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
	phishscore=0 priorityscore=154 adultscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260105
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 suspectscore=0
	adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260106
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	16QI6iGO040568
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 5/7] iomap: Support restarting direct
 I/O requests after user copy failures
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260106
X-Proofpoint-GUID: mcYSDagPwEG2oWezU5bMUYGUjU5ix9iE
X-Proofpoint-ORIG-GUID: mcYSDagPwEG2oWezU5bMUYGUjU5ix9iE

On Mon 26-07-21 19:45:22, Andreas Gr=FCnbacher wrote:
> Jan Kara <jack@suse.cz> schrieb am Mo., 26. Juli 2021, 19:21:
> =

> > On Fri 23-07-21 22:58:38, Andreas Gruenbacher wrote:
> > > In __iomap_dio_rw, when iomap_apply returns an -EFAULT error, complete
> > the
> > > request synchronously and reset the iterator to the start position.  =
This
> > > allows callers to deal with the failure and retry the operation.
> > >
> > > In gfs2, we need to disable page faults while we're holding glocks to
> > prevent
> > > deadlocks.  This patch is the minimum solution I could find to make
> > > iomap_dio_rw work with page faults disabled.  It's still expensive
> > because any
> > > I/O that was carried out before hitting -EFAULT needs to be retried.
> > >
> > > A possible improvement would be to add an IOMAP_DIO_FAULT_RETRY or
> > similar flag
> > > that would allow iomap_dio_rw to return a short result when hitting
> > -EFAULT.
> > > Callers could then retry only the rest of the request after dealing w=
ith
> > the
> > > page fault.
> > >
> > > Asynchronous requests turn into synchronous requests up to the point =
of
> > the
> > > page fault in any case, but they could be retried asynchronously after
> > dealing
> > > with the page fault.  To make that work, the completion notification
> > would have
> > > to include the bytes read or written before the page fault(s) as well,
> > and we'd
> > > need an additional iomap_dio_rw argument for that.
> > >
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > ---
> > >  fs/iomap/direct-io.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > index cc0b4bc8861b..b0a494211bb4 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -561,6 +561,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_it=
er
> > *iter,
> > >               ret =3D iomap_apply(inode, pos, count, iomap_flags, ops=
, dio,
> > >                               iomap_dio_actor);
> > >               if (ret <=3D 0) {
> > > +                     if (ret =3D=3D -EFAULT) {
> > > +                             /*
> > > +                              * To allow retrying the request, fail
> > > +                              * synchronously and reset the iterator.
> > > +                              */
> > > +                             wait_for_completion =3D true;
> > > +                             iov_iter_revert(dio->submit.iter,
> > dio->size);
> > > +                     }
> > > +
> >
> > Hum, OK, but this means that if userspace submits large enough write, G=
FS2
> > will livelock trying to complete it? While other filesystems can just
> > submit multiple smaller bios constructed in iomap_apply() (paging in
> > different parts of the buffer) and thus complete the write?
> >
> =

> No. First, this affects reads but not writes. We cannot just blindly repe=
at
> writes; when a page fault occurs in the middle of a write, the result will
> be a short write. For reads, the plan is to ads a flag to allow
> iomap_dio_rw to return a partial result when a page fault occurs.
> (Currently, it fails the entire request.) Then we can handle the page fau=
lt
> and complete the rest of the request.
> =

> The changes needed for that are simple on the iomap side, but we need to =
go
> through some gymnastics for handling the page fault without giving up the
> glock in the non-contended case. There will still be the potential for
> losing the lock and having to re-acquire it, in which case we'll actually
> have to repeat the entire read.

I've missed you've already sent out v4 (I'm catching up after vacation so
my mailbox is a bit of a mess). What's in there addresses my objection.
I'm sorry for the noise.

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
