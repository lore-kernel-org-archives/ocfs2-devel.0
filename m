Return-Path: <SRS0=AMvx=PR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29457C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 17:50:51 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8950610C7
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 17:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B8950610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19THDY1a020576;
	Fri, 29 Oct 2021 17:50:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byjkf9hgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Oct 2021 17:50:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19THe5dM130070;
	Fri, 29 Oct 2021 17:50:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4guv3ae-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Oct 2021 17:50:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mgW1f-0004n0-50; Fri, 29 Oct 2021 10:50:47 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mgW1c-0004lg-Kr
	for ocfs2-devel@oss.oracle.com; Fri, 29 Oct 2021 10:50:44 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19THoA69044216
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 17:50:44 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bx4h66pvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 17:50:44 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19TGXaO7012458
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 17:50:43 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c0b18yshw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 17:50:42 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7CA9610C7;
	Fri, 29 Oct 2021 17:50:38 +0000 (UTC)
Date: Fri, 29 Oct 2021 18:50:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YXw0a9n+/PLAcObB@arm.com>
References: <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
	<YXmkvfL9B+4mQAIo@arm.com>
	<CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
	<YXsUNMWFpmT1eQcX@arm.com>
	<CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, Tony Luck <tony.luck@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290097
X-Proofpoint-ORIG-GUID: dGcmHONnbMV66cIE-LytsR6CELPxWwIj
X-Proofpoint-GUID: dGcmHONnbMV66cIE-LytsR6CELPxWwIj

On Thu, Oct 28, 2021 at 03:32:23PM -0700, Linus Torvalds wrote:
> The pointer color fault (or whatever some other architecture may do to
> generate sub-page faults) is not only not recoverable in the sense
> that we can't fix it up, it also ends up being a forced SIGSEGV (ie it
> can't be blocked - it has to either be caught or cause the process to
> be killed).
> 
> And the thing is, I think we could just make the rule be that kernel
> code that has this kind of retry loop with fault_in_pages() would
> force an EFAULT on a pending SIGSEGV.
> 
> IOW, the pending SIGSEGV could effectively be exactly that "thread flag".
> 
> And that means that fault_in_xyz() wouldn't need to worry about this
> situation at all: the regular copy_from_user() (or whatever flavor it
> is - to/from/iter/whatever) would take the fault. And if it's a
> regular page fault,. it would act exactly like it does now, so no
> changes.
> 
> If it's a sub-page fault, we'd just make the rule be that we send a
> SIGSEGV even if the instruction in question has a user exception
> fixup.
> 
> Then we just need to add the logic somewhere that does "if active
> pending SIGSEGV, return -EFAULT".
> 
> Of course, that logic might be in fault_in_xyz(), but it migth also be
> a separate function entirely.
> 
> So this does effectively end up being a thread flag, but it's also
> slightly more than that - it's that a sub-page fault from kernel mode
> has semantics that a regular page fault does not.
> 
> The whole "kernel access doesn't cause SIGSEGV, but returns -EFAULT
> instead" has always been an odd and somewhat wrong-headed thing. Of
> course it should cause a SIGSEGV, but that's not how Unix traditionall
> worked. We would just say "color faults always raise a signal, even if
> the color fault was triggered in a system call".

It's doable and, at least for MTE, people have asked for a signal even
when the fault was caused by a kernel uaccess. But there are some
potentially confusing aspects to sort out:

First of all, a uaccess in interrupt should not force such signal as it
had nothing to do with the interrupted context. I guess we can do an
in_task() check in the fault handler.

Second, is there a chance that we enter the fault-in loop with a SIGSEGV
already pending? Maybe it's not a problem, we just bail out of the loop
early and deliver the signal, though unrelated to the actual uaccess in
the loop.

Third is the sigcontext.pc presented to the signal handler. Normally for
SIGSEGV it points to the address of a load/store instruction and a
handler could disable MTE and restart from that point. With a syscall we
don't want it to point to the syscall place as it shouldn't be restarted
in case it copied something. Pointing it to the next instruction after
syscall is backwards-compatible but it may confuse the handler (if it
does some reporting). I think we need add a new si_code that describes a
fault in kernel mode to differentiate from the genuine user access.

There was a discussion back in August on infinite loops with hwpoison
and Tony said that Andy convinced him that the kernel should not send a
SIGBUS for uaccess:

https://lore.kernel.org/linux-edac/20210823152437.GA1637466@agluck-desk2.amr.corp.intel.com/

I personally like the approach of a SIG{SEGV,BUS} on uaccess and I don't
think the ABI change is significant but ideally we should have a unified
approach that's not just for MTE.

Adding Andy and Tony (the background is potentially infinite loops with
faults at sub-page granularity: arm64 MTE, hwpoison, sparc ADI).

Thanks.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
