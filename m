Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5489C433E6
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 22:41:56 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6340364DAF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 22:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6340364DAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QMewxn115561;
	Fri, 26 Feb 2021 22:41:55 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36xqkfb1t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 22:41:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QMeKwQ079133;
	Fri, 26 Feb 2021 22:41:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36uc6wex2b-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 22:41:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFlo1-0001rS-GE; Fri, 26 Feb 2021 14:41:53 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lFlnz-0001r3-3V
	for ocfs2-devel@oss.oracle.com; Fri, 26 Feb 2021 14:41:51 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QMeJZW079014
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 22:41:50 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 36uc6wex1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 22:41:50 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QMWxOZ045157
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 22:41:50 GMT
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com
	[209.85.208.47]) by userp2040.oracle.com with ESMTP id 36wskg2xa4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 22:41:48 +0000
Received: by mail-ed1-f47.google.com with SMTP id l12so12835331edt.3
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 14:41:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=fHpk7bX3cDWOBW490ZT0/lz5t0wLMJKj3dSlv6bBAAo=;
	b=GtnbjAML36fbPj1r4dxAM9ftVTgo2M4I6ZkIQMbhTAQdTGahTXOfj9goE58zBIFUrW
	E87cOIxD716U36kMkoEJjgSL4A1aO3xXRFlFsOiZLvHP6xHo55hrhC+Dy5h38KShRjx4
	2icwaPMwbAIMogD49KTmuOj3TsMIlXXXU+cF4cts/4lKBwgKsvrofuPiH57BdSaOV5+Z
	aklj7AUKkJpgnKeKJtgQzq5Q4cIB8AIbS/OQmH4VO8vWTWKwcOmmotEW5agYqNvOX6BG
	4cKLhO0JmNopBvkP3jmn2o9e2zuPOuKfMVKumnVi9qb3a33wQziRM+sTdKHvHYZVhAK5
	sk/w==
X-Gm-Message-State: AOAM530hnMo+wlEDbX66QeLUan3NqsHeE02n4yMftTLXVOi69fretD5s
	rlWrtBynkL5NdjYro5RDjpeVAyMs/VrgLogoom8qJw==
X-Google-Smtp-Source: ABdhPJzRqB7Th9975KKwZVp3f4l2p1uq8ensA0GvES+o8Z3FVF9VoQw9apOJIKwlD0LzIcC2XhrsXeFRdf3KO98ibv0=
X-Received: by 2002:a05:6402:3585:: with SMTP id
	y5mr5689417edc.97.1614379305912; 
	Fri, 26 Feb 2021 14:41:45 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<20210226205126.GX4662@dread.disaster.area>
	<CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
	<20210226212748.GY4662@dread.disaster.area>
In-Reply-To: <20210226212748.GY4662@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Feb 2021 14:41:34 -0800
Message-ID: <CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-PDR: PASS
X-Source-IP: 209.85.208.47
X-ServerName: mail-ed1-f47.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	adultscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
	priorityscore=158 suspectscore=0 malwarescore=0 clxscore=169
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102260166
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260167
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260167

On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > On Fri, Feb 26, 2021 at 12:51 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Feb 26, 2021 at 11:24:53AM -0800, Dan Williams wrote:
> > > > On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > >
> > > > > On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> > > > > > Hi, guys
> > > > > >
> > > > > > Beside this patchset, I'd like to confirm something about the
> > > > > > "EXPERIMENTAL" tag for dax in XFS.
> > > > > >
> > > > > > In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> > > > > > when we mount a pmem device with dax option, has been existed for a
> > > > > > while.  It's a bit annoying when using fsdax feature.  So, my initial
> > > > > > intention was to remove this tag.  And I started to find out and solve
> > > > > > the problems which prevent it from being removed.
> > > > > >
> > > > > > As is talked before, there are 3 main problems.  The first one is "dax
> > > > > > semantics", which has been resolved.  The rest two are "RMAP for
> > > > > > fsdax" and "support dax reflink for filesystem", which I have been
> > > > > > working on.
> > > > >
> > > > > <nod>
> > > > >
> > > > > > So, what I want to confirm is: does it means that we can remove the
> > > > > > "EXPERIMENTAL" tag when the rest two problem are solved?
> > > > >
> > > > > Yes.  I'd keep the experimental tag for a cycle or two to make sure that
> > > > > nothing new pops up, but otherwise the two patchsets you've sent close
> > > > > those two big remaining gaps.  Thank you for working on this!
> > > > >
> > > > > > Or maybe there are other important problems need to be fixed before
> > > > > > removing it?  If there are, could you please show me that?
> > > > >
> > > > > That remains to be seen through QA/validation, but I think that's it.
> > > > >
> > > > > Granted, I still have to read through the two patchsets...
> > > >
> > > > I've been meaning to circle back here as well.
> > > >
> > > > My immediate concern is the issue Jason recently highlighted [1] with
> > > > respect to invalidating all dax mappings when / if the device is
> > > > ripped out from underneath the fs. I don't think that will collide
> > > > with Ruan's implementation, but it does need new communication from
> > > > driver to fs about removal events.
> > > >
> > > > [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com
> > >
> > > Oh, yay.
> > >
> > > The XFS shutdown code is centred around preventing new IO from being
> > > issued - we don't actually do anything about DAX mappings because,
> > > well, I don't think anyone on the filesystem side thought they had
> > > to do anything special if pmem went away from under it.
> > >
> > > My understanding -was- that the pmem removal invalidates
> > > all the ptes currently mapped into CPU page tables that point at
> > > the dax device across the system. THe vmas that manage these
> > > mappings are not really something the filesystem really manages,
> > > but a function of the mm subsystem. What the filesystem cares about
> > > is that it gets page faults triggered when a change of state occurs
> > > so that it can remap the page to it's backing store correctly.
> > >
> > > IOWs, all the mm subsystem needs to when pmem goes away is clear the
> > > CPU ptes, because then when then when userspace tries to access the
> > > mapped DAX pages we get a new page fault. In processing the fault, the
> > > filesystem will try to get direct access to the pmem from the block
> > > device. This will get an ENODEV error from the block device because
> > > because the backing store (pmem) has been unplugged and is no longer
> > > there...
> > >
> > > AFAICT, as long as pmem removal invalidates all the active ptes that
> > > point at the pmem being removed, the filesystem doesn't need to
> > > care about device removal at all, DAX or no DAX...
> >
> > How would the pmem removal do that without walking all the active
> > inodes in the fs at the time of shutdown and call
> > unmap_mapping_range(inode->i_mapping, 0, 0, 1)?
>
> Which then immediately ends up back at the vmas that manage the ptes
> to unmap them.
>
> Isn't finding the vma(s) that map a specific memory range exactly
> what the rmap code in the mm subsystem is supposed to address?

rmap can lookup only vmas from a virt address relative to a given
mm_struct. The driver has neither the list of mm_struct objects nor
virt addresses to do a lookup. All it knows is that someone might have
mapped pages through the fsdax interface.

To me this looks like a notifier that fires from memunmap_pages()
after dev_pagemap_kill() to notify any block_device associated with
that dev_pagemap() to say that any dax mappings arranged through this
block_device are now invalid. The reason to do this after
dev_pagemap_kill() is so that any new mapping attempts that are racing
the removal will be blocked.

The receiver of that notification needs to go from a block_device to a
superblock that has mapped inodes and walk ->sb_inodes triggering the
unmap/invalidation.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
