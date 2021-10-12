Return-Path: <SRS0=+lI3=PA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237E2C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 18:02:33 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7751610CC
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 18:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C7751610CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CHxCYb030652;
	Tue, 12 Oct 2021 18:02:32 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3bhg1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Oct 2021 18:02:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CI17Aq046021;
	Tue, 12 Oct 2021 18:02:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bkyv9b7ua-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 12 Oct 2021 18:02:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1maM3S-0005c1-MB; Tue, 12 Oct 2021 10:59:10 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1maM3Q-0005be-Pv
	for ocfs2-devel@oss.oracle.com; Tue, 12 Oct 2021 10:59:08 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CHf78n145220
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:59:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bkyv9aywv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:59:08 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19CGXC2t024000
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:59:07 GMT
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
	[209.85.167.53])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bndyv98cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 17:59:06 +0000
Received: by mail-lf1-f53.google.com with SMTP id c16so537822lfb.3
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 10:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=fqSNsVOtXYPiifkp+lepAhAhHgqhsFkG1XDADIpg/Pc=;
	b=T25KNhtytmIx+XdheO5gt2d1YfDiAX0blFasE/Mm/p+Q94P5cIH8/3Rf1G4GRbKN/6
	sCIAWhU/PGhDBuIMjjSi8UlVVzHJvfP/YfvXJgKkzmbO5oQnNbh5oG1aDiu05UUO+SJG
	/mKNz7TmSfnx/pj46ndHCqOqFEx7kOXgBF5Vix2Mx0386qBggiVuOHgzsdv6OON5f7bk
	+ucRjrwhb338frB+wFwl8eBxvVvf4k/O1iswWckuUWnpOlqcBjYOHJftRFoeBeOTfJFE
	bRCZ8q12uvxE9W58hk0IRan0JBpli94ZkBAirwa1Rr0ZBg4KRxMUCsGM3G6eQPr0Ktg/
	Ks8A==
X-Gm-Message-State: AOAM5327CX4SE7S0xNXHwXyo73DzRZBtAheg76LSa9sA4NzttwR3XEHj
	mdmQlWWL4l96GTIJGIPjq56bbNrg50BuL8kj
X-Google-Smtp-Source: ABdhPJw/9gp9duJkKwbLmotwvDGj7wpGz3s1zbeWVNMcgpwFsE9SEuOZg7wxw6LgQFsIipovJOi3MQ==
X-Received: by 2002:a2e:a815:: with SMTP id l21mr31086918ljq.164.1634061543956;
	Tue, 12 Oct 2021 10:59:03 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com.
	[209.85.167.45]) by smtp.gmail.com with ESMTPSA id
	w22sm1091253lfl.161.2021.10.12.10.59.02
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 12 Oct 2021 10:59:03 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id c16so537344lfb.3
	for <ocfs2-devel@oss.oracle.com>; Tue, 12 Oct 2021 10:59:02 -0700 (PDT)
X-Received: by 2002:a05:6512:10d0:: with SMTP id
	k16mr2835560lfg.150.1634061542163; 
	Tue, 12 Oct 2021 10:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<YWXFagjRVdNanGSy@arm.com>
In-Reply-To: <YWXFagjRVdNanGSy@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Oct 2021 10:58:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg3prAnhWZetJvwZdugn7A7CpP4ruz1tdewha=8ZY8AJw@mail.gmail.com>
Message-ID: <CAHk-=wg3prAnhWZetJvwZdugn7A7CpP4ruz1tdewha=8ZY8AJw@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.53
X-ServerName: mail-lf1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=398
	mlxlogscore=231
	priorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
	bulkscore=0 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110120096 domainage_hfrom=5411
X-Spam: Clean
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
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=966
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120097
X-Proofpoint-GUID: wgqvBylEh0jOpSYFd-Rq9QaHuVVGV_pN
X-Proofpoint-ORIG-GUID: wgqvBylEh0jOpSYFd-Rq9QaHuVVGV_pN

On Tue, Oct 12, 2021 at 10:27 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> Apart from fault_in_pages_*(), there's also fault_in_user_writeable()
> called from the futex code which uses the GUP mechanism as the write
> would be destructive. It looks like it could potentially trigger the
> same infinite loop on -EFAULT.

Hmm.

I think the reason we do fault_in_user_writeable() using GUP is that

 (a) we can avoid the page fault overhead

 (b) we don't have any good "atomic_inc_user()" interface or similar
that could do a write with a zero increment or something like that.

We do have that "arch_futex_atomic_op_inuser()" thing, of course. It's
all kinds of crazy, but we *could* do

       arch_futex_atomic_op_inuser(FUTEX_OP_ADD, 0, &dummy, uaddr);

instead of doing the fault_in_user_writeable().

That might be a good idea anyway. I dunno.

But I agree other options exist:

> I wonder whether we should actually just disable tag checking around the
> problematic accesses. What these callers seem to have in common is using
> pagefault_disable/enable(). We could abuse this to disable tag checking
> or maybe in_atomic() when handling the exception to lazily disable such
> faults temporarily.

Hmm. That would work for MTE, but possibly be very inconvenient for
other situations.

> A more invasive change would be to return a different error for such
> faults like -EACCESS and treat them differently in the caller.

That's _really_ hard for things like "copy_to_user()", that isn't a
single operation, and is supposed to return the bytes left.

Adding another error return would be nasty.

We've had hacks like "squirrel away the actual error code in the task
structure", but that tends to be unmaintainable because we have
interrupts (and NMI's) doing their own possibly nested atomics, so
even disabling preemption won't actually fix some of the nesting
issues.

All of these things make me think that the proper fix ends up being to
make sure that our "fault_in_xyz()" functions simply should always
handle all faults.

Another option may be to teach the GUP code to actually check
architecture-specific sub-page ranges.

        Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
