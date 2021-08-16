Return-Path: <SRS0=Wa/f=NH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E592EC4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Aug 2021 19:15:04 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 817FF60F4B
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Aug 2021 19:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 817FF60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GJ6BHG023698;
	Mon, 16 Aug 2021 19:15:03 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3afgmb9yqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Aug 2021 19:15:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GJEtJV123539;
	Mon, 16 Aug 2021 19:15:02 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqksquek-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 16 Aug 2021 19:15:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mFi4Z-0008Rk-Ib; Mon, 16 Aug 2021 12:14:59 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mFi43-0008LL-Gw
	for ocfs2-devel@oss.oracle.com; Mon, 16 Aug 2021 12:14:27 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17GJ6r5Y095851
	for <ocfs2-devel@oss.oracle.com>; Mon, 16 Aug 2021 19:14:27 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3ae3vea4sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 16 Aug 2021 19:14:27 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17GJDGAu026168
	for <ocfs2-devel@oss.oracle.com>; Mon, 16 Aug 2021 19:14:26 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3afge0r00f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 16 Aug 2021 19:14:25 +0000
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
	[209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-523-PwAQOhLJNYWV6pYDO_8llQ-1; Mon, 16 Aug 2021 15:14:22 -0400
X-MC-Unique: PwAQOhLJNYWV6pYDO_8llQ-1
Received: by mail-wr1-f72.google.com with SMTP id
	v18-20020adfe2920000b029013bbfb19640so5756178wri.17
	for <ocfs2-devel@oss.oracle.com>; Mon, 16 Aug 2021 12:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=lWy3l2+IfO7xO6oKpqVQHj7y0vYczHZZ4SIluKLQLb8=;
	b=o9KZsJLg3PzTnRrhjv73WmQJLOTBWMG1cisY6WohjXSjopSyBA7WqkN1Qik473u1c+
	E73FVi/l8RtywcHBkBHc5YlKS509rP+/AmSvqWIb2qmmXlC7DGh8eES8cypu8p6JaPTh
	eXkawsSBTlJ3oRWlwqfhkiQ2Brk5hzkkoPQPTStE+TXRkm0rzwGRKaT7M2tQ3RPruoti
	K9g3BRYVtXGBXaSOhwZRq3HjF2j6djqrThgLw/eZus+0pz1W4b+t5VqfuB//V42uB8F/
	9Zmw2sLncQ2gJJxBEL6UDh89Va65lP1sAEU0N/Qo6ycCWwDvqm1MDxeLI6jqcH7A/ZGY
	uSiQ==
X-Gm-Message-State: AOAM530ZyOPwFYWf1wL0a++l1fZortbxFUYXN81PO8c0g6rxPcHmImmf
	T2TN8jrhe4PB3aY2SQQlljsJg0IlpWOlE7iUquO3u0IazYn4rgb11rChrxx5kJsXV9nJydQF9nw
	UESIH2Xhp0cyuO27v/P6Bpt2xu7q78WtVUGpqdA==
X-Received: by 2002:a5d:674b:: with SMTP id l11mr18978883wrw.357.1629141260956;
	Mon, 16 Aug 2021 12:14:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3e2hMfKU0iq3mIOu2m32crL3qBkqbuiWv8L806qkeQbGdArMICY3wU0R/Jc0O1nkrsAQGzAuFreIkqVtHZaU=
X-Received: by 2002:a5d:674b:: with SMTP id l11mr18978869wrw.357.1629141260774;
	Mon, 16 Aug 2021 12:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
In-Reply-To: <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 16 Aug 2021 21:14:09 +0200
Message-ID: <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108160121
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160122
X-Proofpoint-ORIG-GUID: iw248Ar5kJ1EC0idpVUaefS03ArAuWyZ
X-Proofpoint-GUID: iw248Ar5kJ1EC0idpVUaefS03ArAuWyZ

On Tue, Aug 3, 2021 at 9:45 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Aug 3, 2021 at 12:18 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> > With this patch queue, fstest generic/208 (aio-dio-invalidate-failure.c)
> > endlessly spins in gfs2_file_direct_write.  It looks as if there's a bug
> > in get_user_pages_fast when called with FOLL_FAST_ONLY:
> >
> >  (1) The test case performs an aio write into a 32 MB buffer.
> >
> >  (2) The buffer is initially not in memory, so when iomap_dio_rw() ->
> >      ... -> bio_iov_iter_get_pages() is called with the iter->noio flag
> >      set, we get to get_user_pages_fast() with FOLL_FAST_ONLY set.
> >      get_user_pages_fast() returns 0, which causes
> >      bio_iov_iter_get_pages to return -EFAULT.
> >
> >  (3) Then gfs2_file_direct_write faults in the entire buffer with
> >      fault_in_iov_iter_readable(), which succeeds.
> >
> >  (4) With the buffer in memory, we retry the iomap_dio_rw() ->
> >      ... -> bio_iov_iter_get_pages() -> ... -> get_user_pages_fast().
> >      This should succeed now, but get_user_pages_fast() still returns 0.
>
> Hmm. Have you tried to figure out why that "still returns 0" happens?

The call stack is:

gup_pte_range
gup_pmd_range
gup_pud_range
gup_p4d_range
gup_pgd_range
lockless_pages_from_mm
internal_get_user_pages_fast
get_user_pages_fast
iov_iter_get_pages
__bio_iov_iter_get_pages
bio_iov_iter_get_pages
iomap_dio_bio_actor
iomap_dio_actor
iomap_apply
iomap_dio_rw
gfs2_file_direct_write

In gup_pte_range, pte_special(pte) is true and so we return 0.

> One option - for debugging only - would be to introduce a new flag to
> get_user_pages_fast() that says "print out reason if failed" and make
> the retry (but not the original one) have that flag set.
>
> There are a couple of things of note when it comes to "get_user_pages_fast()":
>
>  (a) some architectures don't even enable it
>
>  (b) it can be very picky about the page table contents, and wants the
> accessed bit to already be set (or the dirty bit, in the case of a
> write).
>
> but (a) shouldn't be an issue on any common platform and (b) shouldn't
> be an issue with  fault_in_iov_iter_readable() that actually does a
> __get_user() so it will access through the page tables.
>
> (It might be more of an issue with fault_in_iov_iter_writable() due to
> walking the page tables by hand - if we don't do the proper
> access/dirty setting, I could see get_user_pages_fast() failing).
>
> Anyway, for reason (a) I do think that eventually we should probably
> introduce FOLL_NOFAULT, and allow the full "slow" page table walk -
> just not calling down to handle_mm_fault() if it fails.
>
> But (a) should be a non-issue in your test environment, and so it
> would be interesting to hear what it is that fails. Because scanning
> through the patches, they all _look_ fine to me (apart from the one
> comment about return values, which is more about being consistent with
> copy_to/from_user() and making the code simpler - not about
> correctness)
>
>                        Linus
>

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
