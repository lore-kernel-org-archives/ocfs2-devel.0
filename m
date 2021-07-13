Return-Path: <SRS0=MtCY=MF=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBD1C07E95
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jul 2021 21:14:18 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B38E760FE9
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jul 2021 21:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B38E760FE9
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DL7DMs017832;
	Tue, 13 Jul 2021 21:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=BCCMyjkjL2W7zyatUli0EaV8qFqzEvOHA/2GDWUPloc=;
 b=UR9PDsiQnYoJUAmgZpK/rwcDgrGldxWga2M2BhY0VxEDGq0/japNZYK9ZcUOTeAI+Rr0
 sLEbacgUkqJ3UuxfegavVCvoawdVnisCOgs0B+uIZY3b9ICKjjo5q2lUPBXWI8BJfOUy
 ZVXEHduoGkh6yRKhRJwR4Pq9tSH6MjUpRzezUR5OKXFGFEaLn5z52nxrghuAUwv8/7Mu
 Daen9zJLm3TiLFtnapvB7iirDZBaiWNw/qBXA9uEZJtDLnHE5u1NC4RjJlKJxYm0QzVf
 TxcYAHBG2jBXIelwOGjoJgHlDyktMbBbhNfVuVyoigGb+RxcVu1epwsA+gzpnqATG8TO CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb3d07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 21:14:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DL4vOe134184;
	Tue, 13 Jul 2021 21:14:15 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39qnb0nh57-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 13 Jul 2021 21:14:15 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m3PjK-0006jx-8N; Tue, 13 Jul 2021 14:14:14 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1m3Pio-0006if-LF
	for ocfs2-devel@oss.oracle.com; Tue, 13 Jul 2021 14:13:42 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16DL6Uap077732
	for <ocfs2-devel@oss.oracle.com>; Tue, 13 Jul 2021 21:13:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
	(mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
	by userp3030.oracle.com with ESMTP id 39q0p5uam4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 13 Jul 2021 21:13:42 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4416.namprd10.prod.outlook.com (2603:10b6:a03:2ae::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20;
	Tue, 13 Jul 2021 21:13:40 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756%6]) with mapi id 15.20.4308.027;
	Tue, 13 Jul 2021 21:13:40 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Tue, 13 Jul 2021 14:13:05 -0700
Message-Id: <20210713211306.50593-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
X-ClientProxiedBy: SN4PR0201CA0059.namprd02.prod.outlook.com
	(2603:10b6:803:20::21) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-233-121.vpn.oracle.com (73.231.9.254) by
	SN4PR0201CA0059.namprd02.prod.outlook.com
	(2603:10b6:803:20::21) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4331.21 via Frontend Transport;
	Tue, 13 Jul 2021 21:13:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1b3b112-6411-4f79-3861-08d946431655
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4416:
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcxpNWozVdFLF3SFL8BziBKBTZVRnKo5eTBOyiS1rE7sXJYbxadexJxFKMUUsnzUY+PJMAIwDJt/ijjMoQEXesZmbuxuVj3/6fxh0tqZZvo19GatXXPqX4KapQetSh5Ec7RJqbCPWsFC5GWGzZM0jGUplXFimZNQyGYl7y081oN3afbAyA2CU8AIPTaJp/vJa1R/s5nQwmexrWL347n5DGCPxQXRwvV1vZIVFVvj8qAXzqbRDGaJlh2IK+szoJbdyaebKNPUM05yJMn/MtdBuchdUyKuPeh315FaLftcljdji9Dr3lTI/sXOP/Z6bA31arfNfLEBENFL4wrudJWlSTHYFmyDmQzmFAqmHQsKJGVVveYajU2V93szNdpGrgo7zY4J953+L58hNIajZQC6SJ/RX4VAAvRJNNI2C2Aykp/lePA81pQUKNB5vT6z7X+UTXmxBMybyoqnutBqS8zzzd7NuCxbN5AwKa0jb4HJrnHu96XoEz+QqeYRwfxsd0fGcEFiFYzC2sWMg1i/l2vlVUr5DtANJlW0JWGQWZ9hDJaOcFzbkLMvSn2efeJ/8x9hi4cIUFUfKnocYFPj1UEF9/AnWJjJPaY/nLukHuKAPws=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkQBmLYRX7k9O5jIBHmV+1xGJ/+4G8BzQM2Ec6ic1BFL0X8E+B+Kpby3/1Hk?=
	=?us-ascii?Q?N8ncfxzP23gjQTygS4y9lrvbmK6jWs7/4XaBVwKn4yr9/yHLAeKbyKyvPYiT?=
	=?us-ascii?Q?Sq9po69XmYKtPENEVpwIOkDUhS0I+ZckRFgu0iIxTl7LXEJmZgKaEC2I+WtI?=
	=?us-ascii?Q?SuRheneMkilh0xoAKLOXtabGn/susjSZZP2H3M0wMrzEM2i9H1IOio85N3Lj?=
	=?us-ascii?Q?9z5thbeehKSNQ6coMICmO07oCr72njnGuTBIh3DOP/flVO4ruUaAAliM2fcv?=
	=?us-ascii?Q?Tzx3VFileNL4muzHQmnqUskixR4+tM+Tw7ZUTZeOICL8j8SfRnqzlmnY8I6w?=
	=?us-ascii?Q?CgWwa+3RudZ/M+DLL3AGhp2g1kgdBuipcJoN82KbAHJii0lKqXCnqtYlXI8D?=
	=?us-ascii?Q?ufX+DaUz1UTDhcCpG3eFKD2uysvbYPErsWsJIqBKd9uS3QncxRgOcLVDHbAi?=
	=?us-ascii?Q?5WFp/ZCAQ5OKNvQ2StKs/VaQjIHZWhb131WThGM9ymuRCyzPA30LfYWFzhdZ?=
	=?us-ascii?Q?oN7Xbhi+IkuL4rPPT6JImYKVcTzQXSl89/ehOqYKu69UxA5ZP4P85tr7YWAm?=
	=?us-ascii?Q?y6cxOGJsxIiBfua99JkURYmoh6e8CZah0S/Q+J9gACNj2otdEDwzQq3uN4if?=
	=?us-ascii?Q?sqM5AD+/Hf7u0dMnQYc8hIvBdGGyUzZG4MNUsadBxboVvH0BAw3D76DcxnCL?=
	=?us-ascii?Q?iJetBLkCIbB2pMWL7majdWIedoX9XQJmEaD9+w+xgNt95kkacx4f/Je4kEgW?=
	=?us-ascii?Q?aIsDBM8NAoFvzFLZ+umKL4hYVCN6i3pyfxiT+HBzdbZ996BV+37wn8ONTpd+?=
	=?us-ascii?Q?ogktZXKSYItAnVSDhW/GZkI/GNsYevwxbawYhRnVQkpttchEv3ML7aft3OZ0?=
	=?us-ascii?Q?6GQ+d73W65Anh2D+IEf3yF18YH5vkuqJLfJzLBC/ZJqBS0VNfkEwh1sJw1xC?=
	=?us-ascii?Q?fyGpycm8Uk3paTK8k+UwHz9o4Q/jN81zEPBd4la7L+qpysAfUvgP3NFX2nz4?=
	=?us-ascii?Q?FqJl5oSOfefWex2vEYOn/v2Hf2OSypITvlSWStELZpg5P4tKJqchfOQbQ4om?=
	=?us-ascii?Q?QFzsCiipoEMQ52cW78HtDq/joRFSDpyxXAp4Aq9YAcsAbrKN5nb4sxpRLMku?=
	=?us-ascii?Q?HNtlY/VGqK5dEjt1aX5P0LhPrVp2qq6uvg0d6oUxM6Ww8VBlxpaPfOxlTAur?=
	=?us-ascii?Q?b+YOLYf4IrKUFFuC4EyTrGsTTLJ2MwepYLGfGkYnzg5YgLRkrDRWq4/hP7eK?=
	=?us-ascii?Q?qYgKC39522S9OjTdUgqfAWesXqSZvvWiHvSkGX3rOS7u+4tZzVoXwQffS3+s?=
	=?us-ascii?Q?l0+pX2SPyPXjrZDWbsTXW0zu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b3b112-6411-4f79-3861-08d946431655
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:13:40.3502 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pm8Ok2LZK3SDfxsteIrz1wjSnk0Lzc0AAQRtYY9rFou0Xb9ko7/KCObTXsZNIIfUX6Cz1qG8zvaGEZx57QaFhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4416
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
X-OrganizationHeadersPreserved: SJ0PR10MB4416.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0
	phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107130130
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix zero out valid data
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130130
X-Proofpoint-ORIG-GUID: opMM-xuT3-Xk09KJ3k_daetZAihBd5Vi
X-Proofpoint-GUID: opMM-xuT3-Xk09KJ3k_daetZAihBd5Vi

If append-dio feature is enabled, direct-io write and fallocate could run
in parallel to extend file size, fallocate used "orig_isize" to record
i_size before taking "ip_alloc_sem", when ocfs2_zeroout_partial_cluster()
zeroout EOF blocks, i_size maybe already extended by ocfs2_dio_end_io_write(),
that will cause valid data zeroed out.

Fixes: 1733438b1d06 ("ocfs2: fix data corruption by fallocate")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 775657943057..53bb46ce3cbb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1935,7 +1935,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
-	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1943,7 +1942,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += orig_isize;
+		sr->l_start += i_size_read(inode);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1998,6 +1997,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		ret = -EINVAL;
 	}
 
+	orig_isize = i_size_read(inode);
 	/* zeroout eof blocks in the cluster. */
 	if (!ret && change_size && orig_isize < size) {
 		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
