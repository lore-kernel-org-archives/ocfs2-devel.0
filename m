Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 742FDC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 10:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xH8Ua1ZWsNCpGFrmrXGwCbyctVOJ+ZMoYvvWwPl7fPU=;
 b=hWLB9tegSPXlJ6kqV954KBYJmpwqqD3DjBw19Y7WOj/CzuhLfxLqEsD0ikdrZKAm0lwL3cB86I7w
   kchjtRWdTv1NcRg3kE5pK0Dj14+qjlAm3p+F0S97jAbD+cNDzMac/S0NVfE+tkNAiuvyvXjZBL4Y
   FjOTgchI6xW8SKTlmUDCYCdyJyMpEt8VTzMzonzVA59eY1svdseTHPPnL2GScA7ydEXgztvNvijq
   PtaZdmPcb8agebkCrmedjcO/PX5D0vkMEJTzrtx6oxMFltXl6iqKd6DVPTQFwrIzQrO9RVEiIowU
   5gN9+pH6zs23Anx0Zk3tn5XffvX9tXprS6+5HA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xH8Ua1ZWsNCpGFrmrXGwCbyctVOJ+ZMoYvvWwPl7fPU=;
 b=ITYJGQzvBehrx5QtdHi1kOMSWsSx1tuJDgFGCFEalO5hvzDvHwk0chJotjrTLZ/TSJFrhB/ROOXd
   bU8/T9a3gg9Ym/d7sT6zAu0UgLnlWrnvao+3Qo7m/utk6kSsla4ZzV7LFFTJ/Z3bTHQ8XaRi5X8b
   0osexsu4hdR0IbAfc9JXUxF59OqtvR9R1v9rcdZqJOCFZuaK/Lvn1s/npFapAbxZI35b/JVi0uxH
   2Fxy3udU501RSwrW3rLW2M+D+uIutjNGlVWQKRvRGVTueQyszzxb6bzkqLnRjeNvHRbJSfwGhImj
   Uk3T39ftgqfoOsdXoVQkdz3nxNdkjyapEXO2Vg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA9001UPVVX6W70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 10:02:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838612;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=pCAC6Bt0cOgVtxTX6EyNitQfvuf6WGv9TFWNvkD3Mpg=;
 b=KIGghJVIOlFE7yvU+qfLONSDAW0jFoxh95YqNZrstRdJcD0bUtRav+/bo0kCPRb1BVwrC5
 kQfEgbkSQduwAzCP2Q79DvRh/kJjqmMABxUxy2MpwSLOC/KFI0OPVM6UZrORhFS7jN/HL7
 T0hXQd3j+kNx9VtQG33jXjLGJI/K5Bw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFIIEenHh3HHYB87HWSL4sV2MOmwcVr/ZBITF2PD62sS71lpQLyOoO0KOkCFWHBu5l7AbfQQLHPluwcyt96qUeRWRMM6Vpd7lexZz/yZRH7LSSfEmImnkSw2CijEJ1STohWE/LAkjo4Dg2259zTrN7pTpoH0CGq4iN7O2BCi/dc23p95F4OJnPJZKsvGDFjSmCtjA1Ymz+JmLXsLgCpcyWoVWk/v1mBqYgVbHBLzOUciWfTrSW4UaK9vRB3aqdfgD8l8MzXXAoto9jTLk3vsW0Utm6PgA+MyATmyDOyZw1WMZMDqUGpCk5WrCYLsqlkNf6ER3aPVIb6fvoUXFExYCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AQZyjxxJNKlyZvZvCJxQDyj7lbKjQMSNeK16sXRd5o=;
 b=Kn8gPOyQLcnydZNGreFtcvuVvbDWAPspb/VG9Q1aFy3tJAT3WanutB5ON0e+HDBgB2IiKinFGo3fW9/RZ0dhVClfMywely6Rky5ISchUOMpsLsGDctdhOOFpixvyQK77q9VxeaQkkPW6y3ya5MDLRvTMoRHkXGwDJ/FIwUuKhPYDNGH4ko8GJCSMkiciqvEmhAOjQHkEQG49gClCJgSs6BPMWtf7Irk16OkFBqGgAhpcK8JYztsPQl5PS5bLJj0nXc+SnUkgwu7nFuGIqjGBgXHG56T+7n5SA/IwFMg33J9yUQpbAD24iOsXrUYjZyu2LsW1fsU8Z5GoD8jqcdjaRQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:52 +0800
Message-id: <20220413082957.28774-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(6666004)(2906002)(186003)(6506007)(5660300002)(44832011)(21314003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:09.4324 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=178
 lowpriorityscore=0 priorityscore=202 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130047
Subject: [Ocfs2-devel] [PATCH v2 0/5] rewrite error handling during mounting
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
X-MC-Unique: JnTSS68jNEOwMsWEFbTkPQ-1
X-ClientProxiedBy: TYAPR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:404:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be760e04-1b48-427d-a447-08da1d27d203
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB81001905D9E3E8F00503E95597EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 V5BGkGhVeVel3QXuZkfq5iF2OUUCgxDZ1XxT/orA6v90n/zreBo6P/GSxOYumX1i/jvcqZ8Hb2PwrdXkdDkxjp+yH44iFNLY6yOHErnspjPzr9/pVQ7qdOdB3fHjHcTZmiNbBqeFoD4ekqljYYzQc03xLrBUdF3Qii71gA+2bDX4Xavx5SBbLG8SM6XtGnhfoNiLNgdcQTS9BES5hrmdUygZDx/H4G1IB7DTZERt02B+DzLQgYaDG4HSiWU043eXxyQvW8a9e4E7NvQrY/NgxWB+l1IPQPjjaLZnqtmDKRp6cTG82kavK4VIf8Aih+EoBsPLpA9YfGElvCwuaaqRZ80aChBSwHJXbVnJjIc8/pL/MaFsnZ8O2dk0N7OFBRkG5DywPkIgSujJUNLy+02YI7FORA4h+RO2Gc+XvEDUp/xEjVQCRq52+oaDvZDuS+CitkOjVmZ58zAND0wPhbTbDx+shTfHw6XB/1u8p9AsSqFUIrJi/jnc4Rkpf45Sn7+1ZChEm8kP7OBcHmEFA/V4vXegn8zJEER/haBGy5LR8pAcrqQtRelwEro2IyWPAqGjS+lJYvWkGdmwEDt6Oc3hDyIqm48yFPml8cszuAAQDrqLJHkcQ9wtZUBirkhRxGcThchatg0cdRwnWhoM5agyu2666lLxN1Bhgo1vLNFuHeQwMAUAgf7xkUf1zdUEK58TwlmL2IkJZi5KKlvgQWmc4Q==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?DGVByb9XsMQ7EGU0p6r3/Vhz5S4jvoEP6P6phCm4kmhDwiZnj0gzCQRgEPF8?=
 =?us-ascii?Q?1xoMWzoLTybD7m/cIo9wxJawOjlxZyP4wEPwdRRL2sYA8AOIqUvdgK9UMTDj?=
 =?us-ascii?Q?QL4EzwSPa6/MdR4nC588WL6FsUjN/i0IGNHNycyHABUh0QRwWKdlD14WODi9?=
 =?us-ascii?Q?KWYIg6YXNXtY/TTybQwOsszIOrIAynDzXMLH103Ke4m/lTF89mIeuRGCpalk?=
 =?us-ascii?Q?27WZIu+PkAvqnzDWEq0CfmZ/R27+tKnxQic3ncnl6laFXJlz8j8WnO0P2n8R?=
 =?us-ascii?Q?94DSssXU2+Jk2ygYgcsYvoc7K1AMtIYvDWKE3bXu+gzhumElQwMz+7OHXSGd?=
 =?us-ascii?Q?5S89X3JaPiP/1x9ihYdbd8vSb3voeLsnwy1Xy7y2vxrVSyKaMMjY/8IhbMe1?=
 =?us-ascii?Q?8F4yJtFGopr7mlrD3L3whRo0mtwqZI8MLnFI8dLXtWMZoFLWAoARcCRBYM2s?=
 =?us-ascii?Q?ZhmqrvfASwGmA2x5ikDg9VaYWTDfeeJedZsmxj3bH89kPKle7M4Vb5Z6iVV2?=
 =?us-ascii?Q?9vvom7Cjvr/flwIa0jCBuXy2adJv++IO5xWHpsQs3cy/CKzoIY40pnnU+XQs?=
 =?us-ascii?Q?DC3/K+NLA/LQZhqb0bZ0OMny4XdfESd+3ym8ecBN8TU2TPjoftyUSckuRI9B?=
 =?us-ascii?Q?xkEYCiQ8M5CwvbuxU6DivJ2iPKxvNiTCwpPSzmNHOh4y79Nnz715pN7FEQdq?=
 =?us-ascii?Q?ii8zM9bSdne6wtvhDo1Bip+3uRoxFHnRSprgoxEjIRrgr3fL1IpAgxIi4rFz?=
 =?us-ascii?Q?xJuXGOuZfbHrUuqrlps3OxPWir9uDu+OVS05BfErHJvg9GoRqQtU9NEjG8MV?=
 =?us-ascii?Q?lYYLX7Sd9aC4/E/wFKTLNgEXP8uCaQypEW3U69bjSQpgVm5c97L3TuqJ2iA4?=
 =?us-ascii?Q?pQxacgsH7sZGUnjVNWKIL+e4clh9v3om6v9bQkyV416Z67pQkNG0yoTkXzo8?=
 =?us-ascii?Q?CT6DIfDF32alFWCCsxR6b/ZbJg4Ch5YU4rpfMD4yNY9JOOHFUdEq+xSfRG+s?=
 =?us-ascii?Q?5/TzNS7DTc2oFdVZEkr4Hhuo3EF9B8+GZXV8hnbAKqb2GRgnlVayTBdZgubG?=
 =?us-ascii?Q?6mV+s10AmNvF2NBQMiwTt+66IRoTeEKxaTTxOMYRChPKDw5ncrrjwxHkZlc/?=
 =?us-ascii?Q?EC9h9FRxAeqNsWn61xoX7/r8BYz9wLLKjWVuZKppBl9AGjfVYnOxUXjJCl5j?=
 =?us-ascii?Q?1ihCzZEydzL75QnT14i+E6UyGO9Zpm99EKVBWBaLk1bIkrO2J3ZimnifmCSd?=
 =?us-ascii?Q?cpa1vYhCGfpVp0KL5JDAXzdUwaZ95VMhWziA2mztwp0/Geq5nSNRWV2iVTq5?=
 =?us-ascii?Q?o9NUTjon4CUTzWFv0BSlWURQwjMbvVcdJ2/d8xZzKvFvGktgG5r6lwlJ6hZ6?=
 =?us-ascii?Q?Rdl/ACXUV+zuSMPCugPwrVV9rr1YSs7yqKN+OFtvoZz1Wk7KDrmHlXQ8ZA4K?=
 =?us-ascii?Q?i0rQ0gJqaRFD3YDwpDG5/M9tDKAby+196VYl9xdmOVVfm3QH0re/adkBj1G9?=
 =?us-ascii?Q?lcS18PBIcUY5j51QxvGUaG3L5R3hDDh1kueDd5o2+33qJUIZvtw0NFdflSIJ?=
 =?us-ascii?Q?sSOLXuI+WO++aCIvjbRAbVa57TVEo6w0yB99YQ4V1tsSFnib7HGy1a3il2o0?=
 =?us-ascii?Q?xu79pyWpq1b5xOYUke49S1XEjWqLYFyPc6lYW89dhSzR1x6Zgyx3KL1iek8B?=
 =?us-ascii?Q?szkxPV1qBht5jSbzZ80xq4QWzt63xR+bJ4D9xFTWL8xwSQIf3mWDWTtuT6/n?=
 =?us-ascii?Q?LqAINOBE5w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 be760e04-1b48-427d-a447-08da1d27d203
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Dyvei20dwmo9mXJVM1LPjysgMVhoahXUjYMqUA6wg+2sCjwu2/ImZicz3fvTmPnEbMNi1GNNQ5AVdue3FLn5PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: DFdGbBK6wqJlmhLOtNKqg5rhedIcFqv0
X-Proofpoint-GUID: DFdGbBK6wqJlmhLOtNKqg5rhedIcFqv0
Reporting-Meta:
 AAEXpB8emGTs2biMMLq/QtX4InpYqftWrvNAKVAzJzlIUqSR0GTrJhelPHnNtR0K
 VvnahBUxJvfwS5iCtBMImCeVJk49YvtUGIta9sE8Aw7/bpuDbA/7ZmPViTWFEzas
 sffJoTrDFhY/qT4BLN7kJIUvQqbvHNG1Fpm8edcN/4yZS8MwbfdfzogeJ8hy/Mfb
 reVUCaIChrUbyCMOzlV5+X/PsNGCxELFltkJ754D1L8j8K3Vni5Td3hf53mxreBu
 KN28yL9lwow3r5jIXvq7+gMw04dVjlZ3cz6RtgZTZzswkqxrrzEkQreZf/3Omwk8
 5uUq89NNM8Zz51cKxgocwxX9MhmdKEo3NsZiJUYP6XdPg/8/gxu+TYoNXSMdVWqT
 /6n1LN5NE2XZObMLxYDCKmy4cOECIziTMOmog0mwWjw14247FusBNvS3EQttzLaH
 9iEYtbi1xXyCXJfaZsU2TW2Gusr++ic9G+WYbSRZKJUvqLVTmALGN/SjiLFQVVoH
 0zPQBQ0firIQ+PQ0Ur4Ih07AeWdF8wLLdeHKyiWpEG1I

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
 fs/ocfs2/journal.c      |  32 ++++---
 fs/ocfs2/reservations.c |   4 +-
 fs/ocfs2/reservations.h |   9 +-
 fs/ocfs2/super.c        | 188 +++++++++++++++++++++++++---------------
 5 files changed, 143 insertions(+), 94 deletions(-)

-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
