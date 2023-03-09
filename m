Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CA9C77B77
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0UqBlUdkZ4IvlaDX6Is2GTZxkpci9m2xfr1EuYXa3C4=;
 b=iyWoQZyS85okgvek1R+kmh9r6uPIi8OKL5mS+6aXEQy/IH5bQyL6Tj2BqmkC8JxIpZ43DzYQ6M/C
   Il0L0MYJespJMvI3xf3OX7tlnq+0wbnfavi6BSC+LoVdkqLIZCP+K1mZeGw7Ahgn+eHxudGqjjKt
   xJlwFZCH0IkC+2gIBI/V+XGRQ/zBvk9n7skvpgT1USkkmoqSoTwKt74zSDbRxiy4nqnBJ6ERqEDg
   JYTTLATDE8qio4PxOy8J9Wq9mH9MThdUfUUALuXRnGieu7eZw24VgptdB7jAPmVt0korCvlL6Kk1
   6WS93XqzDLefqB7FiQoMvIgua+XL9o/6KF6cVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0UqBlUdkZ4IvlaDX6Is2GTZxkpci9m2xfr1EuYXa3C4=;
 b=Iw78HKbYssJiekCt4Xyd3e2m3P0cZuJrgj/rysrE1nGr0vTDRRf0E6AMblRDIk1JjIp4rqMcITWA
   NFxlwbYrVA2YydUV8/h7QF4UEOiRyZI4OMnnfL+J09OzB5yg6JjgH62Vov/AoiFo5AgE1dx3gH6W
   og/+gfGblyKEDEfgLC7eRIUu+a3+oMtcBsjpnFNp9SoIC38s5CgOShihmEUOKVJeBhRsSuE1KgEq
   kEsR5BD3RpfG7+Ph12PPhSwcC79gWXuvePnKcEBRSFO1hBX1se7jLdCZsxbOsajFYBWVkYsQDbdf
   igCXxE2h/oK+zcJEMXI7tMtQFrvnGDfjgCDLag==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX001WLM17CC60@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7pZHpOASzuOzmN510M7cBLn5DREd2+EAVY7KSRPJqXWaVQSt6XApt4R0DyPer1CmdfWPIFdAJpqIbZ9tlv0/OGeF3sujj6UC/vBeABo36CmcuzvLBnIyD9yEPhNH4R6X1owRvACDT8p2QqZGl2cYRRbDEuV416vZdAoszMk4DYsQJSztk2FLriId/0+QShVpp7wmzYF54oOFx1cOHMHZZZNBwWcyLwzkJS8vd7fPI6rdlUwJJUURRWr5WOmUe3I/ehjhyg3ICuBSxWS+NFuvtiUSLji24P7plUsIuWGwiajBJoIe1seNpwfqQyiYO9Px51Er2DLjufmA1HZlg5qQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvVQHptGy31XI17r+72sjhblJuxhfdQF7kdWesGYqM4=;
 b=da645OWWbUeNb5LMqpvAILCRX7m7PNr74yt3GmFuGZuC9DgcaA9MU27l0nVnz381OEGulcQvkwJwNbH+g85M8GaB+D4+FcnrG+GX9hRNUV08L2uu3Bm/wDxWjqTbw7h0gonHrgYk0gKSdKRkR2MmZ0+Baz62tyrtRbKqVvls5U5x7LjqPDCxYgfpPok1GKjlgKyRoWWmTRnLtSnI3+cDfP8ffjglnTnEKCAfhJOqGPyuvNpH5drNaz7LtA0+viMz1Qbtj2PWxCqdjSBFEdP6o1L0+xFl1Fe5FwVxH0nVPTpBKkZ1t5ut5mYIc+A98Hs/iEx1dJBrrFgfKS7miQXc3Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvVQHptGy31XI17r+72sjhblJuxhfdQF7kdWesGYqM4=;
 b=YWKK7h6xs4nMPveucItlGK8+U6IcHvpat+StKXJfKwtZOICYUycff/Dzc8AkEazv6dBr719eIMnTvdFxz71xDAm0eqGpnSRrU1y8ILp1Qh7gN7Qe33qLqutwKfCKrDy7ISvnKHym7tWA/n5WZccYNWL+RMP7XwagNtaNBQjQmN5SertXj+aa9/lwiFiPMBHicSJRUljlOUqaoBeUyHdIkJ1/IxdtZhVmfkN52ruYX6TTdbj//oaRVEIAz6cubsAnzAxMGZg4hcCQU5iEDY1FubXTwNmaaRdwOvUxcj/IRFLjFJfRn7TGZqP0d4k76n7jhMMTLYSFNxZvOIp8o7Po7Q==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 23:21:26 +0800
Message-id: <20230309152127.41427-5-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309152127.41427-1-frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(36756003)(921005)(86362001)(38350700002)(38100700002)(1076003)(6506007)(26005)(107886003)(6512007)(83380400001)(186003)(2616005)(8936002)(5660300002)(6486002)(478600001)(7416002)(52116002)(41300700001)(4744005)(66946007)(2906002)(66556008)(8676002)(4326008)(66476007); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:22:20.0920 (UTC)
X-Source-IP: 40.107.255.90
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=148 malwarescore=0
 mlxlogscore=903 adultscore=0 clxscore=104 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090121 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v3 5/6] ocfs2: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30) To
 SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 043794d5-fc6b-4b0d-6678-08db20b21307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 zB6/i5Ksh0zI4+rKooh0sNe8ZJMxEIXigfwrfaHKXGYw3SMk4fYCEsAZL2Bp12KI+OGb0Nsdj8NoG/yMPwQNKFRcH61xAs1uzNXblxvrITFrXsawQ0KCdWJ+8Zgk029xSWpJHxZX0BYMHPWmYAL4cjvXtTqby4Z+klBDWi46zIsBPu496JZ1YAv8OCdpj9MG6Wb3fValyFPKszrvAzLQ/hpJ9RZ2SKmAdcUui4mo3J/oU+QlZZxlGfMZodV23sHvbVLSo7DY4G9GSe/JGGOAJXwkvVs59Q5xEW70SCjN9ZM8Wn7xdJkWAalhxwhsfqCvLoPFgckVqfOezReBBCy5htpc7bpANdQyLvqkb/6F5Qf2CP5uxRKcTkhC/YYNykDclzLkLUx1zHtrWLPqNJJxUbhtOT5Mk9O8YxMimDq/bIGNOROjFZEz0yo7Pd1Bl8QiJ1HCFQ5nS8nuCQ/axzKq4BzK3PElS0mDN6CQXwVXQdIl9AuV3/A4+lwi8XpLGiAden8LtOMeGAOgBPWxsHVI0TgQqpimoM/ip9384jW8FljpOz+2i0CoH1glB6eXSsw9YoC+Soqe4L9MLmstKaoPbyJSvR8JjoKcYGY5PZoOZ3FPye2ZKEFVJI3fKhr5fpndk8mdxkxAqOd1vGudejoY+m6aelXr5KNmvz9HgqJxR1A/b5002TPJN+pryQTLLSbkj9KBKdpFjjPcwBK17xhkF0mDmCskl+moOI1yIA21iVk=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yv89NdnJEGQz80CUDNL6sJlMcrOXMyDVM7q+K9YCYddUmo3yTghzHnj5MkxA?=
 =?us-ascii?Q?nY0SWK60PtgzsnQQQI94q+4AH4EYnhL7Cg0Ed817s/6AH2m19TRdh2YyBEdW?=
 =?us-ascii?Q?VoJgHQXMvPQL6wejwlkgN11BTIuPq7e1S7DMjGuWUXUTxZVlWV8VwOgA0lQ/?=
 =?us-ascii?Q?iMWbF2A7fymKvlSUFIJbEPT/GPAkzWAL8D4ji9B9WqXXNdxyrUcW73cUTUfz?=
 =?us-ascii?Q?GUg2BwgHmydurYuMHwdPT57OCwNJj/grfuK58O7zN3Id698/FsmCKcQnZJVv?=
 =?us-ascii?Q?clvkhPKNln017OgN/gd6tfjoHbMDqSm8omWLmOe6/kuXzWvYpySQHYBQFf8p?=
 =?us-ascii?Q?fc+deExZVdnTXEVL8rTHB5TiZQ28MIz5ccejAxwm8fXGEq/VA09tUX5Ntbpd?=
 =?us-ascii?Q?G4+aEPmBopJdFsycyhItLZQZ5REWuyN6Ylf7EkMllqhjqCwzZTMnPlcOFl9k?=
 =?us-ascii?Q?MB0tLukNdHZlsKYvBT9mdmeE0TcF/6MqoYen8SExDcMmmQ0ANO6hJudCtDQ6?=
 =?us-ascii?Q?EHVfi8Jt3CxTyriWAfA13PdSvWPsHNvQ8maKOtlwPVym3G9rnwDaB+k2y4KS?=
 =?us-ascii?Q?wkBKDgty6XBgmjAuOku8J7aUUGAQn1v/pxFifiumrnX9AkZSsyiLj6G6PcPA?=
 =?us-ascii?Q?JlupYlUKN1CwphLbE83dU1lFdP5Bugcqqixjx0yC1a/rO7wHJOg+BN58sYKt?=
 =?us-ascii?Q?ZPiZ5wPRd8FjhjEcqaq5XUBGyCwo6AZHS88TqR+jgt7LULRaJG8ssRRIOv6Q?=
 =?us-ascii?Q?Js4aT++tgpQde6zpnT+FQfUl4EwSDkrS+0l4cB8YjU30mw6B6IWUgcQuKZho?=
 =?us-ascii?Q?d3gpB5J8680mDhPNPWfn6rRNWRWucKC40yvOapjqPZm7Xzy2hUxOcm+hPLvt?=
 =?us-ascii?Q?FlNg6vJK+JoQyshCbvqRfbpCm6NlPPoq6UEHeZKQUg1BDNERCQVILQvgA+OJ?=
 =?us-ascii?Q?ekuTE88TCzOQrFDtiHFB8MgL2AL1Ajib1leGP6QwkVMmugdK00ChzaFyXN76?=
 =?us-ascii?Q?UYioC6akZHv+FeFhgwcUhi0FezEzcx+9qVGq/0wFPrro0gryaR+3OCQ5ulsw?=
 =?us-ascii?Q?UWyxgmOfuK1CH8qGyGIH2RPgcOTWxLf91rbnz4es3n3vOFe55QEeL3gYTM64?=
 =?us-ascii?Q?6o+OhGth6NZhwdEtuxLRiFnanSogrJWatH9Y7dXl1PXwO8Q2BWWjR+Tzjyuw?=
 =?us-ascii?Q?2dJOX/yBQhUj6sZ+iMWJEWzf9u1OefvZarWkhZ7paZzLUDpR+DWZ6XMYDpe5?=
 =?us-ascii?Q?qmPV9i4Qv1SL9jE1EaidjdiktRETQg586sQn9595SVgKNRVmrmUIPj2s5R0h?=
 =?us-ascii?Q?W6hbQGfr42azSW1st0wK6QqYFiDWi7IxqlKVbL5BBLXGVN6E4lheg3JyQfuZ?=
 =?us-ascii?Q?/B3kw0KuGIKVN3P2+GKaesnJCMEQWlphW2btB3H7M7DmTIgDY8dNhPZo9rz4?=
 =?us-ascii?Q?ti8kPMo5Vt1cHxgj9L8Xa00ebNIdnyIeEl2goN1eE9bpf/pa3ueQE9GIJ0o5?=
 =?us-ascii?Q?kWF7QRjcU41d6Wb52Ye6KoltoWs5YDHOHu+2D2w+fCnQ/vSLLwMCVCToZceA?=
 =?us-ascii?Q?dEL89bzT6XhutE4O4KImJZULq/y9MxnxOIalVVpk?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 043794d5-fc6b-4b0d-6678-08db20b21307
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 sthvx/GZxh7zB21B6xH2rrvnX4bQ2COITDPfDBEiKOHe2U5sxTv4WudiIMztiuh8W/BSZFLKqj3eikuhQTlw8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
X-ServerName: mail-psaapc01on2090.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: qrKuZCnFf1E6J5iNgkv-W2IFVnZW0Hhn
X-Proofpoint-ORIG-GUID: qrKuZCnFf1E6J5iNgkv-W2IFVnZW0Hhn
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEjyIuM3P9ITye4kkUPtf5wNbwXGYRAWGIwGs97GuqHNK7Dm0p9J953nv46W1Cm
 vt+fgQO2kgqXatRd8zNBGLOSZicjPy9B5Ce8uGwHxnYP2Oq0JAveIfHdceEq/SCM
 er48qizKFPBfjBOPQ+iKGpb6CBhkH5N7tUKjT+6QVeQtzVIEA8SqFvl5bqd60+A+
 QvSjUp4ZPHaJ5vcNPimqUzG8YQbDypLcTcd3aPOW8XtS9+FCu0rBbtRqUlsTZc2g
 hk5av/ztQhw3uELHpgz2BqF64XMC3rbXbcTHnfJ2mF6J4zR+6q9KuqNFbujFRZ1u
 mdsAJGYLeg0NuSllUPNKIy/RupSNJi9x9wOktNVOBSg5iwWHO5Zao2Jm+JarRUNT
 xybDvbXmevuwW5Hug6B+H1u85jeeDHRCJ7+tmogBVVisRZY0MIw5L9cO6xseTsJu
 t+1WFI/dqIaiGBPPfNrrPyI/PNzPPbtMq+CzjeXHN2FAXglV4Q268TeT12ca/GKw
 rDg0JgvntkeUQRAg5k3r+5dLFywUYfLD7zJ2pwMhjiA/

Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
to return bool type.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v3:
-none
 fs/ocfs2/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..baefab3b12c9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2159,14 +2159,14 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
+static bool ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
 {
-	int blockmask = inode->i_sb->s_blocksize - 1;
+	int blockmask = i_blockmask(inode);
 	loff_t final_size = pos + count;
 
 	if ((pos & blockmask) || (final_size & blockmask))
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
