Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91ADEC433E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 21:03:23 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1403964F0E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 21:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1403964F0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QL3MWf132424;
	Fri, 26 Feb 2021 21:03:22 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36tsurbbbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 21:03:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QL0fsx191216;
	Fri, 26 Feb 2021 21:03:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc33r7y-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 21:03:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFkDb-0004sJ-OX; Fri, 26 Feb 2021 13:00:11 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lFkDZ-0004s5-PN
	for ocfs2-devel@oss.oracle.com; Fri, 26 Feb 2021 13:00:09 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QKskOq182653
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 21:00:09 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36ucb3vgbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 21:00:09 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QKsxoe038319
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 21:00:08 GMT
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
	[209.85.218.47]) by userp2040.oracle.com with ESMTP id 36wskg1ghw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 21:00:07 +0000
Received: by mail-ej1-f47.google.com with SMTP id k13so17014995ejs.10
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 13:00:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=zcQVf2L16DF1R7/sAErfdlf5yiNv7ZgQmWWZvBx0O7Y=;
	b=F35r6PoeW0ODzJr/W1R47M8eseUo6uhc4JpfX1bPw6NFq91IdbBwwd5FEReNQ63DKW
	eE4AFjnATgQ/n8DpWInT3ZROWSz0ew68Vf1wdRMs6Znzen426Z89VxH+E0vrUvvHJWsx
	UjiY8ib5ukitejYjhSe5bIg7aj5Xg3t4mfYgl6tOqoIF2vl9UWGFfhv3Hxq4yAVNYnrT
	dfBP6NVoAoMUbUq7mSH0QROwGsWTlLur9guVtEwcdbXw4pB/A5hcrYloKLLH0EzFHwBu
	Xngf2IqMWxEyXPPN0wN7cl92wTkuQpIh2+KaDBXSLPoI0iyCGtiOWioV6UvK/URj9L1a
	I7nA==
X-Gm-Message-State: AOAM5301g3d8swmX/k7tMDOtcP9AL8Ml6rgEe+nEyjji0j4TjDctkHqs
	9eJZ4JZrI6TRXgI4g3aWq21p4fZ1SSIyEmNJIj0B+g==
X-Google-Smtp-Source: ABdhPJxDAdEBlk0RbwYt70jYfdky1u7QL1zNZXib8jYKCmqQiS//AXLx/UeM+e6rrhKUOcntNXe+fmaTNeYAK6yOe7A=
X-Received: by 2002:a17:906:6088:: with SMTP id
	t8mr5436602ejj.323.1614373204093; 
	Fri, 26 Feb 2021 13:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<20210226205126.GX4662@dread.disaster.area>
In-Reply-To: <20210226205126.GX4662@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Feb 2021 12:59:53 -0800
Message-ID: <CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-PDR: PASS
X-Source-IP: 209.85.218.47
X-ServerName: mail-ej1-f47.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	adultscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
	priorityscore=175 suspectscore=0 malwarescore=0 clxscore=259
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102260156
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260157
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260157

On Fri, Feb 26, 2021 at 12:51 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 26, 2021 at 11:24:53AM -0800, Dan Williams wrote:
> > On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> > > > Hi, guys
> > > >
> > > > Beside this patchset, I'd like to confirm something about the
> > > > "EXPERIMENTAL" tag for dax in XFS.
> > > >
> > > > In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> > > > when we mount a pmem device with dax option, has been existed for a
> > > > while.  It's a bit annoying when using fsdax feature.  So, my initial
> > > > intention was to remove this tag.  And I started to find out and solve
> > > > the problems which prevent it from being removed.
> > > >
> > > > As is talked before, there are 3 main problems.  The first one is "dax
> > > > semantics", which has been resolved.  The rest two are "RMAP for
> > > > fsdax" and "support dax reflink for filesystem", which I have been
> > > > working on.
> > >
> > > <nod>
> > >
> > > > So, what I want to confirm is: does it means that we can remove the
> > > > "EXPERIMENTAL" tag when the rest two problem are solved?
> > >
> > > Yes.  I'd keep the experimental tag for a cycle or two to make sure that
> > > nothing new pops up, but otherwise the two patchsets you've sent close
> > > those two big remaining gaps.  Thank you for working on this!
> > >
> > > > Or maybe there are other important problems need to be fixed before
> > > > removing it?  If there are, could you please show me that?
> > >
> > > That remains to be seen through QA/validation, but I think that's it.
> > >
> > > Granted, I still have to read through the two patchsets...
> >
> > I've been meaning to circle back here as well.
> >
> > My immediate concern is the issue Jason recently highlighted [1] with
> > respect to invalidating all dax mappings when / if the device is
> > ripped out from underneath the fs. I don't think that will collide
> > with Ruan's implementation, but it does need new communication from
> > driver to fs about removal events.
> >
> > [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com
>
> Oh, yay.
>
> The XFS shutdown code is centred around preventing new IO from being
> issued - we don't actually do anything about DAX mappings because,
> well, I don't think anyone on the filesystem side thought they had
> to do anything special if pmem went away from under it.
>
> My understanding -was- that the pmem removal invalidates
> all the ptes currently mapped into CPU page tables that point at
> the dax device across the system. THe vmas that manage these
> mappings are not really something the filesystem really manages,
> but a function of the mm subsystem. What the filesystem cares about
> is that it gets page faults triggered when a change of state occurs
> so that it can remap the page to it's backing store correctly.
>
> IOWs, all the mm subsystem needs to when pmem goes away is clear the
> CPU ptes, because then when then when userspace tries to access the
> mapped DAX pages we get a new page fault. In processing the fault, the
> filesystem will try to get direct access to the pmem from the block
> device. This will get an ENODEV error from the block device because
> because the backing store (pmem) has been unplugged and is no longer
> there...
>
> AFAICT, as long as pmem removal invalidates all the active ptes that
> point at the pmem being removed, the filesystem doesn't need to
> care about device removal at all, DAX or no DAX...

How would the pmem removal do that without walking all the active
inodes in the fs at the time of shutdown and call
unmap_mapping_range(inode->i_mapping, 0, 0, 1)?

The core-mm does tear down the ptes in the direct map, but user
mappings to pmem are not afaics in xfs_do_force_shutdown().

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
