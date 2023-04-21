Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACB0C7618E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Apr 2023 08:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OFp2BJO6yLtIVzdoTCqGPcRfhhJKjaxEmAfiTrHKTT8=;
 b=X5IlgHznVkB9z7m6Zaeu28rpEMgXJdNPWnkLxM0a7r/xN+fvwRCU6WXSMNw+z8gKCLyoruulx3PQ
   yL7zbcXgGRc1P3z/JJTDvbENAxJvTGCnaejG4hrYo8zhn9URjMgcMOd/TO1rln2TGZcj6pbvBmjn
   O28ICITs2mz+SnsyE8woDC6C8Kbm7jnTj1UebcqjqFt8SvvuWDYsbgMPcg+/o6qOwJUoe60QtpsT
   7vte3wJLIms7LzJ7A6D7tMu/Bl2vy10NSs5yto8EP4LdBV8wEqhgYe909pS72L/079nSoTcJ81hU
   5A43zOZQlunHeQnQecsxmYOvK4h7AuVAofUdfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OFp2BJO6yLtIVzdoTCqGPcRfhhJKjaxEmAfiTrHKTT8=;
 b=Ck98TJYwcYG7cGi/4OTbAsqZORFYh/DvJpmG6u1clZehW+TUZgKeUs57TUuLsjw8rvaB4LuC58GN
   pObiuT1Kke+9++QaaQ3YNDXn01T7bwCjLnr0Z0SNsZostnNnOt2tOB4Fi3wpZGl/D+sguDOv5coF
   0FV6FUj05ydLpFfUV/FUInYPjKTb7YoYt3gULVoX2BIxV/NSTRpgFY16Ob+5V/fYiOjrgG37usU9
   k89cIKlx5TCRWfVTq6IU7CU20gujFBzevHM1oBLC4fDYF+bcVp0d36S5Gw5cBumaLtPliFBWsbPd
   w/wW51+kzPez6rA1ZzWuCZlsCqdIpxeM5q3Z9g==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTG00LAKIM8LG40@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Apr 2023 08:37:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzvW6zpCTYs2v1b7MsdmmxYU6yIsvDbFL0dRP0JGKrFW3i6j4/t6cys9ijJFY5rC7odZkMoFHS1hY34L+L+r+TlVITo1xnKzaWMrGLm08oyxGExn2h4bQw4soJKQXpjoDCrgTNzjKx/99Z+/c3Oos0kJS8hd5dZGF2x5YQ/UZRcmw6qIGNpSrNYiRY6RAxnJVSR481hVqY9auWZHET9qQoKZqmghrSrwF4LMP4EHArMLjyUbby41DrmN5rCwZ9Lpuo/zOQHdAE6V/kbB327OLx0G6l2NiP0emEgUAQ3k6A031UFRzNncrVv/g/ex/kopoSHCum9zMke2Op60QHeJag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnblDeTzClbWyc7soktf2W/kXC+CDif+AMGc/e/+Tcs=;
 b=nvTLVEWOO4w87Dz6jcLs6+hVCg8kc4xDcNwUO2pC9m4jsj8/yi0kxhjGSi44H2GjPqilNIk2NtEsmPIu4lkCDwHOkGpnvbpWZ9HbDA62Ao0Mwyoef6LhckpYDTMI891tDRqXvj7F8EG1oLXMVFZ6nBYt9lph8171T9gX/JXxrMZtqVQ2Gim0PlwqYs7kQVFOboP9/+uUb8WDc/MspbhhiierNWZdT5CgiEEHYve2sI5+Zw6NtRB1w313eSUWcgi5nQZDEAv4rN1HR8TfvbPr5nBYPWaTvectcUo8rmyrz1zzQcpmMV6UzB6q29pkWnrA7mYpxa9ff7ZwsE2iwNE6wA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnblDeTzClbWyc7soktf2W/kXC+CDif+AMGc/e/+Tcs=;
 b=PojD6foGXms7bzxSDFtwQdLQL7TnThby7q5ZOcVjUzfky8KLFXhPK/xMtW/UMy55i8l617g8o7IjHpJQMbQLlXCrxrq1JnrJEXKth9n/AnstieY89RRxeY8tII25m3OVD0sbjtOeP1yHdsZ7mEGj5cU+DuSWGBK++xJA4RAlTPMzbKPqb1ApiVLcQ2rAaj9+xiL/rmAlUtIwj7wh3tci2CcRhjXFCmzuvYDJK51lVwQ9mvxtXfTd3Vk4VH9z69rWruoWH+hM6QckkDr9ddQvD6w534RLy7sQvzASA7G5Ed2/ObAq2bY1i/ZKLP45g8nxPnMmrYINnEOtyo9C+t+Xmw==
To: joseph.qi@linux.alibaba.com
Date: Fri, 21 Apr 2023 16:36:53 +0800
Message-id: <20230421083653.20380-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(6916009)(4326008)(316002)(66556008)(66946007)(66476007)(36756003)(6506007)(1076003)(26005)(6512007)(38100700002)(2616005)(186003)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(6666004)(6486002)(86362001)(2906002)(44832011); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 08:37:04.3210 (UTC)
X-Source-IP: 40.107.105.86
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=178
 adultscore=0 priorityscore=90 impostorscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210074 domainage_hfrom=9705
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix missing reset j_num_trans for sync
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
X-ClientProxiedBy: SI2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:4:186::17) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB9913:EE_
X-MS-Office365-Filtering-Correlation-Id: ebd541bc-e986-4bfd-30c4-08db42439570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 LJdRql1RSU0IEotcsj7aZmQYTtu+AEc9L2hWv7F+KzA1yJS0PEwNuKxew/UwMIwO1yIx16nya3EJI9aZAlMwwgHfWqU6vGnjA74rkVRjHUV+Nj11w1GElmEOk9NiyxdwSNMXMR2F2KGuFtGSnfAaHcKQ5oss4yf+vIEGBn4NRhBWk4i5xhgiRzKf+tAgfkkeSp+VFA870p0xs5F4eOCfK1OJSdlLcOQeXM3gI0y4+dobEMpwCob0Us5lgQATYvtZY5KvrafqKMH8wDOLb7cmmvVxUGZUa0XRZDVgFWiv23YoK0YQZsahwHuxNmOAuDVxNr6a0n0Urxt0G7bGr6tZXj+rOSnwJOUrk3kyIGKTC5CoWVABDW8cpeW7vp0l35AvKyk0C8VmuRdTjPy04mt597PjmRZK6X5CZ9ArBOCBymXeA86Mg4vW2AEFREAOhvTiQsPsdWb01J+ALnM+7gEP1ya8Xo6ER7Yu2s026cLXs+gLqj12XZqhvgSjHaDM4m9wUi+wF3HIaOdhIBInLJdHzRfyozC5gU0qAtXQ8Uzh/JqZVtIe60913OBNZDvRK3Or
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?u6uyZ8CP6ySrgtnK9Yu0CwjgB8qgkEC+uV4/KpEs6oMRRFyRvrLnDOnaPywM?=
 =?us-ascii?Q?lnqAH7ctGd/rOYFkW/Sk5LPjrhnyv5ok63w1ZFcEH+13YjcwzHpLCpLBO36d?=
 =?us-ascii?Q?jwPRKIztAEc1Q5kLOOq6wHZdV6YNT7xBchncYnHZlUOVnCwoyQpVHz4GlBs3?=
 =?us-ascii?Q?ZkyzIPLXfFg/x4PQ3poF25mt0Hm7mkg7VcLqHqU+3G1S2/onzOwsV6qDH+en?=
 =?us-ascii?Q?TIZe53JiF5LUFX8QW9TMTmyk6i/nqvZkWHuV9JLYdrA7d5sFYObvRCzqJS0z?=
 =?us-ascii?Q?Y3hku4KHeJ3RmMosTup31MDp9rkD4s4La8ADrNINc3/sWssiEnFRpbuQ5teK?=
 =?us-ascii?Q?hF/6LNvZbALhYTbQ6phMg3URdkFg5QzhsnYRHrlSSET/jj6R9e84NYLQGlES?=
 =?us-ascii?Q?5U5NmBKpYmBaHiVokNosCdpGmKJ38QlQtoAzjYDQ4KRqoQhhc5ZoIujiFv09?=
 =?us-ascii?Q?yZbjYEI7Ak5LUWyuO0IG2lnYxLj1GaKDO8v73wuUQiQR+zPczC7f6wSXaGe3?=
 =?us-ascii?Q?IR4BCcKAxnQGboOw4K1IcKZjDOjB9qCTVtrrmb2cmWI1z/bZ0z6IQUHiWh90?=
 =?us-ascii?Q?hoTVet9QlIpow7Ez0/CEgBRunfbHK09BrD5/45kxprvwI/WZBaHzYG2QVHPl?=
 =?us-ascii?Q?NKasedEDNobxFbFBVOiB1NnhHjLIz+OS8X07OLslF+/ohPmlOnWDMta2lyT7?=
 =?us-ascii?Q?6esPhELXnsc9VzSe8OBSc8wknQY7k+Hu+G/x+F+Mqq5oh4pQjPLVQ7MGzbsu?=
 =?us-ascii?Q?tjfOhcYY/+HcLaTnhFgZag++9Q1mfDQhK7rLPEx5upwqLYkDkQ+ORtQe7Upl?=
 =?us-ascii?Q?ish0xox9+DaH4GKLGBfoJW46QrmRiJOZ91QsOI57wAEus7Z6uR0j2iEyElKH?=
 =?us-ascii?Q?kggD3uGINk7va49aUMuzmAjT1eN+0QaMLjkhA400hwuF2vzKMI5skaDS8Xxh?=
 =?us-ascii?Q?Q1vx7LqPMBC5eq+tlByzn72YYM1s8YdslNNT0er6YpSxAD3YibTrwXyQcMYF?=
 =?us-ascii?Q?qrItmBY5pOeUSkM+fMDr+toqcXWn2qWQCsx89TJPnlT3xk0Ef8xuDPHHyBI6?=
 =?us-ascii?Q?/MZRY4ym+ABJCWEwdBieUH5X99i5cCkmMi2d0NQxvBqbMXOg3zm8Lu+8Wv4t?=
 =?us-ascii?Q?QlfQreNofu6eVeWyl66xrceWpczZSDhRAeH4z7ineQ+J88ysNeoKRCZJikMq?=
 =?us-ascii?Q?0bGv8wr0BrmZ35EtsfMN1wtaNwK8Ahhoz1ikkMCd4uHLI8LK3ri53rTb+Ikb?=
 =?us-ascii?Q?yP5+uuHd96nAl20J/gM5+3QnRLUL0tcBBCMjEbAF3uUc9Qy3mSIoy5JJaML2?=
 =?us-ascii?Q?Qq44JEZGSYqjgpPKixrBoySAq+vKRMXnsDsyECUNyT1maZYHoIRGlGGVrC9U?=
 =?us-ascii?Q?/sTBSk1NBf9lCVLo1NIxoozA8Mlan6Flb+ONHWODRB4/N3x+hWk3Jem5SKnJ?=
 =?us-ascii?Q?iKzHoFWBVxnmDzMBOr7mJMI8nJ6a4V2lK0MhzHY/L+9nbqyPgt+q3kSSVO3y?=
 =?us-ascii?Q?B3V2IPZAsr+VFHpbIa/mKh+iVOk2GQICRprhdhfuDFDbw4E+iKYTJSQTEl/C?=
 =?us-ascii?Q?2oqCTOkkXfPWQcfqRWtMXf7jh18Gp8gqD3IPbCQp?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ebd541bc-e986-4bfd-30c4-08db42439570
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 uqvVYSVDAAHbhVBFLg/Z2fPOxz49ZC6sOKke9ot6mwp+VHBw8grOKO9vktIzmSZ1f0mdVyERoQ2slTuhIvy34A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9913
X-ServerName: mail-am7eur03on2086.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: EBMuBzZTKLoX3wcyvyJlCDg11WfpW7ma
X-Proofpoint-ORIG-GUID: EBMuBzZTKLoX3wcyvyJlCDg11WfpW7ma
Reporting-Meta:
 AAElkQXURtiVqTrvJun3sAuRaiitLgYnvY6XIECoTFspFMcGKfuxRnJHis+5wkpr
 GFiblEyBhI8L3Zq1ooKH4KoVSoftjjBSxgdJ6jjdvZz1vsAgBTenQVo0viLCygOs
 DqJ7b79keHNnSVfm7VjfbD6jB6XolQHny54Y9BT4MsGeagClUjNQy7/ut1B8nFWD
 58FITnCcbRJp68wx1tyPMcT4Zk3viXriiZVqewqorFebQ8nKp0pIsifsa5FONKKT
 RSLFgwJVZPjJcoV4DUGNc4O04/0wqrqENBatGDiOIMRTLOwLMwoutpAe9A2t3jSH
 yX8i1czTanynu5KiopICDXuSWOyYsmGUmQl0FFVPRytjtinuQYQIFjhFzwW5Vj6u
 iz5IZCZYJwrG2HAobNulQGbo3D+i9AUkWp6abu9NKDVoehCg5oicXyrqiFNPl9M0
 No+DETuugbiyViZfIFMa/D0X9cpgucl1UP9DOGGjN6wbJ9gVk/EWYO8YvbIUUVxZ
 8oV18SKjND/ORTiXoTgxH3C2KUfx/BoWZR/7dylrXs+k

fstest generic case 266 272 281 trigger hanging issue when umount.

I use 266 to describe the root cause.

```
 49 _dmerror_unmount
 50 _dmerror_mount
 51
 52 echo "Compare files"
 53 md5sum $testdir/file1 | _filter_scratch
 54 md5sum $testdir/file2 | _filter_scratch
 55
 56 echo "CoW and unmount"
 57 sync
 58 _dmerror_load_error_table
 59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
 60     -c "fdatasync" $testdir/file2 2>&1)
 61 echo $urk >> $seqres.full
 62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
 63
 64 echo "Clean up the mess"
 65 _dmerror_unmount
```

After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
verify target file. line 57 run 'sync' before line 58 changes the dm
target from dm-linear to dm-error. this case is hanging at line 65.

In 266, md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
do journal job. but there is only ->j_num_trans+1 in ocfs2_start_trans,
the ocfs2_commit_trans doesn't do reduction operation.

call flow:
```
[md5sum]
 vfs_read
  ocfs2_file_read_iter
   ocfs2_inode_lock_atime
    ocfs2_update_inode_atime
     + ocfs2_start_trans //atomic_inc j_num_trans
     + ...
     + ocfs2_commit_trans//no modify j_num_trans

sync //no modify j_num_trans

_dmerror_load_error_table //all write will return error after this line

_dmerror_unmount //found j_num_trans is not zero, run commit thread
               //but the underlying dev is dm-error, journaling IO
               //failed all the time and keep going to retry.
```

*** How to fix ***

kick commit thread in sync path, which can reset j_num_trans to 0.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0b0e6a132101..9929320bd967 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -408,6 +408,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 
 	if (jbd2_journal_start_commit(osb->journal->j_journal,
 				      &target)) {
+		/* kick commit thread to reset journal->j_num_trans */
+		wake_up(&osb->checkpoint_event);
+
 		if (wait)
 			jbd2_log_wait_commit(osb->journal->j_journal,
 					     target);
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
