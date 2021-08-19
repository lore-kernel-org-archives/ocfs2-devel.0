Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB981C4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 20:21:07 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39BC060C41
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 20:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 39BC060C41
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JKC8iY004009;
	Thu, 19 Aug 2021 20:21:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahs40gudk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 20:21:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JKBAv5167520;
	Thu, 19 Aug 2021 20:21:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm06fcb-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 20:21:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGoR3-0007Qy-Ui; Thu, 19 Aug 2021 13:14:45 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mGoQz-0007QY-A1
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 13:14:41 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JKB7lm188407
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 20:14:41 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3ae3vm60y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 20:14:40 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JKEd7t010727
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 20:14:39 GMT
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
	[209.85.208.174])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahf9p2nuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 20:14:39 +0000
Received: by mail-lj1-f174.google.com with SMTP id i28so13483003ljm.7
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 13:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=GYLpQkQZuRNvZVwWVHs6hiU3DKifELOt1KfkaMF5F2A=;
	b=M8l8erg2pmS2tgxSauBSJrWt/u050mwH2QA/DVBd0gEZy84G8OcguH3XfbcaI67v4y
	usqvnrT10v2+9Dn3gK6tIj+2OQBlKjcYKnKIK1vE4LVu9VVNHECn0J6kbNztT6dDWXRl
	FmGRYZR5qg6WF6l1SfvxK3YdG0Jk9mSoO+eTJKEmdP4+6b7NwXfZ+mx7qNm6s0XFCNW7
	Lfxqy+fr8gKnul7DyMrGhwKfM6nVdqRRt7oilGp0PYIBr8iv1XSY6jVXNCyT7rupn6HU
	nm7yP9EpFVGFX6NYFGbC8JZHxMyVHLj39Ol78CCkfkQdGHgadbhdiHUH7WL/3y3aUGjw
	BN2A==
X-Gm-Message-State: AOAM53155z7dn/EPL+xDAPLnqrkB+ecoPy1lsmw/mRAjIuHTx0xM1ybn
	jausOnMJwpZFJGEJDmueiFCVtTnM8f49vxCqV0A=
X-Google-Smtp-Source: ABdhPJx9b8Sv3MmtHLT3E0KbXwI8hkbbPXJLWs0xlqjWNmUeJrjRFdeEdIF6q/QugZNDPT4o6fN34A==
X-Received: by 2002:a2e:9e8e:: with SMTP id f14mr13269630ljk.502.1629404075012;
	Thu, 19 Aug 2021 13:14:35 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com.
	[209.85.208.169])
	by smtp.gmail.com with ESMTPSA id e6sm403300lfr.257.2021.08.19.13.14.33
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 19 Aug 2021 13:14:33 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id n7so13576621ljq.0
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 13:14:33 -0700 (PDT)
X-Received: by 2002:a2e:8808:: with SMTP id x8mr13668362ljh.220.1629404073513; 
	Thu, 19 Aug 2021 13:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
	<CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
	<CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
	<CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
In-Reply-To: <CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Aug 2021 13:14:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
Message-ID: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.208.174
X-ServerName: mail-lj1-f174.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=345
	spamscore=0
	mlxlogscore=999 priorityscore=118 mlxscore=0 malwarescore=0
	suspectscore=0
	impostorscore=0 adultscore=0 bulkscore=0 phishscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190117
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190117
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 00/12] gfs2: Fix mmap + page fault
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190117
X-Proofpoint-GUID: VRNB7UmjfJBFScC6-mVS_vy2t7OrMeMx
X-Proofpoint-ORIG-GUID: VRNB7UmjfJBFScC6-mVS_vy2t7OrMeMx

On Thu, Aug 19, 2021 at 12:41 PM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> Hmm, what if GUP is made to skip VM_IO vmas without adding anything to
> the pages array? That would match fault_in_iov_iter_writeable, which
> is modeled after __mm_populate and which skips VM_IO and VM_PFNMAP
> vmas.

I don't understand what you mean.. GUP already skips VM_IO (and
VM_PFNMAP) pages. It just returns EFAULT.

We could make it return another error. We already have DAX and
FOLL_LONGTERM returning -EOPNOTSUPP.

Of course, I think some code ends up always just returning "number of
pages looked up" and might return 0 for "no pages" rather than the
error for the first page.

So we may end up having interfaces that then lose that explanation
error code, but I didn't check.

But we couldn't make it just say "skip them and try later addresses",
if that is what you meant. THAT makes no sense - that would just make
GUP look up some other address than what was asked for.

> > I also do still think that even regardless of that, we want to just
> > add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
> > and then you can use the regular get_user_pages().
> >
> > That at least gives us the full _normal_ page handling stuff.
>
> And it does fix the generic/208 failure.

Good. So I think the approach is usable, even if we might have corner
cases left.

So I think the remaining issue is exactly things like VM_IO and
VM_PFNMAP. Do the fstests have test-cases for things like this? It
_is_ quite specialized, it might be a good idea to have that.

Of course, doing direct-IO from special memory regions with zerocopy
might be something special people actually want to do. But I think
we've had that VM_IO flag testing there basically forever, so I don't
think it has ever worked (for some definition of "ever").

            Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
