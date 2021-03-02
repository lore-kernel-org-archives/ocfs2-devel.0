Return-Path: <SRS0=55Qa=IA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2F2C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 03:34:36 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 101ED64D9C
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 03:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 101ED64D9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1223TKwM090276;
	Tue, 2 Mar 2021 03:34:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36ybkb64wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Mar 2021 03:34:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1223Qi7M023209;
	Tue, 2 Mar 2021 03:34:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyuredgt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Mar 2021 03:34:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGvhn-0003Nq-0x; Mon, 01 Mar 2021 19:28:15 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lGvhk-0003NR-1z
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 19:28:12 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1223P9DD116973
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 03:28:11 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 37000wdu49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 03:28:11 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1223DF0G016114
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 03:28:11 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2040.oracle.com with ESMTP id 36ycpuqt0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 03:28:11 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0054864DA1;
	Tue,  2 Mar 2021 03:28:08 +0000 (UTC)
Date: Mon, 1 Mar 2021 19:28:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20210302032805.GM7272@magnolia>
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
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:sjc.edge.kernel.org a:ewr.edge.kernel.org
	a:ams.edge.kernel.org a:nrt.edge.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2009150000 definitions=main-2103020024
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020025

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

I can't tell if we're conflating the "a bunch of your pmem went bad"
case with the "all your dimms fell out of the machine" case.

If, say, a single cacheline's worth of pmem goes bad on a node with 2TB
of pmem, I certainly want that level of specificity.  Just notify the
users of the dead piece, don't flush the whole machine down the drain.

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

Yes.  XFS (with rmap enabled) can do all the iteration and walking in
that function except for the invalidate_mapping_* call itself.  The goal
of this series is first to wire up a callback within both the block and
pmem subsystems so that they can take notifications and reverse-map them
through the storage stack until they reach an fs superblock.

Once the information has reached XFS, it can use its own reverse
mappings to figure out which pages of which inodes are now targetted.
The future of DAX hw error handling can be that you throw the spitwad at
us, and it's our problem to distill that into mm invalidation calls.
XFS' reverse mapping data is indexed by storage location and isn't
sharded by address_space, so (except for the DIMMs falling out), we
don't need to walk the entire inode list or scan the entire mapping.

Between XFS and DAX and mm, the mm already has the invalidation calls,
xfs already has the distiller, and so all we need is that first bit.
The current mm code doesn't fully solve the problem, nor does it need
to, since it handles DRAM errors acceptably* already.

* Actually, the hwpoison code should _also_ be calling ->corrupted_range
when DRAM goes bad so that we can detect metadata failures and either
reload the buffer or (if it was dirty) shut down.

> >
> > .....
> >
> > > > IOWs, what needs to happen at this point is very filesystem
> > > > specific. Assuming that "device unplug == filesystem dead" is not
> > > > correct, nor is specifying a generic action that assumes the
> > > > filesystem is dead because a device it is using went away.
> > >
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
> The physical removal aspect is only theoretical today. While the pmem
> driver has a ->remove() path that's purely a software unbind
> operation. That said the vulnerability window today is if a process
> acquires a dax mapping, the pmem device hosting that filesystem goes
> through an unbind / bind cycle, and then a new filesystem is created /
> mounted. That old pte may be able to access data that is outside its
> intended protection domain.
> 
> Going forward, for buses like CXL, there will be a managed physical
> remove operation via PCIE native hotplug. The flow there is that the
> PCIE hotplug driver will notify the OS of a pending removal, trigger
> ->remove() on the pmem driver, and then notify the technician (slot
> status LED) that the card is safe to pull.

Well, that's a relief.  Can we cancel longterm RDMA leases now too?
<duck>

--D

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
