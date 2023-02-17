Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEB0C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Feb 2023 00:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xKtu1OgRiof9doSw/IvKh9vUv/QgJDnXK/RyHXj18o8=;
 b=tQt7tocx0io230lud++saxiotR214oeiZtdjxhVMoN9hC4n6ur4Zvn5oQRMdMqN54JiqfI00qmb9
   wpF9UMjfrCRCcPb5qsSag2rZ2c7GK2png3zZD8jNDUevna4alxB0UDe5I5dEBlgWU46I629huWte
   1jPVhNb5Zjbfd3PEcHXSHlnHoy7Sw42q362saPkfl2sXUfjThcB+x77hm8weYn39A2WUEUswewWY
   KzWAfW3OMRBFG2n2E8zyGMG+didFIsecvZzwAYcZGilIESgU8KHxaArEX/AAHuRcAJEGfEfO5Wtk
   KoSJ56cCMCkJo8z5WoxIDvc2fIqvJX8N53DDtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xKtu1OgRiof9doSw/IvKh9vUv/QgJDnXK/RyHXj18o8=;
 b=B83Du1TvLQaUq7QnfxIOGpTOhCToxSmNlUWYB2LsRALxh4US8BwGpdDFWbttMIoLhnsZSuo37lk/
   zRa22x4Ld/937oTOQ6hMufVTdxu/qBJ8AtLTiopSOBuDpiPcgPCwLHPkZyOXVhD/NyAAK5ueptRL
   cp4+iL2NpyOsQk5muZb08SBHkX7nCoE0wmHECqyW4ywe0jObcwO4TosKzCrHKRilB64j180CEjwy
   5jerHCANcXAGfx8sXfyt/08pDXpJrERrrpQx4bgxPi+k8+svFLHbo+34B4qDrLcQnqJ1H3DObxq5
   eg2ojf9Aw8M7j0xUJc3qWuGS5yY1c+SefcZ/2g==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ700FKI8F5WW40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Feb 2023 00:37:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHWtJTmc1fMxda+y1VdZvLCJZELS2LYh1T9HrfsEUM1DFTWcL40F9kGZCgtT3TCEw0oaA/SOJmVBwagl+Wdckhb3PblWTgVP244/xCjy6MCDSVeLMJPTwlnb9l0ZgpXX5C407qWSVyQaPh4XdOtoYSOocR4C7NGZoJ3R/qy0mq2rU1MBsN8liFxiBO8aS9+AT3viQ4GXBjYcUdNCDU0UVbjHcEumg8p2xHoDZSKbu70H+VvMzXMgEEhFpk8xhxhLKcCj1IZ0cLMXfOCpPkdsnuIZQznvBXtBHqnxTV4t1EMQUQOKvZHmcAskvRUpER4xtY/s1TWSLqolviXz/LPD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTXK7z//qQylSAWmM7P9xBRZlBVaCiCQr3g40E8FACc=;
 b=jUAoTZcl5D38KRa18CG2Qo92YeZ205A7QdwwdJFyICa2nbMgIfV2MH6JobjLKxV5301Zv1+3KgGM0PYeN5tCloPbc59F+5+DCgC7S6p3AJwmHsr/m1EsQdUTUEX0EfaRorqQAezcSzdXFVMlR1+4haha4tM9p94oY9gruuSjDRHEYXFM0vPFVio7cO9EgmmthfY3aM86DQnyt2g/AH5uAnT27CZYKZADlyz+GChV4HC4tyk41ixH89VYHK5G3MlgdgowVoDhkw4/GnNgLu1cV8DH8v122i8jkzwcOy8IQag4CakEfzVAxu+eALM0aNLUNRaGu9eSFvjCc/Nik2SIuA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTXK7z//qQylSAWmM7P9xBRZlBVaCiCQr3g40E8FACc=;
 b=4zl2rZ9Mur6NCKP8OPTHyF/kUPFh5xzITE9XOxbLTW2u4Rj7uDBiLih+0sZqSEqx9jFQQQ3ETc7edT/+2EdHm+iIXVpkn940a7CvNrQ3QDOup+Lmu+Y7XkxsTYRrIWn3AgDmID/sfnFO+wMOS0bJdaLSLjwE63lWMLO+MKL4hhvFWLqCLPMwzYysgZ2I6qT2egkgUY5wLhJ7lT1+Ebm14XBpDeNYHmtpFZdcQ5MBoXdOrsWhWddSYOAMrnyGeyOAT393AawkAEdqqe8fliUEwPrpDy3WBHC/tVS6OfYYTgww48D5+pnB7X7m7paZW3NSNgy5ch7JwCOx0bSEKnP9Lg==
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Date: Fri, 17 Feb 2023 08:37:17 +0800
Message-id: <20230217003717.32469-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199018)(5660300002)(44832011)(66899018)(41300700001)(2906002)(4326008)(316002)(66556008)(66946007)(66476007)(8676002)(478600001)(966005)(6486002)(107886003)(2616005)(6506007)(26005)(186003)(6512007)(8936002)(1076003)(36756003)(6666004)(86362001)(83380400001)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:37:32.4020 (UTC)
X-Source-IP: 40.107.20.48
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10623
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=932
 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0 priorityscore=173
 clxscore=183 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170002
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix defrag path triggering jbd2 ASSERT
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
X-ClientProxiedBy: TYCPR01CA0075.jpnprd01.prod.outlook.com
 (2603:1096:405:3::15) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DBBPR04MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7c8d25-a776-4c53-3e2b-08db107f2800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 0EyTSM78pRI8ZR6voGw81zbMnwdbmIfaUqTGtY1FEm522S4p+theexH0YuGvgh28qM0xrC3x89VBQmj37ZmQXYvFbyQx6c+7sNuc4EkB2ywlPtDkLbWGMQkHHGMwb/LAt1GCfm5Vy3AUVH6n7vYico728j/I4obOMxmANqLTK+HlDPfiW877YlwAXcNyzBZTd/IX2i1eswsYWga/z1C/+ZYpcX6XEKqDGuy93F6nac0fYrIqnyZfbmZdCUf3iJPJ5d/0HE4fvyHmqkKN5s7RyvPrnOYJq1celh2bluEUCIWAX2vU3YIoqcvl0RblvdmxxCWD+UswbKelasuqFyCVrcCOdZEU1/Pz38Es8cIwJ9vbr+JEPRR87NRvM4vgSoHj+Lu2DkeRS7HaKMbNLF8XLUfZN+8IK+aMkDng4rKQAhnROhey5DaQup4cKFdi5N/lb/f80HtSU4Y7QIoU7mkVRAF4rryRD4j0MavjL3XNFMzsRt8UpII1xOZ8zuJF3Bgh2Uuai09AjwH4G+dR+e5aLWmxtAqZjmzVFqybaS5YnpyvOKGihDCj4Ge6OsjPiF189xqkZ61vvKeahlxJ9vxW7irb0zpGAaKxedZEWDP7T0kroNQTHtBb7UGuFS1jVHVS/3fsasMsIQZ5U0Vt36wrwmPk6G6Jfi+EcNxxEYL8AtI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vBu2lkEAluLCJPjU9IofTEQuDehG7sP3E2+jAVWYq/OMoFrGYvkYjdvbrzLS?=
 =?us-ascii?Q?NyspDscbEZ54PPRF0Pzc68VcK8XMmEGluEFdp86FlI/kgp0e1mUCVTaWg0zF?=
 =?us-ascii?Q?duoyTyz5nIOnn45VSBP2KwXLqlThWKl3V6CqzM3Cdvcv/30Yc2g6yvBT/NZC?=
 =?us-ascii?Q?QXzq94XeLrZa4dFKXl/QSMT/LkM1ZB5vhK6otKFpN9iN0+Lckp10du9DsEl3?=
 =?us-ascii?Q?dPdiNNL2a5LPSLnC5DwPLls0+daC7FMfcsWwkKbESIK0zmRk9527N77vcbtW?=
 =?us-ascii?Q?jpMZ9+MvqurF7DBRt3ZWGPN/I+WTyGphXcRfiAQvv0F+Dd9j5Ok09SVawbXx?=
 =?us-ascii?Q?uFzgEOjS6V+QQXkoNogZQ3jDPhbbYCBtn6aVIKQpDTeAkxKFLBiu+v2eyl9D?=
 =?us-ascii?Q?1lyMG/6o495rAxyZH+16RhwX9GOwZlXAUJyL+LXPIebrVAdcIMZm3GZS7R7l?=
 =?us-ascii?Q?winOhnHDD2cpgmwC9bCI3HtAThbb9CfOy0dxVvqhcnSi+Z4VWX7zQU7sjY4b?=
 =?us-ascii?Q?+BuI1Fq6caM/uLP0FFbSbPUTQOKzCtn32R7czItentf8rElX1zQTqwWMF3Im?=
 =?us-ascii?Q?EzUUKr1GcoeKN2YqBzJ2AbTiqrMmL2IpZXE5o1tjWDaUsnLGVHc8ZJ6/C8XQ?=
 =?us-ascii?Q?kIZaixFRvc/Neck77Fa7v9wCpHPimj09jRJke2hiT2hdWdVl/Ey6f7iEWOZG?=
 =?us-ascii?Q?9SReqQYujVVN4ogIxcUygYxyA9UuZDK8n2jjA8vyFJjZd/dc4RcEQtwXINT/?=
 =?us-ascii?Q?Ou1A0J1hZzCbBul4PimjZmvKgUo0QA1MI3Px02btJk8VgZv1iCS/xKu+gjVm?=
 =?us-ascii?Q?Q5gvpVAKjJw2wjVSSyihhfiCDMyfyZgGZ+B5HFuVuMsVHwOtBJJXlnzQBfwU?=
 =?us-ascii?Q?gCa/3trFK8OWlMVLnfnVuKEt4aFbioqWB1rMJr2xf3l7rC72OO82nkXJjKxH?=
 =?us-ascii?Q?cAxJOpBjdGIu8CzQuhMDv2XPp1/htfNPPHPrGfUuWod04mhmlwhTyO4yNfRt?=
 =?us-ascii?Q?NWFvHJAwfBoNgQAXKm2sW1V+06XOzbLStb993dgHHxRgK8ADOWm1XETOw1ih?=
 =?us-ascii?Q?idnq+rX5Xp0tLvQ9WQDg2UCNxtzkRCdYofAY+6RxJKrUfCbBarABrrXjtYMi?=
 =?us-ascii?Q?k95ojWJahYrjJJ/oGfZsni5xoWLlIfjiT+CidSqeOvESJ4D6b+OfezbeSbdU?=
 =?us-ascii?Q?vun6lnniq0OG/DiE5wN6rLmF26/900I4PQBKbMAm5lZAE8wJS5wlyJbBsDgG?=
 =?us-ascii?Q?x6RGaISrYSQFGAxvCgFTTvQSYhVdbVJjs3p2/uTwA8QBBZMD5GTrXui9wr1q?=
 =?us-ascii?Q?h9CZXUCkvuFoaB6iQi0IlCKHbtUd5h8e230zA6rch98NdoO37rnYpp5aLJvT?=
 =?us-ascii?Q?PgvGxjWomc5Ql3DODJRAv2NjIH/uVuaPWrOutOBk893MeDsZmKcicHl01Ekh?=
 =?us-ascii?Q?6zUYmYeWsfBuDH6ZU4ntDJgjyV5xCvVhWj6aikeYWab2PUrk0ArxfayhEOh2?=
 =?us-ascii?Q?RtooDyL4Enw5d1aK0w0zn2GU7qi+ru+IUyqiXKPp6agLBXUjPqdNSzElwe0X?=
 =?us-ascii?Q?dVb90NeEPgkXylO5DlKAVccMPKa3e0+OknOFhX0I/UaRD9ae38EuuJxTf5Qb?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ab7c8d25-a776-4c53-3e2b-08db107f2800
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 UnwPhWSCZTjJhcNRakLyxwZM8TWG+GekqdyDEextHi1+Fy5MmRcUwCxkqb4sSYf0RovJFeW7Cxda4DabW1OzwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7913
X-ServerName: mail-db8eur05on2048.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: tMlTEHSSgi1TBTX0N9uWzKnWUq0BWG7h
X-Proofpoint-ORIG-GUID: tMlTEHSSgi1TBTX0N9uWzKnWUq0BWG7h
Reporting-Meta:
 AAFbBZTFj20J+VeZ13/QM5magh1OvwbAJyW+w5R9IecyKbKouJLGGHeJLduPOg/V
 4vPSE0xv0A0N2DxFLO0190RfkrkeRSGsuuqDfHP6aC8MkFmreeW8ubNtpkj/lYUg
 cIm6OFEm16Pu5m3afR+K21gGf2LCsnaWJOyoRbbrea1CEsbOizkuIO+4axfQxljM
 EKz9IC4fWHA2bSrhSL6KnpOmkaYfKnfkCgl+JhbWonKrqlrWzDuH8zIMnlMt8vrI
 lT2cY7zrg4d6Bv0uwD18rjyl93HiZth6EVE2b9oU6Jf4JK84n4vIbBNPbs44Xic0
 KBzUOg57J+XnsYAlvmi5wU7XsxSKvVjF4xx3KkIaaYNVwElxNSBddc4xLVdbVCLt
 xI86IZRqcDtTbKKe58icLbsiH25WgBNKDaXJpPrqh9S4wLlymg/Hj1yZSXx8lchk
 fGxpCgkNqVmdkX9fxm0rpSTWn7B9whq3Bo3ZuhkKkS3RxgZkAXm2CZMowOIENA/f
 tf4TOTPg8pQxeNA5MvF76YaGE8rQI2LJoR1bArtdx6hB

code path:

ocfs2_ioctl_move_extents
 ocfs2_move_extents
  ocfs2_defrag_extent
   __ocfs2_move_extent
    + ocfs2_journal_access_di
    + ocfs2_split_extent  //sub-paths call jbd2_journal_restart
    + ocfs2_journal_dirty //crash by jbs2 ASSERT

crash stacks:

PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
 #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
 #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
 #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
 #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
 #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
 #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
 #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
    [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
    RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
    RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
    RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
    R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
    R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
 #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
 #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]

Analysis

This bug has the same root cause of 'commit 7f27ec978b0e ("ocfs2: call
ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()")'.
For this bug, jbd2_journal_restart() is called by ocfs2_split_extent()
during defragmenting.

How to fix

For ocfs2_split_extent() can handle journal operations totally by itself.
Caller doesn't need to call journal access/dirty pair, and caller only
needs to call journal start/stop pair. The fix method is to remove journal
access/dirty from __ocfs2_move_extent().

The discussion for this patch:
https://oss.oracle.com/pipermail/ocfs2-devel/2023-February/000647.html

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v1 -> v2:
- doesn't change any code.
- change patch subject from "ocfs2: fix J_ASSERT_JH in defragment path"
  to "ocfs2: fix defrag path triggering jbd2 ASSERT"
- rewrite/polish commit log

v1: https://oss.oracle.com/pipermail/ocfs2-devel/2022-May/000101.html

---
 fs/ocfs2/move_extents.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 192cad0662d8..6251748c695b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -105,14 +105,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 	 */
 	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
-				      context->et.et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_split_extent(handle, &context->et, path, index,
 				 &replace_rec, context->meta_ac,
 				 &context->dealloc);
@@ -121,8 +113,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
