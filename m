Return-Path: <SRS0=1yMN=I5=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7B4C433B4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:37:46 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EEF3561004
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEF3561004
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VKZ7Z3194984;
	Wed, 31 Mar 2021 20:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=9YdhBcA2R0c/g/ysGUBfuUR78bv9c472c8uY5/FpKaE=;
 b=Iqst05FN4eVdQdJ3txxVFhVbXVsOad8eeU2I8PqhsXR3kPuvvwf/OhlBdjj8BjeT+n8E
 S2PznDRsFdhAzxyZqTPHMWEvxiTckQWuU5kQ/BnmVz2a2uqtuUOHRpsc/QkVNFpNxY5C
 6iB13PUA07nsUhD2aY0NS0AW36MEXPW4BITh7HOHFMOK1vsp4H1g9lX8zJID9K0haki3
 s6Q1VeiDCvcCFJ3174Os3hltC8lWHWfBw0uQ5Iqpcg1yv+Dck8EQeGOYQ7qve1xIGskO
 35ZhObMnHIJvU6aP8NurDy7+oQeR08Q23StXl6xGfzajK47G7I18+fTNFOWxMCR+jeHY 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 37mad9ukrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Mar 2021 20:37:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VKZYMP176918;
	Wed, 31 Mar 2021 20:37:44 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37mabmpqcg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 31 Mar 2021 20:37:43 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lRhaw-0004xb-F2; Wed, 31 Mar 2021 13:37:42 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lRhaW-0004uq-WA
	for ocfs2-devel@oss.oracle.com; Wed, 31 Mar 2021 13:37:17 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12VKafSe025167
	for <ocfs2-devel@oss.oracle.com>; Wed, 31 Mar 2021 20:37:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by userp3020.oracle.com with ESMTP id 37mac5ye1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 31 Mar 2021 20:37:16 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33;
	Wed, 31 Mar 2021 20:37:14 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.3999.028;
	Wed, 31 Mar 2021 20:37:14 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Wed, 31 Mar 2021 13:36:54 -0700
Message-Id: <20210331203654.3911-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
X-Originating-IP: [71.198.166.82]
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
	(2603:10b6:a03:1f4::31) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-235-110.vpn.oracle.com (71.198.166.82) by
	BY5PR20CA0018.namprd20.prod.outlook.com (2603:10b6:a03:1f4::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27
	via Frontend Transport; Wed, 31 Mar 2021 20:37:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d6beb56-260e-4894-5db1-08d8f484c4c3
X-MS-TrafficTypeDiagnostic: SN6PR10MB2464:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ub89v7kixScfJcfY8ZjQxLVF75lbkyAYuI+8nJkDx/LnZ1ET7IFLr6RgPN1sVvfx9dz/xgOHUEn0O2a77za148gYJrkaZy+ow/9HskRYqQI90B0GXg4MJTi0pzihsNc2xikoB20im76XQRWfqhrI6ps8P2QkHXQriAW0nGsi0QNA+T6K8DfElF16fZ3b1bgeHA9rcijzamOBdwzU5PrhN1qlnC0KkmKrVlSci/N5PnJPbpIcajCNDoXwBCX6WXHuFvfSah8PMVZ2vdxGD7tuCbWzDwKI4zXT1N8Ua7gyZGi+TcI3trnp8IcNlzy2XJp7JaLB3Yt81Zp506V4TyCSkG6KWq9+tGVZ57gGeU6HxYzdcSOfonk1YqHlRdwShr//Hk2pz19b8W1wKiJHJg6BDiiuz/CdEEeaU4iSeGlVwEyd1CY6EFa3Pg8GNozVSp5PLbGoMCu1aHSrDQ3yEAqV0JIMfbyRPgNCpvMsA5aTy7U3vcBJDH9OZJ179Nnj+igq2prxIc0UQ8STjuLrKZLoDf0/Cpdj4NrwZ1Ty2E+cpaTc0mkdsoQ3KavUFalsR+f9
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V56OdNYQtYTZcYbl3B5UCngWL/7hfFCorZAeLK1OIfCN8wSShDUqAwmsCEKe?=
	=?us-ascii?Q?tEYbFXtxrIRhUljOfv+lMKCsd9d0YxJTAF0cCNOvcmdMmyo3PyQOtTxHJ0Yo?=
	=?us-ascii?Q?67n+VtiPyGHwcvfQbhe9S0aZGZ2z2JnQWdJ4Bz6dljAsZsp6AfWtzkOElnid?=
	=?us-ascii?Q?w0eigGIa+oFxwqrJKtfTW0mu+hbxpZqAx+KWl6mDvNBHDKBHhTbZYWYsm0q2?=
	=?us-ascii?Q?vvq5nxJHWqUicnhlz0QyfLOGtCmrVyMFHF+u+JG3e48TtQPBSJdD2xpuJ/26?=
	=?us-ascii?Q?a7bUvdRUSKojKZlykXC+3WnVt1QDpL6V7qrHjTrqozmJj1+paB75Apr7n2iW?=
	=?us-ascii?Q?/hvwxnKd6u8jzNxbBsUqQjtYYGd/W2UjKMKQgGqTWZ9xSk+hwY3DZfxX+Sms?=
	=?us-ascii?Q?1bf0cjMuRZcTTZFR4+jJ8k9sgws5mafIjW4gSmTi9FXE6UgI2DKdixaNJ6ct?=
	=?us-ascii?Q?s5zONYJUchd1SpbOJphG82e2QZ1Tg4sxWGcDDpcwFeKU31hsNyaLdy+MNFgJ?=
	=?us-ascii?Q?kx6cELc8aAWi+I0OppZ2DJW/de7chVknMxgICOWwTMMJ5k72Y8P50ixQOfot?=
	=?us-ascii?Q?GeyKZsIssZX14/UxnGNc0C95XZFdAbFf6tG+YY/7dYFxm8AsR/ETeunnilEx?=
	=?us-ascii?Q?FvjKgFrHvjyOlnmKX5xTGnuREJ3HwT+0KhiK7pI84QvlsGXxxfQ3YLk2DKzq?=
	=?us-ascii?Q?sEoq+rhAwLVaKAkLFWq/+c8jpP8nRlxmlKt6H8nWWjGK+iGl7S99sgTP8+Nt?=
	=?us-ascii?Q?B2/Nn1IaiJ8PC7g2W/OJ+cZq0VlC89fUZoCdDksSlo8EfN9GcOg4P3miQdmW?=
	=?us-ascii?Q?Pa3b8cerj65ZOGtxyZ17/mCxlypzZKcorqj5TiiffCPKhOWua/SXCgRg8xNI?=
	=?us-ascii?Q?tNnL4zRDj/9GATG/C9ZkaibmEJxyQvMZHUR/rqJ0OOCTGfRJM6GcS3D8a3Bv?=
	=?us-ascii?Q?xoXDCw0oMU2BB1o9QE4NUhlv3jwGfm8pN54avYaAnDGwWXcQmLLFldNVxZxT?=
	=?us-ascii?Q?94UdWrb9VOlKDe3MlxEvZBNm4SbUbfKvNeyOapg8bqz0zWeDUkmcod+YZ6rq?=
	=?us-ascii?Q?B4wDsFXXlwd0I/HwHnxoQpdQatGswf7DNm179ScQ6xFltkFmMUjUiL5YLQzl?=
	=?us-ascii?Q?NZUnY0KKWvqQ+GnN8wFS9eXeY5oBc8RsVnJcgd6uXKwp3yR1Z/hili1URO6b?=
	=?us-ascii?Q?ScWBsoZYKNYSvwyj+3VxPndFEcTHP18Yw6bx/bVAIuIIMJVL2boP7pjXpBfU?=
	=?us-ascii?Q?ysUnNGEENcK6oSaEanveMeWQUcbv3ZU8jjuHn+Dp139UfQ9R29fFtiWBto2N?=
	=?us-ascii?Q?fr3Kz6KTZvNzn5VYIOYNYf75?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6beb56-260e-4894-5db1-08d8f484c4c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 20:37:14.8072 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ihJQU0lFqhpXb3GOs3VnvZyQc8ft07uZUDSUtGd+DchhF+NInSC+Fp/HSUuAW9nKeBopkTiv8sVlCD7SJ5l+K50Q2vCkXUeQtS9s7ieqF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 71.198.166.82
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2464.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	mlxlogscore=999
	malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103300000 definitions=main-2103310143
Cc: GHe@suse.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock between setattr and
	dio_end_io_write
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310143
X-Proofpoint-ORIG-GUID: p3p1Mn2x1R4k4aoKv9nZ9xhoz9DmDMvL
X-Proofpoint-GUID: p3p1Mn2x1R4k4aoKv9nZ9xhoz9DmDMvL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310143

The following deadlock is detected:

truncate -> setattr path is waiting for pending direct IO to be done (
inode->i_dio_count become zero) with inode->i_rwsem held (down_write).

PID: 14827  TASK: ffff881686a9af80  CPU: 20  COMMAND: "ora_p005_hrltd9"
#0 [ffffc9000bcf3c08] __schedule at ffffffff818667cc
#1 [ffffc9000bcf3ca0] schedule at ffffffff81866de6
#2 [ffffc9000bcf3cb8] inode_dio_wait at ffffffff812a2d04
#3 [ffffc9000bcf3d28] ocfs2_setattr at ffffffffc05f322e [ocfs2]
#4 [ffffc9000bcf3e18] notify_change at ffffffff812a5a09
#5 [ffffc9000bcf3e60] do_truncate at ffffffff812808f5
#6 [ffffc9000bcf3ed8] do_sys_ftruncate.constprop.18 at ffffffff81280cf2
#7 [ffffc9000bcf3f18] sys_ftruncate at ffffffff81280d8e
#8 [ffffc9000bcf3f28] do_syscall_64 at ffffffff81003949
#9 [ffffc9000bcf3f50] entry_SYSCALL_64_after_hwframe at ffffffff81a001ad

dio completion path is going to complete one direct IO (decrement
inode->i_dio_count), but before that it hang at locking inode->i_rwsem.

 #0 [ffffc90009b47b40] __schedule+700 at ffffffff818667cc
 #1 [ffffc90009b47bd8] schedule+54 at ffffffff81866de6
 #2 [ffffc90009b47bf0] rwsem_down_write_failed+536 at ffffffff8186aa28
 #3 [ffffc90009b47c88] call_rwsem_down_write_failed+23 at ffffffff8185a1b7
 #4 [ffffc90009b47cd0] down_write+45 at ffffffff81869c9d
 #5 [ffffc90009b47ce8] ocfs2_dio_end_io_write+180 at ffffffffc05d5444 [ocfs2]
 #6 [ffffc90009b47dd8] ocfs2_dio_end_io+85 at ffffffffc05d5a85 [ocfs2]
 #7 [ffffc90009b47e18] dio_complete+140 at ffffffff812c873c
 #8 [ffffc90009b47e50] dio_aio_complete_work+25 at ffffffff812c89f9
 #9 [ffffc90009b47e60] process_one_work+361 at ffffffff810b1889
#10 [ffffc90009b47ea8] worker_thread+77 at ffffffff810b233d
#11 [ffffc90009b47f08] kthread+261 at ffffffff810b7fd5
#12 [ffffc90009b47f50] ret_from_fork+62 at ffffffff81a0035e

Thus above forms ABBA deadlock. The same deadlock was mentioned in
upstream commit 28f5a8a7c033cbf3e32277f4cc9c6afd74f05300. well, it seems
that that commit just removed cluster lock (the victim of above dead
lock) from the ABBA deadlock party.

End-user visible effects:
Process hang in truncate -> ocfs2_setattr path and other processes hang at
ocfs2_dio_end_io_write path.

This is to fix the deadlock its self. It removes inode_lock() call from dio
completion path to remove the deadlock and add ip_alloc_sem lock in setattr
path to synchronize the inode modifications.

Cc: stable@vger.kernel.org
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c | 11 +----------
 fs/ocfs2/file.c | 11 ++++++++++-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3bfb4147895a..ad20403b383f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2295,7 +2295,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, locked = 0;
+	int ret = 0, credits = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2306,13 +2306,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	    !dwc->dw_orphaned)
 		goto out;
 
-	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
-	 * are in that context. */
-	if (dwc->dw_writer_pid != task_pid_nr(current)) {
-		inode_lock(inode);
-		locked = 1;
-	}
-
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2393,8 +2386,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
-	if (locked)
-		inode_unlock(inode);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 
 	return ret;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 85979e2214b3..9feaa0d2425a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1123,7 +1123,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
-	int had_lock;
+	int had_lock, had_alloc_lock = 0;
 	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_setattr(inode, dentry,
@@ -1244,6 +1244,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 				goto bail_unlock;
 			}
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		had_alloc_lock = 1;
+
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
@@ -1255,6 +1258,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (status < 0)
 			goto bail_commit;
 	} else {
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		had_alloc_lock = 1;
+
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
@@ -1273,6 +1279,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
+	if (had_alloc_lock)
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
+
 	if (status && inode_locked) {
 		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 		inode_locked = 0;
-- 
2.21.0 (Apple Git-122.2)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
