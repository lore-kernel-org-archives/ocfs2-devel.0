Return-Path: <SRS0=SWkS=H6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF240C433DB
	for <ocfs2-devel@archiver.kernel.org>; Sun, 28 Feb 2021 22:39:30 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FB5564E31
	for <ocfs2-devel@archiver.kernel.org>; Sun, 28 Feb 2021 22:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FB5564E31
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11SMdTKI152816;
	Sun, 28 Feb 2021 22:39:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36ybkb2848-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Feb 2021 22:39:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11SMaQ9O020788;
	Sun, 28 Feb 2021 22:39:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyupshu8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 28 Feb 2021 22:39:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGUik-0004Y7-Vb; Sun, 28 Feb 2021 14:39:26 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david@fromorbit.com>) id 1lGUiG-0004XB-KP
	for ocfs2-devel@oss.oracle.com; Sun, 28 Feb 2021 14:38:56 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11SMYqwX039825
	for <ocfs2-devel@oss.oracle.com>; Sun, 28 Feb 2021 22:38:56 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36yyywqq1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 28 Feb 2021 22:38:56 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11SMXCOh003228
	for <ocfs2-devel@oss.oracle.com>; Sun, 28 Feb 2021 22:38:55 GMT
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
	[211.29.132.249]) by userp2040.oracle.com with ESMTP id 36ycpty564-1
	for <ocfs2-devel@oss.oracle.com>; Sun, 28 Feb 2021 22:38:54 +0000
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au
	[49.179.130.210])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7E4FD1041250;
	Mon,  1 Mar 2021 09:38:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1lGUi6-008ztl-Kp; Mon, 01 Mar 2021 09:38:46 +1100
Date: Mon, 1 Mar 2021 09:38:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20210228223846.GA4662@dread.disaster.area>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<20210226205126.GX4662@dread.disaster.area>
	<CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
	<20210226212748.GY4662@dread.disaster.area>
	<CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
	<20210227223611.GZ4662@dread.disaster.area>
	<CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
	a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
	a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
	a=TP_jekbwqI1TK37FQS4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-PDR: PASS
X-Source-IP: 211.29.132.249
X-ServerName: mail105.syd.optusnet.com.au
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=218 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102280192
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102280193
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1034 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102280194

On Sat, Feb 27, 2021 at 03:40:24PM -0800, Dan Williams wrote:
> On Sat, Feb 27, 2021 at 2:36 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Feb 26, 2021 at 02:41:34PM -0800, Dan Williams wrote:
> > > On Fri, Feb 26, 2021 at 1:28 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > On Fri, Feb 26, 2021 at 12:59:53PM -0800, Dan Williams wrote:
> > it points to, check if it points to the PMEM that is being removed,
> > grab the page it points to, map that to the relevant struct page,
> > run collect_procs() on that page, then kill the user processes that
> > map that page.
> >
> > So why can't we walk the ptescheck the physical pages that they
> > map to and if they map to a pmem page we go poison that
> > page and that kills any user process that maps it.
> >
> > i.e. I can't see how unexpected pmem device unplug is any different
> > to an MCE delivering a hwpoison event to a DAX mapped page.
> 
> I guess the tradeoff is walking a long list of inodes vs walking a
> large array of pages.

Not really. You're assuming all a filesystem has to do is invalidate
everything if a device goes away, and that's not true. Finding if an
inode has a mapping that spans a specific device in a multi-device
filesystem can be a lot more complex than that. Just walking inodes
is easy - determining whihc inodes need invalidation is the hard
part.

That's where ->corrupt_range() comes in - the filesystem is already
set up to do reverse mapping from physical range to inode(s)
offsets...

> There's likely always more pages than inodes, but perhaps it's more
> efficient to walk the 'struct page' array than sb->s_inodes?

I really don't see you seem to be telling us that invalidation is an
either/or choice. There's more ways to convert physical block
address -> inode file offset and mapping index than brute force
inode cache walks....

.....

> > IOWs, what needs to happen at this point is very filesystem
> > specific. Assuming that "device unplug == filesystem dead" is not
> > correct, nor is specifying a generic action that assumes the
> > filesystem is dead because a device it is using went away.
> 
> Ok, I think I set this discussion in the wrong direction implying any
> mapping of this action to a "filesystem dead" event. It's just a "zap
> all ptes" event and upper layers recover from there.

Yes, that's exactly what ->corrupt_range() is intended for. It
allows the filesystem to lock out access to the bad range
and then recover the data. Or metadata, if that's where the bad
range lands. If that recovery fails, it can then report a data
loss/filesystem shutdown event to userspace and kill user procs that
span the bad range...

FWIW, is this notification going to occur before or after the device
has been physically unplugged? i.e. what do we do about the
time-of-unplug-to-time-of-invalidation window where userspace can
still attempt to access the missing pmem though the
not-yet-invalidated ptes? It may not be likely that people just yank
pmem nvdimms out of machines, but with NVMe persistent memory
spaces, there's every chance that someone pulls the wrong device...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
