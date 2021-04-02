Return-Path: <SRS0=Ssxc=I7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093DBC433ED
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Apr 2021 17:14:11 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 917AD61151
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Apr 2021 17:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 917AD61151
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132HAe4v151471;
	Fri, 2 Apr 2021 17:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=wqi3PCbfCpv1vPmwxMRLJT34m22yUdLGSeopArRc+p0=;
 b=mZNCQCto1LpyzYweuehy/SI71xl6PIJQPnQcy5kq4hC1RnQ3+YhjytjmRmnSq293ex9Y
 XnLMt3vEVvsG1VeE3GzAqoX6GWTl3vcJyHtvoV25+dFXXfwqyvIo4Y+8XuggGW3ovpqC
 /1tSCdPZGii0jmH3lMjWq2jy9AfAtzpie/u+45gN1s14cYqcabdaFgzjLWhVab8sacrD
 Fq4aXeXmu1mS0T2BnErkceGjXhf8LmSb45ApR4WFa5CwoNSDV8yI1paFt0K1igq/mnFc
 ZXCtyLJJyeVdqROEqBHM16D2f+eunxI49S/uePy6ZlTf9w0dBjPvdHjpanaLbdePKod7 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 37n2a057md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Apr 2021 17:14:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132H9fFY111009;
	Fri, 2 Apr 2021 17:14:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37n2au8w6y-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 02 Apr 2021 17:14:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lSNN1-0005sX-GR; Fri, 02 Apr 2021 10:14:07 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lSNMz-0005rW-1T
	for ocfs2-devel@oss.oracle.com; Fri, 02 Apr 2021 10:14:05 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	132HB1o6042538
	for <ocfs2-devel@oss.oracle.com>; Fri, 2 Apr 2021 17:14:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by aserp3020.oracle.com with ESMTP id 37n2acnxmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 02 Apr 2021 17:14:04 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29;
	Fri, 2 Apr 2021 17:14:03 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.3999.030;
	Fri, 2 Apr 2021 17:14:03 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Fri,  2 Apr 2021 10:13:44 -0700
Message-Id: <20210402171344.1605-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
X-Originating-IP: [71.198.166.82]
X-ClientProxiedBy: BYAPR06CA0001.namprd06.prod.outlook.com
	(2603:10b6:a03:d4::14) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-145-87.vpn.oracle.com (71.198.166.82) by
	BYAPR06CA0001.namprd06.prod.outlook.com (2603:10b6:a03:d4::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26
	via Frontend Transport; Fri, 2 Apr 2021 17:14:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ef9d59e-9b05-4d36-da57-08d8f5fab6d6
X-MS-TrafficTypeDiagnostic: SA2PR10MB4779:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: flaUHoqgdGN0j+vtEIT/H5Ay/xoN7ohwhMBJ/b/cf4TYFu32EIIuFhfhUlqZ4qJLYHHvwog1/2wnP0IFDHxqjNoh8aXZvkTrux58FMEg/DawbOOaEUMmZB5JUEt5oCj43G4V8uGWjh9bPaZC/4PsrvESztiWTGdaUpsHDHXAEwNsSDApa2gNgNPdBEiG4kpHawpQZrwKSgoLU8M3XKBd+A7yk4MU72B6O/x189clCeHN1DE7C3PPntkjs3he8jNOOgnb2gmccOIqcl5PUV76PjHCPGWpYgqANJ1FR5MaozVbHe+aJIClAD9dxchTTnA93NgIR5zR/XQ/M58VjU3jK+DfRiwizQN9pDH5K8Ccl0YYa8XEajUW0lCvG09xL068b79GXpqEBJ8SA+qa5cAVWJmccyBT42pwDVl5PHjdNhTfri8a53lrLvcuFjnXKdGWdoWIUadJlstYC6DRFBoLxpe3ECq+bNSOv4moJVf6PiS+oMvuMZkYYaQEw6Vf8P3FIQJPiq+82+LlO24I/8RzndKRwtQ9f0bI4qmISuCcZccrzTaXIMv0w9PnsvQkR2YG
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m05N8NT0ApY2MDu94xU79jf5d6OUr/ZV3d5iJVxecAGBAXuTV2683cOwxj3H?=
	=?us-ascii?Q?eMtBZA3tgn02DU509/NeLSGAgQBXCrBpoh5yN2HTdMCBP9FAIxMV2HkNIOyE?=
	=?us-ascii?Q?tmFX6T43OxlQqFzblar0f2h9xVgsOL6OzMFKiCwotC/zvEopFUsF/pp7v7fu?=
	=?us-ascii?Q?JU+eYSTrHpIAePTRvqNySQgtURwSbZYSItZNtuqbzOmnGM+JZP6R+LtyLZdi?=
	=?us-ascii?Q?WpPnKBlju4NDh2Yhq+TsmVvgiBs94AwL0uo2dmTwGKyX8Ozz3bP9Nl++sjx1?=
	=?us-ascii?Q?VpqEIfUqbwfU37wsyVvllYa6zffLXC6Fx4YbAayIe03ZbHeIqv0/XHcXRqZK?=
	=?us-ascii?Q?2b0bfKEueysA3jUCJqduIg82Nf69KRzqxPnr4pywerqOSmQSKb5+ClJ45GiK?=
	=?us-ascii?Q?EH6vkux5xGfjUDbgUKugExCxboCLdrX0cZSKbcLojQNWuyWXZsVoYrFnCcj4?=
	=?us-ascii?Q?NB5Y63qnWs94eQM6DqId/EnZq81XqE1TX8Pi7RLDn7qt3iSrJQwzY688ApjL?=
	=?us-ascii?Q?9rw64yFRtTNMBs8yiUGdlmqXHkKBfFhJasf8KBSImpV0oRRGqiOwZ/Tf+0oI?=
	=?us-ascii?Q?MGXPVSF//uvkdMfbaOGjEOMjK7xgVk5aVUIKYrqpT/X1P5yWOOXu9HqVGw4P?=
	=?us-ascii?Q?Ijucer4m2W9VoL84RwGXwGSXeFx9LLgyptVthE9Ami1uxRAwhHeQVB/XYirB?=
	=?us-ascii?Q?3zo3ITNJa2y4wwLt+w0mBdVjGwX9In+TKFF5cv/M8qJRxZr6KAxljQ5MLRRa?=
	=?us-ascii?Q?xpU6bR6mOwHEtf55XxN00C5M5SqoViuQ7CLhht02snyVQqWQpNLDu6/u3dUp?=
	=?us-ascii?Q?YVXUmkpP91RPNBNyi8SJhXoxcpyiOO5TGSGVPZ9JBwKA5vAXBMs6vozJtUMk?=
	=?us-ascii?Q?gksweKmrcZkK1VhESfDHzUWt220eccXw5yh5qBSeA8tjATjIsRJv0C0lhug9?=
	=?us-ascii?Q?SQ01hjtYukxEgHSNNCOklLflhimJ6LxEo4jLfPNZmZnOgEhB/xRhwnxQ2gxj?=
	=?us-ascii?Q?kYIPcm6w63NevX/QM80xR5SEo+ZYl5/SOie2P2FmMqlWq3z+3veqPyTfw9uF?=
	=?us-ascii?Q?BiAEpZZ1kIukvJ7Moj8qQmTRjHUV+TOQIdDoQyJ+ZsFn8g77rHSAqbKLW5Q9?=
	=?us-ascii?Q?SBkR5oDt1WewjloMHRdbFBan+JbQ6gmQ5QU1zm6+lto+zhAzZuHvlM0G2pZP?=
	=?us-ascii?Q?TPfZX2zodpvqGhe5Gl2En9sIBsLwb+QdXSdm8Eqa5W9yvjW8834OG4Llpuqg?=
	=?us-ascii?Q?XLsZkX/nvSOYjNuszPmObzZMnel4mAA7BaQW79dR9M4aKDR2JAjhK87fYfCO?=
	=?us-ascii?Q?lwXCOLbyQ4nidTIIIBuzp0N3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef9d59e-9b05-4d36-da57-08d8f5fab6d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 17:14:03.2487 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idOSFe+OpNhut4poDXtxEW6X2Z/HhNdW//Hr/8764UkrfwsnZC4uV6tvi8yquGblIBghS8jTlmrwH7I7v5Ssp6OCKlngfNRji1oyKLFX9xc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
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
X-OrganizationHeadersPreserved: SA2PR10MB4779.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9942
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 bulkscore=0
	suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103310000 definitions=main-2104020120
Cc: GHe@suse.com
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix deadlock between setattr and
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9942 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020120
X-Proofpoint-GUID: ur5c03jp0fvIeMEjbXy7G8LYP5m6ijmX
X-Proofpoint-ORIG-GUID: ur5c03jp0fvIeMEjbXy7G8LYP5m6ijmX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9942 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020120

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
v1 -> v2: remove the "had_alloc_lock" as suggested.
---
 fs/ocfs2/aops.c | 11 +----------
 fs/ocfs2/file.c |  8 ++++++--
 2 files changed, 7 insertions(+), 12 deletions(-)

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
index 85979e2214b3..8880071ee4ee 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1244,22 +1244,24 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 				goto bail_unlock;
 			}
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 		status = __dquot_transfer(inode, transfer_to);
 		if (status < 0)
 			goto bail_commit;
 	} else {
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 	}
 
@@ -1272,6 +1274,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
+bail_unlock_alloc:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 bail_unlock:
 	if (status && inode_locked) {
 		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
-- 
2.21.0 (Apple Git-122.2)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
