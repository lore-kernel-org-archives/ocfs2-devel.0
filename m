Return-Path: <SRS0=55Qa=IA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743B4C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 00:32:56 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B38AB60249
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 00:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B38AB60249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1220ODAA159522;
	Tue, 2 Mar 2021 00:32:54 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36ydgr5t2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Mar 2021 00:32:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1220Os23025224;
	Tue, 2 Mar 2021 00:32:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000w96dh-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Mar 2021 00:32:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGsy5-0002gC-76; Mon, 01 Mar 2021 16:32:53 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lGsy1-0002fo-RO
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 16:32:49 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1220QU2T130916
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 00:32:49 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36yyur9mgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 00:32:49 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1220NQ0F007838
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 00:32:49 GMT
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
	[209.85.218.53]) by userp2030.oracle.com with ESMTP id 36yc4hk77h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 00:32:48 +0000
Received: by mail-ej1-f53.google.com with SMTP id c10so5337924ejx.9
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 16:32:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=tODMMNozxXCcTO1DIKPL4EyibmUcgBsWXZDYub250/I=;
	b=pqkl+zHF3bCUI3BLMkjxNZ1QDaKZ8uOTRVDO8sesL84cSMFRyJA0srDsd5ap8iA4aQ
	3GurskeyQlIaQM3zKkeLT67Hw5ZBMd0bBAe2n/eHDKgQjRap1JAKu3EKVWHwwD45+Z4M
	ycV3sQejawFPfgKN4S02dHYLEmNWEIQiJeLozBdC788skOXvqxpNqEKwK9adp68bMBzj
	S5WVvsHlXP4QhbHhNeuOxpEit6DLz6xzOV8UYQFij5vr1NJRJU17oA8468n5m8gtKQeJ
	QxYNX/L+MQN7IDTom5ad85O/P4D8jU6HaPNYO0yJ/g/R1q52kMbN6ziCFyeho6WgWAsy
	lmOA==
X-Gm-Message-State: AOAM533Ovpmkeyrr230iVpUMbU3OlbA3VFN/4qFM2N3Bbxr3vmmvQWYY
	oVZj/euhHhzSQYqKxynshIqtTH4bHqNqxRj9699aJA==
X-Google-Smtp-Source: ABdhPJyojx9eyQuxpdaViE7tO5ZYqod6Jb8w+AjTEFCg4L2gIspnja0M9FRCjNwDl+nr+ajUTgRELIXWko2HYS6Vw/w=
X-Received: by 2002:a17:906:1386:: with SMTP id
	f6mr7578675ejc.45.1614645165654; 
	Mon, 01 Mar 2021 16:32:45 -0800 (PST)
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
	<20210301224640.GG4662@dread.disaster.area>
In-Reply-To: <20210301224640.GG4662@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Mar 2021 16:32:36 -0800
Message-ID: <CAPcyv4iTqDJApZY0o_Q0GKn93==d2Gta2NM5x=upf=3JtTia7Q@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-PDR: PASS
X-Source-IP: 209.85.218.53
X-ServerName: mail-ej1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=177 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=134 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103020001
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020001

On Mon, Mar 1, 2021 at 2:47 PM Dave Chinner <david@fromorbit.com> wrote:
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
> Dan, you made this mistake with the hwpoisoning code that we're
> trying to fix that here. Hard coding a 1:1 physical address to
> inode/offset into the DAX mapping was a bad mistake. It's also one
> that should never have occurred because it's *obviously wrong* to
> filesystem developers and has been for a long time.

I admit that mistake. The traditional memory error handling model
assumptions around page->mapping were broken by DAX, I'm not trying to
repeat that mistake. I feel we're talking past each other on the
discussion of the proposals.

> Now we have the filesytem people providing a mechanism for the pmem
> devices to tell the filesystems about physical device failures so
> they can handle such failures correctly themselves. Having the
> device go away unexpectedly from underneath a mounted and active
> filesystem is a *device failure*, not an "unplug event".

It's the same difference to the physical page, all mappings to that
page need to be torn down. I'm happy to call an fs callback and let
each filesystem do what it wants with a "every pfn in this dax device
needs to be unmapped".

I'm looking at the ->corrupted_range() patches trying to map it to
this use case and I don't see how, for example a realtime-xfs over DM
over multiple PMEM gets the notification to the right place.
bd_corrupted_range() uses get_super() which get the wrong answer for
both realtime-xfs and DM.

I'd flip that arrangement around and have the FS tell the block device
"if something happens to you, here is the super_block to notify". So
to me this looks like a fs_dax_register_super() helper that plumbs the
superblock through an arbitrary stack of block devices to the leaf
block-device that might want to send a notification up when a global
unmap operation needs to be performed.

I naively think that "for_each_inode()
unmap_mapping_range(&inode->i_mapping)" is sufficient as a generic
implementation, that does not preclude XFS to override that generic
implementation and handle it directly if it so chooses.

> The mistake you made was not understanding how filesystems work,
> nor actually asking filesystem developers what they actually needed.

You're going too far here, but that's off topic.

> You're doing the same thing here - you're telling us what you think
> the solution filesystems need is.

No, I'm not, I'm trying to understand tradeoffs. I apologize if this
is coming across as not listening.

> Please listen when we say "that is
> not sufficient" because we don't want to be backed into a corner
> that we have to fix ourselves again before we can enable some basic
> filesystem functionality that we should have been able to support on
> DAX from the start...

That's some revisionist interpretation of how the discovery of the
reflink+dax+memory-error-handling collision went down.

The whole point of this discussion is to determine if
->corrupted_range() is suitable for this notification, and looking at
the code as is, it isn't. Perhaps you have a different implementation
of ->corrupted_range() in mind that allows this to be plumbed
correctly?

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
> No.
>
> drop_pagecache_sb() is not a relevant model for telling a filesystem
> that the block device underneath has gone away,

Like I said I'm not trying to communicate "device has gone away", only
"unmap all dax pages". If you want those to be one in the same
mechanism I'm listening, but like I said it was my mistake for tying
global unmap to device-gone, they need not be the same given
fileystems have not historically been notified proactively of device
removal.

> nor for a device to
> ensure that access protections that *are managed by the filesystem*
> are enforced/revoked sanely.

Yes, if the fs needs / wants to do more than the generic need of unmap
all dax it's free to override the generic implementation.

> drop_pagecache_sb() is a brute-force model for invalidating user
> data mappings that the filesystem performs in response to such a
> notification. It only needs this brute-force approach if it has no
> other way to find active DAX mappings across the range of the device
> that has gone away.

Ok.

> But this model doesn't work for direct mapped metadata, journals or
> any other internal direct filesystem mappings that aren't referenced
> by inodes that the filesytem might be using. The filesystem still
> needs to invalidate all those mappings and prevent further access to
> them, even from within the kernel itself.

Agree. If the filesystem was using DAX techniques for metadata it
would want to know before the direct-map is torn down. No argument
there.

> Filesystems are way more complex than pure DAX devices, and hence
> handle errors and failure events differently. Unlike DAX devices, we
> have both internal and external references to the DAX device, and we
> can have both external and internal direct maps.  Invalidating user
> data mappings is all dax devices need to do on unplug, but for
> filesystems it is only a small part of what we have to do when a
> range of a device goes bad.
>
> IOWs, there is no "one size fits all" approach that works for all
> filesystems, nor is there one strategy that is is optimal for all
> filesystems. Failure handling in a filesystem is almost always
> filesystem specific...

Point taken, if a filesystem is not using the block-layer for metadata
I/O and using DAX techniques directly it needs this event too
otherwise it will crash vs report failed operations...
->corrupted_range() does not offer the correct plumbing for that
today.

There's an additional problem this brings to mind. Device-mapper
targets like dm-writecache need this notification as well because it
is using direct physical page access via the linear map and may crash
like the filesystem if the mm-direct-map is torn down from underneath
it.

> > > > Ok, I think I set this discussion in the wrong direction implying any
> > > > mapping of this action to a "filesystem dead" event. It's just a "zap
> > > > all ptes" event and upper layers recover from there.
> > >
> > > Yes, that's exactly what ->corrupt_range() is intended for. It
> > > allows the filesystem to lock out access to the bad range
> > > and then recover the data. Or metadata, if that's where the bad
> > > range lands. If that recovery fails, it can then report a data
> > > loss/filesystem shutdown event to userspace and kill user procs that
> > > span the bad range...
> > >
> > > FWIW, is this notification going to occur before or after the device
> > > has been physically unplugged?
> >
> > Before. This will be operations that happen in the pmem driver
> > ->remove() callback.
> >
> > > i.e. what do we do about the
> > > time-of-unplug-to-time-of-invalidation window where userspace can
> > > still attempt to access the missing pmem though the
> > > not-yet-invalidated ptes? It may not be likely that people just yank
> > > pmem nvdimms out of machines, but with NVMe persistent memory
> > > spaces, there's every chance that someone pulls the wrong device...
> >
> > The physical removal aspect is only theoretical today.
>
> For actual pmem, maybe. But hotplug RAM is a thing; big numa
> machines that can hotplug nodes into their fabric and so have CPUs
> and memory able to come and go from a live machine. It's not a small
> stretch to extend that to having PMEM in those nodes. So it's a
> practical design concern right now, even ignoring that NVMe is
> hotplug....

Memory hotplug today requires the memory-device to be offlined before
the memory is unplugged and the core-mm has a chance to say "no" if it
sees even one page with an elevated reference. Block-devices in
contrast have no option to say "no" to being unplugged / ->remove()
triggered.

> > While the pmem
> > driver has a ->remove() path that's purely a software unbind
> > operation. That said the vulnerability window today is if a process
> > acquires a dax mapping, the pmem device hosting that filesystem goes
> > through an unbind / bind cycle, and then a new filesystem is created /
> > mounted. That old pte may be able to access data that is outside its
> > intended protection domain.
>
> So what is being done to prevent stale DAX mappings from being
> leaked this way right now, seeing as the leak you mention here
> doesn't appear in any way to be filesystem related?

For device-dax where there is only one inode->i_mapping to deal with,
one unmap_mapping_range() call is performed in the device shutdown
path. For filesystem-dax only the direct-map is torn down.

The user mapping teardown gap is why I'm coming at this elephant from
the user mapping perspective and not necessarily the "what does the
filesystem want to do about device removal" perspective.

> > Going forward, for buses like CXL, there will be a managed physical
> > remove operation via PCIE native hotplug. The flow there is that the
> > PCIE hotplug driver will notify the OS of a pending removal, trigger
> > ->remove() on the pmem driver, and then notify the technician (slot
> > status LED) that the card is safe to pull.
>
> That doesn't protect against pulling the wrong device, or having
> someone pull the device without first running an admin command that
> makes systems using DAX safe to pull the device....

Of course not, at some point surprise removal can't be compensated.
There are hardware mechanisms to try to contain mistakes, but those
can only go so far...

> And once you take into account that "pulling the wrong device" can
> happen, how does the filesystem tell tell the difference between a
> device being pulled and a drive cage just dying and so the drive
> just disappear from the system? How are these accidental vs real
> failures any different from the perspective of a filesystem mounted
> on that device?

Not even the device driver can tell you that. The Linux driver model
has no way to communicate why ->remove() is being called, it only
knows that it needs to revoke everything that was handed out since
->probe().

> And then there is the elephant in the room: if there's a "human in
> the loop" step needed to hot unplug a pmem device safely, then
> why the hell is the filesystem on that device still mounted and the
> DAX applications still running?

This goes back to Yasunori's question, can't ->remove() just be
blocked when the filesystem is mounted? The answer is similar to
asking the filesystem to allow DAX RDMA pages to be pinned
indefinitely and lock-out the filesystem from making any extent-map
changes. If the admin wants the device disabled while the filesystem
is mounted the kernel should do everything it can to honor that
request safely.

> This just makes no sense at all from an operations perspective - if
> you know that you are about to do an unplug that will result in all
> your DAX apps and filesystems being killed (i.e. fatal production
> environment failure) then why haven't they all been stopped by the
> admin before the device unplug is done? Why does this "human in the
> loop" admin task require the applications and filesystems to handle
> this without warning and have to treat it as a "device failure"
> event when this can all be avoided for normal, scheduled, controlled
> unplug operations? The "unexpected unplug" is a catastrophic failure
> event which may have severe side effects on system operation and
> stability. Why would you design an unplug process that does not
> start with a clean, a controlled shutdown process from the top down?
> If we make the assumption that planned unplugs are well planned,
> organised and scheduled, then the only thing that an unplug event
> needs to mean to a filesystem is "catastrophic device failure has
> occurred".

There is a difference between the kernel saying "don't do that, bad
things will happen" and "you can't do that the entire system will
crash / security promises will be violated".

git grep -n suppress_bind_attr drivers/ata/ drivers/scsi/ drivers/nvme/

There are no block-device providers that I can find on a quick search
that forbid triggering ->remove() on the driver if a filesystem is
mounted. pmem is not the first block device driver to present this
problem.

> So from a system level, the way you are describing the way hot
> unplug events are supposed to occur and work looks completely
> screwed up to me. Exactly what use case do you have for pmem device
> hot-unplug from under a live filesystem that isn't considered a
> *catastrophic runtime device failure* by the filesystem?

I'm coming at this from the perspective of it historically always
being possible for a block-device to be ripped out from underneath a
filesystem. I seem to be just the messenger conveying that bad news.
What's different now is that DAX has expanded what was previously
constrained to something the block layer could handle with a BLK_STS_*
return value for new I/O to a live pte that needs to be torn down, not
a page cache page that can live on indefinitely.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
