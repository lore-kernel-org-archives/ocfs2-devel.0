Return-Path: <SRS0=N2wx=PJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02A0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 14:42:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 628C9611CB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 14:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 628C9611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYMCG013675;
	Thu, 21 Oct 2021 14:42:56 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm59k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 14:42:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZbIr129807;
	Thu, 21 Oct 2021 14:42:55 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gw4y94-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 21 Oct 2021 14:42:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdZHR-0006g6-Bd; Thu, 21 Oct 2021 07:42:53 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mdZHP-0006fh-6q
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 07:42:51 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZLxJ173272
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 14:42:51 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3bqpj8wxam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 14:42:51 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LEB6vI031102
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 14:42:50 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bu497msy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 14:42:49 +0000
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
	[209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-230-iRecnci8PSWrrTSLJnJMNQ-1; Thu, 21 Oct 2021 10:42:47 -0400
X-MC-Unique: iRecnci8PSWrrTSLJnJMNQ-1
Received: by mail-wr1-f70.google.com with SMTP id
	j12-20020adf910c000000b0015e4260febdso260322wrj.20
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 07:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=SmEzbXtfEVt2BpM7wSrp23JreLNUFM7GXMWeh1u9ztI=;
	b=FE7I5QpPgQ/xuPugvBTNh0hqwi5nME4uRXswsFXqXG+v+8VYnXPp4gnTYfFrI2qjE0
	3xWQHKD9OfwFJEwM+YsoDJ0d+4vmfR3rFtd2RUGfwiCChaKQI50MXi4DsUGNPZYlJlMq
	/gnaNoRYfnTa+ziUZBLSGi8IuSWYPlvT4c62Qg1YkZzvdKuLPdTHJ3giTqemi1Eb8aeu
	SQeCPTkP5S8cAhQmkh1FY0i8WQAkPvbgWopr48M8aIeXM5XNVhMmxo702tvU2GrYi+Py
	10eMcqjunImA0DFzeU/5eIazNd2A5AO/Fyb1RuecFwtIBE+LkHtIdDsaYtS2+/SJ+qGp
	hbrQ==
X-Gm-Message-State: AOAM5333OyyVy94hSpeQU3HgHT321fuwCy+FQFRoBQP+GJxAelsf/KLZ
	W7xLoLPgSZQXhL/rnyqBr8TcKESt+RsXBQNgy2ygP1Dv90uXGi7TWj5gqI+k4it/mrmBo1ty5GP
	aWqYSVrWOd4UDD3vJjVoYlb+cpVkZ0s2YumEKoA==
X-Received: by 2002:adf:c78d:: with SMTP id l13mr7544015wrg.134.1634827364929; 
	Thu, 21 Oct 2021 07:42:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe9FbtIjQkoQAdC+TPuURhpm/wOA+DZOJl2uKRFfWKCj35F5i6OVE+TEzdARceI4I8WSyqjU9LUZpNOmPkJLM=
X-Received: by 2002:adf:c78d:: with SMTP id l13mr7543974wrg.134.1634827364652; 
	Thu, 21 Oct 2021 07:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
	<YXE7fhDkqJbfDk6e@arm.com>
In-Reply-To: <YXE7fhDkqJbfDk6e@arm.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 21 Oct 2021 16:42:33 +0200
Message-ID: <CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
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
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
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
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Will Deacon <will@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-GUID: 7HWEZ2OxL0qhTQJgXJx836BgVzfNRhGV
X-Proofpoint-ORIG-GUID: 7HWEZ2OxL0qhTQJgXJx836BgVzfNRhGV

On Thu, Oct 21, 2021 at 12:06 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, Oct 21, 2021 at 02:46:10AM +0200, Andreas Gruenbacher wrote:
> > On Tue, Oct 12, 2021 at 1:59 AM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > On Mon, Oct 11, 2021 at 2:08 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > >
> > > > +#ifdef CONFIG_ARM64_MTE
> > > > +#define FAULT_GRANULE_SIZE     (16)
> > > > +#define FAULT_GRANULE_MASK     (~(FAULT_GRANULE_SIZE-1))
> > >
> > > [...]
> > >
> > > > If this looks in the right direction, I'll do some proper patches
> > > > tomorrow.
> > >
> > > Looks fine to me. It's going to be quite expensive and bad for caches, though.
> > >
> > > That said, fault_in_writable() is _supposed_ to all be for the slow
> > > path when things go south and the normal path didn't work out, so I
> > > think it's fine.
> >
> > Let me get back to this; I'm actually not convinced that we need to
> > worry about sub-page-size fault granules in fault_in_pages_readable or
> > fault_in_pages_writeable.
> >
> > From a filesystem point of view, we can get into trouble when a
> > user-space read or write triggers a page fault while we're holding
> > filesystem locks, and that page fault ends up calling back into the
> > filesystem. To deal with that, we're performing those user-space
> > accesses with page faults disabled.
>
> Yes, this makes sense.
>
> > When a page fault would occur, we
> > get back an error instead, and then we try to fault in the offending
> > pages. If a page is resident and we still get a fault trying to access
> > it, trying to fault in the same page again isn't going to help and we
> > have a true error.
>
> You can't be sure the second fault is a true error. The unlocked
> fault_in_*() may race with some LRU scheme making the pte not accessible
> or a write-back making it clean/read-only. copy_to_user() with
> pagefault_disabled() fails again but that's a benign fault. The
> filesystem should re-attempt the fault-in (gup would correct the pte),
> disable page faults and copy_to_user(), potentially in an infinite loop.
> If you bail out on the second/third uaccess following a fault_in_*()
> call, you may get some unexpected errors (though very rare). Maybe the
> filesystems avoid this problem somehow but I couldn't figure it out.

Good point, we can indeed only bail out if both the user copy and the
fault-in fail.

But probing the entire memory range in fault domain granularity in the
page fault-in functions still doesn't actually make sense. Those
functions really only need to guarantee that we'll be able to make
progress eventually. From that point of view, it should be enough to
probe the first byte of the requested memory range, so when one of
those functions reports that the next N bytes should be accessible,
this really means that the first byte surely isn't permanently
inaccessible and that the rest is likely accessible. Functions
fault_in_readable and fault_in_writeable already work that way, so
this only leaves function fault_in_safe_writeable to worry about.

> > We're clearly looking at memory at a page
> > granularity; faults at a sub-page level don't matter at this level of
> > abstraction (but they do show similar error behavior). To avoid
> > getting stuck, when it gets a short result or -EFAULT, the filesystem
> > implements the following backoff strategy: first, it tries to fault in
> > a number of pages. When the read or write still doesn't make progress,
> > it scales back and faults in a single page. Finally, when that still
> > doesn't help, it gives up. This strategy is needed for actual page
> > faults, but it also handles sub-page faults appropriately as long as
> > the user-space access functions give sensible results.
>
> As I said above, I think with this approach there's a small chance of
> incorrectly reporting an error when the fault is recoverable. If you
> change it to an infinite loop, you'd run into the sub-page fault
> problem.

Yes, I see now, thanks.

> There are some places with such infinite loops: futex_wake_op(),
> search_ioctl() in the btrfs code. I still have to get my head around
> generic_perform_write() but I think we get away here because it faults
> in the page with a get_user() rather than gup (and copy_from_user() is
> guaranteed to make progress if any bytes can still be accessed).

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
