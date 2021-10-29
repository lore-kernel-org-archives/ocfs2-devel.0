Return-Path: <SRS0=AMvx=PR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4112C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 18:47:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7388360F22
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Oct 2021 18:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7388360F22
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19THFojo020595;
	Fri, 29 Oct 2021 18:47:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byjkf9sfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Oct 2021 18:47:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TIkFWc064397;
	Fri, 29 Oct 2021 18:47:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4h693s8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Oct 2021 18:47:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mgWuy-0007DP-2K; Fri, 29 Oct 2021 11:47:56 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mgWuw-0007D4-Qi
	for ocfs2-devel@oss.oracle.com; Fri, 29 Oct 2021 11:47:54 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TIjOVJ063236
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 18:47:54 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bx4gdh6qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 18:47:54 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19TGXbYY012512
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 18:47:53 GMT
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
	[209.85.167.50])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c0b190cuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 18:47:53 +0000
Received: by mail-lf1-f50.google.com with SMTP id bi35so22762276lfb.9
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 11:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=uGPiPKSphOUEs2fEDAQ1oyHUSr8W7H4wPzT5A6mID2k=;
	b=Or3EuobKpLnxkvm5kt+rGMXUW0MJRr68yTroG50v8KCyDL8L/jysxuI5EZFXtEcdxf
	+cUbYvhbq/0TywNhhdEUKwYG1aGFr3BDiAgTZRN9YYb31VKsdrAbqfcMRbElp1bC0Bv7
	g8mR6StjNEhRwKMzy6qNsf/FaU59tlux5sityKb8G5uOp5Xw68lwbJupGH5XsHp5puua
	FOJzB1WE2vkIk/bCAubV8pEao9IzOValmMUyBU6vcmZ0ujwYsqFieIIQFEo/Txsm9qMJ
	FhyWhkFFl6wbdu46a8lVTws8dx1GD7R6bXQ8met7iGfOn4Tk+eFz9aev5NL4SLu9wwdB
	ZMkQ==
X-Gm-Message-State: AOAM531UyO5B0tETlUDABPWfou+EW8HY5cZgmYP8iTS27Vxkt7XPmCyc
	uig71wzwEa6FOEN92lOwaTChtuURpKzJKPDiq24=
X-Google-Smtp-Source: ABdhPJzswD5NDXXGbMj2+uLAFcPnPvP1iLJrx7Mc3rnuRYju2zrdZkqJzVROXGWZzwNPdKrZC9+M2w==
X-Received: by 2002:a05:6512:234e:: with SMTP id
	p14mr11722431lfu.111.1635533270467; 
	Fri, 29 Oct 2021 11:47:50 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com.
	[209.85.208.177])
	by smtp.gmail.com with ESMTPSA id 187sm681956ljj.80.2021.10.29.11.47.49
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 29 Oct 2021 11:47:49 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 17so15162254ljq.0
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Oct 2021 11:47:49 -0700 (PDT)
X-Received: by 2002:a05:651c:17a6:: with SMTP id
	bn38mr13088470ljb.56.1635533269069; 
	Fri, 29 Oct 2021 11:47:49 -0700 (PDT)
MIME-Version: 1.0
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
	<YXw0a9n+/PLAcObB@arm.com>
In-Reply-To: <YXw0a9n+/PLAcObB@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2021 11:47:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNV5Ka0yTssic0JbZEcO3wvoTC65budK88k4D-34v0xA@mail.gmail.com>
Message-ID: <CAHk-=wgNV5Ka0yTssic0JbZEcO3wvoTC65budK88k4D-34v0xA@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.50
X-ServerName: mail-lf1-f50.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	lowpriorityscore=0
	malwarescore=0 phishscore=0 clxscore=426 priorityscore=264 adultscore=0
	impostorscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110290102 domainage_hfrom=5428
X-Spam: Clean
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290102
X-Proofpoint-ORIG-GUID: jC1rjmFOFf2PXtCWSUc_Wt1kfAS53EUA
X-Proofpoint-GUID: jC1rjmFOFf2PXtCWSUc_Wt1kfAS53EUA

On Fri, Oct 29, 2021 at 10:50 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> First of all, a uaccess in interrupt should not force such signal as it
> had nothing to do with the interrupted context. I guess we can do an
> in_task() check in the fault handler.

Yeah. It ends up being similar to the thread flag in that you still
end up having to protect against NMI and other users of asynchronous
page faults.

So the suggestion was more of a "mindset" difference and modified
version of the task flag rather than anything fundamentally different.

> Second, is there a chance that we enter the fault-in loop with a SIGSEGV
> already pending? Maybe it's not a problem, we just bail out of the loop
> early and deliver the signal, though unrelated to the actual uaccess in
> the loop.

If we ever run in user space with a pending per-thread SIGSEGV, that
would already be a fairly bad bug. The intent of "force_sig()" is not
only to make sure you can't block the signal, but also that it targets
the particular thread that caused the problem: unlike other random
"send signal to process", a SIGSEGV caused by a bad memory access is
really local to that _thread_, not the signal thread group.

So somebody else sending a SIGSEGV asynchronsly is actually very
different - it goes to the thread group (although you can specify
individual threads too - but once you do that you're already outside
of POSIX).

That said, the more I look at it, the more I think I was wrong. I
think the "we have a SIGSEGV pending" could act as the per-thread
flag, but the complexity of the signal handling is probably an
argument against it.

Not because a SIGSEGV could already be pending, but because so many
other situations could be pending.

In particular, the signal code won't send new signals to a thread if
that thread group is already exiting. So another thread may have
already started the exit and core dump sequence, and is in the process
of killing the shared signal threads, and if one of those threads is
now in the kernel and goes through the copy_from_user() dance, that
whole "thread group is exiting" will mean that the signal code won't
add a new SIGSEGV to the queue.

So the signal could conceptually be used as the flag to stop looping,
but it ends up being such a complicated flag that I think it's
probably not worth it after all. Even if it semantically would be
fairly nice to use pre-existing machinery.

Could it be worked around? Sure. That kernel loop probably has to
check for fatal_signal_pending() anyway, so it would all work even in
the presense of the above kinds of issues. But just the fact that I
went and looked at just how exciting the signal code is made me think
"ok, conceptually nice, but we take a lot of locks and we do a lot of
special things even in the 'simple' force_sig() case".

> Third is the sigcontext.pc presented to the signal handler. Normally for
> SIGSEGV it points to the address of a load/store instruction and a
> handler could disable MTE and restart from that point. With a syscall we
> don't want it to point to the syscall place as it shouldn't be restarted
> in case it copied something.

I think this is actually independent of the whole "how to return
errors". We'll still need to return an error from the system call,
even if we also have a signal pending.

                  Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
