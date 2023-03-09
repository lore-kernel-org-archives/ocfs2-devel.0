Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6909BC77B61
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aJDEyT6VTLdb7EGT/BazGRLKLvgvoqCyLM4jh4UxyQI=;
 b=0X0HJaErtHkxzz4+51NEqp/SWMouVXFllJnr+h9HsnYkCSP7vYKBW69wecKdJ6Sn658KXAImaXla
   GAIjSaHv1340DoTzdpBlbMb2BP9DIP61xzEByByKZ4Us34KoEJUJpHYPdnIYO+svOVtFLOZqmNr3
   AhvIS2lLi0t9qxZoIuHWNVkAPXIxCDnXzxZiXepUEvI2Y5tTQUZ3AJ6Ttce3C8hBZMntJuH49+EK
   fcaFxbPXHNb6uXb0eOdl1eqC6j4l50maMh4lNTiGTsLtMStzNKKLURzViURUnNPzF0kLjg7NpJXY
   Sg12V+Pode9oTiWFVKoicHcf9Nwz3rA9HM/XBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aJDEyT6VTLdb7EGT/BazGRLKLvgvoqCyLM4jh4UxyQI=;
 b=DeSHOfYSa+kNpP/pZZdFF+SprPhSTWpMmRqWi76cDdI6qHRWHyN/6Xc32UTm6adZH9FREqngW4ql
   0YnNONf7mDwPjf8tyvw41rBiqUsTw9epsbs+6uMGRArAN57gFW53HynRgbzcyi22kUT4H/QruxdG
   /syQMxm4KDCMaz5ztoduvvBhWCtleDFxFhaUON4O+r/tWilynEnELEdPY9qS4W2Rb0IGgGDj2quB
   SekTv0mCxcTCDzbQzYmdi+wCVVunAbES0Q5w/PW7/3YA+Hlea0GqMzicH6vBvZPOMDnLR08AhYFV
   q6IxPcvZNSNmRHcTyLPzeiC+g1WwhILHPM2KpA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX007W0M166C40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HS0jPPtC2MNIaXPnMOFiHSlfsglqEwsefJSwoHoHG4DWfERutRnlRrYhf6Cs94qFhb2Pgelmp7FNvmoK99iRrKzRzc/JZc5OYcffJ5jcUji9L5dDVSDgsNGDUwqqX5kq2JtqvrmglybanjgTNw+cM3a9q4zXiz//l1ZzbyfNGFyW5wjy3gWDFwL14Ap7MJcaK40PT4T3lNe+MWou/9RrGAvMqrZxIZ+3+owfpgzr8R4FJxygKy9avAaeEdphs1wtJ7elBSDVRExmrTJZvzvp7xT6KxcEWfSXdoUYu0ziR83zC8CB/Z7Xebt5QfyZWYHpvuccSqqkH46T5U8+rT/APQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Z7X19ELXxbAoyy0SRQNbX79+Ll785DAlNhB1quh3gM=;
 b=EJ3lsYjFpyjy9CY7wnmtrJ/tnMcpZQORhFcqe3eHV18s9t8ZPRBIBkYDEGp7E1OAQ2Nwgf1j1LPdUMbiM7UD1Ap2FUTwZ5XfrItfdJtCROzGPfxQvRRW2p9Vk2kjnQYLTY3U/VydoPROS8BOWKpsl/Jy+4sOcX+xTZ+5qmTfPkWo1czqSLB8JRDQWRsQQ7tXitxnWSVWBhyjvDyhQzRigVwReIk/HOqy6m8YjL1nodj73toWacIrECuP6B1AGNnPxro5n2nInXkayJfPuDphXyc1FNc8LVa6w0yXrs6mIBz9Ypm3TT8qQ1Zckb967TYZcmW6xSz5cffjGudWKXS0gw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z7X19ELXxbAoyy0SRQNbX79+Ll785DAlNhB1quh3gM=;
 b=SnhJGLxFtCPjfixZcRmm/jyGrKC6ORp/INWYhRQvXkTBAK/Xpl8S5R3A6dD+KOVjSh2811cwTkkmMZb/RO0ykoffVRmicb9ZduBpvWX0OCrnLPGoCbDiN8nY+pXS3JjjgyXzZU3gt8qr7NM2j/34ONpmd4ZzpXF7qQ2a6DasPPD0lvv7Acn9OdktsbhCtHn+T5QDNOsQ/+ojeVQMFM1izTFYZ8CfO3b9PnUMmh6fzz+5LwUE1kCtaTJUcoXBEgDQa/QpsywI0Ronf/kkB7bVXq5qpL7Zf9gUF56LTcR7BJ67jtAI7F7FWXfRIy/8sVGVdyif9cTjHMZqCWNb6vXQMA==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 20:40:33 +0800
Message-id: <20230309124035.15820-3-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309124035.15820-1-frank.li@vivo.com>
References: <20230309124035.15820-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(36756003)(186003)(38350700002)(38100700002)(86362001)(1076003)(6512007)(6506007)(26005)(83380400001)(6666004)(921005)(2616005)(316002)(5660300002)(52116002)(7416002)(478600001)(6486002)(107886003)(4326008)(41300700001)(2906002)(8936002)(66946007)(4744005)(66556008)(8676002)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 12:41:29.3130 (UTC)
X-Source-IP: 40.107.215.125
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=74
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=811 adultscore=0
 priorityscore=159 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090102 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 3/5] gfs2: convert to use i_blockmask()
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
X-MS-Office365-Filtering-Correlation-Id: a2f2f4c0-3ffa-4533-c8d5-08db209b9ab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 2bmxk9LMJ19LLxjIK7Gnr090TyGqOW7U46Y/tZmZifSSDSW4RNf7aH6rgN4EnpgSJisoOTOoMkHVafZqTDlU8msIpBXMFbpDS+jsKa2P/edT7j9ria3jhO4dZjRk9VDF3zUprP1PHXFdsgP7PrEJ+MD8YRd2o4o7AEE+Jv5IFdX2QFQcrb3A/vZUPDLO6uiVlkgrGePjb/hc98LZ91n/uyKEFWKMG/NIlPm0cl3yvZroDVUiPPapwGquGRtBUeXJkIKnfFWwvitViCbNqua219Ok7OQUcrhiJ4EVVS7PLzWus7RLImno8GKn7MzRnp1vFs8Wb82X2if5oeRFiRrnoQ4k+wzePOpPu4IG4BUmLq5VaRHwsZ4jo1DSw6F5FiqDhg2TBtPNXufABq0JWDfpVTmpZF0OamnKVjc1RcvZ64wpRIz+xkjsFwekkBCqDEM89q1mF8B46EjvcsglqLQONx3ST1U0Kz5ozBzCpmX0TehZhIwCdlD7WpoSnNQ69stjjsERCZkKz4x4l/UV4/7cFBtJ2J2RC3H6WaEncMp5RdY/tKlJcoLxsLwVVENBASGxBHOk6O27xspHAwW8BmckSC5X7h9O5dZpM+XEuXLue4QEw/2MeSBaare4aHlBpPdJSgZ6KYpR+96juFg08d6KZeXYMcXwNoms2dzsQi5tZ/+M7Wm9TY57ie6Y01kzqakxME4mgN9ZyJpWrBYCpQxgUslXk9SQXKWJ2E4+pjfILdY=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ozMcl8yJ2xNy0sbfFZEJjzTtGv0fuq5gde9UNKZIflRh20tKbOCtIEfA6u2j?=
 =?us-ascii?Q?6xEh1rsLzoxZiOlrae5NEFxbXRrbB4sVIU7u9w7Pue5sdBpugpvtQbEeLHQw?=
 =?us-ascii?Q?9rxl7wIJYGvAYM41hMK2EguFseEiUy3kIQd4jDLtARIj4u6z8rqviGd6iK99?=
 =?us-ascii?Q?qFlzObrLU3RbZiEiB6hPZ5v/2NLt2H5ZV0izdnnEO0H7POFE3ua9h1huC/pH?=
 =?us-ascii?Q?6D4lPySMBYlFSog52QAQJx5eVrIubh4lxmQfL34LPHZdbX9nWRKMc8QTkmc6?=
 =?us-ascii?Q?WOko8rs0fnAZ1hX9l91uDFBJjXiqyKK7Rjh3pUxrOyXu0Ejs/xxcfduLNJPV?=
 =?us-ascii?Q?qjA+QKMWWDvbLlUDNZVSqXw03ANqQ6TiQ2HEQTQ+Px8XPn9VNuK1YzQ9+BUK?=
 =?us-ascii?Q?TIyG49/kC0KJmADeO9Q0wRfuRZxAwqfrRjKP9HlScCZer28w5Z2R9CUYdl2O?=
 =?us-ascii?Q?D40+9ksnDsYBpXxfs+ovp95dyReb07QjzLN5XPzCexuQqFHMuAm0Y0jIa+SK?=
 =?us-ascii?Q?On3bf0tTNgEKPmQcg97sE5VyAwG3CK/qVilKulok8NsehLOIvni+F1UgSHy2?=
 =?us-ascii?Q?1bQD3aVz0THMrw6kI9kjCt8JNJY8zv+kWO14L/m1ILWoWxIt6sv0SI0ajG/6?=
 =?us-ascii?Q?uDUOq7zsNaa5OCgqHgdtcbK+2Gu/DTjrJPbmCgXueddi+V1V1hQpc4BI3RXE?=
 =?us-ascii?Q?hDJRXrWEOfp3pagdAxgtecAUlRDtUdfhev14SOK5DmXz6DLH0KhiSnI5Mml9?=
 =?us-ascii?Q?skc8UxnO0QNV7KrW03xfzxCczoutI8Vdl8qF1oy64OYLGKzvdjc9c7pbvPHT?=
 =?us-ascii?Q?KHf11b4UjgQ5P5DIqtlalZ1F9qn1vatS1LFMoUZk0YbdbpWt8dyuYY8udB3P?=
 =?us-ascii?Q?DGbMbY//St7Ev7VQuEKgnZhcYp8KWWXEiwPGGu1RAv9SAjmHL+kZQRfkX/xO?=
 =?us-ascii?Q?gJ64HfGoe8TFVFL7QdX04guA4wTMJ7VBVy/6x2uXZJbCkbdN6/6IcGgi0Fva?=
 =?us-ascii?Q?hdF8v5/nVybMe8I8a+WyyYyc8A4ycL9fzRXq0mkpxslYwagp07Px2GVfSu6F?=
 =?us-ascii?Q?iVSj3ukrDuxu+g2nyi1bTan67R7Pw+9vBu2KtuUB77O1R7j0xor3UB/9XVSy?=
 =?us-ascii?Q?g4RzLXarC4x4oBe/6nrebkNRN9C+rDnLYq5ofVEcZ7wyYr7wnbBeEJ5w8V0F?=
 =?us-ascii?Q?+kBPQqVAJJKeUBHa/oeZ5VBplGvooL4NCxbpoH6gymzpDgBCf4kw5x0U96XL?=
 =?us-ascii?Q?czaOpJtQ/3C40T98atC5s8Ymoku8tYh7Ies4qCUkrrBNW1/iNKlrrGYDT1SG?=
 =?us-ascii?Q?Cnhw3cXbyaToLVyDFK29GUf2hOCEbIZjoZ1mIwoAKC5QGe0RIGzSMTGocmgE?=
 =?us-ascii?Q?vJ4ps05YRnLJttZ5AxPaWUh+J7FBgvHnUy8RbenUqdStZ5XCQ6p4oVPMuZiX?=
 =?us-ascii?Q?mQf1svO+YRjuSuqUJI6nGVhXSgkA3n1qaQ+pyCsVhMNYO6NRlCK0OBiu7i6W?=
 =?us-ascii?Q?SQ3UpBhxqDvF5iXX9pd4gpTsU1aI6IlrmWrEx1cD5ATexwmnZRwqxXg/Yo2t?=
 =?us-ascii?Q?GxB8ZP0DgK6ZGhcgBJ9She1hyPHnSO7RJeyTfenE?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a2f2f4c0-3ffa-4533-c8d5-08db209b9ab9
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /VHGA17u1WDd0a0giZZqm7Sr2Ozv/qboL9WeHNxlJ9yk5qFcTq6iwG1GG/IDREqnaydWCJMDjt9u6XAJY6z1IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6259
X-ServerName: mail-sgaapc01on2125.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: Gm5JykdfogM38OTlUHs4njBFP5YVANcN
X-Proofpoint-ORIG-GUID: Gm5JykdfogM38OTlUHs4njBFP5YVANcN
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGJSUENx/Gn6GTccNnQXmaUgkQeoi65ztZRbNZLHi2Lm6virr1aa7kFRthQfKri
 8RUWWU12F5NJ9Dk/OpcV8FVL0RKAxUsFeWTcnST+gc2itHqSvA9Ut5nT0q2n+ooY
 kgMilQDXIlwfK23OqAzBNn9pELQUtOfXMl1ofiauJREFPYhdf24SC3KBH0NtOBfh
 E8EVfoEQTxJSMOUSdvqZAYRsAwoK2hUEIdMU2xYRfggyP5n+HQhtN4272F0pFcvd
 IpQgR5CKDvuuLtjfDZ3EFAOdHbzmgxagG+eAHBnQDPbnvxnY4XqyiJDipgM1nTdb
 g5DrXne0cTv0w0F7/8kWJC5HxeME0xjFbzBPAGH6DIuU8MVaNjLb5uqxwfFyZVZC
 6/e21MS8994eJp5KYfQ6sF0hFylxpkWtUgpl2dgYRinU01ZEfeNLrqJxVXUFOXzy
 W0RWSQMGyj0XJZ02gL+cbPywKTVmQrUzJbeLI5vyGIay0DudGB7Z4hcZVVNH63/3
 vv3pK+bgJpfH2O9PkH1tPCGLzRgL+5ZGJaG6JR4bK4C0

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v2:
-convert to i_blockmask()
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index eedf6926c652..1c6874b3851a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -960,7 +960,7 @@ static struct folio *
 gfs2_iomap_get_folio(struct iomap_iter *iter, loff_t pos, unsigned len)
 {
 	struct inode *inode = iter->inode;
-	unsigned int blockmask = i_blocksize(inode) - 1;
+	unsigned int blockmask = i_blockmask(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned int blocks;
 	struct folio *folio;
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
