Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7213C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 01:27:32 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DDE461054
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 01:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3DDE461054
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 182MsFmN023057;
	Fri, 3 Sep 2021 01:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2021-07-09;
 bh=yVtIn4M2PxiA1eZECkYy7yk62K+7XoMii0ckFd3+k5M=;
 b=C/rxNEne9YB5meC35nT16s1CiXG5zeyge2cIU/kkera+xCbj1tgtF9VuT09/FhLF12Pj
 UKiQQvwr7wQ85U9jzItpyNMO8bMXYXBswBu+tQDA0a1GhEN/u6YwNcl8v1iVj9+1afjk
 tgtVOgPGEcumGfjIbxNK6O5qK4uKlddnfps8/EtAxsCA+deWPAqpttMmA2LeY6DA7Cph
 /p3SqjQy5BDAn0vHRvZy3w/v3a4NwYLXpqzt6TFFkglAyo0g3Y3axqPldp7KelUJPDRO
 IKU5mchFL5gEvzEPKNMyDaTvPjHi09MASeAGd36BQ0OMkVlGJpxYSGxYZNJJt+3+fWB+ YQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=yVtIn4M2PxiA1eZECkYy7yk62K+7XoMii0ckFd3+k5M=;
 b=rUWDdOXvBQK9Nj1xYAQv+0OA53F4wyp9rilqIxPU1vbLmVGyd69nK0LjwaaC56zSM8En
 RIG877rHYcf0pYW/kVJanM6s41V1YqYveReKhwWJZONYE9Ektj5HZyBt/5Z/UGYivkW9
 HuDv8zeujdeRwY+SPT89HudS0pnQNx/DpleocMRh9ncHp0EFNAKdj0ihBS5KtcCpWfQq
 0Iar8fEq7nmVWiMnJatTZhv6nCfTnI1bBCeiZIFfl0P1+IrAueuYVkoylbg/veKKAu6k
 KFoNGs9G29wkr+3mBGSJVZO/hRi7WGvD02Ao6qMMxAutApU5+29sy3B69Aj9ADZ8hb1Z 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3atdvymsbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 01:27:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1831FwDj015326;
	Fri, 3 Sep 2021 01:27:30 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3ate00t5um-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 01:27:29 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mLxzM-00057v-Nf; Thu, 02 Sep 2021 18:27:28 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1mLxyr-00056n-IK
	for ocfs2-devel@oss.oracle.com; Thu, 02 Sep 2021 18:26:57 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1831FwF3015287
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 01:26:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by userp3020.oracle.com with ESMTP id 3ate00t59y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 01:26:56 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23;
	Fri, 3 Sep 2021 01:26:53 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe%5]) with mapi id 15.20.4457.024;
	Fri, 3 Sep 2021 01:26:53 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Thu,  2 Sep 2021 18:26:31 -0700
Message-Id: <20210903012631.6099-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
X-ClientProxiedBy: SA9PR13CA0162.namprd13.prod.outlook.com
	(2603:10b6:806:28::17) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-128-63.vpn.oracle.com (2606:b400:8301:1010::16aa)
	by SA9PR13CA0162.namprd13.prod.outlook.com
	(2603:10b6:806:28::17) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4500.4 via Frontend Transport;
	Fri, 3 Sep 2021 01:26:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f957abad-efd9-4c51-2036-08d96e79e952
X-MS-TrafficTypeDiagnostic: SA2PR10MB4732:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W27HzWSfyAhFyDvtDgDO1V65OyQR8w0G/kSx4+UsKwnPHNrjhB8rDG7vzqFSCBd+t4dEzwBlD4vZdLjTu3jD0is+bIk7ZeuwtzXuliPfNVGOGZ3v9PSryqTGW6D8zZqtLGw/2RdcYsKxqT2SrvFz/Ao5m+00Es3nW72mFVbJtLPZs1gyARMtiIbZCB5+4IC98ut4bxHc5JWcbeeibkHZDypxEQBxcCB1d5yYOmua8LeDGIZ5PmY4UBgdbUBhwOXZottXqM/oKmsUHQBZQe0dBJ8H8HpGMrDcWR/pKgysYwzFOLo06/fj0Hre6j5VDYhzAPKvtM5M563OGRypxFGp5aMnk4QYOR6VIi/14NaCY96EwtVyiczLkBj982vuCyfTpVbEm4jIvab4lJJ5kcEE9ATrz3xQOSGHKriaa6wsfL8GxUIAhpIVyhPa7vCGjSkY5QjqTPf2pM3eovE2WzjU6790MwBq8fMhuqSlq83VtDeRUtbncV1iOZSAQY2MadNUai3y47hzPK5AR1QiJrFtxCX+yUHZzTEsr74ph04xqRw3tkbaraM2GVdXZte/ykZqLdOR1IMwTsNIrespTtoprrrBEJ+JE7dH2H4QQLSXq08=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oO5vXMCPTpIx6L7wHS6ojDpSiIXGxccbYXYP4rZUVwOVbJ1h55s2VYCIwx6e?=
	=?us-ascii?Q?vvpZ9yQKRPp2WTwkLTLu6K1aVB85wfITKKGX/Uy7r0tdHa3gWQ8JPVcwEm20?=
	=?us-ascii?Q?Hb9tia0SD2g8EWoMaAHSZOhnuCdwObijrHTdhedk1Oz0Y58SwQ9FGBEB4SYN?=
	=?us-ascii?Q?AHp6ldNksdXuXr1bGOmHJcND6iEBIos8CijcRPn0LBxHSM/vT1G4Bu5xTsUU?=
	=?us-ascii?Q?WUMHCkyLdXU9Q7tRyLbKxO0mtvFqy7kvd02qHtWzhDBryjhbUUldZukEpMwI?=
	=?us-ascii?Q?UgODx+ntzitcL4BtwTKJIyxXd/Wri7RVh6VX2H6w6K6rUTIEv58N9HEDF6l8?=
	=?us-ascii?Q?S7+GxiAXGvhCACz23qAEuFkczU5ncMZU7IXCOOcnaHyUJ0+BlLoGf/PAHuBf?=
	=?us-ascii?Q?M7bZMoP8wD+nGxZCYo08ZjwyL9OS7sS/m5Y3kHwwa4883sOqJcSOqgTm3Sup?=
	=?us-ascii?Q?QpG4CCHqNfeFmUliOWArXltT9OSEv8S3cyiONFkzEDoqM+RRKB9p7aYMX8TQ?=
	=?us-ascii?Q?HEYeBC1B+Fll2qfvbaILUL1XE06mqn/4BLqBRc7BZaaGloUPIGLhsZvI3YK+?=
	=?us-ascii?Q?zZO/2sQhaclSc6BA8bNESR3z7LfZGwb19ZEHuForTmsPBR/5E5BNBHDMRHpe?=
	=?us-ascii?Q?PQUCSRFjx+k3pHJWIubK2Qh5qnUTBhMC7+M5NPPQGe33PCXEsnB/JM/vFRir?=
	=?us-ascii?Q?ry23ZW1/RDRpOMvgS1i17TdYqNaKp+UTWm2+mnNYUyuNCPWae76K/NIWioVv?=
	=?us-ascii?Q?nnLgETbhJSOoTY9F+BoPncg50vd6QGNzzAbZnGuV0dj2lPiYqodKKZK667Vk?=
	=?us-ascii?Q?sC2ljcNY/WZjq1QImd9oaoXkSulljtfOwjNIwdR6Igk+pS0xzP6hn52tVErj?=
	=?us-ascii?Q?3wU30svyPULEUZUXxCyA+AWDvSZZ47+jLvdqlH6Id47RoVqi+wOnKO1jlnFN?=
	=?us-ascii?Q?rnjl1gqdGHde+oBrrOLNyDK1qnRKc1bYQ9dD3zYdYomLsM+swl6hXY5FtM+M?=
	=?us-ascii?Q?jl3NX1OQQnR778+TKR3XGPKamYZ0d9ey4wFkPe+fanJDtQNFetib57S5oNoM?=
	=?us-ascii?Q?tm8UOAGK/cVJ6ynWmuei9gojtPUMJdEve9AFXeNCaU4nKO9QZAHjKblqok3x?=
	=?us-ascii?Q?jPF4Wnb7ouq9ccvi6IWjD/RNWSicly7E5RDnOsIwPMPl9MJLhl0YYpCpeO4z?=
	=?us-ascii?Q?jS0KE+St+OYJdnUQ1i31Pe/oo3kudseN2dEq5v65Qpd1tsV/bt8+pZRvUJW2?=
	=?us-ascii?Q?wO0/Dfy55xWN7V03Pt0lCNtlHhkgOGyHXYsJjSgxBEZBDquXaOW/z19JbEEK?=
	=?us-ascii?Q?mD+sCpX5m4yVedFJrZT0ol9EIcGNSqxTdAvYpiQ/u/8vaw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f957abad-efd9-4c51-2036-08d96e79e952
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 01:26:53.6376 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9w7M/7VBou4aSLnnLaVvi62e4XJ9Em2ldS3Cclgi3sBQ81NZ2N21aZUJUff1iw/tibSWMcHq7GKa5MOSV4pGuqlBAD6/9pp7oZ5/SCEvHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 2606:b400:8301:1010::16aa
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SA2PR10MB4732.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0
	mlxlogscore=865 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109030006
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: drop acl cache for directories too
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030006
X-Proofpoint-GUID: D9kOeY7yeLOBwX1OLcghxbQQ8vOtjfx5
X-Proofpoint-ORIG-GUID: D9kOeY7yeLOBwX1OLcghxbQQ8vOtjfx5

ocfs2_data_convert_worker() is currently dropping any cached acl info
for FILE before down-converting meta lock. It should also drop for DIRECTORY.
Otherwise the second acl lookup returns the cached one (from VFS layer) which
could be already stale.

The problem we are seeing is that the acl changes on one node doesn't get
refreshed on other nodes in the following case:

  Node 1                    Node 2
--------------            ----------------
getfacl dir1

			  getfacl dir1    <-- this is OK

setfacl -m u:user1:rwX dir1
getfacl dir1   <-- see the change for user1

			  getfacl dir1    <-- can't see change for user1

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 50a863fc1779..207ec61569ea 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3933,7 +3933,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3964,6 +3964,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:
-- 
2.21.0 (Apple Git-122.2)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
