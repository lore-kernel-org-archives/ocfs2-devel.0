Return-Path: <SRS0=rA73=PP=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7B4C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 27 Oct 2021 19:13:39 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3726A60C40
	for <ocfs2-devel@archiver.kernel.org>; Wed, 27 Oct 2021 19:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3726A60C40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RHth83016773;
	Wed, 27 Oct 2021 19:13:38 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fymru8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Oct 2021 19:13:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RJC17c034595;
	Wed, 27 Oct 2021 19:13:36 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4h2w0m3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 27 Oct 2021 19:13:36 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfoMh-0005bF-Ds; Wed, 27 Oct 2021 12:13:35 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mfoMH-0005aJ-GL
	for ocfs2-devel@oss.oracle.com; Wed, 27 Oct 2021 12:13:09 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RJBI4J122332
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 19:13:09 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bx4gadmpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 19:13:09 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19RJ1PWl024486
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 19:13:08 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bycjb84pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 19:13:08 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EAE960EB4;
	Wed, 27 Oct 2021 19:13:04 +0000 (UTC)
Date: Wed, 27 Oct 2021 20:13:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YXmkvfL9B+4mQAIo@arm.com>
References: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270109
X-Proofpoint-GUID: LcmXVXMBdDj8WrpBkovY9N-PuRI8us5w
X-Proofpoint-ORIG-GUID: LcmXVXMBdDj8WrpBkovY9N-PuRI8us5w

On Tue, Oct 26, 2021 at 11:50:04AM -0700, Linus Torvalds wrote:
> On Tue, Oct 26, 2021 at 11:24 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > While more intrusive, I'd rather change copy_page_from_iter_atomic()
> > etc. to take a pointer where to write back an error code.
[...]
> That said, the fact that these sub-page faults are always
> non-recoverable might be a hint to a solution to the problem: maybe we
> could extend the existing return code with actual negative error
> numbers.
> 
> Because for _most_ cases of "copy_to/from_user()" and friends by far,
> the only thing we look for is "zero for success".
> 
> We could extend the "number of bytes _not_ copied" semantics to say
> "negative means fatal", and because there are fairly few places that
> actually look at non-zero values, we could have a coccinelle script
> that actually marks those places.

As you already replied, there are some odd places where the returned
uncopied of bytes is used. Also for some valid cases like
copy_mount_options(), it's likely that it will fall back to
byte-at-a-time with MTE since it's a good chance it would hit a fault in
a 4K page (not a fast path though). I'd have to go through all the cases
and check whether the return value is meaningful. The iter_iov.c
functions and their callers also seem to make use of the bytes copied in
case they need to call iov_iter_revert() (though I suppose the
iov_iter_iovec_advance() would skip the update in case of an error).

As an alternative, you mentioned earlier that a per-thread fault status
was not feasible on x86 due to races. Was this only for the hw poison
case? I think the uaccess is slightly different.

We can add a current->non_recoverable_uaccess variable cleared on
pagefault_disable(), only set by uaccess faults and checked by the fs
code before re-attempting the fault_in(). An interrupt shouldn't do a
uaccess (well, if it does a _nofault one, we can detect in_interrupt()
in the MTE exception handler). Last time I looked at io_uring it was
running in a separate kernel thread, not sure whether this was changed.
I don't see what else would be racing with such
current->non_recoverable_uaccess variable. If that's doable, I think
it's the least intrusive approach.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
