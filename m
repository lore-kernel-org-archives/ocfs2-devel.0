Return-Path: <SRS0=89/6=MT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E066C4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:14:16 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 14829619E3
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14829619E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RB8DCE003110;
	Tue, 27 Jul 2021 11:14:15 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a23589gk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 11:14:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16RB6jqj005350;
	Tue, 27 Jul 2021 11:14:14 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a234va6cc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 27 Jul 2021 11:14:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m8L2K-0003X8-Sg; Tue, 27 Jul 2021 04:14:12 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1m8L2F-0003Wg-Qf
	for ocfs2-devel@oss.oracle.com; Tue, 27 Jul 2021 04:14:07 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16RB5UHQ142097
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 11:14:07 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3a234800t4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 11:14:07 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16RB9frR019109
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 11:14:06 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a2367yv3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 11:14:05 +0000
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
	[209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-529-_O-fnTKzNtaCd8fsHddgVQ-1; Tue, 27 Jul 2021 07:14:00 -0400
X-MC-Unique: _O-fnTKzNtaCd8fsHddgVQ-1
Received: by mail-wr1-f70.google.com with SMTP id
	s16-20020adfdb100000b0290140a25efc6dso5904205wri.5
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 04:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=afrSbaGGjeeVykwqXymNzbcEw/D8kWccnFVpP7E5Guw=;
	b=Eho7cVLqp2x06ZeER7OpXxBa6GEmiitEACrL/asgmJPD3O7cWF4gW5qMxcXITxLLE8
	qk/VWufVE5jWuv9ic1QJz6vISPjaZVNwgZw7y0btVORiDYYyzfNHQXY5N14UgQIOwoOh
	LE8B/kg8JSXAtCHp0cVGu5XwPWt4pJzJPq2aZbMsztIOo/dm33JGXevLHSUwpCMbsb7X
	w4oAeLPVPM8hokzNjFHgowIP4nySxuTKjCMOKfWHWJf6Der4hFm5aXNHJTfsMRqYa1ZP
	5xM/pRu28UyqRg2PCM3c7XWo2TJd/HVRYKR2/VHlx00EBfgdiVdW8t095MnmlTKp6Czl
	DMXg==
X-Gm-Message-State: AOAM532miTyTbcld9ZrH46UneHjZShQm9i27gfaWezQyfSGS/NUK9e3O
	HB8gwedDoSjjgdVlrmdXFlStgruPDO17fsD0Ue+ca3KhhRVsVpJpU16yb0YeAR3mSzTG04Sqyk/
	K9wNbKxKGEXh8EqjpMtA8erJ0/65sbwk6LHd+Tg==
X-Received: by 2002:a1c:2282:: with SMTP id
	i124mr21633325wmi.166.1627384439578; 
	Tue, 27 Jul 2021 04:13:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzfklfZGsBuVC9rf1FJG+V3aLBjS+SfsovPyqckWGhLMBFH25HVSmfqV0mFgBo9h9VeIN01a4/gyJ0JOvSo60=
X-Received: by 2002:a1c:2282:: with SMTP id
	i124mr21633303wmi.166.1627384439403; 
	Tue, 27 Jul 2021 04:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
	<03e0541400e946cf87bc285198b82491@AcuMS.aculab.com>
In-Reply-To: <03e0541400e946cf87bc285198b82491@AcuMS.aculab.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 27 Jul 2021 13:13:47 +0200
Message-ID: <CAHc6FU4N7vz+jfoUSa45Mr_F0Ht0_PXroWoc5UNkMgFmpKLaNw@mail.gmail.com>
To: David Laight <David.Laight@aculab.com>
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
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	adultscore=0 suspectscore=0
	malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107270065
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
	iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270065
X-Proofpoint-GUID: ubvKjbmxQyCvZ7O18pqwUZgBEXpsXJNA
X-Proofpoint-ORIG-GUID: ubvKjbmxQyCvZ7O18pqwUZgBEXpsXJNA

On Tue, Jul 27, 2021 at 11:30 AM David Laight <David.Laight@aculab.com> wrote:
> From: Linus Torvalds
> > Sent: 24 July 2021 20:53
> >
> > On Sat, Jul 24, 2021 at 12:35 PM Andreas Gruenbacher
> > <agruenba@redhat.com> wrote:
> > >
> > > +int iov_iter_fault_in_writeable(const struct iov_iter *i, size_t bytes)
> > > +{
> > ...
> > > +                       if (fault_in_user_pages(start, len, true) != len)
> > > +                               return -EFAULT;
> >
> > Looking at this once more, I think this is likely wrong.
> >
> > Why?
> >
> > Because any user can/should only care about at least *part* of the
> > area being writable.
> >
> > Imagine that you're doing a large read. If the *first* page is
> > writable, you should still return the partial read, not -EFAULT.
>
> My 2c...
>
> Is it actually worth doing any more than ensuring the first byte
> of the buffer is paged in before entering the block that has
> to disable page faults?

We definitely do want to process as many pages as we can, especially
if allocations are involved during a write.

> Most of the all the pages are present so the IO completes.

That's not guaranteed. There are cases in which none of the pages are
present, and then there are cases in which only the first page is
present (for example, because of a previous access that wasn't page
aligned).

> The pages can always get unmapped (due to page pressure or
> another application thread unmapping them) so there needs
> to be a retry loop.
> Given the cost of actually faulting in a page going around
> the outer loop may not matter.
> Indeed, if an application has just mmap()ed in a very large
> file and is then doing a write() from it then it is quite
> likely that the pages got unmapped!
>
> Clearly there needs to be extra code to ensure progress is made.
> This might actually require the use of 'bounce buffers'
> for really problematic user requests.

I'm not sure if repeated unmapping of the pages that we've just
faulted in is going to be a problem (in terms of preventing progress).
But a suitable heuristic might be to shrink the fault-in "window" on
each retry until it's only one page.

> I also wonder what actually happens for pipes and fifos.
> IIRC reads and write of up to PIPE_MAX (typically 4096)
> are expected to be atomic.
> This should be true even if there are page faults part way
> through the copy_to/from_user().
>
> It has to be said I can't see any reference to PIPE_MAX
> in the linux man pages, but I'm sure it is in the POSIX/TOG
> spec.
>
>         David

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
