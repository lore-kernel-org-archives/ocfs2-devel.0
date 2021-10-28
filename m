Return-Path: <SRS0=40Y/=PQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39C5C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 22:32:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69431610E5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 22:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69431610E5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SM2mmV021616;
	Thu, 28 Oct 2021 22:32:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byja2d8vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Oct 2021 22:32:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19SMM3hK095021;
	Thu, 28 Oct 2021 22:32:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4gthcs4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Oct 2021 22:32:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mgDx3-0002Oy-V4; Thu, 28 Oct 2021 15:32:49 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mgDx1-0002Oa-Ic
	for ocfs2-devel@oss.oracle.com; Thu, 28 Oct 2021 15:32:47 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19SMM21r094948
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:32:47 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3bx4gthcqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:32:47 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19SJXhLQ012100
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:32:46 GMT
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
	[209.85.167.44])
	by mx0b-00069f01.pphosted.com with ESMTP id 3by9q2mg1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:32:45 +0000
Received: by mail-lf1-f44.google.com with SMTP id c28so16631339lfv.13
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 15:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=P2oA0jP1wTViA9d0b6XSu2m2Y7tBKqkUPBuDKDK703M=;
	b=S8jS3OhEzq0nAEIHQkDl2cD44wWOoaeFl5qjtF9AnYClw+1NSykV735stsOZtFcTjn
	LwnEgE4LLi7Slihx+Mk/ZVydfjBrd/UlL9E2GT8lLjtezx2AF+Go6/4EDvOwylR5f8gS
	SoFOWMo2dxRuUKsx0IrlTslXaaJVqTcBUyoycnsXyEuy4/jBM6w1lr1Z+wkyXHauasI1
	VktSjaKUhtuAeSDaou3UKi9UtnOch1qYz2e16pM8DmdHaOncROf2GTn3wPHNjqxvzoCJ
	ZBS0X8Wtk37s/jQ3IB2RwOnBYOJYAwY6/1HnkOYEUtuc+dXGlfJ9mBGYDiZ83QSLmg+w
	BR1Q==
X-Gm-Message-State: AOAM5304vxG4JEahnIJDPhfpS1qJeC+zwHhPNRjV7exx+5EuWuQMUIMz
	UDF0qC/bqeRs6kjSiWhF/+aOM+UvFkUm069l
X-Google-Smtp-Source: ABdhPJzkj2CJA9FB/cwleuyi8rw7P9xdqN4m7mIAPfF8ZAm4FttOGFgPzR9Lxf2vJi4Jz2x3tpIkiQ==
X-Received: by 2002:a05:6512:1052:: with SMTP id
	c18mr6950333lfb.69.1635460362571; 
	Thu, 28 Oct 2021 15:32:42 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com.
	[209.85.208.178]) by smtp.gmail.com with ESMTPSA id
	d20sm481090lfa.280.2021.10.28.15.32.39
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 28 Oct 2021 15:32:40 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id k13so13232541ljj.12
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 15:32:39 -0700 (PDT)
X-Received: by 2002:a2e:89d4:: with SMTP id c20mr7772843ljk.191.1635460359642; 
	Thu, 28 Oct 2021 15:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
	<YXmkvfL9B+4mQAIo@arm.com>
	<CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
	<YXsUNMWFpmT1eQcX@arm.com>
In-Reply-To: <YXsUNMWFpmT1eQcX@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2021 15:32:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
Message-ID: <CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.44
X-ServerName: mail-lf1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	phishscore=0
	malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
	bulkscore=0
	clxscore=329 suspectscore=0 adultscore=0 priorityscore=173 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110280118 domainage_hfrom=5427
X-Spam: Clean
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280118
X-Proofpoint-GUID: 0nHkxIa2hoiKpSYqx22xPXfW6qFsIRvr
X-Proofpoint-ORIG-GUID: 0nHkxIa2hoiKpSYqx22xPXfW6qFsIRvr

On Thu, Oct 28, 2021 at 2:21 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> They do look fairly similar but we should have the information in the
> fault handler to distinguish: not a page fault (pte permission or p*d
> translation), in_task(), user address, fixup handler. But I agree the
> logic looks fragile.

So thinking about this a bit more, I think I have a possible
suggestion for how to handle this..

The pointer color fault (or whatever some other architecture may do to
generate sub-page faults) is not only not recoverable in the sense
that we can't fix it up, it also ends up being a forced SIGSEGV (ie it
can't be blocked - it has to either be caught or cause the process to
be killed).

And the thing is, I think we could just make the rule be that kernel
code that has this kind of retry loop with fault_in_pages() would
force an EFAULT on a pending SIGSEGV.

IOW, the pending SIGSEGV could effectively be exactly that "thread flag".

And that means that fault_in_xyz() wouldn't need to worry about this
situation at all: the regular copy_from_user() (or whatever flavor it
is - to/from/iter/whatever) would take the fault. And if it's a
regular page fault,. it would act exactly like it does now, so no
changes.

If it's a sub-page fault, we'd just make the rule be that we send a
SIGSEGV even if the instruction in question has a user exception
fixup.

Then we just need to add the logic somewhere that does "if active
pending SIGSEGV, return -EFAULT".

Of course, that logic might be in fault_in_xyz(), but it migth also be
a separate function entirely.

So this does effectively end up being a thread flag, but it's also
slightly more than that - it's that a sub-page fault from kernel mode
has semantics that a regular page fault does not.

The whole "kernel access doesn't cause SIGSEGV, but returns -EFAULT
instead" has always been an odd and somewhat wrong-headed thing. Of
course it should cause a SIGSEGV, but that's not how Unix traditionall
worked. We would just say "color faults always raise a signal, even if
the color fault was triggered in a system call".

(And I didn't check: I say "SIGSEGV" above, but maybe the pointer
color faults are actually SIGBUS? Doesn't change the end result).

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
