Return-Path: <SRS0=N2wx=PJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF74C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 10:09:15 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7941C610C8
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 10:09:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7941C610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L90eAI009476;
	Thu, 21 Oct 2021 10:09:15 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqypm6gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 10:09:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LA1ck1085364;
	Thu, 21 Oct 2021 10:09:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkv1jyr7-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 21 Oct 2021 10:09:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdUxV-00013U-Kh; Thu, 21 Oct 2021 03:06:01 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mdUxS-000133-Ry
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 03:05:58 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LA0wLl178186
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 10:05:58 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bqmshv42g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 10:05:58 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19L91uA3004562
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 10:05:57 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bu57g0m4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 10:05:57 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064A8610FF;
	Thu, 21 Oct 2021 10:05:53 +0000 (UTC)
Date: Thu, 21 Oct 2021 11:05:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YXE7fhDkqJbfDk6e@arm.com>
References: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210051
X-Proofpoint-ORIG-GUID: KzpShKbUbbYgqOnKJdaze5C9AA4vY2z6
X-Proofpoint-GUID: KzpShKbUbbYgqOnKJdaze5C9AA4vY2z6

On Thu, Oct 21, 2021 at 02:46:10AM +0200, Andreas Gruenbacher wrote:
> On Tue, Oct 12, 2021 at 1:59 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Mon, Oct 11, 2021 at 2:08 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > >
> > > +#ifdef CONFIG_ARM64_MTE
> > > +#define FAULT_GRANULE_SIZE     (16)
> > > +#define FAULT_GRANULE_MASK     (~(FAULT_GRANULE_SIZE-1))
> >
> > [...]
> >
> > > If this looks in the right direction, I'll do some proper patches
> > > tomorrow.
> >
> > Looks fine to me. It's going to be quite expensive and bad for caches, though.
> >
> > That said, fault_in_writable() is _supposed_ to all be for the slow
> > path when things go south and the normal path didn't work out, so I
> > think it's fine.
> 
> Let me get back to this; I'm actually not convinced that we need to
> worry about sub-page-size fault granules in fault_in_pages_readable or
> fault_in_pages_writeable.
> 
> From a filesystem point of view, we can get into trouble when a
> user-space read or write triggers a page fault while we're holding
> filesystem locks, and that page fault ends up calling back into the
> filesystem. To deal with that, we're performing those user-space
> accesses with page faults disabled.

Yes, this makes sense.

> When a page fault would occur, we
> get back an error instead, and then we try to fault in the offending
> pages. If a page is resident and we still get a fault trying to access
> it, trying to fault in the same page again isn't going to help and we
> have a true error.

You can't be sure the second fault is a true error. The unlocked
fault_in_*() may race with some LRU scheme making the pte not accessible
or a write-back making it clean/read-only. copy_to_user() with
pagefault_disabled() fails again but that's a benign fault. The
filesystem should re-attempt the fault-in (gup would correct the pte),
disable page faults and copy_to_user(), potentially in an infinite loop.
If you bail out on the second/third uaccess following a fault_in_*()
call, you may get some unexpected errors (though very rare). Maybe the
filesystems avoid this problem somehow but I couldn't figure it out.

> We're clearly looking at memory at a page
> granularity; faults at a sub-page level don't matter at this level of
> abstraction (but they do show similar error behavior). To avoid
> getting stuck, when it gets a short result or -EFAULT, the filesystem
> implements the following backoff strategy: first, it tries to fault in
> a number of pages. When the read or write still doesn't make progress,
> it scales back and faults in a single page. Finally, when that still
> doesn't help, it gives up. This strategy is needed for actual page
> faults, but it also handles sub-page faults appropriately as long as
> the user-space access functions give sensible results.

As I said above, I think with this approach there's a small chance of
incorrectly reporting an error when the fault is recoverable. If you
change it to an infinite loop, you'd run into the sub-page fault
problem.

There are some places with such infinite loops: futex_wake_op(),
search_ioctl() in the btrfs code. I still have to get my head around
generic_perform_write() but I think we get away here because it faults
in the page with a get_user() rather than gup (and copy_from_user() is
guaranteed to make progress if any bytes can still be accessed).

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
