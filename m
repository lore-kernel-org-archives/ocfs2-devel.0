Return-Path: <SRS0=HAPo=H7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E217C433DB
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 21:41:29 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3CD7600EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 21:41:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3CD7600EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121LT6xv178997;
	Mon, 1 Mar 2021 21:41:27 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36ybkb5jvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Mar 2021 21:41:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121LUs96113213;
	Mon, 1 Mar 2021 21:41:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000w4dtf-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Mar 2021 21:41:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGqC3-0001iZ-Nl; Mon, 01 Mar 2021 13:35:07 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lGqC1-0001iC-HB
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 13:35:05 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	121LUuX8129014
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 21:35:05 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36yynna034-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 21:35:05 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	121LXT3h010205
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 21:35:04 GMT
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
	[209.85.208.45]) by userp2030.oracle.com with ESMTP id 36yc4hgutp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 21:35:04 +0000
Received: by mail-ed1-f45.google.com with SMTP id w9so6571173edt.13
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 13:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=S5eQqZgOuAzrBI1ZGPeaiXwFuA8MI7ck2ex1o4+Zhi4=;
	b=NRLyYiHW+KUYDia+luR06tVrVRWyjxoJOhxD9/9BcMMCVJ2u5+Os03LaZ6tuBz3DmX
	9B/iPOAX1Aq330sTIZMbpWMBAgWxJRFj0kZicOnaI9HRqaZdnLGpdiri1+Umv36QEn2k
	jYf4XvgbfFU/RLBnNjN19dcNI8e8bMfOCA36SJJIafjsyQpIf3yYMmEKiBhDYOFW+e4U
	cd1qzUd5dKX3dsI3CKzxATLb7PH4MTPSQkaqwssV4FKMJbm2PsBZutxSU1rhJ3c2qZxA
	8IYV+H4PM6byP+b5hWtKSje3m/dBGQ+IAJMbNPCqMihvPWhdaHfV/K6X3K3NnIIgXtPa
	2TEQ==
X-Gm-Message-State: AOAM532q9W0pEmsW6uekUic2OCiJ4t3GVTAsCizRIXNpnt9OHMSRiD4a
	nz6Sd6F6n9I1o8ostdwzC7fgt2yevTBKtIMne8YuCw==
X-Google-Smtp-Source: ABdhPJwE9duJauuJj63Z2mtoHxQXFJwkwdtiBTnboqNDobSDSZ5Ru3/ng679otfZJBNziIAzFv6Zba+Xj6ySXe7YUC0=
X-Received: by 2002:a05:6402:10ce:: with SMTP id
	p14mr18013748edu.348.1614634501187; 
	Mon, 01 Mar 2021 13:35:01 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
	<556921a1-456c-c24d-6d47-e8b15c1d9972@fujitsu.com>
In-Reply-To: <556921a1-456c-c24d-6d47-e8b15c1d9972@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Mar 2021 13:34:52 -0800
Message-ID: <CAPcyv4g3ZwbdLFx8bqMcNvXyrob8y6sBXXu=xPTmTY0VSk5HCw@mail.gmail.com>
To: Yasunori Goto <y-goto@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.208.45
X-ServerName: mail-ed1-f45.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=183 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=152 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103010174
X-Spam: Clean
Cc: "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
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
 definitions=main-2103010174
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010174

On Sun, Feb 28, 2021 at 11:27 PM Yasunori Goto <y-goto@fujitsu.com> wrote:
>
> Hello, Dan-san,
>
> On 2021/02/27 4:24, Dan Williams wrote:
> > On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >>
> >> On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> >>> Hi, guys
> >>>
> >>> Beside this patchset, I'd like to confirm something about the
> >>> "EXPERIMENTAL" tag for dax in XFS.
> >>>
> >>> In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> >>> when we mount a pmem device with dax option, has been existed for a
> >>> while.  It's a bit annoying when using fsdax feature.  So, my initial
> >>> intention was to remove this tag.  And I started to find out and solve
> >>> the problems which prevent it from being removed.
> >>>
> >>> As is talked before, there are 3 main problems.  The first one is "dax
> >>> semantics", which has been resolved.  The rest two are "RMAP for
> >>> fsdax" and "support dax reflink for filesystem", which I have been
> >>> working on.
> >>
> >> <nod>
> >>
> >>> So, what I want to confirm is: does it means that we can remove the
> >>> "EXPERIMENTAL" tag when the rest two problem are solved?
> >>
> >> Yes.  I'd keep the experimental tag for a cycle or two to make sure that
> >> nothing new pops up, but otherwise the two patchsets you've sent close
> >> those two big remaining gaps.  Thank you for working on this!
> >>
> >>> Or maybe there are other important problems need to be fixed before
> >>> removing it?  If there are, could you please show me that?
> >>
> >> That remains to be seen through QA/validation, but I think that's it.
> >>
> >> Granted, I still have to read through the two patchsets...
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
> >
>
> I'm not sure why there is a race condition between unbinding operation
> and accessing mmaped file on filesystem dax yet.
>
> May be silly question, but could you tell me why the "unbinding"
> operation of the namespace which is mounted by filesystem dax must be
> allowed?

The unbind operation is used to switch the mode of a namespace between
fsdax and devdax. There is no way to fail unbind. At most it can be
delayed for a short while to perform cleanup, but it can't be blocked
indefinitely. There is the option to specify 'suppress_bind_attrs' to
the driver to preclude software triggered device removal, but that
would disable mode changes for the device.

> If "unbinding" is rejected when the filesystem is mounted with dax
> enabled, what is inconvenience?

It would be interesting (read difficult) to introduce the concept of
dynamic 'suppress_bind_attrs'. Today the decision is static at driver
registration time, not in response to how the device is being used.

I think global invalidation of all inodes that might be affected by a
dax-capable device being ripped away from the filesystem is sufficient
and avoids per-fs enabling, but I'm willing to be convinced that
->corrupted_range() is the proper vehicle for this.

>
> I can imagine if a device like usb memory stick is removed surprisingly,
> kernel/filesystem need to reject writeback at the time, and discard page
> cache. Then, I can understand that unbinding operation is essential for
> such case.

For usb the system is protected by the fact that all future block-i/o
submissions to the old block-device will fail, and a new usb-device
being plugged in will get a new block-device. I.e. the old security
model is invalidated / all holes are closed by blk_cleanup_queue().

> But I don't know why PMEM device/namespace allows unbinding operation
> like surprising removal event.

DAX hands direct mappings to physical pages, if the security model
fronting those physical pages changes the mappings attained via the
old security model need to be invalidated. blk_cleanup_queue() does
not invalidate DAX mappings.

The practical value of fixing that hole is small given that physical
unplug is not implemented for NVDIMMs today, but the get_user_pages()
path can be optimized if this invalidation is implemented, and future
hotplug-capable NVDIMM buses like CXL will need this.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
