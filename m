Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27300C4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:45:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAF5C60F0F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CAF5C60F0F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173JWQKF008982;
	Tue, 3 Aug 2021 19:45:33 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqdc3pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 19:45:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173JVPYe056788;
	Tue, 3 Aug 2021 19:45:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4un08xsg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 19:45:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mB0Ly-00019N-Ff; Tue, 03 Aug 2021 12:45:30 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mB0Lv-000196-Hx
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 12:45:27 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173JTsjO040702
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:45:27 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3a4xb79j8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:45:27 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173JR98Y001185
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:45:26 GMT
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
	[209.85.167.51])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a77m8k19c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:45:25 +0000
Received: by mail-lf1-f51.google.com with SMTP id a26so409283lfr.11
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 12:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=wgvkBYw+RpMWC0ZlFt+HsFq+ODf+zPXLM/hz4eQHmew=;
	b=RhCPBTWwyWWXNZ305a1eEQy9cLaC3uOguQmBAW8yP9Fv4O4AseMyZQNg9wc5QjRqXC
	SBxDXGhlTn5ehCNGJpxwHdBPzHUp5WyjZQ4GezkYSIFoNSl5hugEFhVk+6PLJa1+sWbW
	2D5USHj9hobMdFNVzJKeog6lbrWJTQqT1sXfRezqCue/gKcL9Xty1o8dlBzRBaMI5Vcs
	ATndtgu5elEn2A5KTY59BLqKJigwX9B8mbw6x08qRtnUQTWD3VzcZhnVC19Y6Rqp5NDm
	l3vtpqLN8y2Iwh/TQzjwfLj/yH94Wt03DJcQLXIwEHJoJrsMVFBnCYkUR23bYRJ+Nvxv
	Z7tQ==
X-Gm-Message-State: AOAM530VZNtGJNPk7+HHiuDsWDQG0JbjO1girDitmXn2C+xEAHmzI3fj
	Si0vrKyGbMDazEVZVv8glE1jGh2257J+h58n
X-Google-Smtp-Source: ABdhPJxQYHydG/jSIx8qNdm/RBzWxTlmiTyjXpLkd5Xo5EfmMDaXSYXA/PSuUIQB0MUW8FttfQhowg==
X-Received: by 2002:a05:6512:128e:: with SMTP id
	u14mr14053722lfs.459.1628019923022; 
	Tue, 03 Aug 2021 12:45:23 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com.
	[209.85.208.177])
	by smtp.gmail.com with ESMTPSA id o1sm1193290lfl.67.2021.08.03.12.45.20
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 03 Aug 2021 12:45:21 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id n6so29495301ljp.9
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 12:45:20 -0700 (PDT)
X-Received: by 2002:a2e:84c7:: with SMTP id q7mr15542412ljh.61.1628019920208; 
	Tue, 03 Aug 2021 12:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
In-Reply-To: <20210803191818.993968-1-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Aug 2021 12:45:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
Message-ID: <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.51
X-ServerName: mail-lf1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=60 malwarescore=0
	impostorscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
	bulkscore=0 lowpriorityscore=0 clxscore=403 mlxscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030124
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 malwarescore=0
	bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030124
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030124
X-Proofpoint-ORIG-GUID: JYSsM4C8Q4vAkFBw1bxrhAa6vc8NhzTS
X-Proofpoint-GUID: JYSsM4C8Q4vAkFBw1bxrhAa6vc8NhzTS

On Tue, Aug 3, 2021 at 12:18 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
>
> With this patch queue, fstest generic/208 (aio-dio-invalidate-failure.c)
> endlessly spins in gfs2_file_direct_write.  It looks as if there's a bug
> in get_user_pages_fast when called with FOLL_FAST_ONLY:
>
>  (1) The test case performs an aio write into a 32 MB buffer.
>
>  (2) The buffer is initially not in memory, so when iomap_dio_rw() ->
>      ... -> bio_iov_iter_get_pages() is called with the iter->noio flag
>      set, we get to get_user_pages_fast() with FOLL_FAST_ONLY set.
>      get_user_pages_fast() returns 0, which causes
>      bio_iov_iter_get_pages to return -EFAULT.
>
>  (3) Then gfs2_file_direct_write faults in the entire buffer with
>      fault_in_iov_iter_readable(), which succeeds.
>
>  (4) With the buffer in memory, we retry the iomap_dio_rw() ->
>      ... -> bio_iov_iter_get_pages() -> ... -> get_user_pages_fast().
>      This should succeed now, but get_user_pages_fast() still returns 0.

Hmm. Have you tried to figure out why that "still returns 0" happens?

One option - for debugging only - would be to introduce a new flag to
get_user_pages_fast() tyhat says "print out reason if failed" and make
the retry (but not the original one) have that flag set.

There are a couple of things of note when it comes to "get_user_pages_fast()":

 (a) some architectures don't even enable it

 (b) it can be very picky about the page table contents, and wants the
accessed bit to already be set (or the dirty bit, in the case of a
write).

but (a) shouldn't be an issue on any common platform and (b) shouldn't
be an issue with  fault_in_iov_iter_readable() that actually does a
__get_user() so it will access through the page tables.

(It might be more of an issue with fault_in_iov_iter_writable() due to
walking the page tables by hand - if we don't do the proper
access/dirty setting, I could see get_user_pages_fast() failing).

Anyway, for reason (a) I do think that eventually we should probably
introduce FOLL_NOFAULT, and allow the full "slow" page table walk -
just not calling down to handle_mm_fault() if it fails.

But (a) should be a non-issue in your test environment, and so it
would be interesting to hear what it is that fails. Because scanning
through the patches, they all _look_ fine to me (apart from the one
comment about return values, which is more about being consistent with
copy_to/from_user() and making the code simpler - not about
correctness)

                       Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
