Return-Path: <SRS0=Exlr=O7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B70C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 19:16:14 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE86F60F23
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 19:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE86F60F23
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BJB6bO025850;
	Mon, 11 Oct 2021 19:16:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bkxs5emu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 19:16:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BJF58J011827;
	Mon, 11 Oct 2021 19:16:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bkyv8sdhg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 11 Oct 2021 19:16:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ma0mQ-0000FJ-EJ; Mon, 11 Oct 2021 12:16:10 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1ma0mN-0000Ev-Lc
	for ocfs2-devel@oss.oracle.com; Mon, 11 Oct 2021 12:16:07 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BJF2fv147212
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 19:16:07 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bkyv7hjgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 19:16:07 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19BJD5n5014926
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 19:16:05 GMT
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
	[209.85.167.46])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bmu7y020k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 19:16:05 +0000
Received: by mail-lf1-f46.google.com with SMTP id t9so76327979lfd.1
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 12:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=8GEklByxwtz5UkrPD1VA8xZriJ2DJzNE/WJEIN7V+8A=;
	b=PGr6+tFX3cIh6qTJlLrgr40lIQumNOs3rI+P0BIqw7J9fBF75mY/dV/SrM6+LOYtsd
	M60tkVY2hRGKx6WuBo+H3Cf/pzZePy6aoEjnTMUIyM3/uwgeGg5xxm/ew01lVxX2Splx
	J9RZlg9/TWeJETm2FO9d4YZAO774CeVWymj8hrd2bBZuCjs64Ry04Cf1Bfnle8yOSLAA
	3/PkRTEkl7RWqP+gC9GI5lVCigoPemqXWUBbBKEMigem8dyjlVM/ylewCG4cgsuC9uUx
	Y5rnHQDtJcBoO4Y7ELEaRiyymkYZ2eqLth1AbaDbgMWXKC4GKg/TY3/gvsdYMAlReVVL
	ffFg==
X-Gm-Message-State: AOAM530MEEh1ZoNSo5GJPxvkJLh3eP5Cy+sGJ+BfsPpVdsf+GFdjuVN0
	0XXtSLtB3wccZgpgAx8MMxOdT0crOxcHN3Ot
X-Google-Smtp-Source: ABdhPJx94DHrpW9YFrETGYqXv6N/YlpE2OceYFbU3G9WtY7maqEg1goSpoZY8vCpM/zsUPWoymP7mA==
X-Received: by 2002:a05:651c:200e:: with SMTP id
	s14mr19132523ljo.397.1633979761942; 
	Mon, 11 Oct 2021 12:16:01 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com.
	[209.85.167.51])
	by smtp.gmail.com with ESMTPSA id r22sm810532lfm.78.2021.10.11.12.15.59
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 11 Oct 2021 12:16:00 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id u18so77479662lfd.12
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 12:15:59 -0700 (PDT)
X-Received: by 2002:a05:6512:12d3:: with SMTP id
	p19mr30204794lfg.280.1633979759600; 
	Mon, 11 Oct 2021 12:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
In-Reply-To: <YWR2cPKeDrc0uHTK@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Oct 2021 12:15:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
Message-ID: <CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.46
X-ServerName: mail-lf1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	suspectscore=0 adultscore=0
	mlxlogscore=999 bulkscore=0 lowpriorityscore=0 clxscore=391
	priorityscore=0 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110110110 domainage_hfrom=5410
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110111
X-Proofpoint-GUID: vyoY4wgBtYWg08mfwiOyyKd7Gq2Fzuy0
X-Proofpoint-ORIG-GUID: vyoY4wgBtYWg08mfwiOyyKd7Gq2Fzuy0

On Mon, Oct 11, 2021 at 10:38 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> I cleaned up this patch [1] but I realised it still doesn't solve it.
> The arm64 __copy_to_user_inatomic(), while ensuring progress if called
> in a loop, it does not guarantee precise copy to the fault position.

That should be ok., We've always allowed the user copy to return early
if it does word copies and hits a page crosser that causes a fault.

Any user then has the choice of:

 - partial copies are bad

 - partial copies are handled and then you retry from the place
copy_to_user() failed at

and in that second case, the next time around, you'll get the fault
immediately (or you'll make some more progress - maybe the user copy
loop did something different just because the length and/or alignment
was different).

If you get the fault immediately, that's -EFAULT.

And if you make some more progress, it's again up to the caller to
rinse and repeat.

End result: user copy functions do not have to report errors exactly.
It is the caller that has to handle the situation.

Most importantly: "exact error or not" doesn't actually _matter_ to
the caller. If the caller does the right thing for an exact error, it
will do the right thing for an inexact one too. See above.

> The copy_to_sk(), after returning an error, starts again from the previous
> sizeof(sh) boundary rather than from where the __copy_to_user_inatomic()
> stopped. So it can get stuck attempting to copy the same search header.

That seems to be purely a copy_to_sk() bug.

Or rather, it looks like a bug in the caller. copy_to_sk() itself does

                if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
                        ret = 0;
                        goto out;
                }

and the comment says

         *  0: all items from this leaf copied, continue with next

but that comment is then obviously not actually true in that it's not
"continue with next" at all.

But this is all very much a bug in the btrfs
search_ioctl()/copy_to_sk() code: it simply doesn't do the proper
thing for a partial result.

Because no, "just retry the whole thing" is by definition not the proper thing.

That said, I think that if we can have faults at non-page-aligned
boundaries, then we just need to make fault_in_pages_writeable() check
non-page boundaries.

> An ugly fix is to fall back to byte by byte copying so that we can
> attempt the actual fault address in fault_in_pages_writeable().

No, changing the user copy machinery is wrong. The caller really has
to do the right thing with partial results.

And I think we need to make fault_in_pages_writeable() match the
actual faulting cases - maybe remote the "pages" part of the name?

That would fix the btrfs code - it's not doing the right thing as-is,
but it's "close enough' to right that I think fixing
fault_in_pages_writeable() should fix it.

No?

             Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
