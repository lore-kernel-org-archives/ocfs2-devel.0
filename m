Return-Path: <SRS0=myWd=PO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB2CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 18:28:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 31AD360E05
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 18:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 31AD360E05
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QIR4Wv007135;
	Tue, 26 Oct 2021 18:28:07 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhxet9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Oct 2021 18:28:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QIFs7p177975;
	Tue, 26 Oct 2021 18:28:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4gps2st-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 26 Oct 2021 18:28:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfR83-0000Wy-Js; Tue, 26 Oct 2021 11:24:55 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mfR7c-0000W4-EF
	for ocfs2-devel@oss.oracle.com; Tue, 26 Oct 2021 11:24:28 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QIFxBO056325
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 18:24:28 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bx4h11s93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 18:24:28 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19QGNlAh019395
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 18:24:26 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bxfq16pd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 18:24:25 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9302360F9D;
	Tue, 26 Oct 2021 18:24:21 +0000 (UTC)
Date: Tue, 26 Oct 2021 19:24:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YXhH0sBSyTyz5Eh2@arm.com>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260102
X-Proofpoint-GUID: bk-0_gAM5qQdSz0Ul-ziYNEPcMR_V6Os
X-Proofpoint-ORIG-GUID: bk-0_gAM5qQdSz0Ul-ziYNEPcMR_V6Os

On Mon, Oct 25, 2021 at 09:00:43PM +0200, Andreas Gruenbacher wrote:
> On Fri, Oct 22, 2021 at 9:23 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Oct 22, 2021 at 8:06 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > Probing only the first byte(s) in fault_in() would be ideal, no need to
> > > go through all filesystems and try to change the uaccess/probing order.
> >
> > Let's try that. Or rather: probing just the first page - since there
> > are users like that btrfs ioctl, and the direct-io path.
> 
> For direct I/O, we actually only want to trigger page fault-in so that
> we can grab page references with bio_iov_iter_get_pages. Probing for
> sub-page error domains will only slow things down. If we hit -EFAULT
> during the actual copy-in or copy-out, we know that the error can't be
> page fault related. Similarly, in the buffered I/O case, we only
> really care about the next byte, so any probing beyond that is
> unnecessary.
> 
> So maybe we should split the sub-page error domain probing off from
> the fault-in functions. Or at least add an argument to the fault-in
> functions that specifies the amount of memory to probe.

My preferred option is not to touch fault-in for sub-page faults (though
I have some draft patches, they need testing).

All this fault-in and uaccess with pagefaults_disabled() is needed to
avoid a deadlock when the uaccess fault handling would take the same
lock. With sub-page faults, the kernel cannot fix it up anyway, so the
arch code won't even attempt call handle_mm_fault() (it is not an mm
fault). But the problem is the copy_*_user() etc. API that can only
return the number of bytes not copied. That's what I think should be
fixed. fault_in() feels like the wrong place to address this when it's
not an mm fault.

As for fault_in() getting another argument with the amount of sub-page
probing to do, I think the API gets even more confusing. I was also
thinking, with your patches for fault_in() now returning size_t, is the
expectation to be precise in what cannot be copied? We don't have such
requirement for copy_*_user().

While more intrusive, I'd rather change copy_page_from_iter_atomic()
etc. to take a pointer where to write back an error code. If it's
-EFAULT, retry the loop. If it's -EACCES/EPERM just bail out. Or maybe
simply a bool set if there was an mm fault to be retried. Yet another
option to return an -EAGAIN if it could not process the mm fault due to
page faults being disabled.

Happy to give this a try, unless there's a strong preference for the
fault_in() fix-up (well, I can do both options and post them).

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
