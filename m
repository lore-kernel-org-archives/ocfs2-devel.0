Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B155C76195
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8iOq8FePjziqubdOmPHzHwdzk6E4emxH8pWrdLq+MjI=;
 b=V+h8Oz3vQUW8JSAGo6vZ6NSd3lhOhJgfBGyea9OIhrHPtciGngKN9JZ333yNPglZZl000shDupKC
   08r8gOtazYazWyFmjqTQc4cRpPTug5QFF33bvVLUVn6siW8SWF11KUqBF+bhJrroGDGr9XMu5ebI
   maLYfKtTD0CjyuVa7d9ky8e0qSk/e0XNjp+q5c0SItR+dR+uwL42emmWBbhDPgcMtRWinnbo0Rjt
   VUyajnBOSJmQimipO9z1XUoFQi7SvMxL2nEYHCxRe1WUgJ8UamnQElIHj4jhJkPLcP+shyXP71iz
   BreFsVQxZXKL2bR6Ml6JwEVloz7MjVj7a3Z0dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8iOq8FePjziqubdOmPHzHwdzk6E4emxH8pWrdLq+MjI=;
 b=d89FWUL0OqGFXnnKyIL45mthoFOSZDvGht/YykGr6QlxdVJGVj33yhMxJxrCKdOPc4q7Efd5/l9n
   J+KA9Lvk65gGZpT704VnY3LWGDscdMcIdsw1araDcS0PnQPz4zhJu6ZCS84uFsF+OpMJxt0b8CfG
   vnuaG6uczt8WmSCGwTPyBqHDDinGYP8P/aC7xYduq/rIXrTKn0DYPzRKpb1azu6FrTU+6IVpO3zd
   5p0ADwbS91ufKrekUoQ6xHSkf95/tVZA9ruyW9ft8SyaLJRzQOhmCXgo2CE5jNjmX6SgDdAOSMZ4
   BRTBz5NVWCJR0CuYH6jbquhsHaRPN7MJ9MX3IQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX007XOM176C40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+aDgfiCOEJwtPdr/RurbHwiaSsy59hTzpptbbgkSbtTQUnTKi9KffeHS+6lNocTyuv8XsXHpMg3KNaoPCQ++/MqY7QapNyVVPgX2Hd1fQGbmPw5ngC4+PpL5v7AvJCIlArB4C+vYa58Z/00NKE4xQsaKoxJDVynY7H/+KXkeQB1of32m18e5Ia7khOgg7eznGIPQhuVXRcHWhDk/SfbAsMzS1TzGPVPqbGN703gi6lyS/4jnsum7b2GXTQtZ6dRpMUmgUs3mLJIWecJbfOnp2e+DXzUA6OXG/pOhXj5zTFTKwemuXDEveqLedV9LFhpB4YZIY+EoNM2oZTey9x0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlDfmkV9Ah+i9b+mzgZJx9kWyxH4piNrBP9agZqeWwg=;
 b=iLuOhdhFMKbm4suS8hDY9CIbEj5qxqfnUDHQPDp9GxfRKGlOy3CF8tpJOenghgbdU3baCmz7wDFqb9Iqtu6pRs95hHHLRYfkdbQWN0dzI6IWR/x1YrCn2eq2SegQp8T9VwF/5WbcK3OnxdOfDMaM2uf4zClTw+sNPR/QSdTeB4NQNTiPh9u9ZXdt9WKM3TpoITR4VISd0NzTaFqOcfG73wTkQlW6K7rsY25VkJ50x1t8GcnHtQNdwy4ymLqdSy5juRX4J7fAiV+6NQPpUWn8y4iuvmeZkyThLLjxf0FQ4wO0YyPO/pafkBqFhax+2dZRYEtcasZb0uVCy4mwNGIgJQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlDfmkV9Ah+i9b+mzgZJx9kWyxH4piNrBP9agZqeWwg=;
 b=SKFhkUKXZ88tt6swle/RzEOj+xytwYgsbXV3BfV8nioLgqYFYvHnpxhRZ/++53pGldB5rXLN3yylSw5vD5LeY5IaMVN53fRgDDbdACpYutMyD5KcZkqWDirQ7vorKeoBrlovogvxp5vjv88SEJN64SOY8pyUa8XtWNxaYEDNBSpX8yO46qQqMncxrA3KmlX3wv34moaxB93tXSulh5tiQFSjmsntmRXIBNpo7mwbm+AzcLzjUYq+FVJIUFO4iZ55T6F9RWm+yxDjZlvYsHeJHJQqjEKNp73AEUpTHPMdjI9vhxPQ4lXmCFy/i1aLbUetDmqVnSVMnRkcQOTJRomP7w==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 20:40:35 +0800
Message-id: <20230309124035.15820-5-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309124035.15820-1-frank.li@vivo.com>
References: <20230309124035.15820-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(36756003)(186003)(38350700002)(38100700002)(86362001)(1076003)(6512007)(6506007)(26005)(83380400001)(6666004)(921005)(2616005)(316002)(5660300002)(52116002)(7416002)(478600001)(6486002)(107886003)(4326008)(41300700001)(2906002)(8936002)(66946007)(4744005)(66556008)(8676002)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 12:41:45.5447 (UTC)
X-Source-IP: 40.107.215.128
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=159 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=166 spamscore=0
 mlxlogscore=893 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090102 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 5/5] ocfs2: convert to use i_blockmask()
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
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|KL1PR06MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bdc6c20-59a4-497f-eb99-08db209ba468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 /9VgcMIo2XZSLx9n+63QodaSkZMcfSnK1zAiby6GGlf5cz9awbp+rj8OcpKLKq+bM3lYB48C2b4K/HSi1v1/VmZetp2vDydqNEZjtcq3L138BczYXPandBWcDb6aM3YtrV+atL9US08QWvFmCLaV+Q9YO4oKVMgcvP1WTmNuAec2//G3fYl8daQ9QFzEd2EgkvkjMGRaDQ+1MDbutBeR03AgjAhwgDiU7fduiaCo5KA0u/jysw5cQ2WX4WvyK1U8FpcjDngkKj/0p9rkT5ob1n4uNoKMfUkYKiwaqwK7ikWKsMcz3l1/kRRRsXnIJoN6JVsRad5mh1SI7phpkXLkDU5YzYvirboie1nqBFe33udS73tPPSoatipJNOuCadDmmefqfCPVDi0xr4Jliice6j+Vu5wq682msJFawltFzoWpOGMruYN4Yb5ibzNh5hom1hhZlenSArcVQVgD48wzELO7TE0JRC7b4J4+GgTsxxCx3Ont+Aau82GUbHUvoeu8AjW557OGM+jNUDwVvWn6T78I+7dbR555BlnAAR6QI9VEaDRnwsRsSfhi4eCCrmevcBb0/MPLz2CFCZF8Wtku87H9S7GfIaMRbFjWjARblMPsndqCaGOo7TL2HN5rCmJrcSE6jBqUw5lF82b/OiXr+BSwZ+jRSTizmO5VK8s7GPAOJDAUkdade2GA0arR2TD6IKGj1nd8TBsC7LL18c+CWzAibiHi6prbyzMPneeF0KM=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?1J/QAn3VEwBO+3y1Jyd7huHzVmxpdJVLFGT0EC3kXaMX9gclQxiqvd3E9gV5?=
 =?us-ascii?Q?dPGM2hNGBRHR5fcviZ/u6awpK71ddv86TjKp5ApHjP/Q8UYZaUcGm3XVcKX5?=
 =?us-ascii?Q?a4UR8QWaMXikNymgUm4hZ3ajnookOA+ZcemVbAF3aZJqamwNhj9QaF7m61sS?=
 =?us-ascii?Q?ZZHOqCmSJddYuasY3hC5st1t4mzmD34bUwtLR8rq8i27kkVqrLWTuR/Ty2rE?=
 =?us-ascii?Q?NsiYryjCxVwLZMZSKAu6CUgIurdG2uVejI7PvcDAPPVDKDBg8ZoGDyWcI4y+?=
 =?us-ascii?Q?3Jh96ROgxLMrcFxuvQqlizB4WolEeSa5YCYyrJesSMBHz68pQfDbhXvu+t1T?=
 =?us-ascii?Q?EAKkzKPNxahctrsfrm2MkwapXXJzW/KuRf92/SkP2sltepl+mdacjdD4s6Ou?=
 =?us-ascii?Q?KNhei5ADvq+a5+k28TcEplp8fX60rmkTinLf28ryYETuB5v6bLNsL4VVo+eg?=
 =?us-ascii?Q?roGlVt1KkYN/1pZqML8AS7+yLtVurHOnt6HCD3TtLLO1nKpTI+CKRrkZj4kV?=
 =?us-ascii?Q?CJl6jDFrnbbGWxbJciFDZyyJJqKonOiBrjsWszEXJUtlSg7lqm1FaMifv+Zq?=
 =?us-ascii?Q?B868t1y0+TdFUxepHf19/3OcPyneP3G28dZvwVO/sydeR4MjQQGpcJsKZAfY?=
 =?us-ascii?Q?juwDNOIqHzN/Q87zgqaaElaZE4PVHf1FVngo9jhIZJtOOaJAi1pU38f6Ur7K?=
 =?us-ascii?Q?cQHM5D6jQxn+PKpuYNXoPK23jHzwkIvooLMukwOZtgp9xyJ/BEwZPJyk6xaV?=
 =?us-ascii?Q?PyJKLD/Z0hWf+BD4TUZxqspf704kYP1VL7bowWZtyT6dhnOrZX4s7Wd2dzGP?=
 =?us-ascii?Q?W9S16gTVuXryCcs1tWbRXtxaeTZJlfFNJskJZVwKVglz0XwubuJF5jghf+sZ?=
 =?us-ascii?Q?DzMd+XpZZ1N7LofcY9PO2yaQVJjPe9HTA189o/P/+nMjAoQYmFF7RXTr6tXj?=
 =?us-ascii?Q?Ufmcv6OCNix6R9oA8uuxX7NloIyA9KZ/x5XFGZ9OQWe0q7IenXvNvMu2Uh54?=
 =?us-ascii?Q?I6y2598dqTjp6oY2So5X16ETT7BPn4dEt/375hlmGdlrAcSubOIAEL+U0G3K?=
 =?us-ascii?Q?q6IUd3OVB5UFYudx5jI9rdGQuSmMRFIgrOsMG4CKibMOsPqM+Vuxtik3SfeI?=
 =?us-ascii?Q?fUoJZIom9+KL+qbV8VsI5rGwhv5M/G1zagM1l4378RvqHNOvjH3BRi5As5rH?=
 =?us-ascii?Q?b9yejqc9+PCK3CPIPpHDqAm3LkPKqF7DRjR1M6MiLzlI/CiMhYcocylW5BPS?=
 =?us-ascii?Q?4C/47wt7RO+4pl4p+FUL/3hgrhiKeJO5rwOcMLIw32YU4fArEw6VlWzemN/v?=
 =?us-ascii?Q?IB8UR7b1bxNL6huaL74HhKxPWhPIR/n2VM556DF4MEA8ayd7CKBv2zXg0UAJ?=
 =?us-ascii?Q?Z1mE5QN2W8Red4zUmy5hkopf81jtKMV3PCZAdx5QHsq60q/hW6ZsiQfblIop?=
 =?us-ascii?Q?kyjbBHli6MXNGd0ON5ydfTnFmb7CNAPdvrOpnuY7QzEGo6NbDRDbWId7Ie3s?=
 =?us-ascii?Q?pladYM6IJpn12JWQX+fFPfcXqXiIot3qKDzlBYNaXbe5+Eq/Mwk5mM5blgn6?=
 =?us-ascii?Q?0y0srKHwWGYPWphx3nd4mx+Z53HmFlNHYXKRl7H9?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5bdc6c20-59a4-497f-eb99-08db209ba468
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 069NZGzxhTPlg+X44XPS7qEWqIOlrvYZxF66H4bSU/VtWXymK9WtKd/hbTJLhLBwfdmQYZEIXtmcU5ae+DyFDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6259
X-ServerName: mail-sgaapc01on2128.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: q8ENCGuEU2JqQAP0FlxdpsnJfVdqUQyk
X-Proofpoint-ORIG-GUID: q8ENCGuEU2JqQAP0FlxdpsnJfVdqUQyk
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGOlPCO/DtAhHg6K586Er4w4yr4EdR/kFH3+x1FnpvVy/hJ5w3xJylaZ7IxKDzx
 O/wuNxt0zWjgn1WSNTFRDSrFIExGyaC2uvuwEQ3HG35u+cPKtalwqaijhK806+w1
 4lF20mzY6FGdxvF/H7/LjrAHdYMaKEcyo6TgSCAiAbF+rCrGzU6Erg7zlWRTvCYB
 +Yhs5MAca6hCAlBDHnnSQJ2xbaFHOD9TIyTxtGxxbr6Zu5jFZtssuDr2J7/0JWcZ
 ZlKU1VJKM1JmF2XXUj7JeedaMHZVH8mKtWgTV99tocuG6MhAJMZ5QyAcQhZgK/m1
 aEkSrVRsVUjLJTWFK1y5yXCUG28PjK4tqwbxLGT05yQ0wT5+bRR87Nx2MHd3Jw9E
 iK53ehmEKu9PpLS6PHEy5Pf5oOvv0UEI0P3Tk5uBIW24HPZ9wvnCstblfwEqEsIF
 i5pdy2bJBU1ex9PSZt8X/o2rMoSVJ/3SA+SXjga/AyxdWQhl1M3fjiG6CWYYkiRz
 uT2iUerJSVEUIDm1tXl3tGRjSbF048PCZjAl/AJZHmea

Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
to return bool type.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
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
