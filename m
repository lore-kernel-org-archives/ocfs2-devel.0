Return-Path: <SRS0=55Qa=IA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BB6C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 05:44:31 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A57B660241
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 05:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A57B660241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1225iTrX149334;
	Tue, 2 Mar 2021 05:44:29 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36ye1m6716-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Mar 2021 05:44:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1225YuAx168770;
	Tue, 2 Mar 2021 05:44:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000wgy91-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Mar 2021 05:44:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGxmY-0002rz-4r; Mon, 01 Mar 2021 21:41:18 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lGxmU-0002ri-Ts
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 21:41:15 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1225YU5G070402
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 05:41:14 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 36yyurh9gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 05:41:14 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1225Y9pG014429
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 05:41:14 GMT
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
	[209.85.218.41]) by userp2040.oracle.com with ESMTP id 36ycpush10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 05:41:13 +0000
Received: by mail-ej1-f41.google.com with SMTP id mm21so32576284ejb.12
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 21:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=qh4mKoIkd3kQcCA7D3vdmXdlqTwhkSQo5TnRd9KvzpU=;
	b=pvS1K4m4KeToW8zAcnWBgiblvC8EIKnr2BmK5YXQRRvLcjYVHvUeFn/CtG/VGDV8k7
	wNuPx9EQD3iZK5eUIyxJjJRaEySohuvaPv9leyjrZo6xBKgPORigigxeSaJ/ZXF7+NJh
	iUjGMUAf4RcXfZ62KhZzEEsqLIUhKKW2DqZVU2F77IN2YGs9hRmV2yZOgiLhsC1uwG/5
	L+muAbHZD/PRvda/UXvaM1K+w7WB24cVhgkIzeitsYIaRbPPlz6Sv1+hKmbhZ7rNS74e
	y4LnMTB2ygGrqMGE3DrPxWVF8bum9sfsnRk6NAvOncJmefW3mKofM+yKVFIobek/JMqe
	2PXw==
X-Gm-Message-State: AOAM531exaxxaiD0ZddtvdgpNPvFOAMBn0z8ZkQhcGyzt9cea14gRQD0
	bEV3TE+N7JwoSeIRsnDxTPfbRzuh3iI6NU4vX9mHLg==
X-Google-Smtp-Source: ABdhPJxSTLNvImcrUmvKf16p/MTyfu851ZZ+6qH6ZGGBP8HSYNNJYVzLikGtLufav/PCWMtKvjVEi1My0ZZJ0iw+rtA=
X-Received: by 2002:a17:906:2818:: with SMTP id
	r24mr19400531ejc.472.1614663671165; 
	Mon, 01 Mar 2021 21:41:11 -0800 (PST)
MIME-Version: 1.0
References: <20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<20210226205126.GX4662@dread.disaster.area>
	<CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
	<20210226212748.GY4662@dread.disaster.area>
	<CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
	<20210227223611.GZ4662@dread.disaster.area>
	<CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
	<20210228223846.GA4662@dread.disaster.area>
	<CAPcyv4jzV2RUij2BEvDJLLiK_67Nf1v3M6-jRLKf32x4iOzqng@mail.gmail.com>
	<20210302032805.GM7272@magnolia>
In-Reply-To: <20210302032805.GM7272@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Mar 2021 21:41:02 -0800
Message-ID: <CAPcyv4jXH0F+aii6ZtYQ3=Rx-mOWM7NFHC9wVxacW-b1o_s20g@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-PDR: PASS
X-Source-IP: 209.85.218.41
X-ServerName: mail-ej1-f41.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=208 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103020044
X-Spam: Clean
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>, "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] Question about the "EXPERIMENTAL" tag for dax in
	XFS
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020046

On Mon, Mar 1, 2021 at 7:28 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Mar 01, 2021 at 12:55:53PM -0800, Dan Williams wrote:
> > On Sun, Feb 28, 2021 at 2:39 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Sat, Feb 27, 2021 at 03:40:24PM -0800, Dan Williams wrote:
> > > > On Sat, Feb 27, 2021 at 2:36 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > On Fri, Feb 26, 2021 at 02:41:34PM -0800, Dan Williams wrote:
> > > > > > On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > > On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > > > > it points to, check if it points to the PMEM that is being removed,
> > > > > grab the page it points to, map that to the relevant struct page,
> > > > > run collect_procs() on that page, then kill the user processes that
> > > > > map that page.
> > > > >
> > > > > So why can't we walk the ptescheck the physical pages that they
> > > > > map to and if they map to a pmem page we go poison that
> > > > > page and that kills any user process that maps it.
> > > > >
> > > > > i.e. I can't see how unexpected pmem device unplug is any different
> > > > > to an MCE delivering a hwpoison event to a DAX mapped page.
> > > >
> > > > I guess the tradeoff is walking a long list of inodes vs walking a
> > > > large array of pages.
> > >
> > > Not really. You're assuming all a filesystem has to do is invalidate
> > > everything if a device goes away, and that's not true. Finding if an
> > > inode has a mapping that spans a specific device in a multi-device
> > > filesystem can be a lot more complex than that. Just walking inodes
> > > is easy - determining whihc inodes need invalidation is the hard
> > > part.
> >
> > That inode-to-device level of specificity is not needed for the same
> > reason that drop_caches does not need to be specific. If the wrong
> > page is unmapped a re-fault will bring it back, and re-fault will fail
> > for the pages that are successfully removed.
> >
> > > That's where ->corrupt_range() comes in - the filesystem is already
> > > set up to do reverse mapping from physical range to inode(s)
> > > offsets...
> >
> > Sure, but what is the need to get to that level of specificity with
> > the filesystem for something that should rarely happen in the course
> > of normal operation outside of a mistake?
>
> I can't tell if we're conflating the "a bunch of your pmem went bad"
> case with the "all your dimms fell out of the machine" case.

>From the pmem driver perspective it has the media scanning to find
some small handful of cachelines that have gone bad, and it has the
driver ->remove() callback to tell it a bunch of pmem is now offline.
The NVDIMM device "range has gone bad" mechanism has no way to
communicate multiple terabytes have gone bad at once.

In fact I think the distinction is important that ->remove() is not
treated as ->corrupted_range() because I expect the level of freakout
is much worse for a "your storage is offline" notification vs "your
storage is corrupted" notification.

> If, say, a single cacheline's worth of pmem goes bad on a node with 2TB
> of pmem, I certainly want that level of specificity.  Just notify the
> users of the dead piece, don't flush the whole machine down the drain.

Right, something like corrupted_range() is there to say, "keep going
upper layers, but note that this handful of sectors now has
indeterminant data and will return -EIO on access until repaired". The
repair for device-offline is device-online.

>
> > > > There's likely always more pages than inodes, but perhaps it's more
> > > > efficient to walk the 'struct page' array than sb->s_inodes?
> > >
> > > I really don't see you seem to be telling us that invalidation is an
> > > either/or choice. There's more ways to convert physical block
> > > address -> inode file offset and mapping index than brute force
> > > inode cache walks....
> >
> > Yes, but I was trying to map it to an existing mechanism and the
> > internals of drop_pagecache_sb() are, in coarse terms, close to what
> > needs to happen here.
>
> Yes.  XFS (with rmap enabled) can do all the iteration and walking in
> that function except for the invalidate_mapping_* call itself.  The goal
> of this series is first to wire up a callback within both the block and
> pmem subsystems so that they can take notifications and reverse-map them
> through the storage stack until they reach an fs superblock.

I'm chuckling because this "reverse map all the way up the block
layer" is the opposite of what Dave said at the first reaction to my
proposal, "can't the mm map pfns to fs inode  address_spaces?".

I think dax unmap is distinct from corrupted_range() precisely because
they are events happening in two different domains, block device
sectors vs dax device pfns.

Let's step back. I think a chain of ->corrupted_range() callbacks up
the block stack terminating in the filesystem with dax implications
tacked on is the wrong abstraction. Why not use the existing generic
object for communicating bad sector ranges, 'struct badblocks'?

Today whenever the pmem driver receives new corrupted range
notification from the lower level nvdimm
infrastructure(nd_pmem_notify) it updates the 'badblocks' instance
associated with the pmem gendisk and then notifies userspace that
there are new badblocks. This seems a perfect place to signal an upper
level stacked block device that may also be watching disk->bb. Then
each gendisk in a stacked topology is responsible for watching the
badblock notifications of the next level and storing a remapped
instance of those blocks until ultimately the filesystem mounted on
the top-level block device is responsible for registering for those
top-level disk->bb events.

The device gone notification does not map cleanly onto 'struct badblocks'.

If an upper level agent really cared about knowing about ->remove()
events before they happened it could maybe do something like:

dev = disk_to_dev(bdev->bd_disk)->parent;
bus_register_notifier(dev->bus. &disk_host_device_notifier_block)

...where it's trying to watch for events that will trigger the driver
->remove() callback on the device hosting a disk.

I still don't think that solves the need for a separate mechanism for
global dax_device pte invalidation.

I think that global dax_device invalidation needs new kernel
infrastructure to allow internal users, like dm-writecache and future
filesystems using dax for metadata, to take a fault when pmem is
offlined. They can't use the direct-map because the direct-map can't
fault, and they can't indefinitely pin metadata pages because that
blocks ->remove() from being guaranteed of forward progress.

Then an invalidation event is indeed a walk of address_space like
objects where some are fs-inodes and some are kernel-mode dax-users,
and that remains independent from remove events and badblocks
notifications because they are independent objects and events.

In contrast I think calling something like soft_offline_page() a pfn
at a time over terabytes will take forever especially when that event
need not fire if the dax_device is not mounted.

> Once the information has reached XFS, it can use its own reverse
> mappings to figure out which pages of which inodes are now targetted.

It has its own sector based reverse mappings, it does not have pfn reverse map.

> The future of DAX hw error handling can be that you throw the spitwad at
> us, and it's our problem to distill that into mm invalidation calls.
> XFS' reverse mapping data is indexed by storage location and isn't
> sharded by address_space, so (except for the DIMMs falling out), we
> don't need to walk the entire inode list or scan the entire mapping.

->remove() is effectively all the DIMMs falling out for all XFS knows.

> Between XFS and DAX and mm, the mm already has the invalidation calls,
> xfs already has the distiller, and so all we need is that first bit.
> The current mm code doesn't fully solve the problem, nor does it need
> to, since it handles DRAM errors acceptably* already.
>
> * Actually, the hwpoison code should _also_ be calling ->corrupted_range
> when DRAM goes bad so that we can detect metadata failures and either
> reload the buffer or (if it was dirty) shut down.
[..]
> > Going forward, for buses like CXL, there will be a managed physical
> > remove operation via PCIE native hotplug. The flow there is that the
> > PCIE hotplug driver will notify the OS of a pending removal, trigger
> > ->remove() on the pmem driver, and then notify the technician (slot
> > status LED) that the card is safe to pull.
>
> Well, that's a relief.  Can we cancel longterm RDMA leases now too?
> <duck>

Yes, all problems can be solved with more blinky lights.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
