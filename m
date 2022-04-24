Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EEBC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gVvYlcyrAPSw0wcdB/cZn4QNaGHSGuw7Jk+oRPBcGvQ=;
 b=01moun4OQIm2md27QBw8ptkvfogLiMP5dIK5PpNvpHJVAVAd73O/k90lpcB+3yCIW+rMnjMCpnFb
   cQ0jLo0p13GymfTn8K/Q89iKN0jOAOLtoZZBZ3r1+NILxmqlDeXeYCuodCNc5RB21WAA191qC+4N
   +hA4Vqw1lIRtvSI8rsnrDifAYDen32/+Kqxf0guuSosz9i91kkXVKB8QxSPn261fUxOBCzEeOeE+
   L6PK2FDmoAO3V3YgKaNZrBwhKRjS9XzF+9yMYYZ1bXX4Kw18vMdoG4DvZ/7LXt5CG/j7iVW8DsZt
   EtLdv5IAixnMO43pBTqSrY5UjKjLZGM5BjJBjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gVvYlcyrAPSw0wcdB/cZn4QNaGHSGuw7Jk+oRPBcGvQ=;
 b=eTKgmyMXM0vvE6trBt4BEJ7LDJAYN3llXBYgW7ZauqIMZef6lWyVQhn52lhH+IRsz1PxrXP5+kLS
   6DnEZ4NZzS77NXPop66mbltN99wiB4Mz/gYIkWJh8OOOL4IRTFjcIpcDMlEaU++jdlY57PFhHbz7
   oMysQtyNKXoKNwLUrAaYQAlnLTfefd2D+IDZ9sTMMx+zkvST/qV5fYx0Tn64RCWq9u2hpbjT6Kf0
   d82L5+kXty6Ts7NocmcN+JCP8x7B4btiIfLBo0gVR8Z9c+OqwEQwai2Ccg0/UTEXniO5uZR1ZuEd
   XUBGhtFFtCM8bclN7MSyAUpyruRY+IVYT1iZIw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU00MFRHXDAS60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805806;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=vTr9tywUBhWxBFNBTNx5I+4N4wCTjjrCMX2/mmEQEX8=;
 b=R+vsfo+nn9l9GRNqk+Rqas/ci9HT6oVirdh65on+fKOWqHTv7uZO0Ci7woZuluZ4Ukxc1B
 nQOpICiBjQh26G8TzLjVcCZw8iY+MCvWNhqnvLvgS8jzG8qTnxfStk9/vIc/DKWYD8CTZS
 GXte8khP7u9U1gscf7RRdWT4udy+oEI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0le8UvQZMulza/MTSI7gJ4/CFhk2nDX8uF6LxxUJ3LNgqLsinPo0JgDeNIGEj6+VHcgcsulQvu8B9GyACXeWRZzx53SP/8lHPgjBB3LnCfFZ2wx7/OW7cM8UVXLin5ebyzMvoNjY2ocsA6+RXf7TCS5LDhVlyyxwVsUkI91LxqyfZMiMBqbsK0QuuIZj1rVrbZO0s3LsV5x2kftuF+AZC72poAx96Yw+zGTPMorwPmjKk7Ur4rh01azcQgzwk66kzsUYVYg6TWw0coI4jAV2D9rbk/niEYOLhm3joHgoyxQ157vccJtwbSNW93HC87Fs1ntingJi5LPBSsf0vC5/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJRfZfr0n0PaqoOQ5F42WJmH0HU87VzXwbftd3QRy/w=;
 b=Vheu8vHDwaD5sTH52Lb/lOxRalKK4CfB0Vf8VDZIEkWNiaf2H/pvANcHi4LsIru3hnTx0UMrv2f4MaU5jzIyjBjujAM2+R/3AfuQDLwZUTuT8ojC6ZykgvuPOp+NOmdC+I8Goucw1pXZxTUh+ob6vLTi0YFQuAnuDwsbpgBEUnT/kdS5T2tQnsCXhl+nmJvuXsK0rJuOdirS/VcA1Nxhkxy1+W+t4w/SiuslJ+7FHQLtnPDdHtMKurhN6z2DZtTrLg7HazTadL13aOu9ZnRoa/NldSfhzoa2XHun1qhH1rxCqOwE7lqBBwFgKzgZYAJwiZg5DeM8aRPVeNZP6/WXFQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:47 +0800
Message-id: <20220424130952.2436-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002)(21314003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:02.6986 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=181 bulkscore=0 priorityscore=149
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 0/5] rewrite error handling during mounting
	stage
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
X-MC-Unique: 9MNbAsNqNl64GrY55j1-rw-1
X-ClientProxiedBy: HK2PR02CA0172.apcprd02.prod.outlook.com
 (2603:1096:201:1f::32) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c75edf41-e809-4758-b8b5-08da25f3be43
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB33444DA150B1CA3EFD1AA95497F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 hFKUMfQkAPNVFBpOJMFsJZJyze2+WUK3qPSSjZJAx0GfLJxm5O1Ub9cwZxmith6kdW2QB+i9TXnCE2J1k8bLB195O0kWDkWPcCG7Lv8LpEoCibMjKvvBnqgk/Q3hxgXe5n3j7qTt86H7qKuKS7aUeKIG/Blggijt2lV+tH5VcfTB87YHxGcBDYJpbN0q7UGqi3gUz1RhuZmd4TJ8exfERlsRveA8HzHl5ax4SqBjmPii6uDwDhq4wtp86QNjygP1GSe9N2DFxTe3Q0GzQ76vWuuak/LCmJUKVL/P99VZ/+fjhYi4Fx2ip/ve9QNVaiAjVLt/dEFHsoZ27T0hpgM7RBLlwGk0g+V12CMmKnRdyMo30JYbZ8rwzrMxAWtd0J8ih467XT8df1eiPT9IdjjkSBI8QS9Xiz1SNMRXMDbTHd/75AKlnMyZRJpKmiv+oBtdWwHwL9NExydQj9COQRLMmDd/6ljVHkgWJPiNeEn9IiEdYrZoI3/ysBiTNHdibwCDsAeJIquXr9UFB8ASYArj6/Ep5cC/44B6RvyZTTj1tbpXYUKXtcmsOB0Ydl8YhuD2DBdR+a/nhD3o/s3kNAbtbKlTnKQYLakB/7AJZEIhdJsppMNa000XmbNeo7CwofbMxcZsrjwCUst9Tp9we7cOD3h8YB8grZgUR6b0YuYrCmwDuWzdFM8WmG/iXKIQ06wO
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?X8rBFEItnUHSAvpgoIlsMful+NTA2s8JxyDvH/jcKLCwMxPIgN6tf7VtPyEs?=
 =?us-ascii?Q?as77F5JGSXwp4DyBo1l9PqYc/8wYH6dhVo9vg+gsjo7duFxUijqCa/iDiYOV?=
 =?us-ascii?Q?lFyO4u8iyeucTi30jm5gLYEgyKyzX2XE/TiGtA8wy+3hpQWsB/4F8Tf1CuQo?=
 =?us-ascii?Q?01duuSrQ8GmB/PanPSYfnRJZDyICXzzoj5OphbzpqSTGxRA4lUU+vRcP1fpX?=
 =?us-ascii?Q?bAAl6Wll93vChv+HwONcWF7KoK2GC+uOtfFSNYtYFlfRg8JEhKH5ATZXa3lM?=
 =?us-ascii?Q?Any9BGK0nwwzB2n1K2f7x3bewbwgix/URJEl63sKB/CBkxcGjK7ju+Q6HA4P?=
 =?us-ascii?Q?KflYjd1o7/Y0eQJJD56Z6TU/jPrZeoAPfnLRDjccntosOpvR92tpFNZAKhAB?=
 =?us-ascii?Q?UzjIZ2/NSE1xPOlctB+rrJVyE8p7orVAMPNI2esjnEpy/MfQ4ROHYkNespy4?=
 =?us-ascii?Q?CeMWnulMmVdYuXjQyAWUaPJUCRBydEZaOMqo4ImZtM5mvt7WeyIoh4pDmjXb?=
 =?us-ascii?Q?1ppvqwceT4Iu6X5l1ERuwyKh1SFPrRYD2Pf44J2BoEgrQKqk6CLgv1wyIwy5?=
 =?us-ascii?Q?adj0XsF8r40t/GX6gMgQvY+XkUxu/ObfAHOI8M2Hq5iQasv8Ldqm/Xu5bFxy?=
 =?us-ascii?Q?GOLFIJsvpmC+4xzaax4T2gKDouyYOp/DIw0kiVCAA8ALfeCi1Xgcg9dwFuzE?=
 =?us-ascii?Q?HqoCS/vFfs6QPYkm+f7GLVFW/vtTSYXIPTSK0raZwtawdrMgV6bgL63wGPZD?=
 =?us-ascii?Q?oalJzhtYonoJHuuV5Vw9b+D1kUhKMqM8fN03zkf4y1SfeAlOCMlpOaVJdgG/?=
 =?us-ascii?Q?S9wuhtAbHQszbVynn7zqdR7hAwyvrbUPh7qiSiY5DGom/H61Bx52qLM3hE1Y?=
 =?us-ascii?Q?BtNFldJk7EmZjNWbJeNZOMqDO5QKdvuJ47YxiRqCWmsMSl1uGrgKX1N3m1p3?=
 =?us-ascii?Q?SC4OnXUSiZTP4Fs4QA/TBMvZhJa4bvElGNmlJpfWt/+qYFXJPJIly8fPkGZQ?=
 =?us-ascii?Q?WvKeFLYwmTdzgNkwAR/B383UAGXZ/6gOqg0t5BcC83vsJDTGfb5fjTRS8puL?=
 =?us-ascii?Q?VoTte2IT7jbqJ4jCQkI4X6bEz/ybGUkpB8OKHNH8Yxsu31i2c+E9KdoHWRjh?=
 =?us-ascii?Q?STSLsP+3Et7wdNEfy4RTr1lvjfmeYpMWKquHDIiOq4PMpor3gU5rhpjhn9CC?=
 =?us-ascii?Q?X9RzlPzAZzLAe+4/Z+gYafrDAqgb6JaDFYSh0h1PJFf2zyYM3CfwI9m7YbSF?=
 =?us-ascii?Q?jl+j2/289IaQzBe+KMUk3VH6I2YpEx9yafMCXCy/EiuRVSqlDswFq5MYLYPa?=
 =?us-ascii?Q?oWeIU1IHVDpkJcNGM8qfxGa9sAbh0ztA8KHvfP6Z7yhNcQYfyz8HW1rQoXuY?=
 =?us-ascii?Q?KrovC8RZ99JDrLx5U7/zg6/VZI6leKcbzzVrg+Kyg0T/7Ew5i0URPMs3vms/?=
 =?us-ascii?Q?odbTN3/6rtVMSEnMmrutPgcEeQ7yhiYIk7fxgwr2kC9Qz59EIINXcLS/bh8H?=
 =?us-ascii?Q?wqv2hlVY4kOWR8AbMBK2yRBG1PR2X7BD3OzXpf7vFynCnojQF/WMZxZcVfYt?=
 =?us-ascii?Q?jUwYhddebm6Z02teEE5KsgjxHJOY6PBGqjrkriDa/Ag2/UY3IBSsCvGMTMzm?=
 =?us-ascii?Q?D4Z3dTgircpouGcLwClx2un++53sPzebFWKwLgG2bufCaPKSAcZCXXUzNa8M?=
 =?us-ascii?Q?0wo4r13rZGBxyBP4wjxOjmdKo71XMVuPcRPf17zIHj6VSWr1EogsgUiddTP2?=
 =?us-ascii?Q?i15qh+I1sA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c75edf41-e809-4758-b8b5-08da25f3be43
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 8kOLg5vWNNT+UYGuEv0i/1qKlNJ23HxOMTzeIFYMh/WhLdk+wQXaeLQmd1tkMtbzOiBcVtlv++DzKw8/SNaQPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: b3yNKiLoP8rrnbrd7l6aNhg5V5w6mzwA
X-Proofpoint-ORIG-GUID: b3yNKiLoP8rrnbrd7l6aNhg5V5w6mzwA
Reporting-Meta:
 AAHF5Iq9AucA6ZInROOCdJzpprOAlkdlnsYfgJHHFpbGSRI17OaP9UlPgxbRBJuJ
 TfqET3bSZWrGNBfgOaw9JGShb6kfZcq2VGECmxQAPbA0NOv4i4VMWQw1s71k6xh+
 lXS3N6K0BEASwXETv82wv3X6XzYfqmUkCwZhw8xFOhlNzHF1NSRos80OLj1KSZWD
 6ex00ev2PHOxg8SVYow/HAbQB33Q70lFken1rPBv5SYUgZSSJ4vLPFL4fnu4jHiP
 /xAxC/45SU5BXFJIelW2/rC4VSrFnBM/K3VxpXutSYt/jqmuJ1i+45ZGA95OxjHu
 eGGR2fp1PBCR9K4dy4j1b53kt/8+qdMD+6xzTouV1ZFdV8bf3X50Aerv8xZHU4Dm
 qkIgDALQ0A3Gjp/fk49IAxYl9G2Z8qEXCI2Vq48entdVLZnSTjH6epZqGfdjVQCk
 criz7p0EaLsL5E4ga++w1wVbyZVD3oEX2mMeB3u8Zp/fnXnykIc/jKv+WkiAmiUS
 v0lmhILpDvBGLCVyLfWvdrd4QVOA35q3xYst5LKF3KI6

Note:
For test code & test result, please check my next patch. 

** v3 **

patch 1/5 
in fs/ocfs2/journal.h, add declaration for ocfs2_journal_alloc()
in ocfs2_journal_init(), add BUG_ON()
in ocfs2_initialize_super()
- change the "if()" condition for return value of ocfs2_journal_alloc
- remove unused variable 'journal', which introduced from v1 patch but
  became unused from v2 after new api ocfs2_journal_alloc().

patch 4/5
- Under review comment, roll back the changes [*] for ocfs2_check_volume().
- add ocfs2_free_slot_info() in label out_system_inodes. without call this
  function, ocfs2 will trigger crash. this crash triggered by my test
  patch.

[*]: new comment at front of function, and a code rule fix

** v2 **

patch 1/5:
 - change patch subject.
 - add a new function ocfs2_journal_alloc
 - add new comment at front of ocfs2_journal_alloc
 - in ocfs2_initialize_super, change legacy comment before calling
   ocfs2_journal_alloc.

patch 2/5:
 - revise commit log according review comment.
 - remove meanless comment of ocfs2_resmap_init in header file.

patch 3/5:
 - set "sb->s_fs_info = NULL" (osb is NULL) when ocfs2_initialize_super
   fails.

patch 4/5:
 for ocfs2_mount_volume():
 - make it return 0 (before return "status") as successful.
 - remove goto label "out_journal_shutdown"
 - add more clean job in label "out_system_inodes"
   - add ocfs2_shutdown_local_alloc() to release local alloc resources.
   - add ocfs2_journal_shutdown() to clean up journal.

 for ocfs2_check_volume():
 - add new comment at the front of ocfs2_check_volume.
 - change comment style/format for "struct ocfs2_dinode *local_alloc"

patch 5/5:
 revise commit log.

 in ocfs2_fill_super():
 - change goto label "out_journal" to "out_dismount"
 - add "goto out" in label "out_dismount".

** draft -> v1 ** 

- split one patch into 5 patches.
- goto labal name change to out_xxx style.
- only test for mount/umount & 0001-xx.patch related issue.

Heming Zhao (5):
  ocfs2: fix mounting crash if journal is not alloced
  ocfs2: change return type of ocfs2_resmap_init
  ocfs2: ocfs2_initialize_super does cleanup job before return error
  ocfs2: ocfs2_mount_volume does cleanup job before return error
  ocfs2: rewrite error handling of ocfs2_fill_super

 fs/ocfs2/inode.c        |   4 +-
 fs/ocfs2/journal.c      |  33 +++++---
 fs/ocfs2/journal.h      |   2 +
 fs/ocfs2/reservations.c |   4 +-
 fs/ocfs2/reservations.h |   9 +-
 fs/ocfs2/super.c        | 178 ++++++++++++++++++++++++----------------
 6 files changed, 139 insertions(+), 91 deletions(-)

-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
