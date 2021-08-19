Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A2FC4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:41:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7BFAD610A5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:41:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7BFAD610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJVApj014397;
	Thu, 19 Aug 2021 19:41:40 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahs5cgspv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 19:41:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JJVD11072952;
	Thu, 19 Aug 2021 19:41:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ae2y524w0-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 19:41:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGnuz-00055k-DI; Thu, 19 Aug 2021 12:41:37 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mGnuV-00053P-2R
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 12:41:07 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JJVBPb072887
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:06 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3ae2y523c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:06 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JJXW9l022166
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:05 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahg4astyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:04 +0000
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
	[209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-128-AuIAbsSWO6CxTRkyGG4pyA-1; Thu, 19 Aug 2021 15:41:02 -0400
X-MC-Unique: AuIAbsSWO6CxTRkyGG4pyA-1
Received: by mail-wr1-f71.google.com with SMTP id
	p10-20020a5d68ca000000b001552bf8b9daso2043254wrw.22
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 12:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=N3r+VfJqTouzOa7Rijd4hTG7Toub9ezhbqH/xKVtdmY=;
	b=HJfqOeU7AQQCh2ZPa+yKAcxZjjD7bg/gD6ftwh55fGWo16V0kKG13+1jQijGEwj21z
	q8yNtw1z+C9h7az9iVw/cW64w6JOz4GY3lNJelLh9XQXT6eWMbgFSaictwWg/bB7CBTt
	BLD/YEHTwgQSjzo3HLecTx0oPKca3krn/WQ8WIyiMafs1FWMkXtwsXNEzzhd9mf0/N0c
	6knLKLh1jTAXxH8eMaAMDQRjMEuld/5l035UA/f8nl0KlQGOczhRayA2gHZ0GeTGYKWt
	7oxgYhqWFWQrqhVpRBQbQVRI/uH7lI9YbZldsDBx7gpzVHnCT6Oxj7G8Kem5dSyhQTEF
	bMUw==
X-Gm-Message-State: AOAM5321qtFXFm6T2v5n0sNn5RSvDep8cA07fZs712rwRmsYXqSp/812
	9sRhHGE+lSOfqppLn+GI/39n5MJZVOu1mnpTV/n91saW+ZZ+46WmUUhFsPWYTE0fMBIxt85HToU
	hpVu0unERhC4dCP32Bc+MJw/sJSR+0xNjthHMQA==
X-Received: by 2002:a7b:c106:: with SMTP id w6mr296752wmi.152.1629402060761;
	Thu, 19 Aug 2021 12:41:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkJcXH65FWnZ1dP5/HoDmwcsHFn3hPhEUkK7xHddEwx16hWpY7f72bzjUNxESwyU+qX2gMS5ZSiNzWhC/qsKM=
X-Received: by 2002:a7b:c106:: with SMTP id w6mr296733wmi.152.1629402060505;
	Thu, 19 Aug 2021 12:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
	<CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
	<CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
In-Reply-To: <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Aug 2021 21:40:49 +0200
Message-ID: <CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
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
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
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
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190114
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190114
X-Proofpoint-ORIG-GUID: aIpfrcR_s3EsT-z2zBm2e2QjTyHfKjg-
X-Proofpoint-GUID: aIpfrcR_s3EsT-z2zBm2e2QjTyHfKjg-

On Wed, Aug 18, 2021 at 11:49 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> [ Sorry for the delay, I was on the road and this fell through the cracks ]

No harm done, I was busy enough implementing your previous suggestions.

> On Mon, Aug 16, 2021 at 12:14 PM Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
> >
> > On Tue, Aug 3, 2021 at 9:45 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Hmm. Have you tried to figure out why that "still returns 0" happens?
> >
> > The call stack is:
> >
> > gup_pte_range
> > gup_pmd_range
> > gup_pud_range
> > gup_p4d_range
> > gup_pgd_range
> > lockless_pages_from_mm
> > internal_get_user_pages_fast
> > get_user_pages_fast
> > iov_iter_get_pages
> > __bio_iov_iter_get_pages
> > bio_iov_iter_get_pages
> > iomap_dio_bio_actor
> > iomap_dio_actor
> > iomap_apply
> > iomap_dio_rw
> > gfs2_file_direct_write
> >
> > In gup_pte_range, pte_special(pte) is true and so we return 0.
>
> Ok, so that is indeed something that the fast-case can't handle,
> because some of the special code wants to have the mm_lock so that it
> can look at the vma flags (eg "vm_normal_page()" and friends.
>
> That said, some of these cases even the full GUP won't ever handle,
> simply because a mapping doesn't necessarily even _have_ a 'struct
> page' associated with it if it's a VM_IO mapping.
>
> So it turns out that you can't just always do
> fault_in_iov_iter_readable() and then assume that you can do
> iov_iter_get_pages() and repeat until successful.
>
> We could certainly make get_user_pages_fast() handle a few more cases,
> but I get the feeling that we need to have separate error cases for
> EFAULT - no page exists - and the "page exists, but cannot be mapped
> as a 'struct page'" case.

Hmm, what if GUP is made to skip VM_IO vmas without adding anything to
the pages array? That would match fault_in_iov_iter_writeable, which
is modeled after __mm_populate and which skips VM_IO and VM_PFNMAP
vmas.

The other strategy I've added is to scale back the page fault windows
to a single page if faulting in multiple pages didn't help, and to
give up if the I/O operation still fails after that. So pathological
cases won't loop indefinitely anymore at least.

> I also do still think that even regardless of that, we want to just
> add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
> and then you can use the regular get_user_pages().
>
> That at least gives us the full _normal_ page handling stuff.

And it does fix the generic/208 failure.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
