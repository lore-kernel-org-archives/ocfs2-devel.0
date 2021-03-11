Return-Path: <SRS0=Hr1N=IJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F63FC433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:53:59 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A13E64FBA
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A13E64FBA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12B0iwae196032;
	Thu, 11 Mar 2021 00:53:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 3741pmmyyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Mar 2021 00:53:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12B0jVMU101955;
	Thu, 11 Mar 2021 00:53:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 374kp05wje-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 11 Mar 2021 00:53:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lK9aN-0008OA-Qr; Wed, 10 Mar 2021 16:53:55 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.j.williams@intel.com>) id 1lK9Zy-0008NL-MI
	for ocfs2-devel@oss.oracle.com; Wed, 10 Mar 2021 16:53:30 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12B0jahQ096464
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 00:53:30 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 374kn1rcfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 00:53:30 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12B0iL0E047634
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 00:53:29 GMT
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
	[209.85.208.42]) by userp2040.oracle.com with ESMTP id 37711g8v63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 00:53:29 +0000
Received: by mail-ed1-f42.google.com with SMTP id h10so251371edt.13
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 16:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=q4/XB1NjVzkcassvGF9k8OOkOtHMefsYgpLIOhbHN44=;
	b=izzpAktnPo21SYzIh9hXTXe0RZ6g/ANmkLvnZlsUybS/xII5F1NSNyziIFciBiGUwW
	c7911ocPJdzlrIvam8lvNZ18sLpZrI+7M2He6IWeOGQ0rk4D1DZLVpfMYx8WRtJj3PTw
	WUO6WoeG75+AnAf3sgGv1GUPb59Kgkfc9L/aRuF9LRloHgQjn5k8b5R5N2kjaMwKaM+Y
	RzZrzNZ3puTc+LC2sAWnYMe0RINpStqP43pabP2iStfbqaQW/+Jl8EB7SfIl/etPLjnh
	3Oxhmu2fIz0EYUAOOl4Xi/U6geeGHhm8/D5hDKujEafN1mg6kqms8o3SOmzxDDRdaUBB
	o8ww==
X-Gm-Message-State: AOAM53176KPvbXA2iKm0btRK5nCJfVEMW3x/bA1VoPqEZoUUs2HGYCyW
	f/xymVLahH2IRB5ny1m7I1rblx8kzvigHmVUDaPhJA==
X-Google-Smtp-Source: ABdhPJypQ8GemOXeRAlB5nBwa/LaXTEzwLO62LM4I6+2OuCpeLVCa5nLj+566PgoZJjKJzgw0+xwotjje7pT9PlLG2A=
X-Received: by 2002:aa7:dd05:: with SMTP id i5mr6011841edv.300.1615424006716; 
	Wed, 10 Mar 2021 16:53:26 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
	<20210310142643.GQ3479805@casper.infradead.org>
In-Reply-To: <20210310142643.GQ3479805@casper.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Mar 2021 16:53:15 -0800
Message-ID: <CAPcyv4i80GXjjoAD9G0AaRDWPbcTSLogJE9NokO4Eqpzt6UMkA@mail.gmail.com>
To: Matthew Wilcox <willy@infradead.org>
X-PDR: PASS
X-Source-IP: 209.85.208.42
X-ServerName: mail-ed1-f42.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	lowpriorityscore=0
	mlxlogscore=638 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
	adultscore=0 clxscore=170 impostorscore=0 mlxscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103110003
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        Al Viro <viro@zeniv.linux.org.uk>, Neal Gompa <ngompa13@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 00/10] fsdax,
	xfs: Add reflink&dedupe support for fsdax
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110003
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110003

On Wed, Mar 10, 2021 at 6:27 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Mar 10, 2021 at 08:21:59AM -0600, Goldwyn Rodrigues wrote:
> > On 13:02 10/03, Matthew Wilcox wrote:
> > > On Wed, Mar 10, 2021 at 07:30:41AM -0500, Neal Gompa wrote:
> > > > Forgive my ignorance, but is there a reason why this isn't wired up to
> > > > Btrfs at the same time? It seems weird to me that adding a feature
> > >
> > > btrfs doesn't support DAX.  only ext2, ext4, XFS and FUSE have DAX support.
> > >
> > > If you think about it, btrfs and DAX are diametrically opposite things.
> > > DAX is about giving raw access to the hardware.  btrfs is about offering
> > > extra value (RAID, checksums, ...), none of which can be done if the
> > > filesystem isn't in the read/write path.
> > >
> > > That's why there's no DAX support in btrfs.  If you want DAX, you have
> > > to give up all the features you like in btrfs.  So you may as well use
> > > a different filesystem.
> >
> > DAX on btrfs has been attempted[1]. Of course, we could not
>
> But why?  A completeness fetish?  I don't understand why you decided
> to do this work.

Isn't DAX useful for pagecache minimization on read even if it is
awkward for a copy-on-write fs?

Seems it would be a useful case to have COW'd VM images on BTRFS that
don't need superfluous page cache allocations.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
