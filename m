Return-Path: <SRS0=N2wx=PJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7854C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 00:46:34 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CB5260FED
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Oct 2021 00:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7CB5260FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L0EYvb000812;
	Thu, 21 Oct 2021 00:46:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4udvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 00:46:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L0fbgn027251;
	Thu, 21 Oct 2021 00:46:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gv2wt1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 21 Oct 2021 00:46:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdME2-0007mj-SX; Wed, 20 Oct 2021 17:46:30 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mdMDz-0007mK-Mv
	for ocfs2-devel@oss.oracle.com; Wed, 20 Oct 2021 17:46:27 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L0erhE158706
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 00:46:27 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bqmsh9wry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 00:46:26 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KNc90L011871
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 00:46:25 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bt6549umj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 21 Oct 2021 00:46:25 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-14-f68UMS0pOYC6XKbbzLcNJQ-1; Wed, 20 Oct 2021 20:46:23 -0400
X-MC-Unique: f68UMS0pOYC6XKbbzLcNJQ-1
Received: by mail-wm1-f70.google.com with SMTP id
	a85-20020a1c9858000000b003231f6f95cbso207429wme.0
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 17:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=GgRzGZvlhKco4vdRDM+mmGlMh4qaw7uLRwsJYM91KRo=;
	b=Pd0UkUBG8MxyUOoiNoUZChslHozYYVYaPRscLE4D0ImFo2YoJ7kxe1UpOXOIV0aR/c
	4uJygUu4t5m9QLZzsA1MxEV7FnUoSt/CDwcJ73a4vNFYaRTo51xDuQuzE2PMjzTrouPV
	sb1V2ka3bAjXy5A1f1SOa5cJud6Z8Wnd9sZVYNTsZi5TNh5W6yPEUc7wZIU6VCsd3awd
	fHLiPwAlG3WL4sPCjuI9bztHQNobta5FsCQd7dlY8S4TE1v7m587AZp/TWBha7M8AaL9
	hxnYUakm+LD06dcW57acJqftPCaBAYkzDcVHXdWoD+1d/K0UO0P5Kk+xYezr7nIrwCHD
	+vHQ==
X-Gm-Message-State: AOAM533hNsSLIt12kRw3dS/j4Xhrl2Kb8C2YF6KJ16Do2qqkIRSUJ6Mq
	qG+ttEpp41D+U9P/lMr07rae0mhzl4gQjPLvuYKIpiuhQj1cQmDqPssX2qfMoPZd9SWLGKt6B1Q
	VZGNJCvxgbhaZYgOpQu/VjqE0OlV10u31hsC2xQ==
X-Received: by 2002:a1c:4e10:: with SMTP id g16mr588671wmh.128.1634777182161; 
	Wed, 20 Oct 2021 17:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRGyQwuX0RWsnHGQyYi/ngKg0rwoZsofzx0FO8yb5Tm0XYCRffyxkRLT6pbnH1pATha3ETgfDhMtMfli9BWdA=
X-Received: by 2002:a1c:4e10:: with SMTP id g16mr588649wmh.128.1634777181923; 
	Wed, 20 Oct 2021 17:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
In-Reply-To: <CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 21 Oct 2021 02:46:10 +0200
Message-ID: <CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210002
X-Proofpoint-GUID: rXtQ1pZ-I_AyymDacYMffnx7NuoR-eSD
X-Proofpoint-ORIG-GUID: rXtQ1pZ-I_AyymDacYMffnx7NuoR-eSD

On Tue, Oct 12, 2021 at 1:59 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Oct 11, 2021 at 2:08 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > +#ifdef CONFIG_ARM64_MTE
> > +#define FAULT_GRANULE_SIZE     (16)
> > +#define FAULT_GRANULE_MASK     (~(FAULT_GRANULE_SIZE-1))
>
> [...]
>
> > If this looks in the right direction, I'll do some proper patches
> > tomorrow.
>
> Looks fine to me. It's going to be quite expensive and bad for caches, though.
>
> That said, fault_in_writable() is _supposed_ to all be for the slow
> path when things go south and the normal path didn't work out, so I
> think it's fine.

Let me get back to this; I'm actually not convinced that we need to
worry about sub-page-size fault granules in fault_in_pages_readable or
fault_in_pages_writeable.

>From a filesystem point of view, we can get into trouble when a
user-space read or write triggers a page fault while we're holding
filesystem locks, and that page fault ends up calling back into the
filesystem. To deal with that, we're performing those user-space
accesses with page faults disabled. When a page fault would occur, we
get back an error instead, and then we try to fault in the offending
pages. If a page is resident and we still get a fault trying to access
it, trying to fault in the same page again isn't going to help and we
have a true error. We're clearly looking at memory at a page
granularity; faults at a sub-page level don't matter at this level of
abstraction (but they do show similar error behavior). To avoid
getting stuck, when it gets a short result or -EFAULT, the filesystem
implements the following backoff strategy: first, it tries to fault in
a number of pages. When the read or write still doesn't make progress,
it scales back and faults in a single page. Finally, when that still
doesn't help, it gives up. This strategy is needed for actual page
faults, but it also handles sub-page faults appropriately as long as
the user-space access functions give sensible results.

What am I missing?

Thanks,
Andreas

> I do wonder how the sub-page granularity works. Is it sufficient to
> just read from it? Because then a _slightly_ better option might be to
> do one write per page (to catch page table writability) and then one
> read per "granule" (to catch pointer coloring or cache poisoning
> issues)?
>
> That said, since this is all preparatory to us wanting to write to it
> eventually anyway, maybe marking it all dirty in the caches is only
> good.
>
>                 Linus
>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
