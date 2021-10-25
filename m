Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95114C4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:12 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3320B60EB9
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3320B60EB9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PEtoNv030360;
	Mon, 25 Oct 2021 15:14:11 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bw6v1ut9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 15:14:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PF1umF064844;
	Mon, 25 Oct 2021 15:14:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bv7gus9xc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 15:14:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf1fs-0004OP-Oj; Mon, 25 Oct 2021 08:14:08 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1mf1fO-0004Md-Fu
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 08:13:38 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PF1Cfp173472
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:38 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bv8efhaey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:38 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PDUYNs012597
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:37 GMT
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bwsgk480a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:36 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 4552621956;
	Mon, 25 Oct 2021 15:13:33 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.224.230])
	by relay2.suse.de (Postfix) with ESMTP id 0CBC5A3B8A;
	Mon, 25 Oct 2021 15:13:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id BF6571E06C4; Mon, 25 Oct 2021 17:13:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Oct 2021 17:13:23 +0200
Message-Id: <20211025150008.29002-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=984; h=from:subject:message-id;
	bh=Z3aUSq5FVN9uFK1uVKy8Mnyf9+pi8/ZTb2uC1OJoijI=;
	b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhdslZ3wL6lmgzxN0buPr4fkDBBM9nhXLop4/FZjZd
	RqHVoM+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYXbJWQAKCRCcnaoHP2RA2WtxCA
	DWw3be8MjJeAB5ATJl6GA9Z4oU23JKG6pYH0lgcuVPVv8ufXhgTHA7MJbIula3JLOvE6MPXtMFNcP0
	Nkb6W9e7NJ8+HyDDB0ce7LRDmEvRv5BNZC7nACOOI3d8BGjRKjti2sO90Wu9kePLL2j1kyuWGjDj0d
	iKveTFqVyA/Lue1j0xyTIWePs/wyNNLA+mwpFlzQR/tFOR93nhCO6hsXC2ax5+1yaIcZdEq6SIoruh
	YPhL5XyPnEvPnakxCJzzbN/wZuhy6UyhQIfgvxFYA65tBzOaJTav29MRbP8cY2rGbahyibWPX84hKl
	Argca78U8gMis+gEnNb/B2TKJxEYNA
X-Developer-Key: i=jack@suse.cz; a=openpgp;
	fpr=93C6099A142276A28BBE35D815BC833443038D8C
X-Source-IP: 195.135.220.28
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 phishscore=0
	adultscore=0 impostorscore=0 malwarescore=0 clxscore=203 mlxscore=0
	priorityscore=48 spamscore=0 suspectscore=0 mlxlogscore=596 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110250092
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: Truncate data corruption fix
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250092
X-Proofpoint-GUID: PP6dZzk9qLIBVS_5H8IifHyvkXQ1Tnvm
X-Proofpoint-ORIG-GUID: PP6dZzk9qLIBVS_5H8IifHyvkXQ1Tnvm

Hello,

as further testing has shown, the commit 5314454ea3f ("ocfs2: fix data
corruption after conversion from inline format") didn't fix all the data
corruption issues the customer started observing after 6dbf7bb55598 ("fs: Don't
invalidate page buffers in block_write_full_page()"). This time I have tracked
them down to two bugs in ocfs2 truncation code. One bug (truncating page cache
before clearing tail cluster and setting i_size) could cause data corruption
even before 6dbf7bb55598, but before that commit it needed a race with page
fault, after 6dbf7bb55598 it started to be pretty deterministic. Another
bug (zeroing pages beyond old i_size) used to be harmless inefficiency before
commit 6dbf7bb55598. But after commit 6dbf7bb55598 in combination with the
first bug it resulted in deterministic data corruption. Although fixing only
the first problem is needed to stop data corruption, I've fixed both issues
to make the code more robust.

								Honza

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
