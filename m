Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBB4C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 18:31:09 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A718160FDC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 18:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A718160FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PHnjV5030370;
	Mon, 25 Oct 2021 18:31:07 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bw6v1vvf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 18:31:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PILqjC034190;
	Mon, 25 Oct 2021 18:31:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bvv5sgh2c-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 18:31:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf4eN-00052Y-93; Mon, 25 Oct 2021 11:24:47 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mf4eK-00052K-Hl
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 11:24:44 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PILthd194280
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 18:24:44 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bv7gv4be5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 18:24:44 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PGpfhi011277
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 18:24:43 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bwwcv3yjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 18:24:42 +0000
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
	[209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-384-3f6SFxuSMJm1sY16hcX6Fw-1; Mon, 25 Oct 2021 14:24:38 -0400
X-MC-Unique: 3f6SFxuSMJm1sY16hcX6Fw-1
Received: by mail-wm1-f69.google.com with SMTP id
	128-20020a1c0486000000b0030dcd45476aso4048135wme.0
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 11:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=F3SLaknlCrgsyNEFXulutuLS6zkvJHd+fv8cS/rpPqI=;
	b=voj+gZWIL/k/XRlAVSP5y9IcQU13MN4cO9sklqfi2jCyAEBZp3lACV0qDXjMTMsQEg
	9rR94kr5SVLBgbqdoFxh3q3nirBcUYmad+n1fi/9YW5VTSsX29kBk3My30NfkVx0jSBE
	WasTuZp7MU31m9yL99JgFaavKJ6gOwmlCELO9hvx/dnFdlfurLuIV4P95kYf1aSQSOwl
	aOs8eqi808qFeCfySIQDyodv4686k3cddpaHgnr6Wpyiy/QtfwSf9BFVGk9dov/yalzL
	p6BJ6MH70hoxYI5NdwpkHYeoeNFOkAvPxfHvkA8oJ8F336naL7ZA3bPXvDqRRkOwBGbK
	WYpg==
X-Gm-Message-State: AOAM532i/AyGHrLOArti3qjlVaaMLhaUkC1OHULE8BbgFgql51UuKNVW
	OmbahcEhKnUgbHQRjrDhLPHKPo4sp6ORor9ZbZZftzpTqD96/pU47tp1E1dEGilcAkZ7H4ruHAl
	GZxEIArq/dSDVT0tnIJmUzQVqGHMqC4CmKZiNAA==
X-Received: by 2002:a5d:4bc2:: with SMTP id l2mr24538443wrt.81.1635186277624; 
	Mon, 25 Oct 2021 11:24:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFzXJ9qteuovw6CsfxV07yOsXNr94Jrc52XFmj3IWaW0sfPtl2ViNad/7UKAIgfk9H2m/v1wcPdQgWW5/Viog=
X-Received: by 2002:a5d:4bc2:: with SMTP id l2mr24538418wrt.81.1635186277388; 
	Mon, 25 Oct 2021 11:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
In-Reply-To: <YXL9tRher7QVmq6N@arm.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 25 Oct 2021 20:24:26 +0200
Message-ID: <CAHc6FU6JC4ZOwA8t854WbNdmuiNL9DPq0FPga8guATaoCtvsaw@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, "Ted Ts'o" <tytso@mit.edu>
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
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
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
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250107
X-Proofpoint-GUID: 2DXSfoh-UJnv9UjleRENX1TUjlr8F0gn
X-Proofpoint-ORIG-GUID: 2DXSfoh-UJnv9UjleRENX1TUjlr8F0gn

commit
On Fri, Oct 22, 2021 at 8:07 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Oct 20, 2021 at 08:19:40PM -1000, Linus Torvalds wrote:
> > On Wed, Oct 20, 2021 at 12:44 PM Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > >
> > > However, with MTE doing both get_user() every 16 bytes and
> > > gup can get pretty expensive.
> >
> > So I really think that anything that is performance-critical had
> > better only do the "fault_in_write()" code path in the cold error path
> > where you took a page fault.
> [...]
> > So I wouldn't worry too much about the performance concerns. It simply
> > shouldn't be a common or hot path.
> >
> > And yes, I've seen code that does that "fault_in_xyz()" before the
> > critical operation that cannot take page faults, and does it
> > unconditionally.
> >
> > But then it isn't the "fault_in_xyz()" that should be blamed if it is
> > slow, but the caller that does things the wrong way around.
>
> Some more thinking out loud. I did some unscientific benchmarks on a
> Raspberry Pi 4 with the filesystem in a RAM block device and a
> "dd if=/dev/zero of=/mnt/test" writing 512MB in 1MB blocks. I changed
> fault_in_readable() in linux-next to probe every 16 bytes:
>
> - ext4 drops from around 261MB/s to 246MB/s: 5.7% penalty
>
> - btrfs drops from around 360MB/s to 337MB/s: 6.4% penalty
>
> For generic_perform_write() Dave Hansen attempted to move the fault-in
> after the uaccess in commit 998ef75ddb57 ("fs: do not prefault
> sys_write() user buffer pages"). This was reverted as it was exposing an
> ext4 bug. I don't [know] whether it was fixed but re-applying Dave's commit
> avoids the performance drop.

Interesting. The revert of commit 998ef75ddb57 is in commit
00a3d660cbac. Maybe Dave and Ted can tell us more about what went
wrong in ext4 and whether it's still an issue.

Commit 998ef75ddb57 looks mostly good except that it should loop
around whenever the fault-in succeeds even partially, so it needs the
semantic change of patch 4 [*] of this series. A copy of the same code
now lives in iomap_write_iter, so the same fix needs to be applied
there. Finally, it may be worthwhile to check for pagefault_disabled()
in generic_perform_write and iomap_write_iter before trying the
fault-in; this would help gfs2 which will always call into
iomap_write_iter with page faults disabled, and additional callers
like that could emerge relatively soon.

[*] https://lore.kernel.org/lkml/20211019134204.3382645-5-agruenba@redhat.com/

> btrfs_buffered_write() has a comment about faulting pages in before
> locking them in prepare_pages(). I suspect it's a similar problem and
> the fault_in() could be moved, though I can't say I understand this code
> well enough.
>
> Probing only the first byte(s) in fault_in() would be ideal, no need to
> go through all filesystems and try to change the uaccess/probing order.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
