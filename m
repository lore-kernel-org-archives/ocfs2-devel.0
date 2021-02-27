Return-Path: <SRS0=VQRS=H5=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0CFC433DB
	for <ocfs2-devel@archiver.kernel.org>; Sat, 27 Feb 2021 23:44:04 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 467BB64E28
	for <ocfs2-devel@archiver.kernel.org>; Sat, 27 Feb 2021 23:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 467BB64E28
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RNewsC020823;
	Sat, 27 Feb 2021 23:44:02 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36ybkb1524-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Feb 2021 23:44:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RNhlFA106500;
	Sat, 27 Feb 2021 23:44:01 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000u002k-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 27 Feb 2021 23:44:00 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lG9Cc-0003pO-Fa; Sat, 27 Feb 2021 15:40:50 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lG9Ca-0003oz-9p
	for ocfs2-devel@oss.oracle.com; Sat, 27 Feb 2021 15:40:48 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11RNelLR184693
	for <ocfs2-devel@oss.oracle.com>; Sat, 27 Feb 2021 23:40:48 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 36yynk881k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 27 Feb 2021 23:40:48 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11RNZdgp002805
	for <ocfs2-devel@oss.oracle.com>; Sat, 27 Feb 2021 23:40:37 GMT
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
	[209.85.218.43]) by userp2040.oracle.com with ESMTP id 36ycptetp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 27 Feb 2021 23:40:36 +0000
Received: by mail-ej1-f43.google.com with SMTP id g5so21355231ejt.2
	for <ocfs2-devel@oss.oracle.com>; Sat, 27 Feb 2021 15:40:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0ElBUABiAQGzdBb9Q14hhgxo5CKFBJ/fW6SlESrFX9c=;
	b=HDC74h+isQYO0SHtd/m+yVUR/Hv5Dbe55ML+r/nO6Aws9Wfch2ZMg7k77myoxqR0Dd
	OJLt+EQ3ZoS5dT2ppulD+ZrwiDz3VSQ4clwHdOlR9ti3bK5vSRSvkdvDxwZhoxC1lBr8
	PentrKKQ10WqO/M0MXLhSTrPy3YqVnSTWvgyGoodOlfId/rk1CDVVn8UfeyGiUe/9sba
	N8jUTz2YbcaRhg4uaD9N9uTEk3wmNX1k4teWx6VNYzMgtKuBZisQhMgAzzFrlBqdI2p2
	EwF+EDhGmBtsHtTwm4YtaHkJl98r8PCuAqEjUDw2a3JEu/xKIZMZ3J+6+Hbb4f1K0pWp
	c4ZQ==
X-Gm-Message-State: AOAM533pXuXO84sUWWnVR+h3SSxGGgLtMDl9bsyN0GLFRcofyxJOLFBA
	ehDOJpj7f7Ojy5XT/9jBmisDS5mc4+7WG/8HBhS88w==
X-Google-Smtp-Source: ABdhPJxbfr1J+RzSUV7IBi8GoEnzC9yBAlDFbKQxsZp0Gu26nrbT35J97kR4cgoSTL5V4L7WiF5R1/XaKW63d8ST/2A=
X-Received: by 2002:a17:907:3fa3:: with SMTP id
	hr35mr9631355ejc.418.1614469233758; 
	Sat, 27 Feb 2021 15:40:33 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<20210226205126.GX4662@dread.disaster.area>
	<CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
	<20210226212748.GY4662@dread.disaster.area>
	<CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
	<20210227223611.GZ4662@dread.disaster.area>
In-Reply-To: <20210227223611.GZ4662@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Feb 2021 15:40:24 -0800
Message-ID: <CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-PDR: PASS
X-Source-IP: 209.85.218.43
X-ServerName: mail-ej1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=204 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102270201
X-Spam: Clean
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>, "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270203
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270202

On Sat, Feb 27, 2021 at 2:36 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 26, 2021 at 02:41:34PM -0800, Dan Williams wrote:
> > On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
> > > On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > > > On Fri, Feb 26, 2021 at 12:51 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > My immediate concern is the issue Jason recently highlighted [1] with
> > > > > > respect to invalidating all dax mappings when / if the device is
> > > > > > ripped out from underneath the fs. I don't think that will collide
> > > > > > with Ruan's implementation, but it does need new communication from
> > > > > > driver to fs about removal events.
> > > > > >
> > > > > > [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com
> > > > >
> > > > > Oh, yay.
> > > > >
> > > > > The XFS shutdown code is centred around preventing new IO from being
> > > > > issued - we don't actually do anything about DAX mappings because,
> > > > > well, I don't think anyone on the filesystem side thought they had
> > > > > to do anything special if pmem went away from under it.
> > > > >
> > > > > My understanding -was- that the pmem removal invalidates
> > > > > all the ptes currently mapped into CPU page tables that point at
> > > > > the dax device across the system. THe vmas that manage these
> > > > > mappings are not really something the filesystem really manages,
> > > > > but a function of the mm subsystem. What the filesystem cares about
> > > > > is that it gets page faults triggered when a change of state occurs
> > > > > so that it can remap the page to it's backing store correctly.
> > > > >
> > > > > IOWs, all the mm subsystem needs to when pmem goes away is clear the
> > > > > CPU ptes, because then when then when userspace tries to access the
> > > > > mapped DAX pages we get a new page fault. In processing the fault, the
> > > > > filesystem will try to get direct access to the pmem from the block
> > > > > device. This will get an ENODEV error from the block device because
> > > > > because the backing store (pmem) has been unplugged and is no longer
> > > > > there...
> > > > >
> > > > > AFAICT, as long as pmem removal invalidates all the active ptes that
> > > > > point at the pmem being removed, the filesystem doesn't need to
> > > > > care about device removal at all, DAX or no DAX...
> > > >
> > > > How would the pmem removal do that without walking all the active
> > > > inodes in the fs at the time of shutdown and call
> > > > unmap_mapping_range(inode->i_mapping, 0, 0, 1)?
> > >
> > > Which then immediately ends up back at the vmas that manage the ptes
> > > to unmap them.
> > >
> > > Isn't finding the vma(s) that map a specific memory range exactly
> > > what the rmap code in the mm subsystem is supposed to address?
> >
> > rmap can lookup only vmas from a virt address relative to a given
> > mm_struct. The driver has neither the list of mm_struct objects nor
> > virt addresses to do a lookup. All it knows is that someone might have
> > mapped pages through the fsdax interface.
>
> So there's no physical addr to vma translation in the mm subsystem
> at all?
>
> That doesn't make sense. We do exactly this for hwpoison for DAX
> mappings. While we don't look at ptes, we get a pfn,

True hwpoison does get a known failing pfn and then uses page->mapping
to get the 'struct address_space' to do the unmap. I discounted that
approach from the outset because it would mean walking every pfn in a
multi-terabyte device just in case one is mapped at device shutdown.

> it points to, check if it points to the PMEM that is being removed,
> grab the page it points to, map that to the relevant struct page,
> run collect_procs() on that page, then kill the user processes that
> map that page.
>
> So why can't we walk the ptescheck the physical pages that they
> map to and if they map to a pmem page we go poison that
> page and that kills any user process that maps it.
>
> i.e. I can't see how unexpected pmem device unplug is any different
> to an MCE delivering a hwpoison event to a DAX mapped page.

I guess the tradeoff is walking a long list of inodes vs walking a
large array of pages.

There's likely always more pages than inodes, but perhaps it's more
efficient to walk the 'struct page' array than sb->s_inodes?

>  Both
> indicate a physical address range now contains invalid data and the
> filesystem has to take the same action...
>
> IOWs, we could just call ->corrupted_range(0, EOD) here to tell the
> filesystem the entire device went away. Then the filesystem deal
> with this however it needs to. However, it would be more efficient
> from an invalidation POV to just call it on the pages that have
> currently active ptes because once the block device is dead
> new page faults on DAX mappings will get a SIGBUS naturally.

There is no efficient way to lookup "currently active ptes" relative
to a physical pfn range.

SIGBUS will happen naturally either way. I don't think the hwpoison
signal with the extra BUS_MCEERR_* info is appropriate given that
indicates data loss vs data offline of a device being unplugged.

>
> > To me this looks like a notifier that fires from memunmap_pages()
> > after dev_pagemap_kill() to notify any block_device associated with
> > that dev_pagemap() to say that any dax mappings arranged through this
> > block_device are now invalid. The reason to do this after
> > dev_pagemap_kill() is so that any new mapping attempts that are racing
> > the removal will be blocked.
>
> I don't see why this needs a unique notifier. At the filesystem
> level, we want a single interface that tells us "something bad
> happened to the block device", not a proliferation of similar but
> subtly different "bad thing X happened to block device" interfaces
> that are unique to specific physical device drivers...
>
> > The receiver of that notification needs to go from a block_device to a
> > superblock that has mapped inodes and walk ->sb_inodes triggering the
> > unmap/invalidation.
>
> Not necessarily.
>
> What if the filesystem is managing mirrored data across multiple
> devices and this device is only one leg of the mirror?

I can see DAX mapping for read access to one leg of the mirror. The
unplug would fire zap_pte for all the inodes with DAX mappings for
that fs. Filesystem is still free at that point to wait for the next
user access, take a refault, and re-establish the mapping to another
leg of the mirror.

> Or that the
> pmem was used by the RT device in XFS and the data/log devices are
> still fine?

I was assuming that the callback would only be triggered for a dax
device as the data device. So xfs_open_devices() would register
mp->m_super for dax_rtdev.

> What if the pmem is just being used as a cache tier, and
> no data was actually lost?

That's fine the cache mapping is zapped and re-fault figures out what
to do. If anything these questions are a reason not to use
->corrupted_range() for this because recovery can happen at refault vs
taking permanent action on a data loss event.

>
> IOWs, what needs to happen at this point is very filesystem
> specific. Assuming that "device unplug == filesystem dead" is not
> correct, nor is specifying a generic action that assumes the
> filesystem is dead because a device it is using went away.

Ok, I think I set this discussion in the wrong direction implying any
mapping of this action to a "filesystem dead" event. It's just a "zap
all ptes" event and upper layers recover from there.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
