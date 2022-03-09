Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC597C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  9 Mar 2022 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kAfZ4tRQdvDGi6WfNNlfdKL0fhhQ19T901oDZI16OZ0=;
 b=nRf/b4QIeWb+CEVrUJFXC4acJ6YbUHeAO/LWzHQQXTWDzXCAXn4+JdAWp20Ro1Tkd/TAx8ReS/HG
   6faPNJ4bmNU9Cn/NRznWGICy4zMeK0IYLQcxwmWDYnoSKZ9ZFKm7Eh9lb0zOggKfCAu6J+dj3ySK
   SNkweUCqmaoFUalb0JT5fVtYxmAg65VM2triQoSYBHHHoF1IEQyb4xNt+KeyhSMEPBV87LZjk+7O
   a1zyQTVUGW+ye1XFxV7JM4toBU9qwpLnaRzF9FYJ7+XohKq1/htbPB8f8m9GpZpecDsAXjg3xBk4
   sRxcIxA8QdaqwiBFS+vfF+3YQSST9eoIwBtF/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kAfZ4tRQdvDGi6WfNNlfdKL0fhhQ19T901oDZI16OZ0=;
 b=DyJvq/MenhuWk1dtZmynbQly/IrLhUgQ/wQ1Mu+tjlvACKXTGKwwIHQYLLq3QVTfkEzzVM8ECLsp
   f71Q6cKj2S4rPYpgzClOGv03UwPcV274FRTbkSLP/9RmypbDkepZ/lvS8t/m+y68C1sCks+niwyR
   p++BEMgrk6xA/mmZD3pTqewjN7ITeGPLu+pfsi/sKq8qGO/4EY2wN6pi6Zjoc5OLNctSOyjFwb92
   qSOJtQLp/EqGxIz+piACQwKlWquHc6CobVT4OPODQcp7LXa4rC0PHNjBOH26gQtQgTlepAsyWTPT
   c0p8b8vNE60r4FiwtYwbBboPlaZ84J+wzuM6Gg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8H00BPUC7H8T90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 09 Mar 2022 13:30:53 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.d=suse.com
 header.s=mimecast20200619; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1646832630;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=qSGREhj5RS+vzsMu2iXzI65/ectcrG6IViLSNJxILoc=;
 b=i6ljH0B1neW8Rc19/N4EY1l2v31Y8lihRMrNIYvnZjrOKdrEFsbIN30LbYfQBoV82YdKDC
 C+O78uMfJ+Yz2CEhO8fd4SPwOXSRck5pygKzNQ7ae7QQ030R64FtYLLUONw/oFkgHIC2MH
 E7N12+dPJdBWJsC0/xHUXC16YobEmYo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjOKusGQnYZmQRrbsVPufV2tcoh5Vz7CqSNpjr4OaknZ0kbtElUwYS50vDT/JLM3g8q6r2Zm1LPEYKvQYcayhC9gWoo9XhaXwt8juIh1c3tT6yZ0YOclMcoGR9BsIUTczFlN4Ew0Wij9nckH7OSU6BRMWZc0VkTOfrUJwMXB6micMkuQ7nIN0qtl3L2FhCSnry9ZfrrBB1no7FHBuudLpYPbCv1s2SNSCna5ztVZycei5aKL++k5kcgRCR5o87lidF1necpaXIZfo5uvMzTBoOkd7lRlkVnTEutGEPAYgBBDZK0qHFNzEsCbwDf8yp+Ms6GSwX3oqFBEpHUDQET0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiFaKCvG1PvgKkcWw+2Z8GpDZCm8GJqns5sfzjjyXyg=;
 b=df2wZj3ZOWEMAhSLbvwvCXAfT9T1G2UAfo58gHmejK9LVuXXu59TB0R/4Xha3Er47Vrr3GGGZ7OKg2YFNqKDsQcPjNTffMMktcwK2juhBHJGYg92vZRE7K2hsLHohRELZSFIxlUJUG3QANZsxf28ZxvY9qrmysURLIAYDdODO5bRX/v9uPN1an019GpWYbNzyjsXULGf7RwPl7qHveeN5/enq9kp7MsJYtq5XpsXDa3mIDbnOJGPwPB4DsNj8Vv1oqrj6Ky/tBBdTU9pEp5x3TCIFucO0GJgFTGwNg92dpj2I90kzYYZ+zUd7hNlOL8ksmZX96KbtbIeYFc4B1hkmA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed,  9 Mar 2022 21:30:20 +0800
Message-id: <20220309133020.1869-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(508600001)(6512007)(107886003)(2616005)(5660300002)(36756003)(44832011)(6506007)(26005)(83380400001)(2906002)(8936002)(86362001)(186003)(6666004)(1076003)(316002)(38100700002)(4326008)(6486002)(66946007)(8676002)(66556008);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:30:28.4087 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280
 signatures=690848
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 adultscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=169
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=243 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090074
Subject: [Ocfs2-devel] [PATCH] fix kernel crash after mounting when dlm	doesn't
 ready
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
X-MC-Unique: nEGQ4H3fOyK9Xe3f34FlGw-1
X-ClientProxiedBy: HK2PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:202:2::30) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52e99046-d4a7-474e-bee6-08da01d0f9b8
X-MS-TrafficTypeDiagnostic: AM9PR04MB8826:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB8826CBB1DC4CA0F2884287D3970A9@AM9PR04MB8826.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 yVTxL1rhWnrNhUmAGxXQ4ikAdddhy3B71HH6ryJ5bfnEq4z8FZSSg2wY1XADPEuUpO4PrnoTQ8S3+KVKyqVXfzbGqPRSd8/iQt2zwKSwruwUBr2MlApJQhEbjLfpzyaknsy4bZhhx1xR1ICL1iyUxm0x8dDKqAOynORvOL/AXNBwwOmx3AEq8eMWXMdz7qy0wMnXMBIbN9W1fsYCjGJtTO8IYQ4H8oq5oJt2Z5dfQqYrcUX3Nh6JBex2tWJz0pCvbmXKZl3U8DntdMEtU/hQBNEtr5ZWqYr69tDMcKaPvgHvupErYnj64bV3sE2ywbHYjeq74CdHQXmtS8qbjIkKj84mOpDgZjgRzJtiOamB1XCrNh+OEGt80nmWo174b7abaL1QP26E+O7J69E4cC5L91i8ir7epeYn/FxtSNE0g4Vy9YLzAXXSwQiXu43OeNlIrUTQkjllTWFO0lfwZA3aF2AH+dKg9uQqRIAkJaWZHH/1H42KfBv7cymKUqNhuTxSKMoVsxRL8XGFTThFtkjx7/aXu/JWyc5ojttOEHWYN5uStDbao/V2LOZOcoe7OmP24oWqK+GHtwQOzQ9PgpZz5pCTTx814nL/ohz9zG3YU3UpYUiAgxufng8OpDxOFG98MxTyZrUlLsin1ZhRL990nw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?f+ypSP07b4n4gzUTUCHsydXGTDOhTN7kjLwcRw028GAjlJMfihKjysMQtfJb?=
 =?us-ascii?Q?tQuRASavXgZl5QRnPNpebGIu1bA0166Ulry3XLrMM5Y0BO1I3vKyHUAOksq+?=
 =?us-ascii?Q?xLUytR5M3u0IaXwpu2M0XtQIL0r+Kiq3ZKEOsuK70pDd3XMC+wGqxBmio1Z5?=
 =?us-ascii?Q?rhX4nT6fM0F/EuXfRzvc/0QgBEIp14fKwW22oFHAZjy0Fkx8wB0RSQdyBo56?=
 =?us-ascii?Q?QVz/lmUZoYcbceEUqpS34nKMGot69rp9pDuLigMi3Roz5kMFKREoQ/FeiPji?=
 =?us-ascii?Q?t29zpwj38iqJucVp2NyGsVTyMnSyUl4h/Bf/KA+v7AomrTZ1MWYqg3heSK8B?=
 =?us-ascii?Q?zt72f5V6pHk0rDpZepyv1qg6Jiib9cwPBpUvpgwXdukdWiG0acjHoOATIn6t?=
 =?us-ascii?Q?+BmAR57jiI1Wly1fBEYust22/SFbD665CVLdXC0so+Bk58oPa1jUPHexdKSO?=
 =?us-ascii?Q?YndE2K6fmMm5qoywk07l4ysKBy3p+ZrfeMROH7cgMrmpuXmB8h89YhhY5Xv6?=
 =?us-ascii?Q?nL/zhwygBb1oJQcoSqs50Ai4pk+jBGYdmPR9Qg7hiKIzaXOO8zJa7A8xM8dE?=
 =?us-ascii?Q?CGlEz8h1YVB2Iv09BoiCBGVAeW1AJdwHVQhIMg/pO2Vw4zF+Kqr9NggOfrDm?=
 =?us-ascii?Q?PmFQ+qxFEIgT/zB3MwA2KxqkDM9QjyGLSl/dt7EeYq64zKNnvX3INJdiC/++?=
 =?us-ascii?Q?34t/fLIog+nQOlbL1knnyODW7aNuHQ9x6NfnCAyEPNMvXQazBzFHUMUYzY5S?=
 =?us-ascii?Q?XWXHtyF0ZFUwg1jL0b0k28wHFE2hL0xeQ05IpZsTIuGoYkg6MFfte9/G08Q4?=
 =?us-ascii?Q?xyN4db1qEDhkRniej/85bBHmQ1UgjGmXzfIADngHuDDESyYbuhrNKNbmfacZ?=
 =?us-ascii?Q?67QgyffQZ8F+uuRRh6sDyFKAZcU5cyQavrCRUjwwkG4WV3hZ8vownnvknF34?=
 =?us-ascii?Q?XQuXreaEhcxo4nDlIQfY8UiPOjnzp4QFSU65acxiJWcNFyrO1Ik/DNN2p2cM?=
 =?us-ascii?Q?e3E7botmkoZQmgcpBXEd9Usu6m7gWXjm7R42HScJ7+olvffwxsxGorwC9tZ3?=
 =?us-ascii?Q?usnufjSf0sy1Pi04Xh+ZEeldjpW+biE1Ebb4ckEosCC4E9E7ZZqH0czi8Ea2?=
 =?us-ascii?Q?1Cne4qkYqQiQCEN+fwva6w0iLFxGIlQvdNGEGjMnC0fCNEc8wbK+PAzqGSpo?=
 =?us-ascii?Q?Vku/jHgRNmfj2fSMTIQGcYsg6v2IyVPYusm7mokWiZFumpd3iwHBa70LaPK3?=
 =?us-ascii?Q?SrdWPbVlNjvLncyrWRLhkukfzbI12O7WiWtuyPw7kq9jB5Y9ET66zXVlFIm2?=
 =?us-ascii?Q?YpdS7ehIlibN/ZK0y/ANkj2RSrVd8BeFhvB1MYdUfRICcSdgFNeXH8GUQR6C?=
 =?us-ascii?Q?731P5FTWBAobn8wV03xaURrS7gwhbwx8sFQ2Wstv/TZkvLRn2BOcpL2NQPWC?=
 =?us-ascii?Q?04dklza3TpmrsqQoDp/DLZ11WDOTMDzfNn5YGW7vGCF+qDSdU/GBoVLYelyg?=
 =?us-ascii?Q?uuQflY/CcBajw0lJQ9pacr8v2vheMcMEIH8+YPqyQ+X8m7xGCQ+OwTeFNOmq?=
 =?us-ascii?Q?6Qp4kryZXy1/iGy6RydbbIqmqouBbz0vAfTM/UvxVLqXJQ5SMgbyWwZfwfuM?=
 =?us-ascii?Q?/vucJlXlA5pUaE/5pS5q0fc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 52e99046-d4a7-474e-bee6-08da01d0f9b8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 zlCxTdtVidcfE8y7hp3WT1014Hr5Z9kQk7pGQ9yVRw0xHigfpD5DeU9hYQRpJ8RZnzUuJwJltVQCs46IjbTi3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8826
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: tYd_DAUMPxS_JLESzeYkSdVtJSp0nH-f
X-Proofpoint-ORIG-GUID: tYd_DAUMPxS_JLESzeYkSdVtJSp0nH-f
Reporting-Meta:
 AAHQmOxzn6oX3RiZvFcCIs6XOw2gokawRvIXKI2GMcmZ9tEJ+voox/AeG/N+kBag
 333CS+r/3mc6tsi2+c9Zg6rHFoBOc02EWYH47MX31mXfjcM58yAQl5c0VZ7ocUjD
 gWDENvZ3VzBDrVMi8LIJs2h1Waw+sAuBXBuhWjAXYSs8ND6hpEkj/xHNZJ1npOSE
 49bRBOFrnhrf5fDiIR6DZEgYu7nP67J1VRbUWw1cqNq9yB68ulPdT0vXWm68RTRc
 DwW6xAAVxOX6YMIu3VXvvLqC3R2Mm7srBoJJCA74F1IVVK6J+XT277pr1neM9F91
 EonLFrDZiP4VRxswuICry4ODJHixcwVgUNBWdZDK+oIEYQ3wbV0FoSmU6Z9Z3wz7
 eBK/s4pxDzCfVnwnrHGP9hy+6sLJxHcYZFCqqwKP9sCGlK4Mi5nM/L2AdZjWw9fJ
 t6HxlYgGOEZz90GLjdK6C8nxqnf/hiaL1hfJ6q012fKUMLXyLeYtI7tcYTMI9UqA
 xRtqYgX1cnGb5rbMYeWp4wQRHx3Rl/gkWQg5YQtFPww=

How to trigger:

 tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
 tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
            --cluster-name=ocfstst
            == there is no dlm running ==
 tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
            == kernel crash ==

Crash log

```
kernel: DLM installed
kernel: ocfs2: Registered cluster interface user
kernel: dlm: no local IP address has been set
kernel: dlm: cannot start dlm lowcomms -107
kernel: (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
kernel: (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
kernel: (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
kernel: BUG: kernel NULL pointer dereference, address: 0000000000000030
kernel: #PF: supervisor read access in kernel mode
kernel: #PF: error_code(0x0000) - not-present page
kernel: PGD 0 P4D 0
kernel: Oops: 0000 [#1] PREEMPT SMP NOPTI
kernel: CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40a195b7ff0f3399a616c3290f963c4ad189e84
kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
kernel: RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
kernel: Code: 24 e8 9b 68 04 00 48 c7 c7 70 88 db c0 48 8b 80 98 03 00
00 48 8b 80 70 01 00 00 48 89 44 24 08 e8 3c 50 d8 d8 48 8b 44 24 08
<48> 8b 48 30 49 39 4f c8 0f 88 ff 00 00 00 48 c>
kernel: RSP: 0018:ffffbbf000847bf0 EFLAGS: 00010246
kernel: RAX: 0000000000000000 RBX: ffff95f6834b8000 RCX: 0000000000000000
kernel: RDX: 0000000000000001 RSI: ffff95f6a1fbcbe0 RDI: ffffffffc0db8870
kernel: RBP: ffff95f6a1fbc6b8 R08: 00000ab5a9371b7a R09: 0000000000000230
kernel: R10: ffffbbf000847bc0 R11: ffffffffc0d53ea0 R12: ffff95f6a1fbc560
kernel: R13: ffff95f6a1fbc408 R14: ffff95f6834b8000 R15: ffff95f6a1fbc908
kernel: FS:  00007f366f151740(0000) GS:ffff95f6fdc00000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000000000000030 CR3: 0000000003fcc004 CR4: 0000000000370ef0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: Call Trace:
kernel:  <TASK>
kernel:  ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
kernel:  evict+0xc0/0x1c0
kernel:  ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
kernel:  ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
kernel:  ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
kernel:  mount_bdev+0x182/0x1b0
kernel:  ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
kernel:  legacy_get_tree+0x24/0x40
kernel:  vfs_get_tree+0x22/0xb0
kernel:  path_mount+0x465/0xac0
kernel:  __x64_sys_mount+0x103/0x140
kernel:  do_syscall_64+0x59/0x80
kernel:  ? syscall_exit_to_user_mode+0x18/0x40
kernel:  ? do_syscall_64+0x69/0x80
kernel:  ? syscall_exit_to_user_mode+0x18/0x40
kernel:  ? do_syscall_64+0x69/0x80
kernel:  ? exc_page_fault+0x68/0x150
kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
```

Analysis:

ocfs2_fill_super
 ocfs2_mount_volume
  ocfs2_dlm_init //failed, journal still doesn't be initized.
   goto read_super_error
    ocfs2_dismount_volume
     ocfs2_release_system_inodes
      ...
       evict
        ...
         ocfs2_clear_inode
          ocfs2_checkpoint_inode
           ocfs2_ci_fully_checkpointed
            time_after(journal->j_trans_id, ci->ci_last_trans)
             + journal is empty, crash!

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/inode.c   | 3 ++-
 fs/ocfs2/journal.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 6c2411c2afcf..3826ab7eab3e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1205,7 +1205,8 @@ static void ocfs2_clear_inode(struct inode *inode)
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
-	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
+	if (osb->journal)
+		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8dcb2f2cadbc..1610d49b4112 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -189,7 +189,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_mount_local(osb))
+	if (!osb->journal || ocfs2_mount_local(osb))
 		return;
 
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
