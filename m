Return-Path: <SRS0=AMvx=PR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C228C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 12:57:15 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98F8760F0F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 12:57:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98F8760F0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TCTvIb014452;
	Fri, 29 Oct 2021 12:57:14 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byedarvhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Oct 2021 12:57:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TCqAUa069993;
	Fri, 29 Oct 2021 12:57:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4h5shx3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Oct 2021 12:57:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mgRLO-0004K9-Ok; Fri, 29 Oct 2021 05:50:50 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mgRKx-00049r-41
	for ocfs2-devel@oss.oracle.com; Fri, 29 Oct 2021 05:50:23 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TCjNqR036876
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 12:50:23 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bx4gd2h1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 12:50:22 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19T736V0016608
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 12:50:21 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c058w7ne9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 12:50:21 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAE10611CC;
	Fri, 29 Oct 2021 12:50:09 +0000 (UTC)
Date: Fri, 29 Oct 2021 13:50:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Message-ID: <YXvt/mNABVv6a5nO@arm.com>
References: <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
	<YXmkvfL9B+4mQAIo@arm.com>
	<CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
	<YXsUNMWFpmT1eQcX@arm.com>
	<CAHpGcMLeiXSjCJGY6SCJJ=bdNOspHLHofmTE8aC_sZtfHRG5ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHpGcMLeiXSjCJGY6SCJJ=bdNOspHLHofmTE8aC_sZtfHRG5ZA@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	19TCjNqR036876
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
	deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290076
X-Proofpoint-ORIG-GUID: Ms9rY9sLn4mo72hZiro6uUrt0PvghUM_
X-Proofpoint-GUID: Ms9rY9sLn4mo72hZiro6uUrt0PvghUM_

On Fri, Oct 29, 2021 at 12:15:55AM +0200, Andreas Gr=FCnbacher wrote:
> Am Do., 28. Okt. 2021 um 23:21 Uhr schrieb Catalin Marinas
> <catalin.marinas@arm.com>:
> > I think for nested contexts we can save the uaccess fault state on
> > exception entry, restore it on return. Or (needs some thinking on
> > atomicity) save it in a local variable. The high-level API would look
> > something like:
> >
> >         unsigned long uaccess_flags;    /* we could use TIF_ flags */
> >
> >         uaccess_flags =3D begin_retriable_uaccess();
> >         copied =3D copy_page_from_iter_atomic(...);
> >         retry =3D end_retriable_uaccess(uaccess_flags);
> >         ...
> >
> >         if (!retry)
> >                 break;
> >
> > I think we'd need a TIF flag to mark the retriable region and another to
> > track whether a non-recoverable fault occurred. It needs prototyping.
> >
> > Anyway, if you don't like this approach, I'll look at error codes being
> > returned but rather than changing all copy_from_user() etc., introduce a
> > new API that returns different error codes depending on the fault
> > (e.g -EFAULT vs -EACCES). We already have copy_from_user_nofault(), we'd
> > need something for the iov_iter stuff to use in the fs code.
> =

> We won't need any of that on the filesystem read and write paths. The
> two cases there are buffered and direct I/O:

Thanks for the clarification, very useful.

> * In the buffered I/O case, the copying happens with page faults
> disabled, at a byte granularity. If that returns a short result, we
> need to enable page faults, check if the exact address that failed
> still fails (in which case we have a sub-page fault),  fault in the
> pages, disable page faults again, and repeat. No probing for sub-page
> faults beyond the first byte of the fault-in address is needed.
> Functions fault_in_{readable,writeable} implicitly have this behavior;
> for fault_in_safe_writeable() the choice we have is to either add
> probing of the first byte for sub-page faults to this function or
> force callers to do that probing separately. At this point, I'd vote
> for the former.

This sounds fine to me (and I have some draft patches already on top of
your series).

> * In the direct I/O case, the copying happens while we're holding page
> references, so the only page faults that can occur during copying are
> sub-page faults.

Does holding a page reference guarantee that the user pte pointing to
such page won't change, for example a pte_mkold()? I assume for direct
I/O, the PG_locked is not held. But see below, it may not be relevant.

> When iomap_dio_rw or its legacy counterpart is called
> with page faults disabled, we need to make sure that the caller can
> distinguish between page faults triggered during
> bio_iov_iter_get_pages() and during the copying, but that's a separate
> problem. (At the moment, when iomap_dio_rw fails with -EFAULT, the
> caller *cannot* distinguish between a bio_iov_iter_get_pages failure
> and a failure during synchronous copying, but that could be fixed by
> returning unique error codes from iomap_dio_rw.)

Since the direct I/O pins the pages in memory, does it even need to do a
uaccess? It could copy the data via the kernel mapping (kmap). For arm64
MTE, all such accesses are not checked (they use a match-all pointer
tag) since the kernel is not set up to handle such sub-page faults (no
copy_from/to_user but a direct access).

> So as far as I can see, the only problematic case we're left with is
> copying bigger than byte-size chunks with page faults disabled when we
> don't know whether the underlying pages are resident or not. My guess
> would be that in this case, if the copying fails, it would be
> perfectly acceptable to explicitly probe the entire chunk for sub-page
> faults.

Yeah, if there are only a couple of places left, we can add the explicit
probing (via some probe_user_writable function).

-- =

Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
