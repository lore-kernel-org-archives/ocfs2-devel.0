Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66FF8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8DskZ94tkpGfObk0WfqCgnFOYvlaooPnZzWbQ5Wq9tA=;
 b=vPYXjY3nbGzpmcC8vGrOTvEBH1a80Amct9hCeD/lzPSf858Iyga8tGLUruebaBhdjqYYRg8hPPaX
   /DpdD9ZGAJ+knP6I06x1CuN65FbMuHZ/2NaYp2rdqxfmWBBfSYR19ipuJ/ARAvkwMO9eunKrvHzt
   oVeAjGimRnvN1TEjPd7xSV+zh9iKLtcmj15LtKbn7nEKvpbQzatFPieZhWuz3ypO7hj7+285R4Lt
   lWpzbmUSnXuEXF72873MqSGyhoCU8dTgsUG1N/dUpGeG7rIOdal+JQNtHZc5cP20o9SgbXALcTTf
   yW4I04WriiRGD+YNIWYTiP0QDjdZakqkdcRwUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8DskZ94tkpGfObk0WfqCgnFOYvlaooPnZzWbQ5Wq9tA=;
 b=OlZ0T239AT8bsQ07mjjYDUzOoILhCR1n3EyxeekPlGSOdt8urvboboXc8LIQdj7JJIHrk7wRStLI
   WQpLw+fSDPJeqGiVeYOujd4Um27Y3iCqo1vYTto1MrRqua08kPh+S6hMBAgnV65OzNv/ngSvHlIO
   8tV7pxYNiQUP78EvlaFMZEggEwY08NCldUlx2lXVrRrzJgR1RMA1ph7KIzTGGm67I4HrK38M62d8
   uMdNNa5rqZvmtfjbN/daxRZKFnIZaqQ8LUBJQ02Kv1K5vswfYy+bVvWUF1oLVUzj+4TjdJG95Vz5
   cDU809T5TyI239PAliFBysSl4M6vy2xqvqPaUg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000DFPNX2LRE0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:31:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413858;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vOe3mXre2DZ+43O+q48IuGIO2YJjgsg7ILUVYY8RKa8=;
 b=No3Yc153KGlAcvDXVsOxSECRx518ii/Kh++cQd7ZncsCYnn4KOHIM5aTInXkGyHL5ygdSa
 oVLl9XeLexVfPYludTD9g3cX0cj3qjCKV3K5ookFzYKSJfYVV2zc00LpbDXDJtK4RhQrVv
 duidSEXJicboZJpo5edw1udY4RzngF0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyvWr9PK7nd70V/n2837lAyRmhnHOBAPjIXdfu/yD03yCUh/Wmzg3t7gHrB4izht+RjY9Okkq3b8c86Q5K43xxin6SUp3D2zia1bLY8iUy0AOkulbiaD/dyCGHVIKSb0Ouen+hRiUlROY3/uP63o/UMnbWeL1lTPGYNRb2aKWqB+13/m8yfrIS9AqLeYVtSC0Ld2+7s2SJrMdKNS3wSt9eWG/G4JDtIKLiPuqTYuGjTzY+LJETQNOir8oIaeUyfc/JSwoevhRLVB/tWdRQKg26kS3jkkTy+DlJFG2WJVQF1Z0wObEp1AqCuMW0hdRDLRqLc5qCjv45J8RmP/tTboEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65iv4Rgmu8oP4DpoC8GKKRruOfUbb0DgANAJxSnQ/to=;
 b=OC3goFu+Pfz08jBJFtbukVqzpi0ob+vz7ydB1sDXMsp/bUTsFynSfWrcw4l3ysiWCQF87HU2B2ATYg5V/x13DCiYCR/Qao2mIC0xp07AfkawTpCGH+NufWZvfF0fHrfATwTtxx+rSk0iLTQ39jfbdzr6834LpdZVBOqEX4lDy/ashWneV+/iv6C7BSkEMVoqjwalVXB+gLkVqfdM6UA1REomicxdgJAz/CwjxUwmiw5gF43xqE5MWzTEF9g4rXVcAEyFgFtFqCJERRFGmsI0lybz3Av50q11Puuq6Z68HLNzhRljQ8pbe4JjZJKx/liLPDvNiElaz33+gvTAcnd3hw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:10 +0800
Message-id: <20220408103012.1419-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-reply-to: <20220408103012.1419-1-heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:30:55.8057 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=226 mlxscore=0
 clxscore=205 suspectscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080054
Subject: [Ocfs2-devel] [PATCH v1 3/5] ocfs2: ocfs2_initialize_super does
	cleanup job before return error
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 6HSCiTh3MnCmnID3ib3vvg-1
X-ClientProxiedBy: TYWPR01CA0034.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::21) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fca337e-67ed-4107-3ed6-08da194add48
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB78405DD248053B7613E140C697E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 m6ucaMIAL5xc2/hRtGdsNIcj38XH4TukUrY+IkqEnSMGa2IbRS8OVt+LDUsqizcB0g2qkq2rwmBxUwgE4Oe7VnVqHspW8hPyZiH3WpQx3ubTYWuBGIUWVrqoXP5BV5sjJ1KnpaIQEf8S0SmCEfe1ZAI/Qo+F7CrPNavfasrOzwqBBQU7lz+7Qg4CC0U0EzwJl/VLejFEvXulqUD37OyEGPCANLQ1xJIWzCskIUGzrpIBM+SU33xV7ne6MGaxrnZyA8LW2YJe03r2kY6yHrqnDzaUbLTJ93NsXJoi6HcbT/wKb2IKHnpzIAAS402kJxe3Mk9drhcx765gjjacTyB14A8u+/oNUpGtQDRC5qHjMATrbeAD7/KCG2pP9hlMa1uchJ/AwF45lNBP5ih69XFdqDyG5t8R2bHSjvHf8D8aPGs8bkr16rWU69FTvEqMmkWQw7M2IrrQp2QqBgq8FAbbSELN2I121VEuNZ0hltOwp3IbT8BzJLx2PwsE/uvVX3KTAJ5SdrBfobPw32IY2/DQnwO+3Q3CRrCPZ19L9g27uKVMEQnK+eZq1m7uw6bNXYHRHRGgMydZK1oUlvVpwc+QQlezrRrVdnpNJ4zUUAzbTCRvDJiq6akq5+00q5QGj+VkM0JMyJX4jgg0s1EW+6fiQA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?TKP7CDnTAHSkI8394OKaFKxGV1nCd8eGgC/EHRweB4bMsmfnMe/GLb+HpRjh?=
 =?us-ascii?Q?E2nRNTJqRghexIozN/Jrk+hNMHIOs69+KNJRlyxr7IiRRGycTCJoEZCHOpxn?=
 =?us-ascii?Q?WdPsJbzIvDIgGZn9TDNEPMJRzKbP4PZYzvwjP52GsHC69dkDU+WyUFW/CEv8?=
 =?us-ascii?Q?b9ca6QimM2SvW4jjgfNnBtwp2ZvmX+T0pSLqYaYl+q4k1UFpzMlAzNrciOQZ?=
 =?us-ascii?Q?l7Tp2vT01xz3wbXe7N0BdOiQZbyQgXYTv2mlJupdJBExH5ayu3chiU4Yv5C/?=
 =?us-ascii?Q?ax2BWbtH9VvK5S0fN3gzIE4UEHOb1vhA9TLLfsi5HsFsVkYEXbMcOEhGEJXQ?=
 =?us-ascii?Q?41JMU014cENqMM36AHKjrbrNJFFX2kzLBk/fGpv7QHnzwyllSWINghP3ep6U?=
 =?us-ascii?Q?mBVS9anblVX2Y+o/WkzbJSD0FdPQEumbEJxqcWQSf8bjTD8hZe5+trB4RTiX?=
 =?us-ascii?Q?PqO0oJjUaaXro6BcFreHjVJKJbomalRqk+z8HSdAfAi/7z9lX18rkVLlwSj9?=
 =?us-ascii?Q?cCD715Uzj7wqTrZ1ek1vygAtAMeDANyaCEMmddmkH0s/dz+NWL9DAEDbgXYv?=
 =?us-ascii?Q?gcfiWno0OZME7d2K7nycSNuU/saJm9WUTUZ+r2/p4lwWdA2WQ3pnQzT/izvQ?=
 =?us-ascii?Q?RbMEeNHp5QmyH1JPz3wLkCS23AkNw13yFTcUdcuqV6pZLdsZtBcFC6OJHIum?=
 =?us-ascii?Q?mIivopCTvaaqwzuYBozAS/vEmF3IMQG84BYbF8a0eNHupsMhnRJqwwuunJ7U?=
 =?us-ascii?Q?o6rHKhUImb4DeUrVplJQPcuNGhYAcu8w1v+U3VCd27Ru8lWH6Pgd+k0nnzaW?=
 =?us-ascii?Q?EOueCh7M3g0O1wQ0NDZUVqwUTb8kEHRfy8MlgCBC2CFMU8qeK/r/5LwHxzIr?=
 =?us-ascii?Q?iZWLlD5MGyEfIqLW4LJL5/nxoGzk1xwjCbXK1oHvg4252RxKqLoFdWj6C0Uq?=
 =?us-ascii?Q?DmFLRByLEWo+avMf5lQshZFx4uehp63gYG4g0F3X+l0jFjtOPIBqjznKOnfQ?=
 =?us-ascii?Q?E+eZRYHI3GQ271cEMJPRaJA2GYZA6sp4pcgZS6L8LHMrn7M7K3yVrnKQuGrx?=
 =?us-ascii?Q?jA7uNJbO+/Mlwvz/Yws7GvhC/twvIGmaXout0+jx6Uset4/zGGroIwJkLP/Q?=
 =?us-ascii?Q?+o6ONDcwwD8JMjqUP+Mmfnm9odKg5vkjk800iFGxz//9LYxX1IiicRmccW/e?=
 =?us-ascii?Q?Bd33D1Ai1lYl5l+PYOWKER2ESQOGawv8ibqB3FxgaBPxg3Y4bjqTsQPxmGzB?=
 =?us-ascii?Q?rfoYr8FDuuygiCqI3WMGTRTCMpMg/UqK5fChXjqLH7A2MfxQGjF/EZ8JGVuL?=
 =?us-ascii?Q?FZHzNr4wOsOs8+hVuYq0QSBlSSahtKjMZIFcI1DpCLHAJl6x3c0up922k5eU?=
 =?us-ascii?Q?HMi5vOkSwyPt+SPQn3Gdg/r3gfODhw37MEUKmoPUCubXfYx2TP043Irhn/pq?=
 =?us-ascii?Q?9+La7L2alowMzk9gjHcsF2aOc8yd4DbjOe8A1ilOTMvBdj/ofX32ctB6EVw2?=
 =?us-ascii?Q?kpcT50Ck8ycByHCsrKtDcwGrwtWz7hRmuMhhycGKqKQjyVsQlCIBSOqHn07Z?=
 =?us-ascii?Q?5RqxQ03VfqqxN1ukV5Dr25lJPjyK1jfPpQdu77Hl5wzUy4poxNvmD+GEfNSQ?=
 =?us-ascii?Q?PC3HZO/YJ0iRj/CuGsJd3errt0C3M7hA4CGLsT8XRlY1oED5qI1QeJpw/xWN?=
 =?us-ascii?Q?sI26poFboMOKqH5L3vpEeut918RfXoFIcgf13oktnLYn3aFkBbCFyBpkiPhY?=
 =?us-ascii?Q?bOTdtdRjvQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9fca337e-67ed-4107-3ed6-08da194add48
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Wb1TYaASqgds9m4QOMqTXOQ24egSDrLFCTtAfm8pTq3UZpyuV9Wc73zMs3WtYMw57zBEewxJIR9WnE9Yo4c8mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: wpwrzLjrkgdYyO5ptV9XrhHI7TEyALag
X-Proofpoint-GUID: wpwrzLjrkgdYyO5ptV9XrhHI7TEyALag
Reporting-Meta:
 AAH2jUUd8w6e0ZVanTJzLPd5T4Vt2UZaoIQDb0O8vyQHJBnJbVBYzStVh3qZWDTR
 NKMAs2jUpf27Lb2l4xXG2dfzBfDQm7JYhSJUCO6zNbfeWXFqg+w77i5L2Jc33PVX
 LWVTzORSkqfazi01TwHWYL0JXoODkXEVuA7MnwpzK6RH8Q8zrTX/BUA06F9W0A+d
 DVFf1Ih3ReUFIgECrFjA/z/AuPrj3O07eD0J5pk8IK9c345KFnAquW1673+3xkla
 xSkb1VCHjTowiF8rSHADq2BESQxG/zPYeS8HnU3cIDD5FOGK1Jb0nnU94PyFhZVj
 ioaJ7LN7PbA8ThfpqYvHZZuy0evbX5nBeagjSuHsWDCnlvlMkYphdSQhvFlQ8jXR
 2HK93mnzY21wZzip0IRavML2D91wwgbZJx+N1UrFO4WdHhbJD02UumVUhAjgwjpg
 q2DQy6C/yM8A/iiBRpV+PROB8HfrI5QFHEL+YHLN/4ahWb6wRB0gclilyK2vK89l
 qEKD4EDc0d/dPcxFcK1rschq8fzhGXbOFAtQ5uuQ2ZZe

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_initialize_super.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 58 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f91c5510bc7e..8443ba031dec 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2023,7 +2023,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	sb->s_fs_info = osb;
@@ -2084,7 +2084,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
-		goto bail;
+		goto out;
 	}
 
 	ocfs2_orphan_scan_init(osb);
@@ -2093,7 +2093,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (status) {
 		mlog(ML_ERROR, "Unable to initialize recovery state\n");
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
@@ -2117,7 +2117,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2126,7 +2126,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2136,7 +2136,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2152,13 +2152,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "couldn't mount because of unsupported "
 		     "optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
 		mlog(ML_ERROR, "couldn't mount RDWR because of "
 		     "unsupported optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
@@ -2179,7 +2179,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto out_orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2204,7 +2204,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!journal) {
 		mlog(ML_ERROR, "unable to alloc journal\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 	osb->journal = journal;
 	journal->j_osb = osb;
@@ -2231,7 +2231,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto out_journal;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2243,14 +2243,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume too large "
 		     "to mount safely on this system");
 		status = -EFBIG;
-		goto bail;
+		goto out_journal;
 	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_journal;
 	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
@@ -2270,7 +2270,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2279,7 +2279,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_dlm_out;
 	}
 
 	/*
@@ -2290,7 +2290,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2303,16 +2303,38 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
+		goto out_slot_info;
 	}
 
-bail:
+	return status;
+
+out_slot_info:
+	ocfs2_free_slot_info(osb);
+out_system_inodes:
+	ocfs2_release_system_inodes(osb);
+out_dlm_out:
+	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
+out_uuid_str:
+	kfree(osb->uuid_str);
+out_journal:
+	kfree(osb->journal);
+out_orphan_wipes:
+	kfree(osb->osb_orphan_wipes);
+out_slot_recovery_gen:
+	kfree(osb->slot_recovery_generations);
+out_vol_label:
+	kfree(osb->vol_label);
+out_recovery_map:
+	kfree(osb->recovery_map);
+out:
+	kfree(osb);
 	return status;
 }
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
