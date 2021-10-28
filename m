Return-Path: <SRS0=40Y/=PQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E00BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 22:16:20 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F6E461056
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 22:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F6E461056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SKnt91022926;
	Thu, 28 Oct 2021 22:16:19 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byhqrcyut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Oct 2021 22:16:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19SMC2pk064609;
	Thu, 28 Oct 2021 22:16:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4gtgtn2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Oct 2021 22:16:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mgDgy-0001sM-L0; Thu, 28 Oct 2021 15:16:12 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1mgDgw-0001rx-Aq
	for ocfs2-devel@oss.oracle.com; Thu, 28 Oct 2021 15:16:10 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19SMC2Rx064668
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:16:10 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3bx4gtgtht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:16:09 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19SHKS1e022275
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:16:08 GMT
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
	[209.85.166.44])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bynmtbqpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 22:16:08 +0000
Received: by mail-io1-f44.google.com with SMTP id g8so8814877iob.10
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 15:16:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=rg70L5/px9IrBTtKlC6NDcYo4kfwnEG9jTpOWhVqPcc=;
	b=VbojsEjSkLYRdaQWGYTpGvz59iOat5Slv1xzbGINpZuaDyAwGABbjkqgxTzvSFx72q
	wOjXEc2gfYcGOQG5zagRhpd5TnqGn0jL3gmgeJdJEdOnbmslw7dklaqCNNY2e2zAT03F
	nHCEGDkzIBPlS2eJXO8HDFyDm7XEEHLHm2NW3sjuetiEn+5aQyUCLuarpliH200ouMaq
	EvhkBVYSjL8Ydey5493WU1WM7jHPwkUk76ANzQFjPaB4M1LOCejx6yqU8pLzSsHN4vYQ
	VeanqiEv9+JRuJlGzphy/+NH7Wup3TE4e+Gc1GdAt5paVskPUr+EQExXkdfui9sae7tN
	owEA==
X-Gm-Message-State: AOAM531q0s0O62+nHIuOPz3oNsMf4AOrxpB6pPH2rYLIZlzAPXCM6yyd
	rrhQGLSa2gwVNMlCFw6aNqWtvhaL/ml/IbsrB8E=
X-Google-Smtp-Source: ABdhPJwQxQk+UInDEwQGMzT3vtIBaThPNMfpgrXChu4UuLq9KZI3dYCJq/rt6DgOPhDRcNVWlcfUbesD2a/U+JO29i0=
X-Received: by 2002:a05:6602:736:: with SMTP id
	g22mr5165002iox.139.1635459366944; 
	Thu, 28 Oct 2021 15:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
	<YXmkvfL9B+4mQAIo@arm.com>
	<CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
	<YXsUNMWFpmT1eQcX@arm.com>
In-Reply-To: <YXsUNMWFpmT1eQcX@arm.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Fri, 29 Oct 2021 00:15:55 +0200
Message-ID: <CAHpGcMLeiXSjCJGY6SCJJ=bdNOspHLHofmTE8aC_sZtfHRG5ZA@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.166.44
X-ServerName: mail-io1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=359 impostorscore=0
	clxscore=187 phishscore=0 mlxlogscore=780 spamscore=0 bulkscore=0
	suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110280117 domainage_hfrom=9573
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280117
X-Proofpoint-GUID: blmq10_pLH37kpYdlwf6dAADqUGyscx6
X-Proofpoint-ORIG-GUID: blmq10_pLH37kpYdlwf6dAADqUGyscx6

Am Do., 28. Okt. 2021 um 23:21 Uhr schrieb Catalin Marinas
<catalin.marinas@arm.com>:
> One last try on this path before I switch to the other options.
>
> On Wed, Oct 27, 2021 at 02:14:48PM -0700, Linus Torvalds wrote:
> > On Wed, Oct 27, 2021 at 12:13 PM Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > As an alternative, you mentioned earlier that a per-thread fault status
> > > was not feasible on x86 due to races. Was this only for the hw poison
> > > case? I think the uaccess is slightly different.
> >
> > It's not x86-specific, it's very generic.
> >
> > If we set some flag in the per-thread status, we'll need to be careful
> > about not overwriting it if we then have a subsequent NMI that _also_
> > takes a (completely unrelated) page fault - before we then read the
> > per-thread flag.
> >
> > Think 'perf' and fetching backtraces etc.
> >
> > Note that the NMI page fault can easily also be a pointer coloring
> > fault on arm64, for exactly the same reason that whatever original
> > copy_from_user() code was. So this is not a "oh, pointer coloring
> > faults are different". They have the same re-entrancy issue.
> >
> > And both the "pagefault_disable" and "fault happens in interrupt
> > context" cases are also the exact same 'faulthandler_disabled()'
> > thing. So even at fault time they look very similar.
>
> They do look fairly similar but we should have the information in the
> fault handler to distinguish: not a page fault (pte permission or p*d
> translation), in_task(), user address, fixup handler. But I agree the
> logic looks fragile.
>
> I think for nested contexts we can save the uaccess fault state on
> exception entry, restore it on return. Or (needs some thinking on
> atomicity) save it in a local variable. The high-level API would look
> something like:
>
>         unsigned long uaccess_flags;    /* we could use TIF_ flags */
>
>         uaccess_flags = begin_retriable_uaccess();
>         copied = copy_page_from_iter_atomic(...);
>         retry = end_retriable_uaccess(uaccess_flags);
>         ...
>
>         if (!retry)
>                 break;
>
> I think we'd need a TIF flag to mark the retriable region and another to
> track whether a non-recoverable fault occurred. It needs prototyping.
>
> Anyway, if you don't like this approach, I'll look at error codes being
> returned but rather than changing all copy_from_user() etc., introduce a
> new API that returns different error codes depending on the fault
> (e.g -EFAULT vs -EACCES). We already have copy_from_user_nofault(), we'd
> need something for the iov_iter stuff to use in the fs code.

We won't need any of that on the filesystem read and write paths. The
two cases there are buffered and direct I/O:

* In the buffered I/O case, the copying happens with page faults
disabled, at a byte granularity. If that returns a short result, we
need to enable page faults, check if the exact address that failed
still fails (in which case we have a sub-page fault),  fault in the
pages, disable page faults again, and repeat. No probing for sub-page
faults beyond the first byte of the fault-in address is needed.
Functions fault_in_{readable,writeable} implicitly have this behavior;
for fault_in_safe_writeable() the choice we have is to either add
probing of the first byte for sub-page faults to this function or
force callers to do that probing separately. At this point, I'd vote
for the former.

* In the direct I/O case, the copying happens while we're holding page
references, so the only page faults that can occur during copying are
sub-page faults. When iomap_dio_rw or its legacy counterpart is called
with page faults disabled, we need to make sure that the caller can
distinguish between page faults triggered during
bio_iov_iter_get_pages() and during the copying, but that's a separate
problem. (At the moment, when iomap_dio_rw fails with -EFAULT, the
caller *cannot* distinguish between a bio_iov_iter_get_pages failure
and a failure during synchronous copying, but that could be fixed by
returning unique error codes from iomap_dio_rw.)

So as far as I can see, the only problematic case we're left with is
copying bigger than byte-size chunks with page faults disabled when we
don't know whether the underlying pages are resident or not. My guess
would be that in this case, if the copying fails, it would be
perfectly acceptable to explicitly probe the entire chunk for sub-page
faults.

Thanks,
Andreas

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
