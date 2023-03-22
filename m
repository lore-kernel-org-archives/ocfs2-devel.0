Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FACC7EE2D
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LYjMLUTXT8rIMr7tRs8r6vx0nB3CXUp4tExB31g00vU=;
 b=HIqoWKydc7PCwgIm93AoRFP72Qw+dfSmatuT7YcmZxLp4BbjAvK2a6056ken5rxtrqSFNHOdHC/s
   RR2kL54WY0qzMVmYukr1zfl7zn1MZe/osaKotR8/eiZsrxevKIp4XPjgs3i3cJaaFM1EZct2AsbJ
   9lk9Uvmi1zNuxJ/CKbgYCBVUyLyl0VFPbRXaKTk/bvBAXEziV74J1hSgdlZoMoc1gZ1R3F2wAu2H
   KlWHqffrGmLNWfOOjpmsYkFelatGqpyWWRTevtsInKzt1YeHrkL/adiBRXww+e9TE/CEAxJlowMJ
   kTQYaMsznlrkOujTE0zm1Pp8igXFnDyAs3dL6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LYjMLUTXT8rIMr7tRs8r6vx0nB3CXUp4tExB31g00vU=;
 b=S2XOlA90g5F5FJ5W0pPQ+Lfcw35THVYSM1j/LakPIlSKQyf6Y2cfSTKKLh05uX1DcBPxQ69OjKvB
   J1lgstx248WPTvOb9x9H2XJo+SKYSib4a3s8ppadDtjcPcJhVG8qaOlgN3rCuzeNQ6wJae4GVUee
   GCiTWfBZUZl32K5lNUjU3JVgjGwLNWucsB3zvLGPFgkFni9MxRZvDBCYIHcPZ0xrCA/BBxE1j0fM
   +y7wj+W3eJehozg49+oiZ+EkRUuuZ6wGa6cCF7muKIf/SxG8ZsNwmOkUWeW3cE1WUlm87PTWPp6o
   +/BVv84nPRvyfVcMloqqP/Oo3M1cGWqNm1NP/A==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX0093SM1ACIB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJZSeWLUV7nK0VVISCGbzT7VRosfDS8+/eQWknw0PauuUOt9XdTVNyeLvc+S30WpOOZ4DLBtoIxiwUm7EJHcXx6JwKnkeJ1YpI3u3iHqWohaEpQoIfQ2uTZ6ja+NSCds87FTrdUmJUj50HnbcK4UWNlg3QIdHkFTfuTmNsRHd0q467PWZPhMTQH+DiKJzTT+v0mNTRwWWvLKoI/Au9MNtgvr7twjo88dZChXDaQleP01x2BR3cCrhJbw88+Wqigr7Q0n6IYtoLVJ8LAwVgItq3GtyK5bTeCJ8G3ThHEGmB/Zf4LinmEJybb6UShD3y0v0vQvofBpmVN22KZPhoxtQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWU/bvQplpq32Knxv8Pox9YEw/v27hnBYemurc1ELJ8=;
 b=j81VP9v/KD1429vCbHILuNM08XyuVpOyQHzg/mMbAf2+HpXRpFABjSILNqLAZuF7JyxX4GHq2BuSIM250d6w0cecsAR0IASgplvHGwyTdfMKf3FAU0e383SFg3vfaX+fheKZ6aonI4KrZmwojQZiqvUHw+wjOJeiwdXR7cv/grqoSxHlzDhSDxIi8NKD8frwhISFBVjv7tYLMA7xoY3blwPF+wp0UPsAmP7718Odl1ZO4GghSIlZ3ngT0x4Rog9ndCQUCM4012+zVZrC8IHBBQB35vmHGejqYTHmYdpXBZTjcvHPX5/xbvNNaDFRzQNDOjXb3Pn1sLTVmymOPByP3w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWU/bvQplpq32Knxv8Pox9YEw/v27hnBYemurc1ELJ8=;
 b=dLnAJvqv7qCszNP62jfkaIDObQxwd4JQeWVotpDkmRYHtutvGhR96r37/7GlvDxU1dN5nCGic13VoA5T7bHl2LXpydgd5p66WjWYNZkebZAMBi/eK/RhXLC1B29AU4380gVHX7QHqMbZRACmiHqCSE5Yd09lDmMfMNIR9HW0hfb8S+wqHPX+xga55XpXeHTm7b1oNqIhBYZCBEMPYf54vpb7S7zgAn4EgreDxagXs8WORHp89J00hXqSszk6SAznKF/Lli/cmLfZT8hT290PJuhqG8o4+XaC+Md6C/nEh6LaT+GbdigFq0+S/ac1elKAbtcNXxA318kEk2MU7W8vlg==
To: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org,
 konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org,
 damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
Date: Thu, 23 Mar 2023 00:58:30 +0800
Message-id: <20230322165830.55071-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199018)(2616005)(107886003)(6506007)(52116002)(478600001)(6486002)(6666004)(83380400001)(316002)(66476007)(66946007)(66556008)(6512007)(26005)(186003)(8676002)(4326008)(1076003)(8936002)(7416002)(41300700001)(7406005)(5660300002)(2906002)(38100700002)(38350700002)(36756003)(921005)(86362001);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:58:48.2130 (UTC)
X-Source-IP: 40.107.117.95
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10657
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=110
 lowpriorityscore=0 spamscore=0 mlxlogscore=735 adultscore=0 malwarescore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220119 domainage_hfrom=9115
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v3 01/10] kobject: introduce	kobject_del_and_put()
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
X-ClientProxiedBy: SI2PR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:4:197::13) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SG2PR06MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf0ab43-7108-4dbe-3a25-08db2af6b457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9qJOVVxzLZDz0WkTMJRMgXev43UyXmXE57liHybP0/OZw/0HQYplTaY3Psqpr3YmL7Lj6w3yS+r3pZL8da67rpRhHdJDZHXtDYA9RUb6ap7kA3YOrb6a0I/CRFM50S3cOkwLSo2lXPAMU4mzFm88+OGD4fqK6YNAUJGZiufiVewQotc8P0ZXinyxWABRJLyd0jT6krlNwV+W+esDUixAFg7JU1n21I6I/ocMQlcCJ/JFUx5g/TA29eXFkTT391QCyycgKAql+pilxXX8pCHiurx6QkspOSMQJYd0namXkrkLbehwUovYhKwMWaZkNpetQedY22NoheqgxvXIFkpOth4s39Fj+NvKgRP9a6xOHbZF5t4LboYktQ0xf6rW5mqK1uZaJ9D5nmIQ1SDAoa0TE98TJ+UyKIyKV8JLPFtv4vOdVuiBuOilqoPs5YzDTtSBbcVmkK0Rx4OuMNyNFaXwwgQxVnMYaTqgWWZ9HTa7wK0i1my6Dph67nGCnWXMXOVbQyTmpJyfv3QYcQyOjR+sZ9/0apSzKt59dDZOSVbnWvy1swWKRmsfaHj+ZD21SsD+iTQrs9THhjC3WSmjfQ2+42+wYzc0wwI/sglHpPylpvGQPyg7LifIIs9BWDKRJDUPPkr5D2OA1U7GXmPWG0G7EaxDjCjweEa4NKqp7KqKEPvxSgAR841ud3O45Usot2+r051F3Bo9FthzAiBX8qPEvorqiCVXscEGOE72HPVOYbk=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?gNhhB9iRDFkitx4TYmdMrIr1teoxZmEMzrX0SYkD/a97ZfOlwCtHvPxP15hV?=
 =?us-ascii?Q?gxC6OKAH535EdkPqvCypdrxHiG/9Kal3m5aXm3SZv2hpN+CEy58v7oN6t+aX?=
 =?us-ascii?Q?RoRl4MjM2Dx77I7/JTWlIPzikCz6diNxQAM/FZCfqBOMUYynViYZeE3UXStk?=
 =?us-ascii?Q?UrDkkH15aSZRL9stEI1SKH3L93ZdnV2BPYqqNDnue6ID3j3p8UZrA4WhZV02?=
 =?us-ascii?Q?iXfizmVYtFQa9a63h11uYa/mOp4VhqJa5OqHrF5whaOFH7VkIgasWw6b+sLa?=
 =?us-ascii?Q?RnTpJEzfjaNj2z6TQMnwXSh6pq8T3qsjR0bXII3xkuHhzyf9kbDK7sBdHswO?=
 =?us-ascii?Q?I2/MjDURS1DnPJ/SwvEbsTM812LXFKIbFhx+p6Y9YhQO82EiXDisyb0aVFlJ?=
 =?us-ascii?Q?W3LBSDTa4qZ7CHnlpBSRG57Da2/0M5gVFDl+zTeDO74zKGi83Asg6l9dzO3G?=
 =?us-ascii?Q?xQTXiYzVXdDW1X18e+anJ1hpL7tz+HkFmsX/qUvGu1v+LOdvySfWJnmsLQya?=
 =?us-ascii?Q?LmarepN5Ahxs1XsoAEtYD7u99g+VCl8W6FszN5r8mBSK3Ej+a/9TFUTdSLjJ?=
 =?us-ascii?Q?4cB5ZQt92RKZfstT6jcQgCNyY+c1blGPQcHonEjsyTDhnHg6aGk8D6j1IxzD?=
 =?us-ascii?Q?w+iZPAoKHdJlGd2xTg/xwj6P+a+8gAPs73IV6EF+A8RXqvDa9U7O3oJ3MdXS?=
 =?us-ascii?Q?0rzr5YnewvkdbLhRbcCjQLT0jZh9srPcgaljx0fPWcgDcGy9UP6eBCh/5TI8?=
 =?us-ascii?Q?mirpBDL+EA/PejA9Hk19Bir/Hpp3UNHZSRnLyjW8tpPeGA4s0T1JKeW3mLjS?=
 =?us-ascii?Q?zd+5DF+YJGAiX/vDFbEE7iCDx8iC0KUrfIEWupZH0A4Mb9t/VN+1gag6vIsS?=
 =?us-ascii?Q?X+eJdTljkBA0SXuKblNnnCWYoLB6umvSUGtmL91ELqeu7hJ3zVdeyrYxT1JM?=
 =?us-ascii?Q?vww6K+J5OvdvJSvlKBOfKNliVWVbYvPg6Jd6MgWCRAw+OsQ43oIIr0TejAwV?=
 =?us-ascii?Q?remaviuvzX6FNq2+qF0ba8otOkpNFSXIuW5cPs4Zg2pafAqDBVKoUALRRVj9?=
 =?us-ascii?Q?hXRdAeX4IQUqma4Rqn3rnM1TGX9y1Qu98tV9Xh6Pnj+oNADfEADliSJZO2Qx?=
 =?us-ascii?Q?McgPgjsyxM49aUSrdSJT7mQEjqtTBuTm9FPxR6YK+uBY1Cfp6RqdNAKDwfyR?=
 =?us-ascii?Q?bhcIGfRsKf2CVKwYKR5xXhiu6vEC8STB0E8pma6xHa2GE+D27z+S1k7SJ4ft?=
 =?us-ascii?Q?zSd86vSvsAZHRw+MbadKR65Vldwi8f3qLZ+CvYqSKtNHHtAM4kduUtzx0vOc?=
 =?us-ascii?Q?HUQhB23TlsPA9WbMOfcNpyVjrtXdOHPf9FmlBsviV+qdAP6NNi204+TQ2upI?=
 =?us-ascii?Q?dLhTMH1snkf2ThGD0YfJ3voU+oVXEyI1ydHnt4Cxb/7tRobk0Bd/hV83n9sZ?=
 =?us-ascii?Q?Y5yV8Ka0f+dACyBQNr318wcV2VehahfnohpOVr9/C38VFDlv+pYsSjiaJOXl?=
 =?us-ascii?Q?PVkW2Pa5rx7vh6voHbwyr7ttQwyah+bfNgFWqdNfGKlHnkDt6UNnGGOe3iKB?=
 =?us-ascii?Q?cfrAsFwwFAzongLqIrvz/+2eHHWxvjtYnUQo9AEw?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 bdf0ab43-7108-4dbe-3a25-08db2af6b457
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 4D7rdYu7Yq229lsRULEq7gfQJ5DkHyu5VyyEhqw2D+ZJDCFYvuKotVGTwkB104E0drqoLD/pLsipFm8byl/LwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB5238
X-ServerName: mail-tyzapc01on2095.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 7pIubeg4XGAdqA847lJJ1UIuvLHDzxjt
X-Proofpoint-GUID: 7pIubeg4XGAdqA847lJJ1UIuvLHDzxjt
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAE2dT0ZX1zd407aqWI1lnvwSVZ3VjMs4qcH1w7Sf5JzNw+OuR/9i2AJ21WsZSyL
 8IgWxJylV15tUSNgIcS9msncHMB/7ClktXF/jtkhqCkEB2/zSG6NdembWIeAYbcr
 +PDFccOuaCge/YIM7mk/DYZR4xMryEhhb2g6w8vx0GUf6U2QEXAGWNEihuDi0Jwc
 DiCYwQYtVyDDiglUtzEnqqoZpnPJcA6R5Fy5WkjyQcfv5yrHS44QR5KktU1Q/SGb
 3uRuL3T17TTRLSrDHn7x3lkuMFgK+z21+yc2cJXxQ2GyRbdSgDYed2SUEjNEmxTm
 5b/U1qKDmuu3aOG5C6fchFB2Poujuxj4552pAc+B3TGiHPXtfTgsUFsIsDDeSDj2
 WGvoNniMIJqtp0oT+V/jV1Z8OtdWwxNRefslijp+LsUzaDRQt33kgQxnpKik8agS
 6zld89zPNI/IJPTnyWw4xpOAe8d05ERzaP5yU2PzcDNFEhf+n9VpUJn+tBpHFXgZ
 tSDPXagua3pmc4P0F1iXbhJ6eClLNOVbZ4jsKy4SGwGK7Q==

There are plenty of using kobject_del() and kobject_put() together
in the kernel tree. This patch wraps these two calls in a single helper.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v3:
-convert to inline helper
v2:
-add kobject_del_and_put() users
 include/linux/kobject.h | 13 +++++++++++++
 lib/kobject.c           |  3 +--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bdab370a24f4..e21b7c22e355 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -112,6 +112,19 @@ extern struct kobject * __must_check kobject_get_unless_zero(
 						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
 
+/**
+ * kobject_del_and_put() - Delete kobject.
+ * @kobj: object.
+ *
+ * Unlink kobject from hierarchy and decrement the refcount.
+ * If refcount is 0, call kobject_cleanup().
+ */
+static inline void kobject_del_and_put(struct kobject *kobj)
+{
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+
 extern const void *kobject_namespace(const struct kobject *kobj);
 extern void kobject_get_ownership(const struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
diff --git a/lib/kobject.c b/lib/kobject.c
index f79a434e1231..e6c5a3ff1c53 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -876,8 +876,7 @@ void kset_unregister(struct kset *k)
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
