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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27BFC433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:10:46 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 54F8961103
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54F8961103
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QMAiQB081027;
	Mon, 26 Apr 2021 22:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=IRgHqvuCftcB5LI6A7XXYJTxKOKh089s1ot2YYw+GFI=;
 b=i6KmHFhaH2KnmGpjQkQi4Xq8hCBK0eJTqcWVIcb2+jrDHOC3NXI0/VMrL+BeT88n21JC
 xtqk+Iq7TnBZoCgORPOMArLrswlE28i5+TvVpoE+qA0hJEEtN9yl47OhhlemEa+dYn1M
 tq+GT0JAkbr3dJWuvvcuR7cnAZ7Eh4vjuz/aG4oX+eU5p8CI7eaWjcjsTjyQn/mzONmq
 tQIYMeQuuRSqcmuA2WhKZ2q9A4a3o0snkZFrF7GTw6Y7fbuQu9Rpms9ZpB2NxA10ZOjZ
 i0zWAIoSq3TkChyMWa3GoGHdSW9Tq+HTAVlanwWzzF6CiAFLtbz44+8lQIeSbdZO2aet 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 385afsuk8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Apr 2021 22:10:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QM6KTC105585;
	Mon, 26 Apr 2021 22:10:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3s69fd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Apr 2021 22:10:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lb9O8-0003t6-95; Mon, 26 Apr 2021 15:07:32 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lb9O3-0003s7-Ci
	for ocfs2-devel@oss.oracle.com; Mon, 26 Apr 2021 15:07:27 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13QM6Kle105544
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:27 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com
	(mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
	by userp3020.oracle.com with ESMTP id 384w3s65pu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:27 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Mon, 26 Apr 2021 22:07:24 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Mon, 26 Apr 2021 22:07:24 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Date: Mon, 26 Apr 2021 15:05:50 -0700
Message-Id: <20210426220552.45413-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
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
	via Frontend Transport; Mon, 26 Apr 2021 22:07:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0e7a9d6-7dfb-41e4-2b4e-08d908ffabb3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O5vKjBM3fozZjptfX62di4lX+XzUHcr6ULe/vpr3pEWpFpkRzF7zdnxgaPZNAN3xANuLgSWg+bMCdLXgco/f6aQwnYaSwTifO+K5wDa73RpqYU47V+J0zPw+HI4Zup/upQeA/nxy10IDoDqlAzGGkMKsYYi8eBIhwVikw4Z7JKja8iCOG7LyGf+mjK2icVzbEKEVMXW+ojZdFzH6n4YbVjhfBjlmEbeUHzP7gFKpvNcwcGv4xQEnotsutZQTc6WCE6hB760G2LMhgYOiKtg9BCYzMkwLc5P/SKI8E9zv6HDUQ63UqqB3zHldJeXtdnVSBxcnywS+R2o5yoWm1PJZKZgXtuSkzybjTYMsbhlPJlP+NNZ8QN+23Ckcn6xM0nYi1rMm9JUweEU1YVnLBBNJwUjzhRN1kN16M3JYpThCV428wDH1mgbV/3TXbhuBE/WIK8ACuOo2SC4jPrFwIDZ3DyDD+a6kkNENgZyLL4pLRcZotYAoYWuln8FVFTFFUDpxbJiHB9BjcpcAijjh786RqV1ZUQfLh9f2qwfyvUoXNv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v4gZCJCK9k+BgKtTbrFKxbLID81u/jknEt2iZ4f9w6P+kCrFxeW+eCSvz174?=
	=?us-ascii?Q?dZWh4S17iQ7dqXSybytcy0Vtp/SHyTp9e+OW5zq+RO5mjIn92LvKoAGCqpvD?=
	=?us-ascii?Q?G4YZuxRVgt8o1ZIODKNgie0yTzG/k85fMpPrQzb8sIZYKOXhzCNiosHXecTG?=
	=?us-ascii?Q?7jM/UNMoXq1z/eEjzwoOrnGcYVNOds2q+fiCP+NOMlSXFLwbXSXC76M3EaAu?=
	=?us-ascii?Q?joUjQ1lpgZrA+BdNHIhsxEuVs/7cZasJI1KLadD/VSPrJV+Xg2OIVlmGSTYC?=
	=?us-ascii?Q?HngGEw2pMNZsYP6Z8I4Ouw4CxCjZqK2X1sStBO1t89gh+g1BBXJPWIvhYbF1?=
	=?us-ascii?Q?XghDkrrca9BSNc1y2K6K52ft2STdR7MusfuWJDmqETDyrmA3FtocPpAXLMph?=
	=?us-ascii?Q?QVwClpeR2iT3jg1uMsBmM3xmOy4epTnJzr8kq5VLYTPwIhSMofqZ46xXh7b+?=
	=?us-ascii?Q?Gq45FHtpcchM0VM1debHrZy2Ru0jna7tUYCWg6QE9jcnHDGHrtmJUyR9Dcs7?=
	=?us-ascii?Q?9pLeeflgV98vcQadiR5irJ81IUojpWZOPM3K/JklBpb1+LiXvG5rae24QXkL?=
	=?us-ascii?Q?Wj4DGFa3PLRornp0IKnUqpP1ok8pCd8Vt+moPpSFs6MI8QOaRDNWxK5/lqOR?=
	=?us-ascii?Q?60tQXWUy5Nb7Hzyr5JIMT7B/tgBjKXpuoOLkkvAO1e5JHMEm0yqxpPXYWyc3?=
	=?us-ascii?Q?6hhu2+m3h4kMrM1uz+C5ofMHnuPJA3poDbKgXDKnUgCDmuYh01LAlTrCgBkB?=
	=?us-ascii?Q?aSx4RUI5CGLesbu8Zdu31th4TT95wDnRao2in1Pzm5KLs0w+bjngBitAE0pt?=
	=?us-ascii?Q?MDFGDlX4BYgl4e0LR/meeGqLTRZUmEjHyT2we5w7XBERc1bW4ufBhH6VCbng?=
	=?us-ascii?Q?lGvj5pshsM0atFsTyw2ZqsoIAis50vh9oswL3OtZ3kzWI2uVx6w5GSk+0FLv?=
	=?us-ascii?Q?dvHORvBZk0f8YMYhIsP/VniCjCYASeDNrTLcreQIcC28bVxbiejlm3gnzkQ0?=
	=?us-ascii?Q?C8Fqr7EPH5G3YBCGT8EfZhrCFZKc1Cvyt1BrlpKK7xQhlJVVETOkZoIGBFtK?=
	=?us-ascii?Q?0DALgex2kupn5AeuxT/rpuC13qEgaqrpQeXdD7A4FQ7L/rGLgAGmqMZi4nDb?=
	=?us-ascii?Q?gNaQBtYzKFQHgoFD33dz7OWE9FKzrOYw0UsDX1zyBjiF4t78PSFJVwPPwT4q?=
	=?us-ascii?Q?0DcEuHkWlD4EkAmr33bax7h8xWPluLJL8o/vf+T/lXwJovUH0ToukGh49BS+?=
	=?us-ascii?Q?uQ/40yW+qLJaB1ez652db+2FiviFaRNEJyqFF6kO3f4bes8JUedxYbQqo3mH?=
	=?us-ascii?Q?mM+ZULKDujmjU+Uovfe1JgoH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e7a9d6-7dfb-41e4-2b4e-08d908ffabb3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 22:07:24.2204 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snLY8rZffYOjsGQC0zOLdHBspCuyTAIkdH+8UH/3c7TK1tzASA8A/o/dJA9lkyvNMV/XhOPJFhn/0kULeqaeWQ==
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
Subject: [Ocfs2-devel] [PATCH 1/3] fs/buffer.c: add new api to allow eof
	writeback
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
X-Proofpoint-GUID: VI7mVfbq-gbBPVH2f3Z9bMWhTcqjOlud
X-Proofpoint-ORIG-GUID: VI7mVfbq-gbBPVH2f3Z9bMWhTcqjOlud
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260167

When doing truncate/fallocate for some filesytem like ocfs2, it
will zero some pages that are out of inode size and then later
update the inode size, so it needs this api to writeback eof
pages.

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/buffer.c                 | 14 +++++++++++---
 include/linux/buffer_head.h |  3 +++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0cb7ffd4977c..802f0bacdbde 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1709,9 +1709,9 @@ static struct buffer_head *create_page_buffers(struct page *page, struct inode *
  * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
  * causes the writes to be flagged as synchronous writes.
  */
-int __block_write_full_page(struct inode *inode, struct page *page,
+int __block_write_full_page_eof(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc,
-			bh_end_io_t *handler)
+			bh_end_io_t *handler, bool eof_write)
 {
 	int err;
 	sector_t block;
@@ -1746,7 +1746,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 	 * handle any aliases from the underlying blockdev's mapping.
 	 */
 	do {
-		if (block > last_block) {
+		if (block > last_block && !eof_write) {
 			/*
 			 * mapped buffers outside i_size will occur, because
 			 * this page can be outside i_size when there is a
@@ -1871,6 +1871,14 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 	unlock_page(page);
 	goto done;
 }
+EXPORT_SYMBOL(__block_write_full_page_eof);
+
+int __block_write_full_page(struct inode *inode, struct page *page,
+			get_block_t *get_block, struct writeback_control *wbc,
+			bh_end_io_t *handler)
+{
+	return __block_write_full_page_eof(inode, page, get_block, wbc, handler, false);
+}
 EXPORT_SYMBOL(__block_write_full_page);
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 6b47f94378c5..5da15a1ba15c 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -221,6 +221,9 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc,
 			bh_end_io_t *handler);
+int __block_write_full_page_eof(struct inode *inode, struct page *page,
+			get_block_t *get_block, struct writeback_control *wbc,
+			bh_end_io_t *handler, bool eof_write);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, unsigned long from,
 				unsigned long count);
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
