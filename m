Return-Path: <SRS0=nImK=NJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BECC4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 21:50:28 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36AD8610FF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 21:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36AD8610FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ILbZDu023556;
	Wed, 18 Aug 2021 21:50:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agw7t2472-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 21:50:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17ILfLrd124368;
	Wed, 18 Aug 2021 21:50:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqkx3fv1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 18 Aug 2021 21:50:25 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGTS4-0006or-TV; Wed, 18 Aug 2021 14:50:24 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mGTRZ-0006f8-2n
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 14:49:53 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17ILf5xQ078730
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 21:49:52 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3ae5na8nn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 21:49:51 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17ILdUMT019802
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 21:49:50 GMT
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
	[209.85.167.43])
	by mx0b-00069f01.pphosted.com with ESMTP id 3age2p2k27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 21:49:48 +0000
Received: by mail-lf1-f43.google.com with SMTP id d4so7755106lfk.9
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 14:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=iJVkGRZsMGQxCh04dQEEetPATyoitTCuRRt3dR/OwaQ=;
	b=Lf6nt/9mUViZSG1H94TUp5y7c0TxtPTM8JJTPpFQkizYY6F0AvVI0zLLgGYKQqbLvj
	bbcZZmQEKmSswgII5lRU8ESowGyXxXfjhjgQNBLVde7C+tobCfgsr8dAasMLkMtuDLeW
	XespsiidEEYZ8gwfFiPrYQSqX8QrT7WM6aNgvrdDpmsfYT3X5tuwELMbe55zzkaOVNgh
	0l1cigiMZRZ0nUGnQ8eVlwgK3BEym8rGhK+wASv8Gs6Zrl63pCC8O/IOpetrBD/UTlGC
	ZFqMzZqaYOFLa9ucraV9uxglVwScsAX1vf2TT0qTyuHH5Yhcsi3ES0daRauydw3R5gu3
	Wthg==
X-Gm-Message-State: AOAM531pvSfCrCfHwHpj9kH1x3CwZLbbebfq0ZubOTnSyl5O8g2eiR4E
	PCm7coyjGEgs2E2Nj9QTdemJ4FJGHNFvi0/R
X-Google-Smtp-Source: ABdhPJyNlTZzDTvtOH5+qJFr/qytCT4/GXPmMu6ZdPwJlNPSTWVMootBFmwT3E3N385k9Rj+Wy6vnA==
X-Received: by 2002:a19:ee1a:: with SMTP id g26mr7898666lfb.611.1629323386200; 
	Wed, 18 Aug 2021 14:49:46 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com.
	[209.85.167.49])
	by smtp.gmail.com with ESMTPSA id f19sm98511lfu.100.2021.08.18.14.49.44
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id x27so7809974lfu.5
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
X-Received: by 2002:ac2:5a1a:: with SMTP id q26mr7636192lfn.41.1629323384436; 
	Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
	<CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
In-Reply-To: <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Aug 2021 14:49:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
Message-ID: <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.43
X-ServerName: mail-lf1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=136 adultscore=0
	bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
	clxscore=407
	spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180133
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180133
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180133
X-Proofpoint-ORIG-GUID: k0nUb9vbdVFq9_7gXE-r9bO5G3z9l_fA
X-Proofpoint-GUID: k0nUb9vbdVFq9_7gXE-r9bO5G3z9l_fA

[ Sorry for the delay, I was on the road and this fell through the cracks ]

On Mon, Aug 16, 2021 at 12:14 PM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> On Tue, Aug 3, 2021 at 9:45 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. Have you tried to figure out why that "still returns 0" happens?
>
> The call stack is:
>
> gup_pte_range
> gup_pmd_range
> gup_pud_range
> gup_p4d_range
> gup_pgd_range
> lockless_pages_from_mm
> internal_get_user_pages_fast
> get_user_pages_fast
> iov_iter_get_pages
> __bio_iov_iter_get_pages
> bio_iov_iter_get_pages
> iomap_dio_bio_actor
> iomap_dio_actor
> iomap_apply
> iomap_dio_rw
> gfs2_file_direct_write
>
> In gup_pte_range, pte_special(pte) is true and so we return 0.

Ok, so that is indeed something that the fast-case can't handle,
because some of the special code wants to have the mm_lock so that it
can look at the vma flags (eg "vm_normal_page()" and friends.

That said, some of these cases even the full GUP won't ever handle,
simply because a mapping doesn't necessarily even _have_ a 'struct
page' associated with it if it's a VM_IO mapping.

So it turns out that you can't just always do
fault_in_iov_iter_readable() and then assume that you can do
iov_iter_get_pages() and repeat until successful.

We could certainly make get_user_pages_fast() handle a few more cases,
but I get the feeling that we need to have separate error cases for
EFAULT - no page exists - and the "page exists, but cannot be mapped
as a 'struct page'" case.

I also do still think that even regardless of that, we want to just
add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
and then you can use the regular get_user_pages().

That at least gives us the full _normal_ page handling stuff.

                   Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
