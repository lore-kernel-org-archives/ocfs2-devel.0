Return-Path: <SRS0=X2TA=HK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8CEC433E0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:16:34 +0000 (UTC)
X-Greylist: delayed 80 seconds by postgrey-1.34 at mail.kernel.org; Mon, 08 Feb 2021 15:16:34 UTC
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1900664F2D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1900664F2D
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:16:33 +0000 (UTC)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118F9dcN033485;
	Mon, 8 Feb 2021 15:16:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 36hkrmv5ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Feb 2021 15:16:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118FAcBc088639;
	Mon, 8 Feb 2021 15:16:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36j4vq12cg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 08 Feb 2021 15:16:32 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l98H9-0008Fg-Qf; Mon, 08 Feb 2021 07:16:31 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from <hch@lst.de>)
	id 1l98H7-0008FR-RC
	for ocfs2-devel@oss.oracle.com; Mon, 08 Feb 2021 07:16:29 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	118FBM5A039948
	for <ocfs2-devel@oss.oracle.com>; Mon, 8 Feb 2021 15:16:29 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36j50yy2ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 08 Feb 2021 15:16:29 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	118FDDYf028955
	for <ocfs2-devel@oss.oracle.com>; Mon, 8 Feb 2021 15:16:28 GMT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by userp2040.oracle.com with ESMTP id 36hhqtkdgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 08 Feb 2021 15:16:28 +0000
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2ABDA68B02; Mon,  8 Feb 2021 16:16:24 +0100 (CET)
Date: Mon, 8 Feb 2021 16:16:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210208151623.GD12872@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-5-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210207170924.2933035-5-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-PDR: PASS
X-Source-IP: 213.95.11.211
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 adultscore=0
	spamscore=0 bulkscore=0 clxscore=301 malwarescore=0 suspectscore=0
	priorityscore=60 mlxscore=0 mlxlogscore=604 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102080104
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 4/7] fsdax: Replace mmap entry in case of
	CoW
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
 engine=8.12.0-2009150000 definitions=main-2102080104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1034
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080104

>  static void *dax_insert_entry(struct xa_state *xas,
>  		struct address_space *mapping, struct vm_fault *vmf,
> -		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +		void *entry, pfn_t pfn, unsigned long flags, bool insert_flags)
>  {
>  	void *new_entry = dax_make_entry(pfn, flags);
> +	bool dirty = insert_flags & DAX_IF_DIRTY;
> +	bool cow = insert_flags & DAX_IF_COW;
>  
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);

Can we just move the __mark_inode_dirty to the one caller that needs it
in a prep patch?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
