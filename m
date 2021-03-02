Return-Path: <SRS0=55Qa=IA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40136C433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 05:45:01 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C15C160241
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 05:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C15C160241
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1225iML9149320;
	Tue, 2 Mar 2021 05:45:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36ye1m671x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Mar 2021 05:44:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1225iWW9095792;
	Tue, 2 Mar 2021 05:44:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyurhdcn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Mar 2021 05:44:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGxk0-0002ik-0i; Mon, 01 Mar 2021 21:38:40 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david@fromorbit.com>) id 1lGxjv-0002iK-Pu
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 21:38:35 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1225Yv6n074161
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 05:38:35 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 36yyyyde2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 05:38:35 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1225XW0W013907
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 05:38:34 GMT
Received: from mail107.syd.optusnet.com.au (mail107.syd.optusnet.com.au
	[211.29.132.53]) by userp2030.oracle.com with ESMTP id 36yc4hq2yy-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 05:38:34 +0000
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au
	[49.179.130.210])
	by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 6C9E4FA8629;
	Tue,  2 Mar 2021 16:38:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1lGxjo-00AzkM-R6; Tue, 02 Mar 2021 16:38:28 +1100
Date: Tue, 2 Mar 2021 16:38:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20210302053828.GI4662@dread.disaster.area>
References: <20210226212748.GY4662@dread.disaster.area>
	<CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
	<20210227223611.GZ4662@dread.disaster.area>
	<CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
	<20210228223846.GA4662@dread.disaster.area>
	<CAPcyv4jzV2RUij2BEvDJLLiK_67Nf1v3M6-jRLKf32x4iOzqng@mail.gmail.com>
	<20210301224640.GG4662@dread.disaster.area>
	<CAPcyv4iTqDJApZY0o_Q0GKn93==d2Gta2NM5x=upf=3JtTia7Q@mail.gmail.com>
	<20210302024227.GH4662@dread.disaster.area>
	<CAPcyv4ja8gnTR1E-Ge5etm+y69cHwdWN6Bg79wPPF4M=C-w79A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ja8gnTR1E-Ge5etm+y69cHwdWN6Bg79wPPF4M=C-w79A@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
	a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
	a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
	a=OJFMFRqHYWYmYpl_lvQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-PDR: PASS
X-Source-IP: 211.29.132.53
X-ServerName: mail107.syd.optusnet.com.au
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=188 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103020044
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020046

On Mon, Mar 01, 2021 at 07:33:28PM -0800, Dan Williams wrote:
> On Mon, Mar 1, 2021 at 6:42 PM Dave Chinner <david@fromorbit.com> wrote:
> [..]
> > We do not need a DAX specific mechanism to tell us "DAX device
> > gone", we need a generic block device interface that tells us "range
> > of block device is gone".
> 
> This is the crux of the disagreement. The block_device is going away
> *and* the dax_device is going away.

No, that is not the disagreement I have with what you are saying.
You still haven't understand that it's even more basic and generic
than devices going away. At the simplest form, all the filesystem
wants is to be notified of is when *unrecoverable media errors*
occur in the persistent storage that underlies the filesystem.

The filesystem does not care what that media is build from - PMEM,
flash, corroded spinning disks, MRAM, or any other persistent media
you can think off. It just doesn't matter.

What we care about is that the contents of a *specific LBA range* no
longer contain *valid data*. IOWs, the data in that range of the
block device has been lost, cannot be retreived and/or cannot be
written to any more.

PMEM taking a MCE because ECC tripped is a media error because data
is lost and inaccessible until recovery actions are taken.

MD RAID failing a scrub is a media error and data is lost and
unrecoverable at that layer.

A device disappearing is a media error because the storage media is
now permanently inaccessible to the higher layers.

This "media error" categorisation is a fundamental property of
persistent storage and, as such, is a property of the block devices
used to access said persistent storage.

That's the disagreement here - that you and Christoph are saying
->corrupted_range is not a block device property because only a
pmem/DAX device currently generates it.

You both seem to be NACKing a generic interface because it's only
implemented for the first subsystem that needs it. AFAICT, you
either don't understand or are completely ignoring the architectural
need for it to be provided across the rest of the storage stack that
*block device based filesystems depend on*.

Sure, there might be dax device based fielsystems around the corner.
They just require a different pmem device ->corrupted_range callout
to implement the notification - one that directs to the dax device
rather than the block device. That's simple and trivial to
implement, but such functionaity for DAX devices  does not replace
the need for the same generic functionality to be provided across a
*range of different block devices* as required by *block device
based filesystems*.

And that's fundamentally the problem. XFS is block device based, not
DAX device based. We require errors to be reported through block
device mechanisms. fs-dax does not change this - it is based on pmem
being presented as a primarily as a block device to the block device
based filesystems and only secondarily as a dax device. Hence if it
can be trivially implemented as a block device interface, that's
where it should go, because then all the other block devices that
the filesytem runs on can provide the same functionality for similar
media error events....

> The dax_device removal implies one
> set of actions (direct accessed pfns invalid) the block device removal
> implies another (block layer sector access offline).

There you go again, saying DAX requires an action, while the block
device notification is a -state change- (i.e. goes offline).

This is exactly what I said was wrong in my last email.

> corrupted_range
> is blurring the notification for 2 different failure domains. Look at
> the nascent idea to mount a filesystem on dax sans a block device.
> Look at the existing plumbing for DM to map dax_operations through a
> device stack.

Ummm, it just maps the direct_access call to the underlying device
and calls it's ->direct_access method. All it's doing is LBA
mapping. That's all it needs to do for ->corrupted_range, too.
I have no clue why you think this is a problem for error
notification...

> Look at the pushback Ruan got for adding a new
> block_device operation for corrupted_range().

one person said "no". That's hardly pushback. Especially as I think
Christoph's objection about this being dax specific functionality
is simply wrong, as per above.

> > This is why we need to communicate what error occurred, not what
> > action a device driver thinks needs to be taken.
> 
> The driver is only an event producer in this model, whatever the
> consumer does at the other end is not its concern. There may be a
> generic consumer and a filesystem specific consumer.

<sigh>

That's why these are all ops functions that can provide multiple
implementations to different device types. So that when we get a new
use case, the ops function structure can be replaced with one that
directs the notification to the new user instead of to the existing
one. It's a design pattern we use all over the kernel code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
