Return-Path: <SRS0=/QLR=II=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7387BC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Mar 2021 14:27:24 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 01FC164FF3
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Mar 2021 14:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01FC164FF3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AEOgBb045344;
	Wed, 10 Mar 2021 14:27:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 3741pmk540-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Mar 2021 14:27:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AEP5Yc059689;
	Wed, 10 Mar 2021 14:27:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 374kgtdwnj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 10 Mar 2021 14:27:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lJzo1-0003Nf-1i; Wed, 10 Mar 2021 06:27:21 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <willy@infradead.org>) id 1lJznz-0003NR-1p
	for ocfs2-devel@oss.oracle.com; Wed, 10 Mar 2021 06:27:19 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12AEPZCR172614
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 14:27:18 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 374kn113rg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 14:27:18 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12AEOHhk035262
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 14:27:18 GMT
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by userp2030.oracle.com with ESMTP id 373yskvamu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 14:27:17 +0000
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lJznP-003gjI-VB; Wed, 10 Mar 2021 14:26:45 +0000
Date: Wed, 10 Mar 2021 14:26:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <20210310142643.GQ3479805@casper.infradead.org>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310142159.kudk7q2ogp4yqn36@fiona>
X-PDR: PASS
X-Source-IP: 90.155.50.34
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 impostorscore=0
	phishscore=0 clxscore=242 priorityscore=335 spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 mlxlogscore=875 mlxscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103100072
X-Spam: Clean
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Neal Gompa <ngompa13@gmail.com>,
        darrick.wong@oracle.com, david@fromorbit.com,
        linux-kernel@vger.kernel.org, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        dan.j.williams@intel.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1034 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100072

On Wed, Mar 10, 2021 at 08:21:59AM -0600, Goldwyn Rodrigues wrote:
> On 13:02 10/03, Matthew Wilcox wrote:
> > On Wed, Mar 10, 2021 at 07:30:41AM -0500, Neal Gompa wrote:
> > > Forgive my ignorance, but is there a reason why this isn't wired up to
> > > Btrfs at the same time? It seems weird to me that adding a feature
> > 
> > btrfs doesn't support DAX.  only ext2, ext4, XFS and FUSE have DAX support.
> > 
> > If you think about it, btrfs and DAX are diametrically opposite things.
> > DAX is about giving raw access to the hardware.  btrfs is about offering
> > extra value (RAID, checksums, ...), none of which can be done if the
> > filesystem isn't in the read/write path.
> > 
> > That's why there's no DAX support in btrfs.  If you want DAX, you have
> > to give up all the features you like in btrfs.  So you may as well use
> > a different filesystem.
> 
> DAX on btrfs has been attempted[1]. Of course, we could not

But why?  A completeness fetish?  I don't understand why you decided
to do this work.

> have checksums or multi-device with it. However, got stuck on
> associating a shared extent on the same page mapping: basically the
> TODO above dax_associate_entry().
> 
> Shiyang has proposed a way to disassociate existing mapping, but I
> don't think that is the best solution. DAX for CoW will not work until
> we have a way of mapping a page to multiple inodes (page->mapping),
> which will convert a 1-N inode-page mapping to M-N inode-page mapping.

If you're still thinking in terms of pages, you're doing DAX wrong.
DAX should work without a struct page.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
