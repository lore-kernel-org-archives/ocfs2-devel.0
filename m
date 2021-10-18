Return-Path: <SRS0=Tqqh=PG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12905C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:14:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57D8A61212
	for <ocfs2-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 57D8A61212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IH5Or8012322;
	Mon, 18 Oct 2021 17:14:15 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3brnfhne06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Oct 2021 17:14:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IHBTag185854;
	Mon, 18 Oct 2021 17:14:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkuvu55g-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 18 Oct 2021 17:14:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mcWDE-0003VQ-Kc; Mon, 18 Oct 2021 10:14:12 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mcWCl-0003UW-W7
	for ocfs2-devel@oss.oracle.com; Mon, 18 Oct 2021 10:13:44 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IHBTed068418
	for <ocfs2-devel@oss.oracle.com>; Mon, 18 Oct 2021 17:13:43 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3br8gqx16r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 18 Oct 2021 17:13:43 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19IElo2e031312
	for <ocfs2-devel@oss.oracle.com>; Mon, 18 Oct 2021 17:13:42 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3brnp1dnet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 18 Oct 2021 17:13:42 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id A68E3610C8;
	Mon, 18 Oct 2021 17:13:38 +0000 (UTC)
Date: Mon, 18 Oct 2021 18:13:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YW2rPyvwltDb8wdJ@arm.com>
References: <YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<YWXFagjRVdNanGSy@arm.com>
	<CAHk-=wg3prAnhWZetJvwZdugn7A7CpP4ruz1tdewha=8ZY8AJw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wg3prAnhWZetJvwZdugn7A7CpP4ruz1tdewha=8ZY8AJw@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=883 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180098
X-Proofpoint-ORIG-GUID: jcMA-2V-Eesvat5JlT9b-cTdBawc1wzM
X-Proofpoint-GUID: jcMA-2V-Eesvat5JlT9b-cTdBawc1wzM

On Tue, Oct 12, 2021 at 10:58:46AM -0700, Linus Torvalds wrote:
> On Tue, Oct 12, 2021 at 10:27 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Apart from fault_in_pages_*(), there's also fault_in_user_writeable()
> > called from the futex code which uses the GUP mechanism as the write
> > would be destructive. It looks like it could potentially trigger the
> > same infinite loop on -EFAULT.
> 
> Hmm.
> 
> I think the reason we do fault_in_user_writeable() using GUP is that
> 
>  (a) we can avoid the page fault overhead
> 
>  (b) we don't have any good "atomic_inc_user()" interface or similar
> that could do a write with a zero increment or something like that.
> 
> We do have that "arch_futex_atomic_op_inuser()" thing, of course. It's
> all kinds of crazy, but we *could* do
> 
>        arch_futex_atomic_op_inuser(FUTEX_OP_ADD, 0, &dummy, uaddr);
> 
> instead of doing the fault_in_user_writeable().
> 
> That might be a good idea anyway. I dunno.

I gave this a quick try for futex (though MTE is not affected at the
moment):

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=devel/sub-page-faults

However, I still have doubts about fault_in_pages_*() probing every 16
bytes, especially if one decides to change these routines to be
GUP-based.

> > A more invasive change would be to return a different error for such
> > faults like -EACCESS and treat them differently in the caller.
> 
> That's _really_ hard for things like "copy_to_user()", that isn't a
> single operation, and is supposed to return the bytes left.
> 
> Adding another error return would be nasty.
> 
> We've had hacks like "squirrel away the actual error code in the task
> structure", but that tends to be unmaintainable because we have
> interrupts (and NMI's) doing their own possibly nested atomics, so
> even disabling preemption won't actually fix some of the nesting
> issues.

I think we can do something similar to the __get_user_error() on arm64.
We can keep the __copy_to_user_inatomic() etc. returning the number of
bytes left but change the exception handling path in those routines to
set an error code or boolean to a pointer passed at uaccess routine call
time. The caller would do something along these lines:

	bool page_fault;
	left = copy_to_user_inatomic(dst, src, size, &page_fault);
	if (left && page_fault)
		goto repeat_fault_in;

copy_to_user_nofault() could also change its return type from -EFAULT to
something else based on whether page_fault was set or not.

Most architectures will use a generic copy_to_user_inatomic() wrapper
where page_fault == true for any fault. Arm64 needs some adjustment to
the uaccess fault handling to pass the fault code down to the exception
code. This way, at least for arm64, I don't think an interrupt or NMI
would be problematic.

> All of these things make me think that the proper fix ends up being to
> make sure that our "fault_in_xyz()" functions simply should always
> handle all faults.
> 
> Another option may be to teach the GUP code to actually check
> architecture-specific sub-page ranges.

Teaching GUP about this is likely to be expensive. A put_user() for
probing on arm64 uses a STTR instruction that's run with user privileges
on the user address and the user tag checking mode. The GUP code for
MTE, OTOH, would need to explicitly read the tag in memory and compare
it with the user pointer tag (which is normally cleared in the GUP code
by untagged_addr()).

To me it makes more sense for the fault_in_*() functions to only deal
with those permissions the kernel controls, i.e. the pte. Sub-page
permissions like MTE or CHERI are controlled by the user directly, so
the kernel cannot fix them up anyway. Rather than overloading
fault_in_*() with additional checks, I think we should expand the
in-atomic uaccess API to cover the type of fault.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
