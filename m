Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D46CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat, 21 May 2022 10:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HVq4Atxx4rvn+d+qMoMWcWjIlse/jyN7NxIV1MgqIL4=;
 b=uFsWbtpFA3BHFVDgrC66SrvTxbUsk3+H9mweMZUItsqc1Z4qTZ0fgCHN7ibxcMzhGU6z22WOzk/J
   hbt20JdMXOGyyKy/XonFaDzToIlOPVvE+kXVmQOhTGOJYXdt8cChVcBxWSX8Z7rgw3YpxCYtWdvu
   HTnPntIcrrOVmJ70vTA3/dkIkVhlFrd7DHuCWi/ij3G9enaMt3Xppvs/fvNsYHCiBgq//cxzKh+Z
   UvhIchRlTMZAoyFbyf/ior0pN+33G1RfEOcdhF2gP8f2n2MLhCfBBZh3OY8xR7H2UjMgaKtCQhkB
   Wjc7WiRM5DXOojC7X0Wkc5ilI60DFhCsa0YTAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HVq4Atxx4rvn+d+qMoMWcWjIlse/jyN7NxIV1MgqIL4=;
 b=cVQ3/RyFRrrWxVrezxMBBdEwYjFnCiAcATvWTpdlH0XFsDiTXZaDufyQ16i87OP5Y7lNKqvc0xOx
   j8LX6WNn8NUCcjsln+KBSMU7xzTUxYo1+WiRKEtpTgz40AgTa0WVqMxQqIavDOzqIDdVtF+khoNW
   EIcoZqEjflrFP9jSVRG/uMiOY1FNOQonAYJAmWccetNp2Einh8i+Q4/OsiMI8pCJSFuokqIErZ56
   uef8QZdLu8ClWdQ8UryoFPzPOqTuNTpprvmuITtUwZSJLiexfFfXN3WHl2HPYmqtuHSLqCp+wr9o
   psBJ+Ii1txGWdpMPk3FFKtc8C44EZ+3bUKLW3w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC8005TQ9SQU7B0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 21 May 2022 10:14:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1653128071;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=oM3c3SD+f06uAuuWzZm+Y7lk5IAciOy7GKNYczD8edE=;
 b=nBlYiu6i8IalbUiqZPvlPh6NePiYutx3RPipaq/7QKVONzbxmipkhmAsSyBtHiy+0uFd0o
 HMT3xNPKgElXhD0/Y3TZ5wI5B0b7q5c7Sj4nnypsFQPDh0zJFRaJ107CWowLbnqGrChBHM
 xm6SS8aZ0FGqm5Ctlk0PfebMLQeOeuk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVpqXlfnRT6UrHcEDyyvKLu+g43WfKqLMO5gBnngb0osH733HyuE5Hm033+vg/mgXowyJ5PQ1OVAHp4Sxz7P4tqdF3FYVwP7+/2NMK3gvV/XxdLVwp7kyB+nUfYLU+2n0/7+t1a43H6BlRacXhV7bT54rJUIL/iic1pg3xI+iGmIkyQA59NepwQtfQEfHXPqhYqQ+LVezbj1MnAj4pRBl9fMhfMatYGZt1H1tStd4kHoKQllhs6YTyJYGzVaTRaXdN63uCslDwG9DcnhvXqEDKLBzbNLys8r0wNTQvyn4MQ+U4X+j8OeAgXWEAWRadB/XD6P7vZTDgNPcBsiuo95yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVoGT7V5+TVxzQa9ZeiOlvjxQriLH60Wh/r2d8qmfV8=;
 b=AHxBzpbdM/BH2vId1VIGCRBKhXvIYgn2shyi7/VVjOtfhB5iNed8J/O1OquESnwrp8ZpfZRF4I9s7mHCBIB8zwG0vYK9IVUAT65rBBRWgS3XwdT59pGXu0p0dzx1fqa+NXSV1vz4PunjTvrA/yHddS4mliHvSEL8oNp+gKwi/gJ316life8UAdzKzJF90WnnH5+3Fl33RYkcklsmkcmfDR6dP7vO6OA/rk+WyQvNKCSy362UYhEdi0tnykNuK9r/IZXo8zjDHT8XKR33TBnT+L3PcZLLYhaxtytzBxOx/hVWYQ9EQkjkMXCzl9q/mm+o12EIXArNsfmJ3rYFWRz5qQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 21 May 2022 18:14:15 +0800
Message-id: <20220521101416.29793-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(86362001)(6666004)(38100700002)(508600001)(8676002)(316002)(6486002)(66946007)(66556008)(4326008)(186003)(1076003)(83380400001)(6506007)(2616005)(5660300002)(26005)(6512007)(44832011)(107886003)(36756003)(8936002)(2906002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 10:14:28.1176 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10353
 signatures=594197
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=616
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=164 spamscore=0 adultscore=0 mlxscore=0
 clxscore=182 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205210062
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix jbd2 assertion in defragment	path
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
X-MC-Unique: GZ833OmZOSu3yOeQnZum_Q-1
X-ClientProxiedBy: TYAPR01CA0203.jpnprd01.prod.outlook.com
 (2603:1096:404:29::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0efa0cde-371b-4b71-403b-08da3b12b037
X-MS-TrafficTypeDiagnostic: AM0PR04MB5556:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB5556343C62E255623F2E17A097D29@AM0PR04MB5556.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 bCu7Z4BQy1xHiS35lkHzgTe1yY/TNRjRD8jCB/XVEeYBqzuRaBg1CSkBCP3AZj/q0Z7YPpvufSLZ3vwsN3wzHxWoMOjsv8ToS3g6gp+IpJZDWUwq7xKwGSb5WMS4yE1xAHthh33Iy+UOv3APj95+DS/f/LldeWuXSm6vr7Dbq7tBij0v3pClFAOv4UU9Bep7nuYR0tfzRsLI6+TY1luCrHhiEo+9AoLKS2198WWB3+iY5S8NleAoQjRO71hX7gyYzHZcZ71NWGaE36n+ODkFqctrA8/gdcm5rZsMW9idkKL8mACsRjvoX1FrJd32j4bomwNtWv78u2P3CPZ7o8MGR8fvBBhg/3JZB1Ryw9I+7Ma9vqhyYU6zLE06wT8TmRYYkPSTpHWiAJOrrZNSysdXKmPcWvPZhj523n6eXcHkXjCSVWSBc9RL8ct0q0lor7ntfpR/A4MJV/kfEmPrgeObPaNOzjHv2ewGZzu1wWCy2XH8p6nBO1A1UKqc31aWSb+krejZ1m94IAJMC/udumNEZm+z2paz9StIJnu139mvs9OzYkVBSQE6+KtTkqhovAZURBng2zz1bYIlaM6z7iZFdMlc7mbWXLs7kjdVkWC67/WlmJX1R5dSE82n9J+zakuih9m6M0kMxM5SCI86wxH7Vw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?5VxkuGaVOFRCGSalOLp0SITFexfX7xQX2egbtsxDu79RdA8lI1OEvuwO7V8Z?=
 =?us-ascii?Q?d+A77zdor+f6Az7PL/YfzwIf2y8z2Nb64ubid7uigojfabIP/x0Hxe0Bz1Zf?=
 =?us-ascii?Q?iokMCMqej8iuHGl2FfnVq/krPk3dOGPYBlYXN9WDjvW2+LbJyUqwT6jEjAOq?=
 =?us-ascii?Q?BiBKoGWn8wG7dn8LMdz9AeoANpRHxUvWEpgLwGWFcybMT/6/WxB00tTdCVnX?=
 =?us-ascii?Q?/uS90cN/yZq/9qpB567sA60I3X3RBRVv3Q60MOnO9Pq4DawhFz7Xd/WIH+Jd?=
 =?us-ascii?Q?UGowhfhJovjEVIbD7qS+GObJ3ZRa0mfcavrAkuMlq+/pHfAsh1HseggWDpYT?=
 =?us-ascii?Q?s4hYlIaM4nRxlK4m6qlX/V8RALiJewKd/8SldRAGq5hdrn+N8nU2mRrnn1+t?=
 =?us-ascii?Q?HL1zx/CSQGClNZehemsGpm86BoOEu8+4Ex6QJ2suaHU2zR+Mqw9+gua9SsDL?=
 =?us-ascii?Q?Sgvejq1MW1e7rhteiIDI0JjAGPEKLy8a0fd1lddp1Cx+Dl75JHADpgQL0gYO?=
 =?us-ascii?Q?NUESr9W49afYW6l1eEBmm3axY+blFgdLfoKALWKz2T2/0WaNYuYAhf8e+Cnu?=
 =?us-ascii?Q?grwRJCn1fnyFO4wIMSjsIh3Epf/XqMulY8y9R7Vf7logAcU2PKmQFoZse8oE?=
 =?us-ascii?Q?pn9YICYYoBQWbJzkZ4mpRf9Zbvniblh6FyupmVINH7LymD7JOfqZSk//f3Qg?=
 =?us-ascii?Q?jFQq1mGzUanKpEHDICwlvS15AW8cIZyxzBlmutD0oYJuDHSBrvNqnxE69Rw3?=
 =?us-ascii?Q?U9YWVvbY3y8VeTA6i84uPpaH4nkK5HurwyNZZScWtai2zOH5e7irLPCt386g?=
 =?us-ascii?Q?W2bgp8B1lI/vy2+5xqLfoNBE5rBWUzKbNShs6xhyu2WYEHfg4PcoAFGCqYWb?=
 =?us-ascii?Q?Rs76Sgg3saIxfoGeMfKjVTStABq+98B6QucPAuY/JOVMIMvHRm42isZo+0Ma?=
 =?us-ascii?Q?K181cmk3IHMA11/dVaT3Lbo/vQ12j+oGsDEPRUHsSdwrpYk55shZg4tD++Aj?=
 =?us-ascii?Q?FUiThZyXAby3KXMA2nC+KQxMMf1+jmJW+0B78EEIFBy58Twftpxte8iuMq+r?=
 =?us-ascii?Q?qIfK4s2MNWfxxs1xDiPNrOHGw+nyehg5l/Jcu8tU+NWqeCfkRGcM6l9BkMxQ?=
 =?us-ascii?Q?UydtUygD9OFKFX/8+pUfaWTOCMLxam9v6xWtJpx6RfiwKijWXT3Zq0QrDgEl?=
 =?us-ascii?Q?5pXeuXb4LyozWvWHiTX4l8E+4M9C1on28gW9RYNcluYFh5aGcg4rsTqTcCqx?=
 =?us-ascii?Q?6XrjCtltONnzSP0Mp/86PzSJDP7HW8lJP+tjfuQTR46ymj7fB1ids/e22DTX?=
 =?us-ascii?Q?y28Douheb8snj/XANrGxYf3b3oTMU/XkqJjqlOkanka8MRdTcsxiYifFnmik?=
 =?us-ascii?Q?VqM+HKlzM4FR6HT6WuIcajuPtPmiWnMKtPI2AAyfKJeCEMMKqHqvWk8S1rJP?=
 =?us-ascii?Q?wxWL1oKVT0G5ycm9jnyc1weXBeywNvSeQ1tr2DUYpw1Loth4fK+Vth2dKg8W?=
 =?us-ascii?Q?4Jxx0Sp7pTdUr4PQd7q6lf8nP8gCtuBWLYCqiozyme0qY6ernGI+0rHtu9VS?=
 =?us-ascii?Q?iKhKJesBu2U7VHowpQAea0qaf//OWKL9r4UtiOSgUJvO9WRbzDhBIN7pToxN?=
 =?us-ascii?Q?iX4YnjFHMDGAetdIMODoSs4lzWYQdjJyuJsb8ud3gcBndM7kHihmFA6zRX1J?=
 =?us-ascii?Q?CREPMdoZzx30G54V2NfpMG/RZrOEwtMQrpXmMcMSocfu/iycSz2j0bK8Z6sR?=
 =?us-ascii?Q?1Sffl54EgA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 0efa0cde-371b-4b71-403b-08da3b12b037
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 eAm7PfeOLsgRSeKYs7K2sguNe4/jqNp/de+W3avEAedR68oUQYUiE/MBoQLsmPhWLNCooY4v42F0esPS1XAQkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5556
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: YqEXcbzkSsGBN-yRAopauqOr1I3VcFw9
X-Proofpoint-ORIG-GUID: YqEXcbzkSsGBN-yRAopauqOr1I3VcFw9
Reporting-Meta:
 AAHthZZ52wL+yu2fQ0N/tucFbWh65VhVcC5mxnxcuG8CdqwKCaiW0GHbmCkFtv6v
 xR9VjofiWWJNg5Hup8jazTnNvLxxmnL6tPhybbRv/nXeGIOYO3Ofglm8IH9YW87J
 x8/YrsU0XhTe345ndhj8hOjbvfhVDLZ7HfgNDN8JAyDSbG1hfO5Svl/RHQ+eduvC
 pkxj/uOmNj0zaBwGnX04gNPWH4NdhZJNCeWfONjggNY/bSKRZtcMM1uCBhcBRxj3
 Z9SzWAKxzg9Hfr36EbSLZBLj5zs/Sbn7pJzj/zUkfjQXmOjL9/CrLi0o8KhlwhlL
 4i6udLezGjoNG+bYZZGbfc2Cf6qSxeRKO/9QuTQE8k69m0onvuDTdUXUhZzzSGG4
 qacSosMuLWzZ4NbxVVPNrfT9q0cKHC1zS9Om8D4RAvMlHFzBcg1qrT2B3xM026Ii
 nyui5GhyoCye7qtT3CW56H5UpMn5RAKvmxtukKMgs7kdwiHXrU1FlwMn0HXy0Wjn
 kn1eu6vOWIukiwKZbYkvhjXRgnWtuUSMeWhHtdN7W8/PoA==

defragfs triggered jbd2 report ASSERT when working.

code path:

ocfs2_ioctl_move_extents
 ocfs2_move_extents
  __ocfs2_move_extents_range
   ocfs2_defrag_extent
    __ocfs2_move_extent
     + ocfs2_journal_access_di
     + ocfs2_split_extent  //[1]
     + ocfs2_journal_dirty //crash

[1]: ocfs2_split_extent called ocfs2_extend_trans, which committed
dirty buffers then restarted the transaction. The changed transaction
triggered jbd2 ASSERT.

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

The fix method is simple, ocfs2_split_extent includes three paths. all
the paths already have journal access/dirty pair. We only need to
remove journal access/dirty from __ocfs2_move_extent.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
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
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
