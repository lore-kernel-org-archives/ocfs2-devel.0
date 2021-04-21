Return-Path: <SRS0=ZrhC=JS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E534DC43460
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:30:34 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 418B66141C
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:30:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 418B66141C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LGDpts028709;
	Wed, 21 Apr 2021 16:30:32 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 37yn6cay76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Apr 2021 16:30:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LGFx2P175807;
	Wed, 21 Apr 2021 16:30:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3809euhp59-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 21 Apr 2021 16:30:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZFkE-00079E-4i; Wed, 21 Apr 2021 09:30:30 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1lZFjj-00072w-0w
	for ocfs2-devel@oss.oracle.com; Wed, 21 Apr 2021 09:29:59 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13LGEsU8141900
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Apr 2021 16:29:58 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 3809m0vbev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Apr 2021 16:29:58 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13LGFQtm044938
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Apr 2021 16:29:58 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2030.oracle.com with ESMTP id 382ht2quf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Apr 2021 16:29:57 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 48FBFB4D4;
	Wed, 21 Apr 2021 16:29:54 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id B22D31F2B69; Wed, 21 Apr 2021 18:29:53 +0200 (CEST)
Date: Wed, 21 Apr 2021 18:29:53 +0200
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20210421162953.GA13863@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=97
	mlxlogscore=567 spamscore=0
	adultscore=0 impostorscore=0 suspectscore=0 priorityscore=30 mlxscore=0
	malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
	definitions=main-2104210119
X-Spam: Clean
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] Possible fs corruption when hole punch races with
	other ops
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210119
X-Proofpoint-GUID: eSh_IZ7DvyJwYTL-kMGd6eYDU0tDm-qO
X-Proofpoint-ORIG-GUID: eSh_IZ7DvyJwYTL-kMGd6eYDU0tDm-qO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1034 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210119

Hello,

I'm unifying protection various filesystems use to protect hole punch
operations from racing with other operations (like readahead, page fault,
writepage etc.). I was looking into OCFS2 and I think it is prone to a
following race which can possibly lead to filesystem corruption. But maybe
I miss something so that's why I'm writing here. The scenario I'm concerned
about is:

CPU1					CPU2
ocfs2_remove_inode_range()		ocfs2_writepage()
  ...					  block_write_full_page()
  ocfs2_remove_btree_range()		    ocfs2_extent_map_get_blocks()

Now ocfs2_extent_map_get_blocks() runs without protection of ip_alloc_sem
AFAICT and so both these operations can be modifying extent map at the same
time? What am I missing?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
