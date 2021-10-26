Return-Path: <SRS0=myWd=PO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8202C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 03:57:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 365D961029
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 03:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 365D961029
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q3tItx001150;
	Tue, 26 Oct 2021 03:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=TQVFJhcK2ZK+P0uJbSHffyiwKyYNUVyCkfsa7quX7T0=;
 b=KKX3KpNB4sAX1dUVIgQoi1DXVNuJh3noyOg61QyI/oV1qwocnnMfPPC3fp/VzoEcL/F7
 zLTgxGYYA6ggJnzYAe+6TdvY84CKki2+GSR4J442ZAjaQUcghD6UI6iLAHel4xgOUzsx
 tXTyJbXV7KrIcVg6Cjie0hqu4sUEBmY+yYggjbAM0mBgA/R2JD7rWpDgTt23eOj8da5L
 w2W/SrfQDenrKeXmWOIWlvBOKTU/fDq9ywApqeY9kLKVPAt4du9sgEm1IalrvN7r+x99
 V9G3hoCMVE5tXm7fnDCGInZVZTIQROa2puLl5je0VydVvdkHsLVVncfSI9yKCMLCvfzc gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4ffry75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Oct 2021 03:57:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q3tvbZ030850;
	Tue, 26 Oct 2021 03:57:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4gyv7j8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 26 Oct 2021 03:57:32 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfDXa-0008PG-6v; Mon, 25 Oct 2021 20:54:22 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1mfDX9-0008OM-Cm
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 20:53:55 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q3ps7W022466
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 03:53:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
	by userp3030.oracle.com with ESMTP id 3bx4gyv5ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 03:53:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=ZxIl/U0GUuU2twDEMa9C+0mFrfRjkuAHK4AfRFyRGdexJTOKpm774dr+mS/IhJT5jYNSOOSFk48kKbJ11/k2lg/NvSNkeeGq3TBa/aQ4FLEDujA28aRf4XxtbMbnBZViowL/2RX+B4rPrPcZ9a3lA4vhQTiKlepRlwwAsopC9hZgbj6V9PezOtWU839jnXt8LAKzKGkb1crk4a7eBoi5JwwHaty6w7BI34g/Gfxadd02WIWKsGy3zx2LeRrTFdWEbdZ06VkK/ldS3F2qEmkhYSAcGB0LJysOVoS66bj65QPf/4jzcfyQzRgF/51P5Le4hKA/Qdauic5e96Rn/sQrAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=ca91lT3dTgdmjx7uvq9W9urXUOUU1hIZyoqqsqiHi3M=;
	b=ksp2iS7BMSbA47C74et1J3mYrJBRWQ8w2EiU3xpkqOVgfUT37vZVYUvaE2zqWLbqlQxPlwCP/RqZrBMv3mVh/SMNIVE/xwzmX7CCmn/jni50KhkzC5Txmxc6M26FMrlszQp4IbgGHmLZg0L4cjtnih/pb/pT9UEzaJWz6iqkDuimUcHOkJZubCbcZ6nMBr+lue6JPagIbtNiNtOpdXDsg4jR6UEDuzvEwu4frPrwLvFBk+mYXS3L6zdq4SLv7YDeMp6KRaQFzUquZIwj1TgW8cA9Z4Aqi2KVAgEGBIYJkAoeilwB4bulRbKcl+dw4c/wphiL6PnraBFFOe2y5bTS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
	dkim=pass header.d=oracle.com; arc=none
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
	DM6PR10MB2906.namprd10.prod.outlook.com (2603:10b6:5:6f::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4628.18; Tue, 26 Oct 2021 03:53:52 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2]) by
	DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2%5]) with mapi id 15.20.4628.020;
	Tue, 26 Oct 2021 03:53:52 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Thread-Topic: [PATCH UEK6-U3 1/1] ocfs2: fix race between searching chunks and
	release journal_head from buffer_head
Thread-Index: AQHXybjEi9HRrDBeNEWalxYlB8zn/qvkpm3w
Date: Tue, 26 Oct 2021 03:53:52 +0000
Message-ID: <DS7PR10MB48786D92455E1D256E6ED780F7849@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <1635177335-23973-1-git-send-email-gautham.ananthakrishna@oracle.com>
In-Reply-To: <1635177335-23973-1-git-send-email-gautham.ananthakrishna@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
	header.d=none; oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 038e310f-6099-43f2-61e3-08d9983439ef
x-ms-traffictypediagnostic: DM6PR10MB2906:
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D/Lt8eRoAURrRqbeK4VqTUhN2zeJVe1YUUNuV5jkoOP+5cYNophnILaVO1I2eywj+zKG62yonmWb+lNh8MpaMwYtTQZJQu5jwJakvD9G7yxw16mfpvIum1X7y4Kvi0uQzXlX/AmIBoFLzNZHTiAZFDOv4pG4SWIVawDpQuWOXL98GWpJA6OAQF0QJbnqKVIV3LZzkOtIu9RNub9yblfK5IMB39Z6Odn8FXSbxnn1kX62uTpaz0EitEf9A067E7RhHWGu0zxidfJNwYTqU1AShgJ9S5TTdBhaAdv2Hv5CF6CWcEK1k3lI2+YOKY08afABuWxD5WGjt4vcZDD7IOidmM632vaYAQQxMAEd6Nn/mAR/rbEkRMAC+jdeXl2WNF8/Ofak1AViOyIB60VyARqSoXA78IUAufJL7mLBflVPnctYkzrNQ2c6dVWaUg79enEUZ1i6LHmdebyl4/xSskT5ZaMef+STnmW6wfwyomK33RLaRnZPd82AtgsvR2osIV9FgTjldQvDwYAPHiiTP9uiaBSeAW383ZyeoDHk7TNuIa4eiUmoXFRPlDznBK7Uf5PL8ik9aRY3xGIFYaC0jlM1JWsh5IJTw3g8g9fczlcHHHM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038e310f-6099-43f2-61e3-08d9983439ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 03:53:52.6171 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sQDE+bapbnU0rmOM1wMu/OaKZBLPRZWAOtmauOeR3XmVO0bomjXLiDXS/kLvGEPL/fmNtxaiXbkV7cPZOi6OJOA1lKww5B1fL7y/dYjyP3NWG9HV29nyxIgAPIn0SI1K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2906
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 157.50.3.77
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM6PR10MB2906.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	bulkscore=0 suspectscore=0
	mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2110260018
Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH UEK6-U3 1/1] ocfs2: fix race between
 searching chunks and release journal_head from buffer_head
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260019
X-Proofpoint-ORIG-GUID: Hp7GfQx5pASz2RrpomgqMy0z2Qabx0OE
X-Proofpoint-GUID: Hp7GfQx5pASz2RrpomgqMy0z2Qabx0OE

Please ignore this patch I will resend it. Sorry for the inconvenience.

Thanks,
Gautham.

-----Original Message-----
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com> 
Sent: Monday, October 25, 2021 9:26 PM
To: ocfs2-devel@oss.oracle.com
Cc: joseph.qi@linux.alibaba.com; Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: [PATCH UEK6-U3 1/1] ocfs2: fix race between searching chunks and release journal_head from buffer_head

Encountered a race between ocfs2_test_bg_bit_allocatable() and
jbd2_journal_put_journal_head() resulting in the below vmcore.

PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
 0 [ffff8802435ff1c0] panic at ffffffff816ed175
 1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
 2 [ffff8802435ff270] no_context at ffffffff8106eccf
 3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
 4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
 5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
 6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
 7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
    [exception RIP: ocfs2_block_group_find_clear_bits+316]
    RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
    RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
    RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
    RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
    R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
    R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
    ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
 8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at ffffffffc11ef680 [ocfs2]
 9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 [ocfs2]
10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b [ocfs2]
12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb [ocfs2]
13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf [ocfs2]
14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at ffffffffc11cc0db [ocfs2]
15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at ffffffffc11ce53f [ocfs2]
16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at ffffffffc11f59b5 [ocfs2]
17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 [ocfs2]
18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at ffffffffc11dc169 [ocfs2]
19 [ffff8802435ff960] ocfs2_make_clusters_writable at ffffffffc11e4274 [ocfs2]
20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 [ocfs2]
23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
26 [ffff8802435ffec0] kthread at ffffffff810a7afb
27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1

When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the bg_bh->b_private NULL as jbd2_journal_put_journal_head() raced and released the jounal head from the buffer head. Needed to take bit lock for the bit 'BH_JournalHead'
to fix this race.

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/suballoc.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 8521942..481017e 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1251,7 +1251,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,  {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret;
+	int ret = 1;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
@@ -1259,14 +1259,18 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	if (!buffer_jbd(bg_bh))
 		return 1;
 
-	jh = bh2jh(bg_bh);
-	spin_lock(&jh->b_state_lock);
-	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-	if (bg)
-		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-	else
-		ret = 1;
-	spin_unlock(&jh->b_state_lock);
+	jbd_lock_bh_journal_head(bg_bh);
+	if (buffer_jbd(bg_bh)) {
+		jh = bh2jh(bg_bh);
+		spin_lock(&jh->b_state_lock);
+		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+		if (bg)
+			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+		else
+			ret = 1;
+		spin_unlock(&jh->b_state_lock);
+	}
+	jbd_unlock_bh_journal_head(bg_bh);
 
 	return ret;
 }
--
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
