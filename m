Return-Path: <SRS0=Mf06=IH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150EDC433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:25:39 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A3A7C61574
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:25:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3A7C61574
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 129GJShv156088;
	Tue, 9 Mar 2021 16:25:38 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 3742cn7wx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Mar 2021 16:25:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 129GLFJa038404;
	Tue, 9 Mar 2021 16:25:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 374kgs1sdt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Mar 2021 16:25:36 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lJf4n-0001WV-Iq; Tue, 09 Mar 2021 08:19:17 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rgoldwyn@suse.de>) id 1lJf4P-0001VW-3H
	for ocfs2-devel@oss.oracle.com; Tue, 09 Mar 2021 08:18:53 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	129FtR5k094493
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Mar 2021 16:18:52 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 374kmyp1sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Mar 2021 16:18:52 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	129FsFeJ032900
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Mar 2021 16:18:52 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2030.oracle.com with ESMTP id 373yskabqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Mar 2021 16:18:50 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D8065AF0C;
	Tue,  9 Mar 2021 16:18:47 +0000 (UTC)
Date: Tue, 9 Mar 2021 10:19:06 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210309161906.jjd7iw2y6hcst5c3@fiona>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 195.135.220.15
X-ServerName: mx2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.221.0/24 ip4:195.135.220.0/24
	~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 impostorscore=0
	phishscore=0 clxscore=180 priorityscore=213 spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 mlxlogscore=648 mlxscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103090080
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
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
 engine=8.12.0-2009150000 definitions=main-2103090081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1034 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103090081

Hi Shiang,

Thanks for picking up this work.

On  8:20 26/02, Shiyang Ruan wrote:
> This patchset is attempt to add CoW support for fsdax, and take XFS,
> which has both reflink and fsdax feature, as an example.

How does this work for read sequence for two different files
mapped to the same extent, both residing in DAX?

If two different files read the same shared extent, which file
would resultant page->mapping->host point to?

This problem is listed as a TODO over dax_associate_entry() and is
still not fixed.

<snip>

-- 
Goldwyn

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
