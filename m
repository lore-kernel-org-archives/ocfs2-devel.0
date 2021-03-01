Return-Path: <SRS0=HAPo=H7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CCCC433DB
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 22:47:04 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F6E160C3E
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 22:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F6E160C3E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121Mhad4015306;
	Mon, 1 Mar 2021 22:47:02 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36ydgr5m29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Mar 2021 22:47:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121MislY032073;
	Mon, 1 Mar 2021 22:47:02 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000w6apr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Mar 2021 22:47:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGrJd-0005aB-6X; Mon, 01 Mar 2021 14:47:01 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david@fromorbit.com>) id 1lGrJY-0005Zk-QJ
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 14:46:56 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	121MkT26145943
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 22:46:56 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36yyur6pnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 22:46:56 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	121MhaU4044678
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 22:46:56 GMT
Received: from mail106.syd.optusnet.com.au (mail106.syd.optusnet.com.au
	[211.29.132.42]) by userp2030.oracle.com with ESMTP id 36yc4hhvda-1
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 22:46:50 +0000
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au
	[49.179.130.210])
	by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 96FFC78B08D;
	Tue,  2 Mar 2021 09:46:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1lGrJI-00AYOj-RV; Tue, 02 Mar 2021 09:46:40 +1100
Date: Tue, 2 Mar 2021 09:46:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20210301224640.GG4662@dread.disaster.area>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jzV2RUij2BEvDJLLiK_67Nf1v3M6-jRLKf32x4iOzqng@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
	a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
	a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
	a=A7xB1iZnyS4vYbptKj0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-PDR: PASS
X-Source-IP: 211.29.132.42
X-ServerName: mail106.syd.optusnet.com.au
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=185 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103010184
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
 definitions=main-2103010184
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1034 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010184

On Mon, Mar 01, 2021 at 12:55:53PM -0800, Dan Williams wrote:
> On Sun, Feb 28, 2021 at 2:39 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sat, Feb 27, 2021 at 03:40:24PM -0800, Dan Williams wrote:
> > > On Sat, Feb 27, 2021 at 2:36 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > On Fri, Feb 26, 2021 at 02:41:34PM -0800, Dan Williams wrote:
> > > > > On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > > > it points to, check if it points to the PMEM that is being removed,
> > > > grab the page it points to, map that to the relevant struct page,
> > > > run collect_procs() on that page, then kill the user processes that
> > > > map that page.
> > > >
> > > > So why can't we walk the ptescheck the physical pages that they
> > > > map to and if they map to a pmem page we go poison that
> > > > page and that kills any user process that maps it.
> > > >
> > > > i.e. I can't see how unexpected pmem device unplug is any different
> > > > to an MCE delivering a hwpoison event to a DAX mapped page.
> > >
> > > I guess the tradeoff is walking a long list of inodes vs walking a
> > > large array of pages.
> >
> > Not really. You're assuming all a filesystem has to do is invalidate
> > everything if a device goes away, and that's not true. Finding if an
> > inode has a mapping that spans a specific device in a multi-device
> > filesystem can be a lot more complex than that. Just walking inodes
> > is easy - determining whihc inodes need invalidation is the hard
> > part.
> 
> That inode-to-device level of specificity is not needed for the same
> reason that drop_caches does not need to be specific. If the wrong
> page is unmapped a re-fault will bring it back, and re-fault will fail
> for the pages that are successfully removed.
> 
> > That's where ->corrupt_range() comes in - the filesystem is already
> > set up to do reverse mapping from physical range to inode(s)
> > offsets...
> 
> Sure, but what is the need to get to that level of specificity with
> the filesystem for something that should rarely happen in the course
> of normal operation outside of a mistake?

Dan, you made this mistake with the hwpoisoning code that we're
trying to fix that here. Hard coding a 1:1 physical address to
inode/offset into the DAX mapping was a bad mistake. It's also one
that should never have occurred because it's *obviously wrong* to
filesystem developers and has been for a long time.

Now we have the filesytem people providing a mechanism for the pmem
devices to tell the filesystems about physical device failures so
they can handle such failures correctly themselves. Having the
device go away unexpectedly from underneath a mounted and active
filesystem is a *device failure*, not an "unplug event".

The mistake you made was not understanding how filesystems work,
nor actually asking filesystem developers what they actually needed.
You're doing the same thing here - you're telling us what you think
the solution filesystems need is. Please listen when we say "that is
not sufficient" because we don't want to be backed into a corner
that we have to fix ourselves again before we can enable some basic
filesystem functionality that we should have been able to support on
DAX from the start...

> > > There's likely always more pages than inodes, but perhaps it's more
> > > efficient to walk the 'struct page' array than sb->s_inodes?
> >
> > I really don't see you seem to be telling us that invalidation is an
> > either/or choice. There's more ways to convert physical block
> > address -> inode file offset and mapping index than brute force
> > inode cache walks....
> 
> Yes, but I was trying to map it to an existing mechanism and the
> internals of drop_pagecache_sb() are, in coarse terms, close to what
> needs to happen here.

No.

drop_pagecache_sb() is not a relevant model for telling a filesystem
that the block device underneath has gone away, nor for a device to
ensure that access protections that *are managed by the filesystem*
are enforced/revoked sanely.

drop_pagecache_sb() is a brute-force model for invalidating user
data mappings that the filesystem performs in response to such a
notification. It only needs this brute-force approach if it has no
other way to find active DAX mappings across the range of the device
that has gone away.

But this model doesn't work for direct mapped metadata, journals or
any other internal direct filesystem mappings that aren't referenced
by inodes that the filesytem might be using. The filesystem still
needs to invalidate all those mappings and prevent further access to
them, even from within the kernel itself.

Filesystems are way more complex than pure DAX devices, and hence
handle errors and failure events differently. Unlike DAX devices, we
have both internal and external references to the DAX device, and we
can have both external and internal direct maps.  Invalidating user
data mappings is all dax devices need to do on unplug, but for
filesystems it is only a small part of what we have to do when a
range of a device goes bad.

IOWs, there is no "one size fits all" approach that works for all
filesystems, nor is there one strategy that is is optimal for all
filesystems. Failure handling in a filesystem is almost always
filesystem specific...

> > > Ok, I think I set this discussion in the wrong direction implying any
> > > mapping of this action to a "filesystem dead" event. It's just a "zap
> > > all ptes" event and upper layers recover from there.
> >
> > Yes, that's exactly what ->corrupt_range() is intended for. It
> > allows the filesystem to lock out access to the bad range
> > and then recover the data. Or metadata, if that's where the bad
> > range lands. If that recovery fails, it can then report a data
> > loss/filesystem shutdown event to userspace and kill user procs that
> > span the bad range...
> >
> > FWIW, is this notification going to occur before or after the device
> > has been physically unplugged?
> 
> Before. This will be operations that happen in the pmem driver
> ->remove() callback.
> 
> > i.e. what do we do about the
> > time-of-unplug-to-time-of-invalidation window where userspace can
> > still attempt to access the missing pmem though the
> > not-yet-invalidated ptes? It may not be likely that people just yank
> > pmem nvdimms out of machines, but with NVMe persistent memory
> > spaces, there's every chance that someone pulls the wrong device...
> 
> The physical removal aspect is only theoretical today.

For actual pmem, maybe. But hotplug RAM is a thing; big numa
machines that can hotplug nodes into their fabric and so have CPUs
and memory able to come and go from a live machine. It's not a small
stretch to extend that to having PMEM in those nodes. So it's a
practical design concern right now, even ignoring that NVMe is
hotplug....

> While the pmem
> driver has a ->remove() path that's purely a software unbind
> operation. That said the vulnerability window today is if a process
> acquires a dax mapping, the pmem device hosting that filesystem goes
> through an unbind / bind cycle, and then a new filesystem is created /
> mounted. That old pte may be able to access data that is outside its
> intended protection domain.

So what is being done to prevent stale DAX mappings from being
leaked this way right now, seeing as the leak you mention here
doesn't appear in any way to be filesystem related?

> Going forward, for buses like CXL, there will be a managed physical
> remove operation via PCIE native hotplug. The flow there is that the
> PCIE hotplug driver will notify the OS of a pending removal, trigger
> ->remove() on the pmem driver, and then notify the technician (slot
> status LED) that the card is safe to pull.

That doesn't protect against pulling the wrong device, or having
someone pull the device without first running an admin command that
makes systems using DAX safe to pull the device....

And once you take into account that "pulling the wrong device" can
happen, how does the filesystem tell tell the difference between a
device being pulled and a drive cage just dying and so the drive
just disappear from the system? How are these accidental vs real
failures any different from the perspective of a filesystem mounted
on that device?

And then there is the elephant in the room: if there's a "human in
the loop" step needed to hot unplug a pmem device safely, then
why the hell is the filesystem on that device still mounted and the
DAX applications still running?

This just makes no sense at all from an operations perspective - if
you know that you are about to do an unplug that will result in all
your DAX apps and filesystems being killed (i.e. fatal production
environment failure) then why haven't they all been stopped by the
admin before the device unplug is done? Why does this "human in the
loop" admin task require the applications and filesystems to handle
this without warning and have to treat it as a "device failure"
event when this can all be avoided for normal, scheduled, controlled
unplug operations? The "unexpected unplug" is a catastrophic failure
event which may have severe side effects on system operation and
stability. Why would you design an unplug process that does not
start with a clean, a controlled shutdown process from the top down?
If we make the assumption that planned unplugs are well planned,
organised and scheduled, then the only thing that an unplug event
needs to mean to a filesystem is "catastrophic device failure has
occurred".

So from a system level, the way you are describing the way hot
unplug events are supposed to occur and work looks completely
screwed up to me. Exactly what use case do you have for pmem device
hot-unplug from under a live filesystem that isn't considered a
*catastrophic runtime device failure* by the filesystem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
