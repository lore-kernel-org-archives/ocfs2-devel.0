Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91B0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Lcd/GYdjwYJ5hXuX3jUxYXdC1Vzy3t2je8w46lphvao=;
 b=NNmABoHZpEm6+xlvmbTdyFfVrbfPzduwj+oJkwIZCy+49yPEVqVy6VpU2MFqO79UnBG2tXKsKF4Q
   kZZhK+g2rG6B68U9nc41Nwc/l1Bua56fB/qnqW77uhqcmmZjZRM2e68++eOShOUIBKyx8cEf4K2A
   804O9d++5EjzDaG3H6OInGeNSWCsGv7eJJibp79+d3M/Lzu6vD46NDbrTYTU3NO14LcNBbd50Uau
   U4N+yKFDU/orz5FlkZfjN1KIfF8VI6dU70UYjds/XUsuWBhLUhb5vciQa2c/PwgePgVG4go48mnU
   VuJ6Phpi6k8q7EzdxuRcPOPHheh5crqBB8Laeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Lcd/GYdjwYJ5hXuX3jUxYXdC1Vzy3t2je8w46lphvao=;
 b=Uu6Ndwgb/d+QE5YxoT7RKgGiTxE0VqFCrKS0z97PUEqW1/27XekUpH+oJWFwQRJ1WOs5r7gnuuwV
   ZVbflVCoHHWfgaIGQ9uVcsDRshGzbbTDH5EVf5ewTvYynANtfCRpKBnizdryXch6AwqANwoZpMQt
   +cWhQam9J89yQkbXoF/8K7wwlGrqETwHdXiTUZ3CBuPoLESM3YBczwqiY/Eje084JNHB9pp8tpZV
   tc5kJsBj7KSjR8QOa1j89XIPNofOliAkQl6fDX/r9PSserOczabPe82RI3BVaNn5bO9cmgrNR4Ax
   mo9aN1xRIwquRl4Rknqdnz/eTQSPxZx2kY+lvQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU0081UHXWQ680@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805827;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Wk2GElS4RwxPOb2QMUI/sgOPf9q1JdPWKmxAr1flQ1E=;
 b=Qk6rIFem5t7dMO98llrKalw7uJZnyQZXNlpg+IW8+j/IgLszA4m3noKVk7Y1GwwR0WvWUc
 ivphTvUTyDtFDpVsXVVmbEeXDc0Jwsvre5zB1ieK7nef3Ej35IBLz9AbKciMvKutsjFku7
 UAsPAHilQGGbYFmld2fZmdSil+m3AZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aE+KihINiuOloU9tJvQe0eA6NR5XtWzXl3jmfkgAN8Oicm9I5PA5xmZkLvoX1nZksH7EESWETb9/RhFtq/YtZqAVwTRDFRjwfZimCYPmD6AwN2rjO1GHmyW3sCEE46WFHXvgdWMBdamXK2sJ4mnLsVlzs914/IOmL4WBq+9dxC7gcntEX8a7j5kJJWVNKfiTGVbnfQMvl9FXE19iohuXUjYdkuYBxq6ZMlx9LlhNNmumJisz4/6xgKsTFPBF2CVmPs7TtWityanUPYcH73tzSJxBP/6Z2tctj3xRAH7Yxa8ij5ANxWmAPYFCfvuWXMeMWxFTNvwC3A5upbHSFScTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brNyngq5odmPMrhy9v+U8PzHzHIyLIPjdhP58UWFSXM=;
 b=e0H842/5nckR9c28zzGcZDV+t3ZoCZWphVC6D3FcNy34xLJCdsJsJlm9ro/t8Vm1AiDXs2BoyKbuwZ3jDCM8oB0mqPsHWmZAN2v/BNZEIBpcJ7kXqKInbLUDJ7rkopS9xsuXb8iIoM1yrWe4QhjrMhXxZ/DQaRiSsfXR7GKs9X+NU40rbSmTRWlb3P1linzZkECeGsq1J3/Le5ZlDpdO5JI/IOr1gUP+R9vy9MiS6I2ucnNGT2jvxH0d1CvyOlj2jIzHC1mWCaQQGPamfAQeLVfeWv9zlA99aRQbdUuxNR6wj6C3EC7K7QZ4+sGwCWRCy8tscRjSW1LSGhK1Os/hBg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:50 +0800
Message-id: <20220424130952.2436-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220424130952.2436-1-heming.zhao@suse.com>
References: <20220424130952.2436-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:23.6189 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 clxscore=191 phishscore=0
 suspectscore=0 priorityscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 3/5] ocfs2: ocfs2_initialize_super does
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
X-MC-Unique: tktrgFSUPc6q2YOGLYii0g-1
X-ClientProxiedBy: HK2PR04CA0073.apcprd04.prod.outlook.com
 (2603:1096:202:15::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6c70159-2cff-4d9e-850c-08da25f3cab9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB3344FCCEBAC76F828056DEDC97F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 6SRuOpJx4jwdYKwxAjPrJSE67apAsPuXkqFVEnPmprxBBtTJRidDzpc02bN3cEwnslnDczt3qA0kW4tachby67PLdFfSIBQPEVU3L4rDVv5Z1VGmr1fMK+c4Y/IJUBigNqzOf78Zq0ZfWIphwH1+z3Zt5pqXUf3vwJoPKqFbn9xolFmjRUOODv68pQcqUID+GCjRzURWouexS27kujFPhynEBMrZoNDMQEqdBj+d0mZNwrJ1Ldcge7sW02GDPbgbxYIpzhuXolyn08O58zyAgZUgR8EMwAjD8IIPpHZp0k81jsoazIY4NwdO7Wss9JyrH0QcCR582sCmkHG/lR1/BdrGELKy6UnRXmcpQmvdd4t+9g2KAE5XzVl81WM9AAro+vY3wlC4KAwQ/LVesqD0mdzhxXWMNzuoRE1z8n287KPbLB+0h7c9OLK/4eLIz9rhgQcngpNIILgp+YYqkuOnSM7NnEaYnTfrtTK9+7aIhuHPIy3rq2ZaN5nY/jUOSj4WgtufY5M1GnIsUKhKZlAV15JvDIPQdUSPwbM0PsIKPqSDtSvy771MtNGeaITBqqt1lhW3eBhTBAZwDP7bZk6q45Ja5BlEhpFFn2asKjF/Of5fjC9cOoYOOEa+IESfSyLgUk3lCntGu/KYlFk3tyYBiA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?lLJm3EqxFK6VHhLxINzHfPDcItZ1Ccgl8w2KNILJOx5fHmMG7PomF3xqQQWf?=
 =?us-ascii?Q?eITvSENHJ5kyryYepcMl9bbvhPJiINdyRBii4LL2uvu0C6oJ5Duu410enIqJ?=
 =?us-ascii?Q?lRZLRD+vhW7YqqU5ke0qlgn4thIKEbmXzR3HZY6DK5N71cWZebPjPtUPJBNy?=
 =?us-ascii?Q?y6TCRw0q5OdOnO/0myLXAjnmSEWXeLmx1JW8lemJnH0WL7Zkz49kIaIA2Yh4?=
 =?us-ascii?Q?GLg//4YpBFvYtGZggq+OfqM0LEcdRZ4ymEwbBr0WZOqR6rCo3mMULAqCYCVh?=
 =?us-ascii?Q?h8lpVxeLsHZihEHYR/M1ExWXbl2xV7wfE6Jwarccdn+5jPTM9JkhbIMKM21S?=
 =?us-ascii?Q?pIu9koqJTpDPTudveS/0RAZlbOtLRpNp0niUisdekbIOfHhhqL0Q40DknWXZ?=
 =?us-ascii?Q?A+2Id6ofQPIZiLxs4w8R6moVpS4HCN1j3fNP7HtIp2ZbXO6K3CSwV1OTFdlW?=
 =?us-ascii?Q?h3ROcJ9Pq0f4FpjLww4KJO3EFjsY1POp35NZVMkkyjv6zGDxvqP18xDo3+vT?=
 =?us-ascii?Q?QZMtfJEYZ+K2c7L+sNDuEGm71bKa+uxyZFQ4MGmlfRl2pkRBesISv7f9b1/6?=
 =?us-ascii?Q?MPGVa24p+cX+etdpuR9UbmLM+jimsxEl/ILSE0fXkq5Rz0Bz1udiuuByfCeq?=
 =?us-ascii?Q?Lo2SNPdRBuyInX8MxF8d0jwt1geL42Dff6HBI6IRhmzmXg8KBRBr99ZS1ndM?=
 =?us-ascii?Q?VgdGUjF1YQYXQHg2nQ3iNmDXOeUGSfto05egy9+hHd7lLEkYcwLYEtgeUnKU?=
 =?us-ascii?Q?UOrirhwOOKaHvwpYEUYzXs34RG0DrMACxyWKqSUBIX6fDU5FXsUL9CBM2l0q?=
 =?us-ascii?Q?VpBvY5NrNuUBq6a3d2VoioUswFLA6Jz+Szn7ZqGtC2Bohh3wxHcC9W2bdstA?=
 =?us-ascii?Q?jyTkapVihIXUcPOZgTeoCY/2Ix0KjlII1zz4dMo6NXRvoFDetLyhLyTB5/tL?=
 =?us-ascii?Q?E2j/e/GaBKB5G8q/ymfctbFdbr5D3hF4v0wLhjKJiIOsXQyBjeCoqj5dbdPn?=
 =?us-ascii?Q?EXzWdd8PJLJOp7xM5TzhkvL0VsGzFTsbeJhxvzwlLYLid5EhKE4vgQYCJamn?=
 =?us-ascii?Q?NxjDFWanQfjcFRsMvxs43k0/XWtiUxq+owidA/CDv8SiQ2bXPBBryc87aFkR?=
 =?us-ascii?Q?NhfTV7p9S7TpsM/BR5ajbiTks3Su9UP/EYXUjIf7fczLtsPSHJBE84jsFnyj?=
 =?us-ascii?Q?0zRG9fpbNsmpSbzruxhQBL6J+CxU6usl9JxMuCho8tOx3NyCyQsQ3XbzH+40?=
 =?us-ascii?Q?L+MuwFhGyBa+B6seuQFd3P+M+dKrtdNHjr0lBEB7eCsSP2jo/oDepnPt3nNA?=
 =?us-ascii?Q?zUmG59L5NTV6u/i4gcRNqZdqevqoQr5uuK9XqpaqDuJFxMiKrJFho5nlQUY8?=
 =?us-ascii?Q?rSZsT86L5P9fvwE87P5T9oTG8h0UGHlxtzA2YLACwA413cgzbFNKPc9twY17?=
 =?us-ascii?Q?/pEhHcNMDfIZ+1zHT5YNEYCq4twN/b4ZZfhhgew9nOpaeivNSgH0cvkixhdn?=
 =?us-ascii?Q?NW5RRMrr9PONMNmwvltLx5Xevs3drWBJgZv53favbeOhzpor8zCCOe0suPYi?=
 =?us-ascii?Q?hiZRJ/OngUxpgdmQYdmkcjRTlJspWzQjAdWNmuK61lrruYA6m1HbaRJNIIbm?=
 =?us-ascii?Q?Ntzqx+jymxQIuZUU8xDwRiebvxc7sA2GJoqyPn4Vt39nu5vsKqnHLnmp2pAH?=
 =?us-ascii?Q?l1YBYwAZ2NEMzTiz8khVdK/o2b8b6N6aw4eMlBTIhNUMucmkQiHpMEks4CmB?=
 =?us-ascii?Q?sv27UTczKQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a6c70159-2cff-4d9e-850c-08da25f3cab9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 OqNC3EtSnUrJp9s5nGrj8rI7VDE2YYYAL8xVrHUfglux8fF/Zb8w0A7HH9UNMBJ7onDqrA3CJPDxGxjWb0P4ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ROSwoy2H99k39twUin4JvnnZhsZgG0Vz
X-Proofpoint-GUID: ROSwoy2H99k39twUin4JvnnZhsZgG0Vz
Reporting-Meta:
 AAHmMxb4dD9l5ZGTg7wErkO8P6ocihd8jEdEkBZefDlKcg+2AR/F6pvatdtj5MvK
 GGJ9eZ+6Eshl9ZSEioNQ8gDMiyGtXeCnEX97ewaKUWmGkM3AmkOPNeXK+U1qRmKB
 ocCd3WiyocVNuF1kn074pIvDKR3Dh0gSpgKug7XjAbEZEIA4PveQYkMT3eAXFkpz
 GPXD9h+T8QlA6PEkHVO/FVF01s/Sy6d8zZVST8TVQ/Z72lN2uHubTSJ8ITIGzgtL
 g5TL/OQ3RYRGi31uKQ+Uq4XMhgxvh+aTXrUcaHCrn5I3sD3DcPUpP4JXFbcz0Kzg
 EnS3QS7fbmPypKlpM5mznI5lt4V0UdrTIvBJp+1fqgQW8ufpvIEuLqwyrV16XpAo
 iBde6fn4l4p4DW8upWvc8eflFW6CdD9Bbi7fuqKWo6rlAZG/d4dUgfMDBUchQGaP
 x5ssSkEQ8LvW4vHadKjekVTNBUCteCnCqwpCzRmmpPkiAylk9Mul6C0gKLOY7Lor
 ugxu2hSjjjjxxUeRnhjjqPL9ZcGCGVh2MGDmGaH5cNdj+w==

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_initialize_super.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 59 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8014c690ef72..758ea3313f88 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2022,7 +2022,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	sb->s_fs_info = osb;
@@ -2083,7 +2083,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
-		goto bail;
+		goto out;
 	}
 
 	ocfs2_orphan_scan_init(osb);
@@ -2092,7 +2092,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (status) {
 		mlog(ML_ERROR, "Unable to initialize recovery state\n");
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
@@ -2116,7 +2116,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2125,7 +2125,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2135,7 +2135,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2151,13 +2151,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
@@ -2178,7 +2178,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto out_orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2198,7 +2198,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	 */
 	status = ocfs2_journal_alloc(osb);
 	if (status < 0)
-		goto bail;
+		goto out_orphan_wipes;
 
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
@@ -2213,7 +2213,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto out_journal;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2225,14 +2225,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
@@ -2252,7 +2252,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2261,7 +2261,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_dlm_out;
 	}
 
 	/*
@@ -2272,7 +2272,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2285,16 +2285,39 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
+	sb->s_fs_info = NULL;
 	return status;
 }
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
