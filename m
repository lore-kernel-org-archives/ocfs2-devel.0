Return-Path: <SRS0=FAnV=KX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B14C47087
	for <ocfs2-devel@archiver.kernel.org>; Fri, 28 May 2021 21:12:24 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AB0A61378
	for <ocfs2-devel@archiver.kernel.org>; Fri, 28 May 2021 21:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AB0A61378
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SL9cGn177064;
	Fri, 28 May 2021 21:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=WXZKlxATym5Ie7rvCAha6QrW787EorWffzhdC9ay658=;
 b=JlXj/poXsuY1l4598jamoLuwoW5pzbE1O15+t0/CS1NiWSrKJud+cNJVSgFJj7Wl3RKI
 z258oK2yqRAECttLcXboWJqERez5KwBn6sOXgkDHDUF7Csdo+qagrxOc+DzQfv2KA6Xu
 1CUCWrlsfBcYNefbTKY1q35/ReOLehNSKwDTUhfJVYk6fEP+Tm6+nK5BcVN+StZkk3Yd
 vOEPhX4+VAEN4NigcYAfRAjcTFHPuwDAPeCHGNDscszh9hmu0SF77AJ1d9ORbXq68Gr0
 uo+5LmuJlMpCuijpW2DNgB/iHgvOIwDpEBDwss8yTFtcJ2Da8H8kKGcWH2/gFZRdVN12 Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38ptkpg2vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 May 2021 21:12:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SL6OHp001430;
	Fri, 28 May 2021 21:12:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqvv44m-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 28 May 2021 21:12:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lmjjE-0004bt-As; Fri, 28 May 2021 14:09:12 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lmjil-0004b6-1w
	for ocfs2-devel@oss.oracle.com; Fri, 28 May 2021 14:08:43 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14SL6Hud188784
	for <ocfs2-devel@oss.oracle.com>; Fri, 28 May 2021 21:08:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
	(mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by aserp3030.oracle.com with ESMTP id 38pr0evxw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 28 May 2021 21:08:42 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4431.namprd10.prod.outlook.com (2603:10b6:a03:2dc::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22;
	Fri, 28 May 2021 21:08:41 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%5]) with mapi id 15.20.4173.024;
	Fri, 28 May 2021 21:08:41 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Fri, 28 May 2021 14:06:48 -0700
Message-Id: <20210528210648.9124-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
	(2603:10b6:a03:2c0::17) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-129-251.vpn.oracle.com (73.231.9.254) by
	SJ0PR13CA0012.namprd13.prod.outlook.com (2603:10b6:a03:2c0::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9
	via Frontend Transport; Fri, 28 May 2021 21:08:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81a7a93c-862a-4175-78fc-08d9221cc554
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4431:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:272;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nEfNDWocaymij1DckTVauC6VvjUPcBXKtITAjyLG/iBXUxnxJNwlfBKYa0lNwucu7vybLsbvsBH0tlGoYbPu7Gneifaef2z83CPtjWDTMZp2hll+cpR5dKo/lRBJxBCfcEvRcQkendFrDegcCQIvqNcykZfLo9L05tEUUcHJv3casFSKcZWjAsCKFUr0zzED4GYu0Dhmq0UQ/tmda71bsBT6dKNWA6cHGddYKs7hg/iOUPCfR5IZPdRxH9SU+v4XwofevipAnh7Di9YYinbjc3BTpE8qKc+JmCwH8NcypnScXJO8+R4RAjsePXzMTWhzeFEdJ5KLQtRutlmBuRMzlCkW14fwMQ7PRmV9Ka+YqzgMg4x2pIBlp8crKYJ48QWJ4DFUMvlcrqW4hPSEEEhvG2noUuuRmFY3jII9bYZGF4/lBirLvG/MFWimB/kYwtWWsdLInco5nuGr60b71wHKI3baZ39aE1Jr0lN3SCw3RfCkb6YL8mQp4g7V5Hr2Iw7sePYlIOxusiGJx6xchohwXgPUsiTMDbiROBgyepkNmyanX0UvY+w/Q+wNzu5wAylHGzByQDgJwvqcpVv+ZUpBcGqV63ac7zUjjwhOjsuF5HHQXTQ+SdyIL99xqr7gxDO+lYJ6VUALqJY0dIpNL085FSwbiCnhIIaejUiUqXDdHKoQ0Y+H1m6SNCyHE0CXSyr114K4AqQ0971TliyAnuUSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?atgviq2kSp12X07VAFfSiUzod6G65VZ/9k0CC5GVqdv57LbZSWvYrecTat2m?=
	=?us-ascii?Q?zQea/EOkBcOIa9EYYLXq64jkfUbTtz6SQuJo+YpF0uJ4+D92F7gOzCv/ql0N?=
	=?us-ascii?Q?njkA+69mIzUh0drQOYtuVlpFGOaFADSthjS4X9LfTEyIv1chwZqHMRME7/RQ?=
	=?us-ascii?Q?3Rkyc+FaxQJVKrM8Ip5CKzS9Dj0yZ1d/I3uCm1BqPovxBBTi1XcVZvHj+E80?=
	=?us-ascii?Q?SEpJXGFhOJ9I0MTFf9+z8dFgFjAiJEwsRZkVo2V26UHR2tTyn+u/lfJn2aSt?=
	=?us-ascii?Q?vPULHv7iNNt6FwvOEKYshFruwO710VosEY23S7ZeKoqy1LK9cwaHz+L9EOhs?=
	=?us-ascii?Q?zl3gJaT0QN3bp6V0MVbPUp0tulBQTILWVGYnemWC1wIyolaADtnH3L8AfzAP?=
	=?us-ascii?Q?OK1ChyaQh+SMNLYgy1DS5IRJxVcXXVq+XkLFASlGAIqYlI+GxhihClBVZC1R?=
	=?us-ascii?Q?2bGRE3FH0ZpoLpINmBrCo7KkkkhO7VjGLsOPykhfD8Amr9zEXvTiESRkG4ac?=
	=?us-ascii?Q?U36F2dBIwRRg+avNephh4fLoQXqsF5Tnx/7bnw+u/8Rf3Ooh9w8f6ZS3NPcB?=
	=?us-ascii?Q?0q0ks9WlvyyDSCYDWmNc5fWkJsdH9CR3sapQ97emLqYxMUIDOC1UyQHmPTAP?=
	=?us-ascii?Q?hcCj0U9dEn3LAd8NyV+om4+Hejc9vUa/i+JavNDDacUIpAEELOEveR3YaPhq?=
	=?us-ascii?Q?kIuphwMwyXPZloSrnr8kcf1GW8ttLH+aO6D6GdKoeRI0uI5Hr8MkERZr+E/D?=
	=?us-ascii?Q?xg20uRPWGH1z3iudBBMjIqdyR1GyGm7xpkiAXBf86+TyYxnNtKYrT7KXZfYe?=
	=?us-ascii?Q?eKzXAOBmgWCRNR3VrWyh6DqE/beqJdlVFXlo7qF3KUA8VXzwP3y23pOWN2Gq?=
	=?us-ascii?Q?u+QIDsPnrAlwt4LhEB+ftRlzoLn5ObEbNhPbQvDMIlV36bGj6NFQkfczF2il?=
	=?us-ascii?Q?yg5jG8YJpP4lsOmZf4uvAb/8R1YbC1jsjgV7tqqkaQt5gEo36hOboUP98ghR?=
	=?us-ascii?Q?zZF/cxuA4XpqNVoR3PpJ9p8FOlGjpYjTN8djU3nYxYGy9yYbcAVwFoNjNcB4?=
	=?us-ascii?Q?HtvX6o/xlHIPVrDQaZ0gl4FhDFB9HhTGNquRxd56He+UOQqd7h8SwOKZF5Mc?=
	=?us-ascii?Q?oaAv6xw+xFwUNHFnjh5hfXO3T8S2JRshuJ8je+9TzzYStRSZnK2QNnWdvQ+a?=
	=?us-ascii?Q?8F86JIuWP2vpCw1lrdg+GYoANgzJYm+SF7kVUC33t3CRU0mfJ+O/XPbfAetK?=
	=?us-ascii?Q?PjTD4ufdMlS4VWoD3raDxFY8GDF7fSGDxZoExdGXuQkINZCiMUEj2F/Jj+hn?=
	=?us-ascii?Q?yYrDhRKggNCzai95PKRhaXYi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a7a93c-862a-4175-78fc-08d9221cc554
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 21:08:41.5737 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oE7wnJ+/wDAI4vkqRgCo46Nlpw11zgYzOQnwSB+a455YzujD0yorE4MuTXo9NCtckRKDZNMo7hmc8gPnviXSCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4431
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
X-OrganizationHeadersPreserved: SJ0PR10MB4431.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105280140
Cc: linux-fsdevel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280140
X-Proofpoint-GUID: 4l653jBUEWmaCY-seQvxemTmaKMpqDut
X-Proofpoint-ORIG-GUID: 4l653jBUEWmaCY-seQvxemTmaKMpqDut
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280140

When fallocate punches holes out of inode size, if original isize is in
the middle of last cluster, then the part from isize to the end of the
cluster will be zeroed with buffer write, at that time isize is not
yet updated to match the new size, if writeback is kicked in, it will
invoke ocfs2_writepage()->block_write_full_page() where the pages out
of inode size will be dropped. That will cause file corruption. Fix
this by zero out eof blocks when extending the inode size.

Running the following command with qemu-image 4.2.1 can get a corrupted
coverted image file easily.

    qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
             -O qcow2 -o compat=1.1 $qcow_image.conv

The usage of fallocate in qemu is like this, it first punches holes out of
inode size, then extend the inode size.

    fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
    fallocate(11, 0, 2276196352, 65536) = 0

v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html
v2: https://lore.kernel.org/linux-fsdevel/20210525093034.GB4112@quack2.suse.cz/T/

Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---

Changes in v3:
- move i_size_write after zeroout done, this can remove duplicated code and kill possible race.

Changes in v2:
- suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.

 fs/ocfs2/file.c | 55 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f17c3d33fb18..775657943057 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1855,6 +1855,45 @@ int ocfs2_remove_inode_range(struct inode *inode,
 	return ret;
 }
 
+/*
+ * zero out partial blocks of one cluster.
+ *
+ * start: file offset where zero starts, will be made upper block aligned.
+ * len: it will be trimmed to the end of current cluster if "start + len"
+ *      is bigger than it.
+ */
+static int ocfs2_zeroout_partial_cluster(struct inode *inode,
+					u64 start, u64 len)
+{
+	int ret;
+	u64 start_block, end_block, nr_blocks;
+	u64 p_block, offset;
+	u32 cluster, p_cluster, nr_clusters;
+	struct super_block *sb = inode->i_sb;
+	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
+
+	if (start + len < end)
+		end = start + len;
+
+	start_block = ocfs2_blocks_for_bytes(sb, start);
+	end_block = ocfs2_blocks_for_bytes(sb, end);
+	nr_blocks = end_block - start_block;
+	if (!nr_blocks)
+		return 0;
+
+	cluster = ocfs2_bytes_to_clusters(sb, start);
+	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
+				&nr_clusters, NULL);
+	if (ret)
+		return ret;
+	if (!p_cluster)
+		return 0;
+
+	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
+	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
+	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
+}
+
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
@@ -1865,7 +1904,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 {
 	int ret;
 	s64 llen;
-	loff_t size;
+	loff_t size, orig_isize;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
@@ -1896,6 +1935,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
+	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1903,7 +1943,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += i_size_read(inode);
+		sr->l_start += orig_isize;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1957,6 +1997,14 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	default:
 		ret = -EINVAL;
 	}
+
+	/* zeroout eof blocks in the cluster. */
+	if (!ret && change_size && orig_isize < size) {
+		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
+					size - orig_isize);
+		if (!ret)
+			i_size_write(inode, size);
+	}
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ret) {
 		mlog_errno(ret);
@@ -1973,9 +2021,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
-	if (change_size && i_size_read(inode) < size)
-		i_size_write(inode, size);
-
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
 	if (ret < 0)
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
