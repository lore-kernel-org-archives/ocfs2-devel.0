Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63235C4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 21:46:44 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E83F661029
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 21:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E83F661029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JLfvmZ013750;
	Thu, 19 Aug 2021 21:46:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agykmmf8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 21:46:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JLj9XF065469;
	Thu, 19 Aug 2021 21:46:41 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm0ba18-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 21:46:40 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGplt-0002XY-LF; Thu, 19 Aug 2021 14:40:21 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mGplo-0002X6-3q
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 14:40:16 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JLV4nw040839
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 21:40:16 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3ae3vm9x2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 21:40:15 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JLbTAx012255
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 21:40:14 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahg4au0j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 21:40:14 +0000
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
	[209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-519-Z3B1CtjpP82fQCkw-x5zdw-1; Thu, 19 Aug 2021 17:40:09 -0400
X-MC-Unique: Z3B1CtjpP82fQCkw-x5zdw-1
Received: by mail-wr1-f69.google.com with SMTP id
	a9-20020a0560000509b029015485b95d0cso2166933wrf.5
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 14:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=DvdcXZIwl3tPZt3OBpuE3xqKVNbMTKzJBp4rw8ENU30=;
	b=g1IdnFfU1qojbv/xBiprZlvsgPf9evJx0mqwzMce7slB9mIghSj1Csohiu2PVSeMvg
	89yHwZUebtpRkpAHCLjbqI1a5ivC4tdBJl0nz9vCtucvKcEki7pnm78i1UPF264Ll1zh
	AMzn5+1aN5/SuUBwJckqoUWPoGiSdnBxgHYxt5SSe0sEdm+rZbhyZo3qnYWTSH31/gty
	uIowqSy1lRtlOKBXfowWOUsLoYvQo1gHYmqsZM8iGFz05ZyXS9cQAM0/LeLCJ2AWFwhn
	Ge+GTelumfP1ZO+6XBgz+0DJJIEdwz44fQhsUx3uU+UPA1LY6z8ZXdXtiNngef9RReF7
	dZ1Q==
X-Gm-Message-State: AOAM531kUgVNOx4T3ePGdriylcH7clpj5A5ovWb851lN70d8a6QWWVMI
	Braxj5dbwUIc9gt7M68ixLNkREDd/Uuj1uwLWdvT8qlU5xzpnlyf5qeKYgFStmtioYa0S1i87Lx
	8JcNS+9VEy8UFbhrSfpR+azw2PCkjuXStfCfXvw==
X-Received: by 2002:a1c:7916:: with SMTP id l22mr623016wme.27.1629409208119;
	Thu, 19 Aug 2021 14:40:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYA97+cGFeqU43YBkPI260mv8aQOOw6JSQmOGyumgFbyOD0nefEq4MgAFBQrx6D74nVITzdNSFMePqB4OBxCo=
X-Received: by 2002:a1c:7916:: with SMTP id l22mr622994wme.27.1629409207884;
	Thu, 19 Aug 2021 14:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
	<CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
	<CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
	<CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
	<CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
In-Reply-To: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Aug 2021 23:39:56 +0200
Message-ID: <CAHc6FU6a8SLmHfMoS7NUDKboWpVEGBKyC46pU_brx3y8crbEXA@mail.gmail.com>
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
X-Source-IP: 216.205.24.124
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190124
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
 definitions=main-2108190126
X-Proofpoint-ORIG-GUID: Afljb_WfA4vIJKgsXetJWaNiGAk6uc1F
X-Proofpoint-GUID: Afljb_WfA4vIJKgsXetJWaNiGAk6uc1F

On Thu, Aug 19, 2021 at 10:14 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 19, 2021 at 12:41 PM Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
> >
> > Hmm, what if GUP is made to skip VM_IO vmas without adding anything to
> > the pages array? That would match fault_in_iov_iter_writeable, which
> > is modeled after __mm_populate and which skips VM_IO and VM_PFNMAP
> > vmas.
>
> I don't understand what you mean.. GUP already skips VM_IO (and
> VM_PFNMAP) pages. It just returns EFAULT.
>
> We could make it return another error. We already have DAX and
> FOLL_LONGTERM returning -EOPNOTSUPP.
>
> Of course, I think some code ends up always just returning "number of
> pages looked up" and might return 0 for "no pages" rather than the
> error for the first page.
>
> So we may end up having interfaces that then lose that explanation
> error code, but I didn't check.
>
> But we couldn't make it just say "skip them and try later addresses",
> if that is what you meant. THAT makes no sense - that would just make
> GUP look up some other address than what was asked for.

get_user_pages has a start and a nr_pages argument, which specifies an
address range from start to start + nr_pages * PAGE_SIZE. If pages !=
NULL, it adds a pointer to that array for each PAGE_SIZE subpage. I
was thinking of skipping over VM_IO vmas in that process, so when the
range starts in a mappable vma, runs into a VM_IO vma, and ends in a
mappable vma, the pages in the pages array would be discontiguous;
they would only cover the mappable vmas. But that would make it
difficult to make sense of what's in the pages array. So scratch that
idea.

> > > I also do still think that even regardless of that, we want to just
> > > add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
> > > and then you can use the regular get_user_pages().
> > >
> > > That at least gives us the full _normal_ page handling stuff.
> >
> > And it does fix the generic/208 failure.
>
> Good. So I think the approach is usable, even if we might have corner
> cases left.
>
> So I think the remaining issue is exactly things like VM_IO and
> VM_PFNMAP. Do the fstests have test-cases for things like this? It
> _is_ quite specialized, it might be a good idea to have that.
>
> Of course, doing direct-IO from special memory regions with zerocopy
> might be something special people actually want to do. But I think
> we've had that VM_IO flag testing there basically forever, so I don't
> think it has ever worked (for some definition of "ever").

The v6 patch queue should handle those cases acceptably well for now,
but I don't think we have tests covering that at all.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
