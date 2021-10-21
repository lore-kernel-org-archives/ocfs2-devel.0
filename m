Return-Path: <SRS0=N2wx=PJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51D2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:09:39 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6918B61A0C
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6918B61A0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LGi3U3030729;
	Thu, 21 Oct 2021 17:09:38 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkxa0431-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 17:09:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LH5dKl049740;
	Thu, 21 Oct 2021 17:09:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gwd4bu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 21 Oct 2021 17:09:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdbZQ-00060N-4G; Thu, 21 Oct 2021 10:09:36 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mdbZN-0005zz-PO
	for ocfs2-devel@oss.oracle.com; Thu, 21 Oct 2021 10:09:33 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LH7FxU098929
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 17:09:33 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3bqpj95fy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 17:09:33 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LFbgvG011544
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 17:09:32 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bub0q9744-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 17:09:32 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA4EE61A0A;
	Thu, 21 Oct 2021 17:09:28 +0000 (UTC)
Date: Thu, 21 Oct 2021 18:09:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YXGexrdprC+NTslm@arm.com>
References: <YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
	<YXE7fhDkqJbfDk6e@arm.com>
	<CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
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
 definitions=main-2110210085
X-Proofpoint-ORIG-GUID: 14pgdmWXlb017ZF8THmr5J2VZF0kdyeN
X-Proofpoint-GUID: 14pgdmWXlb017ZF8THmr5J2VZF0kdyeN

On Thu, Oct 21, 2021 at 04:42:33PM +0200, Andreas Gruenbacher wrote:
> On Thu, Oct 21, 2021 at 12:06 PM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Oct 21, 2021 at 02:46:10AM +0200, Andreas Gruenbacher wrote:
> > > When a page fault would occur, we
> > > get back an error instead, and then we try to fault in the offending
> > > pages. If a page is resident and we still get a fault trying to access
> > > it, trying to fault in the same page again isn't going to help and we
> > > have a true error.
> >
> > You can't be sure the second fault is a true error. The unlocked
> > fault_in_*() may race with some LRU scheme making the pte not accessible
> > or a write-back making it clean/read-only. copy_to_user() with
> > pagefault_disabled() fails again but that's a benign fault. The
> > filesystem should re-attempt the fault-in (gup would correct the pte),
> > disable page faults and copy_to_user(), potentially in an infinite loop.
> > If you bail out on the second/third uaccess following a fault_in_*()
> > call, you may get some unexpected errors (though very rare). Maybe the
> > filesystems avoid this problem somehow but I couldn't figure it out.
> 
> Good point, we can indeed only bail out if both the user copy and the
> fault-in fail.
> 
> But probing the entire memory range in fault domain granularity in the
> page fault-in functions still doesn't actually make sense. Those
> functions really only need to guarantee that we'll be able to make
> progress eventually. From that point of view, it should be enough to
> probe the first byte of the requested memory range, so when one of
> those functions reports that the next N bytes should be accessible,
> this really means that the first byte surely isn't permanently
> inaccessible and that the rest is likely accessible. Functions
> fault_in_readable and fault_in_writeable already work that way, so
> this only leaves function fault_in_safe_writeable to worry about.

I agree, that's why generic_perform_write() works. It does a get_user()
from the first byte in that range and the subsequent copy_from_user()
will make progress of at least one byte if it was readable. Eventually
it will hit the byte that faults. The gup-based fault_in_*() are a bit
more problematic.

Your series introduces fault_in_safe_writeable() and I think for MTE
doing a _single_ get_user(uaddr) (in addition to the gup checks for
write) would be sufficient as long as generic_file_read_iter() advances
by at least one byte (eventually).

This discussion started with the btrfs search_ioctl() where, even if
some bytes were written in copy_to_sk(), it always restarts from an
earlier position, reattempting to write the same bytes. Since
copy_to_sk() doesn't guarantee forward progress even if some bytes are
writable, Linus' suggestion was for fault_in_writable() to probe the
whole range. I consider this overkill since btrfs is the only one that
needs probing every 16 bytes. The other cases like the new
fault_in_safe_writeable() can be fixed by probing the first byte only
followed by gup.

I think we need to better define the semantics of the fault_in + uaccess
sequences. For uaccess, we document "a hard requirement that not storing
anything at all (i.e. returning size) should happen only when nothing
could be copied" (from linux/uaccess.h). I think we can add a
requirement for the new size_t-based fault_in_* variants without
mandating that the whole range is probed, something like: "returning
leftover < size guarantees that a subsequent user access at uaddr copies
at least one byte eventually". I said "eventually" but maybe we can come
up with some clearer wording for a liveness property.

Such requirement would ensure that infinite loops of fault_in_* +
uaccess make progress as long as they don't reset the probed range. Code
like btrfs search_ioctl() would need to be adjusted to avoid such range
reset and guarantee forward progress.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
