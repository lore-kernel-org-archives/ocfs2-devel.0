Return-Path: <SRS0=55Qa=IA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C60C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 03:33:57 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 613FD64D74
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Mar 2021 03:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 613FD64D74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1223Ttl5078910;
	Tue, 2 Mar 2021 03:33:56 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 36yeqmx00c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Mar 2021 03:33:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1223QhsR023191;
	Tue, 2 Mar 2021 03:33:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyured6p-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Mar 2021 03:33:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGvnH-0003bW-7z; Mon, 01 Mar 2021 19:33:55 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lGvnE-0003bF-FE
	for ocfs2-devel@oss.oracle.com; Mon, 01 Mar 2021 19:33:52 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1223PAl9123876
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 03:33:52 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36yynnkbfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 03:33:52 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1223Xocs039825
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Mar 2021 03:33:51 GMT
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
	[209.85.208.46]) by userp2030.oracle.com with ESMTP id 36yc4hnc5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Mar 2021 03:33:50 +0000
Received: by mail-ed1-f46.google.com with SMTP id d13so18463751edp.4
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 19:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QHkKhS85lTO/1ZkryMnHdjoXWEHU3orWJwuliOPijEg=;
	b=fHpD/V+ajdEPbJKp+t0fLHwbYH5YJF8X4khCi+h3Pw7A5Eg82DlyCHaHGJ5hauK1Tl
	uxb8DbTxK7hSY2kH2e6H9IFrXS2Sbe7Lx2BVOBzYPHZpkIjKYSs1zJnCDUiuO5g96Tkr
	kPUiuiJ/vyb8/KbpYrPR6jOBXT4mMUxD+M5vjWcrXP/1Vlb2aCljIgqXtDAIZ7nOWylU
	w/jtkVSZssgRMxSE3ovLPQoDiH0ePHIp26iyTP2PyYrhAkC6xRF7/j8SN2zDELueyG3a
	7herSOCQYOU2fWPaEJPrKwnX4eb0l/rphvQNoDzFB2KcyJ6V7OSrXuwya/bPDXUAmLZm
	xyZw==
X-Gm-Message-State: AOAM5325/ElDtQ1iU9ugacPA/4Ml5/uokDyb+NAJkdgjOMBWWhf7XUsS
	eo6DWCd+szrCa4XW/+K9pRlgItoCgB98YJ8xVTPIjw==
X-Google-Smtp-Source: ABdhPJy6/ka8tGagcwE2L5RBcYi+8/lqcA+6OxdF6mdgjEfsgOsYpbXmbns7gGEU/XAr64+OyUVXGqCAa0atgxuU9hs=
X-Received: by 2002:a05:6402:1152:: with SMTP id
	g18mr19307291edw.18.1614656017366; 
	Mon, 01 Mar 2021 19:33:37 -0800 (PST)
MIME-Version: 1.0
References: <20210226205126.GX4662@dread.disaster.area>
	<CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
	<20210226212748.GY4662@dread.disaster.area>
	<CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
	<20210227223611.GZ4662@dread.disaster.area>
	<CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
	<20210228223846.GA4662@dread.disaster.area>
	<CAPcyv4jzV2RUij2BEvDJLLiK_67Nf1v3M6-jRLKf32x4iOzqng@mail.gmail.com>
	<20210301224640.GG4662@dread.disaster.area>
	<CAPcyv4iTqDJApZY0o_Q0GKn93==d2Gta2NM5x=upf=3JtTia7Q@mail.gmail.com>
	<20210302024227.GH4662@dread.disaster.area>
In-Reply-To: <20210302024227.GH4662@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Mar 2021 19:33:28 -0800
Message-ID: <CAPcyv4ja8gnTR1E-Ge5etm+y69cHwdWN6Bg79wPPF4M=C-w79A@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-PDR: PASS
X-Source-IP: 209.85.208.46
X-ServerName: mail-ed1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=190 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=123 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103020025
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
 definitions=main-2103020025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020025

On Mon, Mar 1, 2021 at 6:42 PM Dave Chinner <david@fromorbit.com> wrote:
[..]
> We do not need a DAX specific mechanism to tell us "DAX device
> gone", we need a generic block device interface that tells us "range
> of block device is gone".

This is the crux of the disagreement. The block_device is going away
*and* the dax_device is going away. The dax_device removal implies one
set of actions (direct accessed pfns invalid) the block device removal
implies another (block layer sector access offline). corrupted_range
is blurring the notification for 2 different failure domains. Look at
the nascent idea to mount a filesystem on dax sans a block device.
Look at the existing plumbing for DM to map dax_operations through a
device stack. Look at the pushback Ruan got for adding a new
block_device operation for corrupted_range().

> The reason that the block device is gone is irrelevant to the
> filesystem. The type of block device is also irrelevant. If the
> filesystem isn't using DAX (e.g. dax=never mount option) even when
> it is on a DAX capable device, then it just doesn't care about
> invalidating DAX mappings because it has none. But it still may care
> about shutting down the filesystem because the block device is gone.

Sure, let's have a discussion about a block_device gone notification,
and a dax_device gone notification.

> This is why we need to communicate what error occurred, not what
> action a device driver thinks needs to be taken.

The driver is only an event producer in this model, whatever the
consumer does at the other end is not its concern. There may be a
generic consumer and a filesystem specific consumer.

> The error is
> important to the filesystem, the action might be completely
> irrelevant. And, as we know now, shutdown on DAX enable filesystems
> needs to imply DAX mapping invalidation in all cases, not just when
> the device disappears from under the filesystem.

Sure.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
