Return-Path: <SRS0=5YYK=JX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEB6C433ED
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:10:45 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47CCF611BE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47CCF611BE
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QMAPKs132406;
	Mon, 26 Apr 2021 22:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : in-reply-to : references : mime-version : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=HNAHs9wlHBeIk3YJ270OyFCwabHVuTO497aLwHTB0Ms=;
 b=UHYmAHWa8DSoDLjN2VPtdiTMUgeKgH41LJijsyQDJ8GmDwM7C/SmlH2kyjS8yAYqwO6Q
 0gGNkLyIjdGIb4MeEnK3SSw29dBfDJF4xI7BqJrei6OQOSSYwMqouF29Axp9gUu2qQpn
 VUbgxbn9/lLwUSz1H8zXqXM7tDqr28KbgLX5+c6uELHMrBtg3Rb1c8dE/AkQBnXJp81k
 /sMuxJ6h59kAxdO/Buic3EpNg3zrT4g6LrekfCceQUyn3GuBmac/pW2fN20r5Jk9grj3
 2I6vNn6X8I5wwdAZC0jBwdmmkfcb7YRUDFap6ixNxDn7dFdntntUODU0XAQLI3APcOw8 lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 385afpukxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Apr 2021 22:10:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QM6LT5105690;
	Mon, 26 Apr 2021 22:10:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3s69fg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Apr 2021 22:10:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lb9O8-0003tZ-Ek; Mon, 26 Apr 2021 15:07:32 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lb9O4-0003sS-6E
	for ocfs2-devel@oss.oracle.com; Mon, 26 Apr 2021 15:07:28 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13QM6Klf105544
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:27 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com
	(mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
	by userp3020.oracle.com with ESMTP id 384w3s65pu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:27 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Mon, 26 Apr 2021 22:07:25 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Mon, 26 Apr 2021 22:07:25 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Date: Mon, 26 Apr 2021 15:05:51 -0700
Message-Id: <20210426220552.45413-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210426220552.45413-1-junxiao.bi@oracle.com>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN6PR05CA0026.namprd05.prod.outlook.com
	(2603:10b6:805:de::39) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-151-113.vpn.oracle.com (73.231.9.254) by
	SN6PR05CA0026.namprd05.prod.outlook.com (2603:10b6:805:de::39)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16
	via Frontend Transport; Mon, 26 Apr 2021 22:07:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a8e2d37-4503-4b06-f203-08d908ffac6e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VwMN72pqD8+9zVPai+/fFEcyXEuxfDn97mOfBmdNNGDgkMD5ngT+5YaWVSXgTYdP+AeZRcA5mgi4kmpBgj8Ug0xWJBtYKdpAZeBGwIuujCdP49R+Jk1ocv5op9UI10MNrKDyWpcF24yHboIXFTFKs4SrklNyLL/rCxERU92ComzJLLP9952/sYyvwh61EVLz5N6PxT/IquCjBR/r+pZfUjENafE1UoievGQrLn9GjeuR7F+xZNWvnewEpJA1/l9tzjuFP3TsSrfWtWJ+criT+RpwuXDe8mIewM4zYcpVBJymEz6jAU4us5aoermiPqIPvOLc4wzw4nd9TXErTzjlc8kI8s/UPkYMV/vsecWL45NhfmT49qDodG+QCLfGe/ohRzc4Z7KNyZrbRHC/3N0lR1tVHaE4cMMkaXDxDkv9h/TUHqz/ZWbNEYS1WkMrrUtkGF+OT5lkMhMLmcr+BZ9Jzj/RKoKiaIHftlSI9ra4WgHCIeI1sSVyq16v2tYO2p0yEB0SdZRDB443s1XV1UM9le9E146gmIFwGtKS4mIDqO1mU5jacjCLyrZ2fyKl7m+q
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6KXTj43qY+Wv+rpAe2aVddFMY9DQfqLQKc+a439RrSIazpBXuZuae9TyER89?=
	=?us-ascii?Q?RI1dk7MiBFrugdwH4wd1+3p0sygsnoXOg+2XHZ+ScO6HY2lmGNRVaJWOjzPY?=
	=?us-ascii?Q?VQ4E9wQnjkGxAyMxpjADeUIJPxQVClCO8ax8NAr0RM0BSiGUnB1PDzTWC3Xw?=
	=?us-ascii?Q?wUxe1402GvYsYI7GjMb+DjtTjbRCP8iGG/FVEFvV5WxbeYuFa/ZNv+3yBVyv?=
	=?us-ascii?Q?PVcUk/5iBPH3zkFSpCErSbXiyiT1+6ELKbFCu3/F6DFUY6JNnynva6/oCCdD?=
	=?us-ascii?Q?4LLg1cBm2vthNPA5nU/rTFxBdIIXyAK8RSl3zSbbawiJpRItCc6p0szISTTQ?=
	=?us-ascii?Q?FJZfvR0qIHfGnmz4e8dl4Qy3Pbhg0uEwym5EoPgjsHoTgiLHCga1dFEpj5Pq?=
	=?us-ascii?Q?1ucROyuJl+pDlP0D7OZjtyQ749UzEEgFm3+zjbxYG81hB4nwcPsgsXj9exOO?=
	=?us-ascii?Q?4SbiJmr8k/yhhORPC63Z3s0nCdyr7tbTWYJ8fNzTpTxhncsWoAOCHafVd+gz?=
	=?us-ascii?Q?2dPdA9i/bO1I+tzxcPMhhyNmEHieV47eldTNoXtuN27TS7rgzZt0+EcKuLnE?=
	=?us-ascii?Q?YwVvmiWeHxhLsz9URufXeipzbq5F58j7p26O7m+geA9ygtrJHidmkr+piiMV?=
	=?us-ascii?Q?Ktjk6LnyZRCBya/A1Ed91QFblx4tP59CmcOFHUtCV4bzNbuVj506rGX2Sq43?=
	=?us-ascii?Q?qJCXho47q0gXOegSnnbNm7WnW8PExKJaBW92nBpaRJmELk3iIYUA5LyuUo6D?=
	=?us-ascii?Q?0u7JlsyvJIvw3/AXh3FcDuovi2W/qHI4/WxwffT+OOp2zzZotaZ9OeS3Em6l?=
	=?us-ascii?Q?1tXbZ03lAeao+WLpq4ARMKDadwrB2axP1fn+JhuzT6lOkEeo+SHwWD5kJttr?=
	=?us-ascii?Q?eD120mswSVL7jj00GPAzNP4nRnf76wJWyN2qG1NTqNzCXnOi+OsTQWQFxEQN?=
	=?us-ascii?Q?uB1oMnBcu0K4eNK/Y7p3dgz9SG6Q+ltRmnJPtuYI6tuov5cboamnQyHTov2i?=
	=?us-ascii?Q?fdJTojmFyqmMxQDnBhtnqmhXbJnw/v9DMl1fhQoWoSEg6LqkpA6dpycnY7tO?=
	=?us-ascii?Q?Ozq1LODnGXcU+KRww8rbJXbVkVmoVBUcQI1wyoaEPEkxUFnjtmKlHd4BcUdf?=
	=?us-ascii?Q?3aVc82X7JGFtwGd/j4TATTp09RqgwApOMOdla1hcXm1OZfRAEF8cNP7Mqq9H?=
	=?us-ascii?Q?CgKSQkBMrEYR2Akk0cFNpFgcG2mt4vdciMcb/s7bX+Qwd8Wu2+eJXFBPVpMg?=
	=?us-ascii?Q?Yjgar9+oCttze/SyFrpZCyTKYpxH654r2vlMilld+jcGw712Gxg7AXr0v+yh?=
	=?us-ascii?Q?LGiMbyp32CvG5SypDWh+dwmY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8e2d37-4503-4b06-f203-08d908ffac6e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 22:07:25.3863 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rv8xsTrN/O+NCzFaHs19l22ZD6yrK3wBAt7Blb2gKtFX1jW2QeHUoTvhSFEp+rVtP9Bomygel5Js5XujDAd3rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BY5PR10MB4307.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	malwarescore=0 mlxscore=0
	mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104260167
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: allow writing back pages out of
	inode size
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104260167
X-Proofpoint-ORIG-GUID: G1PeHi4ki3h83opJEbPcd14hgeQFAxDD
X-Proofpoint-GUID: G1PeHi4ki3h83opJEbPcd14hgeQFAxDD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104260167

When fallocate/truncate extend inode size, if the original isize is in
the middle of last cluster, then the part from isize to the end of the
cluster needs to be zeroed with buffer write, at that time isize is not
yet updated to match the new size, if writeback is kicked in, it will
invoke ocfs2_writepage()->block_write_full_page() where the pages out
of inode size will be dropped. That will cause file corruption.

Running the following command with qemu-image 4.2.1 can get a corrupted
coverted image file easily.

    qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
             -O qcow2 -o compat=1.1 $qcow_image.conv

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/aops.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ad20403b383f..7a3e3d59f6a9 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -402,11 +402,28 @@ static void ocfs2_readahead(struct readahead_control *rac)
  */
 static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct inode * const inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	const pgoff_t end_index = i_size >> PAGE_SHIFT;
+	unsigned int offset;
+
 	trace_ocfs2_writepage(
 		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
 		page->index);
 
-	return block_write_full_page(page, ocfs2_get_block, wbc);
+	/*
+	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * writepage invocation because it may be mmapped.  "A file is mapped
+	 * in multiples of the page size.  For a file that is not a multiple of
+	 * the  page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	offset = i_size & (PAGE_SIZE-1);
+	if (page->index == end_index && offset)
+		zero_user_segment(page, offset, PAGE_SIZE);
+
+	return __block_write_full_page_eof(inode, page, ocfs2_get_block, wbc,
+			end_buffer_async_write, true);
 }
 
 /* Taken from ext3. We don't necessarily need the full blown
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
