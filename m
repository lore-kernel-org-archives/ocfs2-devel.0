Return-Path: <SRS0=+lI3=PA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC247C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:31:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CBA060EFE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6CBA060EFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CGo0Um007290;
	Tue, 12 Oct 2021 17:31:20 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmq2vs50e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Oct 2021 17:31:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CHFMpw028180;
	Tue, 12 Oct 2021 17:30:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bkyv99df5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 12 Oct 2021 17:30:53 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1maLZ1-0003hW-W1; Tue, 12 Oct 2021 10:27:43 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1maLYZ-0003gc-92
	for ocfs2-devel@oss.oracle.com; Tue, 12 Oct 2021 10:27:15 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CHGedk183754
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:27:15 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bkyxs20ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:27:15 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19CGXCEu023998
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:27:14 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bndyv8u9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:27:13 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EB460EFE;
	Tue, 12 Oct 2021 17:27:09 +0000 (UTC)
Date: Tue, 12 Oct 2021 18:27:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YWXFagjRVdNanGSy@arm.com>
References: <CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120095
X-Proofpoint-GUID: NfUz9mogweQgLF8mKMryMYH0zUuQxpSG
X-Proofpoint-ORIG-GUID: NfUz9mogweQgLF8mKMryMYH0zUuQxpSG

On Mon, Oct 11, 2021 at 04:59:28PM -0700, Linus Torvalds wrote:
> On Mon, Oct 11, 2021 at 2:08 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > +#ifdef CONFIG_ARM64_MTE
> > +#define FAULT_GRANULE_SIZE     (16)
> > +#define FAULT_GRANULE_MASK     (~(FAULT_GRANULE_SIZE-1))
> 
> [...]
> 
> > If this looks in the right direction, I'll do some proper patches
> > tomorrow.
> 
> Looks fine to me. It's going to be quite expensive and bad for caches,
> though.
> 
> That said, fault_in_writable() is _supposed_ to all be for the slow
> path when things go south and the normal path didn't work out, so I
> think it's fine.
> 
> I do wonder how the sub-page granularity works. Is it sufficient to
> just read from it?

For arm64 MTE and I think SPARC ADI, just reading should be sufficient.
There is CHERI in the long run, if it takes off, where the user can set
independent read/write permissions and uaccess would use the capability
rather than a match-all pointer (hence checked).

> Because then a _slightly_ better option might be to
> do one write per page (to catch page table writability) and then one
> read per "granule" (to catch pointer coloring or cache poisoning
> issues)?
> 
> That said, since this is all preparatory to us wanting to write to it
> eventually anyway, maybe marking it all dirty in the caches is only
> good.

It depends on how much would be written in the actual copy. For
significant memcpy on arm CPUs, write streaming usually kicks in and the
cache dirtying is skipped. This probably matters more for
copy_page_to_iter_iovec() than the btrfs search ioctl.

Apart from fault_in_pages_*(), there's also fault_in_user_writeable()
called from the futex code which uses the GUP mechanism as the write
would be destructive. It looks like it could potentially trigger the
same infinite loop on -EFAULT. For arm64 MTE, we get away with this by
disabling the tag checking around the arch futex code (we did it for an
unrelated issue - we don't have LDXR/STXR that would run with user
permissions in kernel mode like we do with LDTR/STTR).

I wonder whether we should actually just disable tag checking around the
problematic accesses. What these callers seem to have in common is using
pagefault_disable/enable(). We could abuse this to disable tag checking
or maybe in_atomic() when handling the exception to lazily disable such
faults temporarily.

A more invasive change would be to return a different error for such
faults like -EACCESS and treat them differently in the caller.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
