Return-Path: <SRS0=/Yqq=H3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6B9C433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 07:35:45 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B524A64ED9
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 07:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B524A64ED9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P7ZRGV107789;
	Thu, 25 Feb 2021 07:35:43 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36vr627ts1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Feb 2021 07:35:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P7UbtY078255;
	Thu, 25 Feb 2021 07:35:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc0vdv4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 25 Feb 2021 07:35:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFBBV-0004u2-JJ; Wed, 24 Feb 2021 23:35:41 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from <hch@lst.de>)
	id 1lFBBN-0004ta-NM
	for ocfs2-devel@oss.oracle.com; Wed, 24 Feb 2021 23:35:33 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11P7Ufvl107641
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 07:35:33 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36ucb1py8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 07:35:33 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11P7X4bq036048
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 07:35:32 GMT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by userp2040.oracle.com with ESMTP id 36wskey4mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 07:35:32 +0000
Received: by verein.lst.de (Postfix, from userid 2407)
	id D893868B05; Thu, 25 Feb 2021 08:35:25 +0100 (CET)
Date: Thu, 25 Feb 2021 08:35:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20210225073525.GA3448@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
	<9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
	<20210209093438.GA630@lst.de>
	<79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
	<20210210131928.GA30109@lst.de>
	<b00cfda5-464c-6161-77c6-6a25b1cc7a77@cn.fujitsu.com>
	<20210218162018.GT7193@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210218162018.GT7193@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-PDR: PASS
X-Source-IP: 213.95.11.211
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	adultscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=809 phishscore=0
	priorityscore=0 suspectscore=0 malwarescore=0 clxscore=277
	impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102250062
X-Spam: Clean
Cc: jack@suse.cz, Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>,
        linux-nvdimm@lists.01.org, darrick.wong@oracle.com,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 5/7] fsdax: Dedup file range to use a
	compare function
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250062
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1034 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250062

On Thu, Feb 18, 2021 at 08:20:18AM -0800, Darrick J. Wong wrote:
> > I think a nested call like this is necessary.  That's why I use the open
> > code way.
> 
> This might be a good place to implement an iomap_apply2() loop that
> actually /does/ walk all the extents of file1 and file2.  There's now
> two users of this idiom.

Why do we need a special helper for that?

> (Possibly structured as a "get next mappings from both" generator
> function like Matthew Wilcox keeps asking for. :))

OTOH this might be a good first use for that.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
