Return-Path: <SRS0=X2TA=HK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DAEC433DB
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:39:21 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6523964E30
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6523964E30
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118FTFem080434;
	Mon, 8 Feb 2021 15:39:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36hk2kc9vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Feb 2021 15:39:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118FUblW006355;
	Mon, 8 Feb 2021 15:39:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36j4vq27e5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 08 Feb 2021 15:39:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l98dC-0000jI-Bf; Mon, 08 Feb 2021 07:39:18 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1l98dB-0000iw-2O
	for ocfs2-devel@oss.oracle.com; Mon, 08 Feb 2021 07:39:17 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	118FVLUc148530
	for <ocfs2-devel@oss.oracle.com>; Mon, 8 Feb 2021 15:39:17 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 36j51005g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 08 Feb 2021 15:39:16 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	118FXMRd028211
	for <ocfs2-devel@oss.oracle.com>; Mon, 8 Feb 2021 15:39:16 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2030.oracle.com with ESMTP id 36hh5h2nff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Mon, 08 Feb 2021 15:39:15 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 03D05ADDD;
	Mon,  8 Feb 2021 15:39:12 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id AD8FD1E13F9; Mon,  8 Feb 2021 16:39:11 +0100 (CET)
Date: Mon, 8 Feb 2021 16:39:11 +0100
From: Jan Kara <jack@suse.cz>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210208153911.GE30081@quack2.suse.cz>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-PDR: PASS
X-Source-IP: 195.135.220.15
X-ServerName: mx2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	malwarescore=0 mlxscore=0
	adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=48
	suspectscore=0 clxscore=314 bulkscore=0 mlxlogscore=676 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102080105
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 0/7] fsdax,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080105
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1034 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080105

On Mon 08-02-21 01:09:17, Shiyang Ruan wrote:
> This patchset is attempt to add CoW support for fsdax, and take XFS,
> which has both reflink and fsdax feature, as an example.
> 
> One of the key mechanism need to be implemented in fsdax is CoW.  Copy
> the data from srcmap before we actually write data to the destance
> iomap.  And we just copy range in which data won't be changed.
> 
> Another mechanism is range comparison .  In page cache case, readpage()
> is used to load data on disk to page cache in order to be able to
> compare data.  In fsdax case, readpage() does not work.  So, we need
> another compare data with direct access support.
> 
> With the two mechanism implemented in fsdax, we are able to make reflink
> and fsdax work together in XFS.
> 
> Some of the patches are picked up from Goldwyn's patchset.  I made some
> changes to adapt to this patchset.

How do you deal with HWPoison code trying to reverse-map struct page back
to inode-offset pair? This also needs to be fixed for reflink to work with
DAX.

								Honza

> 
> (Rebased on v5.10)
> ==
> 
> Shiyang Ruan (7):
>   fsdax: Output address in dax_iomap_pfn() and rename it
>   fsdax: Introduce dax_copy_edges() for CoW
>   fsdax: Copy data before write
>   fsdax: Replace mmap entry in case of CoW
>   fsdax: Dedup file range to use a compare function
>   fs/xfs: Handle CoW for fsdax write() path
>   fs/xfs: Add dedupe support for fsdax
> 
>  fs/btrfs/reflink.c     |   3 +-
>  fs/dax.c               | 188 ++++++++++++++++++++++++++++++++++++++---
>  fs/ocfs2/file.c        |   2 +-
>  fs/remap_range.c       |  14 +--
>  fs/xfs/xfs_bmap_util.c |   6 +-
>  fs/xfs/xfs_file.c      |  30 ++++++-
>  fs/xfs/xfs_inode.c     |   8 +-
>  fs/xfs/xfs_inode.h     |   1 +
>  fs/xfs/xfs_iomap.c     |   3 +-
>  fs/xfs/xfs_iops.c      |  11 ++-
>  fs/xfs/xfs_reflink.c   |  23 ++++-
>  include/linux/dax.h    |   5 ++
>  include/linux/fs.h     |   9 +-
>  13 files changed, 270 insertions(+), 33 deletions(-)
> 
> -- 
> 2.30.0
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
