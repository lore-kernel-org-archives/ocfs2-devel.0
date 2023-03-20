Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A09EC6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=baucZyL8MKY8Xx51bWqSIM6XyuNB+JnBNJgwyWvYLzo=;
 b=kOtstqi2o/ASpD1klYr/zI0g7oXCS7lsJ+bj1dCprrZkTPB/MDtKAkX1NaT6YRYWTXQSARNTZpob
   GAwJ8x2/yTzXt0TVUkiccI6Qi6S39ncYjFNSxfxplEvU87guDlk3mE2KhVGPsRFJg0UQhtjt4GlY
   5Tr+1o8ImNzMl6UkW++3Usr3/WEV6XIe407cj4lKS2yvTkcaAjSJvaN9lJt8CWhBy9r2tVBCj4DT
   mxrQMoD/v/Gcd0qgnJvf/psUwQJc3rucznAp8q/Zh5/rJynoKRgqEpLRmYwmTGWRhoZUV6K/acJq
   Lej57pv9ueEzCIAnWA8Vd9BJtWF8AmiTw/W0mA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=baucZyL8MKY8Xx51bWqSIM6XyuNB+JnBNJgwyWvYLzo=;
 b=AVf7z76JmXmQd4lEVdy3c8WAIemWk3IrCf8DCTB5ipXbp03GFxN/xLWIV4hw/eaQlBCRXnATqqp0
   cff+Aj6Zwj2b3qX24LLYU/anvpa801buhfbGYbm3ZhHUnktipj3xc6f8WXcOkFrbvcMWKCl0Jqob
   765qC2gddIIItey3PfjzxsCepO5kvdkHvNMP3QWGp46ut4Ft3L+hZAqkII2N9MZJYsfm+UxFF8Ph
   1gVDDowyULMDmcTNmP6DmAPOFxkUepwGOc4akG6RmcsCOmr2VAUCRpMXkui7uji9UDFVw/bgPwFc
   uri2OQnYAJ2CZNrFXRAf8eZ6GbDYbwF23fkjLw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00M67M1AMU70@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnIyWvanrQatP8FP2pOuK0yuP2ja5EMihziwXvDIy9S4nfDvU3cKEihR4hyqxLVVKIvEllFdSfcuokAlNxrNyB43JJJ+PkeQFEhGcu4t84y7K5bQF+pfxyNi9uFuijH9BKy2tUl70z1YZFBsAatzPFpcIUwunSHFSQEhgJ2WHWmbWgoUQjsZpwACy4xh48cEe5w1sgIRAnHOqYvOTHxJUscAf9wviSQCQ7vzQCxjUpaxoEzlXMKbPGDYU6JPU+RvJS1nwSfum/G/FjY7+w7xMuJ3xRs9JDWtT0tNwAf6WNRceROdzlpfWSmBYaWdYRXDKuwJMmqpGCTxFNO2k/1Zlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f6n1UCEAAcz+QTfKGhjodobaG8npGp7MDh8Bm+DuiM=;
 b=W6DB23H8SiFo9n9+BzMlgImvb1IB50vX5av7fRTIUn3R8GMhIXJc6E2zKQze9Rvb3JEDWuik3UgDs6gLPKvzZk9ZHuUrUUrAD+VScQ2mJkIgFki2IpWEX5We3yJOWYhBK5QlL7sdPF517rdv8ArN+SUVuWUD39A0rjgfxH152bCpoFcFRMCxb4xcWtvDKvA+lwvED3dWJdG+EuQU5FtvTifQzABIjtcBz3bXyD5bMHKrLyqmlFT97dFl7RdtJQRCgbdIWiRGQqKKhLpFxBiIqbmFByTYDXZdmfjKUyUPgi4DtKg34hmt69rfNCYO9Usy/kRVjEMYmzPyZPdUUgVs7w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f6n1UCEAAcz+QTfKGhjodobaG8npGp7MDh8Bm+DuiM=;
 b=avahy9j67MbUgEV5UHkvAGGIawSEz4La41fbV8o1DV1X8t1tKXHX+WCCRf1CyV/VRvVL8ZALS7+2R+5KWC8MzPVQfyoobHz9Znm8DOjKgbBv7pRzOVt35BycfRATHt43DUXPW3+802qVMMPweVVPpJzuC/pWKzMjSWCD9mrgpRL9Bu/wn8CDDB23RS13T2fH39QxZP+PE9sM+zzpAOMWnJr/GUs7PpOjG2OP+Kk6pJ2aAeZFPTmXaysjGvXv2oge77GXCWoMNGiwUKxPYkhRjCV4k/9hZDd6pKM/J+rjATqQ1HAYwmBHiTLWU/STr6IgEAYoRXp5Tnb38Y/Sg4eeuw==
To: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org,
 konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org,
 damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
Date: Tue, 21 Mar 2023 02:46:56 +0800
Message-id: <20230320184657.56198-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(86362001)(36756003)(52116002)(316002)(4326008)(83380400001)(66946007)(478600001)(66556008)(8676002)(186003)(66476007)(6486002)(26005)(6506007)(6512007)(2616005)(6666004)(107886003)(1076003)(38350700002)(38100700002)(921005)(7416002)(7406005)(5660300002)(8936002)(41300700001)(2906002);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 18:47:13.4689 (UTC)
X-Source-IP: 40.107.255.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=98
 impostorscore=0 malwarescore=0 mlxlogscore=814 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=185 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200157 domainage_hfrom=9113
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [RESEND,
	PATCH v2 01/10] kobject: introduce kobject_del_and_put()
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
X-ClientProxiedBy: SG3P274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::34)
 To SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: c1cfcdcb-d869-40d0-e140-08db29738503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 MsOGvRl+lIw0km+HsMBTnxn6HDWZGk6Y2he4hWo0ZnTlC+b1YAAdA+nnWFHH2LnuBwn2Rl/cu6KONHB0AoRCPYxLAz60pHhmhfcRwZOHOuBxoXPwUGYRe4rL4hmshNUnK4NAgPpCEynxCJyA12v7g5lfIgKZ+a1lwntOxojqDf44JvwiVxDWYE6LmtUsZUJEgyt/ncsa46J5Lh1zwu7v/nbpg0AD9f03rGdCQ4S6N5t8Hsex9r/tsHwKLYeKjjHeM1LN4XyUFUzmoN0Q7cNMsLbMOoBPCuHtGCTWLhGR048HTxZ5fmAmbd846Wau4O4ddTyMhcZLfQ9u5oJjXNZkzIhxvqsmWv9xiB6HmROZnCj9BW0r7G9SFTzt+BGU5a5ZcmYMGW8VWJl4recceWWKicH27ytdAPQtN1J0EBoVfmQyDqnLkRGLG27mcIUAK8HfbsJqLk3Me3GblTXoR/NOl+ItBZL/j/0Sci3cW2ra3sTmbzTNZ6O0lwWpGiYhFOGgJB1ZmDhOOldKr04KnqHbYLv7JzANWhwc08gaY6DrYffcEJRGAdEW/7Ea8NXvtIr3NeC/yTV6GHnnUGab6lfc9CcxF3Tc22l/ewdTAE5QhLStM8d9TXVFYbbR0jmSUXemfp/EXJtj4Z0tUNDf1LwVd+SW1NxcuWfznLuFEacXuWv3iTBhuv8beKlTt+VxDV27kObsdFCNw5+mb1hGSLTTv0Eii6sL7DxfFkziCog06u8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?g/6eNiYY7YQN4AMo78BFCWQN5++6QU91SJ05dcW/32nE7acWycSlcT/2wh47?=
 =?us-ascii?Q?LRH2AK96RBLc1kKNAdUL5Puip4rbQxbA52B1xkcCYSZLU/tCOujQEFFQqW9S?=
 =?us-ascii?Q?frb4ee8pOXw2IJl0gDMNC/Al1nVP8ucbzvkLj2TXfBJHTG7IbGoRIuvs5ijl?=
 =?us-ascii?Q?5FPxvvE2SVmvZCzjtRpjZSoVO694Dqx3X4Rc8fUq6pkD/0GXWTK4H5VIBMvs?=
 =?us-ascii?Q?3TSJw0/Ymf6ztS3Q73oqhizBfpzFGLCZnDlRS7P5KWLZoDzZu3/lmWBs4QEA?=
 =?us-ascii?Q?IeB+ISrFc2N0iRKmvP+DD6JsuwlrMfUIOH2sjF1/Ce1zo9KMncdVsBkm2Rtg?=
 =?us-ascii?Q?+oZgEo8RjZDLGRkdf89A2R8WJeMQTZk/3v/eez8MQbiwAydkoGKiyIg4GErn?=
 =?us-ascii?Q?WP2ncFYHKtl575hr7c5c15V74Wq7hHPlA3UWHf8Y64+R1epivy9+XhvIrDpz?=
 =?us-ascii?Q?Uyo1z77KE2VnHKTBmIvwsy8wfzmChNw//iqZu8+1ZczaDcBxmu64c//Ov+V/?=
 =?us-ascii?Q?bc8jfVSZKtpv07H+gi0yPqd7x/IZhOJElnEV00brhi5wz9gM2HhhELigsl0H?=
 =?us-ascii?Q?54sAFeNXDCphDQ670M4276JCc69pGSU7nzpfwBw0506QOtVYc3DMgXt04cXg?=
 =?us-ascii?Q?TK/kkIu6WXqBVT1tL5wKSJVXuDxGn9ybnYJEUq4nu3Wt4dK3CsGPPKeQVl46?=
 =?us-ascii?Q?A8bdCXQecD2YEgve0Q/tswKuuD35p7sXjS9T32PWV2YV+kvJUO3S/PrUz6Ss?=
 =?us-ascii?Q?+eCA32oZEPHMtyc1pPc7qSveDpKyigSApExkU/kXTfs/QM7XCBPgHUksWDw4?=
 =?us-ascii?Q?zpDRNeM+1ieyhk1ubFGXav8EPmLpsEQ0/uvXUW0SfJFlRV1UH4wxs2mpxya/?=
 =?us-ascii?Q?ujJA1ckz9O928Tyv6hJkDIfTGvhCHLfwB4mDp/biOp/rBauLCPgSvLH5JRY6?=
 =?us-ascii?Q?nztJN/qCkA/oalsJfBtWOMmdlLVukaPwd5npHcBSl/eJyFTC51gahcnYPfJA?=
 =?us-ascii?Q?wAJIv8w+WgbE1RCOBEEDFuK2ia68IreTj1Us9fs4Iy8JZlgZo5m+19x6kTrF?=
 =?us-ascii?Q?w7OeVszdSKFKkiocIcMqyusT4kZUwf/D7ql+JkMj7BdGwcxE503Cnhr+OCvT?=
 =?us-ascii?Q?pQ/7VOE9ZDaAd3XH7GIfpffRrQXJZEFijEkwosuZIIdNvryadJ9PDzw+M9nA?=
 =?us-ascii?Q?FNUiVYvM6htbdTmFV1ENaQkNLEy+Y+Q6w9W8lN8wKAA+3UWMhy0m9Heea7Fw?=
 =?us-ascii?Q?SDVynnRGP4ESrcVbSE14HPJ7MvjZBRH0zIXOjE58S+gi8eLxXRj+GPN3UqTf?=
 =?us-ascii?Q?rV0GzqLgpf3hji7Wue7miWTFnFQ1tLDC4mTwN8Oc5JLehn9eT9Y4TcbAsQd+?=
 =?us-ascii?Q?rsaSfa1wc5D9bZUerQr51zv26XJToiYjsd36ny6eS4PL1ceoQC2ud46R4mzV?=
 =?us-ascii?Q?4WxaBmJteceCEatEp2bAAHPqLpXEIJ2CKLg2EJS4sF3A35bqaZPohzdmn/FF?=
 =?us-ascii?Q?lqKszVaBUWXgeZED1H2rUZdY+/AeDSexWBSF4tzIqqlt6miQHQ2r3YpUgBUv?=
 =?us-ascii?Q?/I2jB3B0HfAQNtVx89K32SQQWIe2r7af4xjHQcPv?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c1cfcdcb-d869-40d0-e140-08db29738503
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Iw6yhFRY3fWfQtJR37Yy4Na+2pS2YzTcSx5S8aPN2N/1coERwHo0/5nreieXryTa6Gq4S5UQkEgstX8i7GVXlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4121
X-ServerName: mail-psaapc01on2118.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: _gRQlq1d18xCsq4_v6o4wkNtvtelIEnp
X-Proofpoint-ORIG-GUID: _gRQlq1d18xCsq4_v6o4wkNtvtelIEnp
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGIXGW8tpGQvTDhWFyEz5/PE0jOWupXW3pbo285PXFPHDoF7LgnBMQq11spRstu
 2CBQpByeF0XCtrgxMmaluPBumToE12CzI/TVcomwyaeKqoa4gGxlJiUPmNpbEZ2x
 jF9PwjlOfL1KBOjH42hxraf2liFnFZiU9gxqfi2OQg0LEHz38rKQLnYKCXI3weDt
 B/2ALVRAfduHNOqfh+gqHlPVC6EJ76nahnpq8DiA8y8tc6QfxvmFgHuzO0gd0Jvi
 5NAZCTes9NPjcmkDEvQZI/m2G9+9E9iKGUlxAiC0S0+ZEjfaxtBt2IzondzZXkNu
 /bc7EPgdbgkv9QeZnEtCl2LCjN9ZDYHzVDWyH4gqop6y3Pukbsfzsuz4neJJCyxn
 Pat6M3XKb+qN7lsMOAh95vRKNUdGjMMBnljtrmTGFCk6IIn31onguBOVd2GObq5n
 OxDW000GRlabKblIFWan/H4C5i3KnDnlXOsBYbzUinm7kSLmHN6pW8stIArNH0cy
 9VZ2J6/4+ziKlCFEKK4hHhvtbQYX3YkaRtfg9pTLIS3Jdw==

There are plenty of using kobject_del() and kobject_put() together
in the kernel tree. This patch wraps these two calls in a single helper.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v2:
-add kobject_del_and_put() users
resend patchset to gregkh, Rafael and Damien
 include/linux/kobject.h |  1 +
 lib/kobject.c           | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bdab370a24f4..782d4bd119f8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -111,6 +111,7 @@ extern struct kobject *kobject_get(struct kobject *kobj);
 extern struct kobject * __must_check kobject_get_unless_zero(
 						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
+extern void kobject_del_and_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(const struct kobject *kobj);
 extern void kobject_get_ownership(const struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index 6e2f0bee3560..8c0293e37214 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -731,6 +731,20 @@ void kobject_put(struct kobject *kobj)
 }
 EXPORT_SYMBOL(kobject_put);
 
+/**
+ * kobject_del_and_put() - Delete kobject.
+ * @kobj: object.
+ *
+ * Unlink kobject from hierarchy and decrement the refcount.
+ * If refcount is 0, call kobject_cleanup().
+ */
+void kobject_del_and_put(struct kobject *kobj)
+{
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+EXPORT_SYMBOL_GPL(kobject_del_and_put);
+
 static void dynamic_kobj_release(struct kobject *kobj)
 {
 	pr_debug("kobject: (%p): %s\n", kobj, __func__);
@@ -874,8 +888,7 @@ void kset_unregister(struct kset *k)
 {
 	if (!k)
 		return;
-	kobject_del(&k->kobj);
-	kobject_put(&k->kobj);
+	kobject_del_and_put(&k->kobj);
 }
 EXPORT_SYMBOL(kset_unregister);
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
