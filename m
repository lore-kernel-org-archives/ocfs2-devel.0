Return-Path: <SRS0=SdAF=OS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678BAC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:42:11 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0ECD96138D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0ECD96138D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SJxmt8031117;
	Tue, 28 Sep 2021 20:42:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbejempjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Sep 2021 20:42:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SKa82M185199;
	Tue, 28 Sep 2021 20:42:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bc3cd61yc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 28 Sep 2021 20:42:03 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVJvO-0003DK-NI; Tue, 28 Sep 2021 13:42:02 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mVJvK-0003Cu-7A
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 13:41:58 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18SKaSeo174124
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 20:41:57 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bc3bhwpjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 20:41:57 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18SJJNhs018805
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 20:41:56 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc5grw78p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 20:41:56 +0000
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
	[209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-511-ETMHi_6mOWKeSnwJNYQTww-1; Tue, 28 Sep 2021 16:41:54 -0400
X-MC-Unique: ETMHi_6mOWKeSnwJNYQTww-1
Received: by mail-wr1-f72.google.com with SMTP id
	r15-20020adfce8f000000b0015df1098ccbso106100wrn.4
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 13:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=3jBAm38dwxejV13EKa37YtYOLD3eWnXj6fegh8i3dws=;
	b=v6FpcXkGNZgjRqN4EjT8Ly4EghGKBwc80rn7bhdXAT++TEyQjgVXUuysW7b6pwBJ9G
	0lrDpn7sKaTiRjkNUAQvrClIbCIDfX2Lc04+AIxTdH9WcSfXRrIU4/lA1CC2pfT/cdRK
	TxQI3t6ml+eebOVtsesrpNTPkPmnwl2X3Xx/YevkW86ZOdH/6bkv+ZQ53VXGNybe83GN
	lidl6rDtmJTmZBqEHnfouFhrzuL1DqL/JtHX5b1gyokBxM1lga2xaBt4UNhCyH69gDnr
	Phj8d0F9M7TGcBOoE8g8RNRJvQYPkaP1xQJA977uitlkC19VnvJmCl2GGG2O36+batHT
	KaAQ==
X-Gm-Message-State: AOAM530AOXIfoY+Hywg2O2uiBGkEFgerAz65bu+HAnOvT2ColCK0arXp
	RV0BozfMAotpaYNJA4E8J+Seb7gfjdA4VcQGfExn5p2sBlPTuzHIUcpMixK5dUPRThQwlZQCkAE
	7V5RjiBybMV1VNfnCOq0vr8oXtJ+vDUUZreprKA==
X-Received: by 2002:adf:fe11:: with SMTP id n17mr2531996wrr.134.1632861712997; 
	Tue, 28 Sep 2021 13:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ3DYdqCR9Z5PcqKHy1xm32GHNEUBLV2gDJNFBOzxHyUdTS2vH5aXkMEboVTXvHTdpTp6sggiL9+bBSwcUm1A=
X-Received: by 2002:adf:fe11:: with SMTP id n17mr2531978wrr.134.1632861712811; 
	Tue, 28 Sep 2021 13:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-4-agruenba@redhat.com>
	<CAL3q7H7PdBTuK28tN=3fGUyTP9wJU8Ydrq35YtNsfA_3xRQhzQ@mail.gmail.com>
	<CAHc6FU7rbdJxeuvoz0jov5y_GH_B4AtjkDnbNyOxeeNc1Zw5+A@mail.gmail.com>
	<YVNE4HGKPb7bw+En@casper.infradead.org>
In-Reply-To: <YVNE4HGKPb7bw+En@casper.infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 28 Sep 2021 22:41:41 +0200
Message-ID: <CAHc6FU47kX=P2VhjAxk-7hqiKoEHUMMzbC-8vRYfWXUVs9zAtQ@mail.gmail.com>
To: Matthew Wilcox <willy@infradead.org>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        fdmanana@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 03/19] gup: Turn
 fault_in_pages_{readable, writeable} into fault_in_{readable, writeable}
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280121
X-Proofpoint-GUID: cWpp_pB5be5FrdLKdHDc4mKFIpDYJnJ5
X-Proofpoint-ORIG-GUID: cWpp_pB5be5FrdLKdHDc4mKFIpDYJnJ5

Hi Willy,

On Tue, Sep 28, 2021 at 6:40 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Sep 28, 2021 at 05:02:43PM +0200, Andreas Gruenbacher wrote:
> > On Fri, Sep 3, 2021 at 4:57 PM Filipe Manana <fdmanana@gmail.com> wrote:
> > > On Fri, Aug 27, 2021 at 5:52 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> > > > +size_t fault_in_writeable(char __user *uaddr, size_t size)
> > > > +{
> > > > +       char __user *start = uaddr, *end;
> > > > +
> > > > +       if (unlikely(size == 0))
> > > > +               return 0;
> > > > +       if (!PAGE_ALIGNED(uaddr)) {
> > > > +               if (unlikely(__put_user(0, uaddr) != 0))
> > > > +                       return size;
> > > > +               uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
> > > > +       }
> > > > +       end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
> > > > +       if (unlikely(end < start))
> > > > +               end = NULL;
> > > > +       while (uaddr != end) {
> > > > +               if (unlikely(__put_user(0, uaddr) != 0))
> > > > +                       goto out;
> > > > +               uaddr += PAGE_SIZE;
> > >
> > > Won't we loop endlessly or corrupt some unwanted page when 'end' was
> > > set to NULL?
> >
> > What do you mean? We set 'end' to NULL when start + size < start
> > exactly so that the loop will stop when uaddr wraps around.
>
> But think about x86-64.  The virtual address space (unless you have 5
> level PTs) looks like:
>
> [0, 2^47)               userspace
> [2^47, 2^64 - 2^47)     hole
> [2^64 - 2^47, 2^64)     kernel space
>
> If we try to copy from the hole we'll get some kind of fault (I forget
> the details).  We have to stop at the top of userspace.

If you look at the before and after state of this patch,
fault_in_pages_readable and fault_in_pages_writeable did fail an
attempt to fault in a range that wraps with -EFAULT. That's sensible
for a function that returns an all-or-nothing result. We now want to
return how much of the range was (or wasn't) faulted in. We could do
that and still reject ranges that wrap outright. Or we could try to
fault in however much we reasonably can even if the range wraps. The
patch tries the latter, which is where the stopping at NULL is coming
from: when the range wraps, we *definitely* don't want to go any
further.

If the range extends into the hole, we'll get a failure from
__get_user or __put_user where that happens. That's entirely the
expected result, isn't it?

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
