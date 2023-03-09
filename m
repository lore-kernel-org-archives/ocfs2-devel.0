Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C374C77B76
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tEFfM9uLdAzKvmk+02jLPzzr9iZW9qMJhtHPHjTbic0=;
 b=fkrW1B9rH5x4+ZeOEA4FQhiazD7wzz5A1IkTXYi5q11con/XsUKmzbRqcFU4rBFxirTsWHKmnrJI
   u7S5unnorKyBKUE88Yx/fseqwAcfNuYdDs5yAWMR6cmoBzK6ID4sxqhn7Q38LTjADpB6/HAsGUuP
   3NdLZ1Kq5fUZf5cLYD1NsfiyiasjJqDW+lA3nwTCg9vHDeLLytIaWN2DO3d2EapGrOWb5So8t86v
   mWyoYqTt2Pzgt0+8EPkupm2esPP2k2+OP0rZBPx4MSpOL1itEzot5vAoOR41T8ptl7bI/9kbz6eR
   dzlRvOJeACR6XbnfvYnWwI+CSSIrklQhFOElLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tEFfM9uLdAzKvmk+02jLPzzr9iZW9qMJhtHPHjTbic0=;
 b=AQevDFIHdiB1rAD5CW1rf8riN5sUwp7MXMHEpIXwPuNMeP40Dhjp9rj/hlBG2k6W8LQ08ebr0qlG
   7FzsCxrbiTmk6a+iysqg2xiL9P3h7LJjpinujHGoFYNb6leKL25d4qyE237K7zs7d9S/N2T8/jzo
   f038lnNegWTs5+Ufm30rmg+dYgIghNKgASqn5vMDhkkdyBbcOMMPWZJGWyBfS4r1gPzzmRRqd0A8
   PlRaPk6CprWyj1KOx6Itygs6vwY1Ibx5B/WubjARMz9LzcROdX9xJGHw7LrinkxwZYx3pE1MmXEG
   c0ZB0nEHu+xxMK6cuNIPog+rFKhaeRZGC0ydYQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00LCYM17G570@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBZp69LbLGq3HLC+g9DslItHy6JmL9+w/Iz7oDJpbe2+mKPFnZYdfHF8QcJf6Vrw2CCfuJj2GFbQs4Ero19J+ZFaYrrnqGsjYRqppe8pdSQgkj0GShsPeElQSpoCt49/eLAGcC+6O5UM79RxTdE9YHFmRdO5C84svfEO+ckjJy+Mqjcxtxq30c2AofDp4FzlSo5oO6f4UxDMJwK7nHPloCD3KRGIRdsRMK1Q84Kj3t/CZ9yquApnEM0vWcMFydtqnlETYrPel6mpsFr5ytVm3Mhye0iXj0E9Di//1gKZ6EGHW9eSTnhw7fZWkVSQGD6XDSbmiqEcNQH4e3QNfFTbzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwynQujYWLmomSTW+O+riD1QybTK4tF8eo7csGlUAVc=;
 b=SGGQlROZYZqBYiwqCGj+Z7e+5t+DutwVuif+oHYLgwW1XDtkL2C9iK4Ne1cGffwnHfT6n0JHP4L+n/WZFJ/YnTr//YiWQutG4fSIQXcXcqpuwa2JaF1cq0UUfwADogIiEUcrEFrWoRSo2uqBWMJAfgUlsWZ9T4J1syP2Ji/l9Gif0OEshzknXKN+y3Sd7PgTb3Z94MOPifeIIqKfhkyZH98ph0zGK+2jhAAgSpUBlN380miPOT+Ul1t4emJeTKOiBXlCz0LaLBYYNMDpkK0G2jFeBKGSv0XF8yqxXkFlnw9Hph+gQ1vVNlIBsSQgI7HN5Nmjd0xoLHoMCGLtTZFi9g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwynQujYWLmomSTW+O+riD1QybTK4tF8eo7csGlUAVc=;
 b=QNoW48eaQIMcvUo6+PcGITmRqc/cC+5Fq8oNP2n9WRcm1gqpEYHISyyp7bfGIw02SbhFOSqWXEzI+X0xQtoprUIzDyuYHfXuXqvd2zFKK9BkvrtFO0LFkGTHGq/hLt3pQ6+VaxjEf6SC3Sa3AaXWG1wCSgVS9gQJXi0vvC+OW+lPfnk09ufw+4YW6HlIaA3zG1QZfq3dOlFXr+I1P/XOwcG1xNAtp7n44cy9u7AfJmGomVeZZFsedUJ6GzRCXdMJheBUHOYA+sa2v9C9mEGLo20y25LWWWe2tO4Fu0ZLdhio9BNR/jRryM2vD6MJ7OiV+s7KkZZI7udVgJeybcefFg==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 23:21:22 +0800
Message-id: <20230309152127.41427-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(36756003)(921005)(86362001)(38350700002)(38100700002)(1076003)(6506007)(26005)(107886003)(6512007)(83380400001)(6666004)(186003)(2616005)(8936002)(5660300002)(6486002)(478600001)(7416002)(52116002)(41300700001)(4744005)(66946007)(2906002)(66556008)(8676002)(4326008)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:21:59.0430 (UTC)
X-Source-IP: 40.107.255.128
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 clxscore=71 mlxlogscore=768 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=104 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090121 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v3 1/6] fs: add i_blockmask()
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
X-MS-Office365-Filtering-Correlation-Id: aacda692-1cf9-40a2-33fb-08db20b20679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 G4Pjw5dPbaeSobXs+hHJALkpNaxqVrInZ3P/dUvslGuaxS5icrGf96zouh8jplvNB9vxQpnsRa4gaNPe9gzbGAgkRQuqoMpWK2YtRZrYOxi/fHbUg0iZZk8HjtMdiLqjf/ov0dojwJNNBbB/ygRySIB4bIdMEODvYaTpf3G0gVGsT0D7Jun1L25zdyUQ7QsQW1yWhfSr0+MOlLlMfqv+5xgdiGTE0/9yV5erJa68ZZueXzRTWL6oKJ9OuU8nXswEKxPdf6Sf5hNnaShnX4myd1MlY0lTD2ARtH5B90utrosTWZMq4TDVQ7rw6xlI6tyqtdGvGSVcLF3zxvUFn0vh1NBpjmbexF3RsSAnIj0JzZIh/N2GsbArXeBQUa+8qcXm3W0QJEmgOYGEtW1SNhwc7PT5S85ZuHMsis3CphPJz7RbmM200a7tUwDGJVpAcs2MkWYQi2cRBgudTs6l9WsnCyFwsL92Oc6AR6/FreBUQfHdmWY+LqBgWE9Slrq4X3+PdpDRUWf2u7sbODRjuh4UIcCi1fScvBGSQsiFA2hJ46TQ6HjXkwogwGmwjhaadTdg4JkwBll4ZuUrp2ySrxyu7VmevNbfjyYLp6VKPcMX2hJdzIL12yyxeh0lT9FPrjtv2D10vqjZ2dBlaq/Y79ryV3Uyg6BoTbLONg9I29xM/n0CUZYLqey0NKtt3hy9QrqF6Jzy2RudsrKq/ACGuN/QN+lKCqraob8o7IelUu4FL7k=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vFx2AaYmgjQTOiYJdNJ5Y2pz5I2+7gQRUQbTGVCKvSa8v7E+P7ep3I00wZSv?=
 =?us-ascii?Q?VfE0nFh+V+/xPB515Yiy/hhWJnlrxR2D24OkN7vT5hrKrOwK65WOdtB/q3bt?=
 =?us-ascii?Q?Cg4GXr1OcU9EWW5SXgSdswmVrlvFNICPgND5kmkmOg31+mLQ/FO8TKs7y46U?=
 =?us-ascii?Q?RKav4GuVECPl3g8Ok0L3KrAnJEzy4g5Pjrv3ooz/N+BsiyGlJo2wVWrK4gOk?=
 =?us-ascii?Q?Hx2EXIT84qNpt28auIFSAmWOqLe7e8lp9+JnhOZ0Hna6ElQYpx6XsEbYAP8b?=
 =?us-ascii?Q?2+TPTk5YPXLjFSrF+KdC/VDd5bKdG9oRDm7lI283GnZ9YRrzr7xX0/znm0MS?=
 =?us-ascii?Q?kg2zM/eD0Z5a4mImqncZgy0mNRzjS9y9oPF6CdPLarhGsKj8EOPuhx1hiH4l?=
 =?us-ascii?Q?o55dOTH46d4uIQYnWJYxb36hwjopa+sxAN71ybNjJsDhy2Q5d/vmvskZvUVc?=
 =?us-ascii?Q?xEr+h97vTkmopm4HLy8N1O2AMxRucb3LR2kSNbhFaRMQuyFtSX+EGl1RRUL8?=
 =?us-ascii?Q?Plh/gbNRe8IS/91y5TgY6uW3s0e/aUUcN4b6I+VRyV+dfQco+BXJYpgH51bi?=
 =?us-ascii?Q?L3oDXGZ//CJxHIU0GW1sVPHgPeNaa5NhxGYMz9F/mUWnd2KerbGPDMx932/T?=
 =?us-ascii?Q?YLTGfz1BvRnvSlik2oaFpdLdZcBnpn6YtIEhT5mONy/vjZZYoAbmMLB82rbp?=
 =?us-ascii?Q?tRxFb1of7/VPlkdMzzbWgudYviRcB4It6hhNjLGwm1hLN0slh2p3XAT44KaM?=
 =?us-ascii?Q?9IPR/0zcnNsDzGfOe5xUNCYlSbIVggR8FdGOtymqpBKxqVMe8Ar7NjVOrrNZ?=
 =?us-ascii?Q?MF73ThDzGmF5vbspU5mD1DtUdD+P86kcvB1D+ShJ1WXvwEnvAbaJ5bZaJ+A0?=
 =?us-ascii?Q?hL/l2HW7q/spXdnqB6TVIoLg2MAE9JnNXfzgsIuw1Plj7Qm+3mU6kpt5nLZU?=
 =?us-ascii?Q?t6mtWMTBVLx0AyboOaRr47q7TmT2Qo2HnJvJq4XYi/efWXkTwFJqimyD2z6D?=
 =?us-ascii?Q?VuVmB3oATIbFca6/vcI2oUELNeyxOevQ3WEcjeZLgDD3qfMk+vagfHq9C7Ig?=
 =?us-ascii?Q?QWbVflP8/m3opCF6XYQPhef+qBLYhsGh1pt8tKhOFQ5phA8V1KbdcYeqkuOQ?=
 =?us-ascii?Q?Ba0LLLP3RDkP/b/I+RSYNadSLCUk8nykWiG2d1yjySC6koy9py/eXuCn19A5?=
 =?us-ascii?Q?ACEBPiuO1J5+iM6HQjiTlLEwo6F3+nYRGHYY0REkw3lfHwapMsZJM6Eho4mt?=
 =?us-ascii?Q?Do/NFIq9EEQ0l1fZLO/KBXQyzYZBAE2uSMsAb65B3OXg3SJoESDA2Ff12zyS?=
 =?us-ascii?Q?m2MQhiF4Jk4Nb19tenHd0CnhzP3FFJR7mV18bLy+byQatBjnhMQb6syxZcTX?=
 =?us-ascii?Q?8Rbik+sQrcd32mOHluSAB25n0Jvyx+c0h8LnWnpD1K0eHwAi7lhyJwnDpXWL?=
 =?us-ascii?Q?Tdx4Md19zaKfKYbVwhSLY8VoKto/mpq7hLWp1kkwRQZbxsQTK9OAvELAISiC?=
 =?us-ascii?Q?qqOBniy+WF5ditT2ovAS02OEPJdCpoXN3fheGiSJWGCw6PGoShpK+wMU5Nrh?=
 =?us-ascii?Q?cQVagMdHPE9VDkQ+Z7PmcMs3dUY+Re+9mJcAZWp0?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 aacda692-1cf9-40a2-33fb-08db20b20679
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 otqDAUOTrXaBBUEezH21yUh1L+jDlF9Dyb8Bvsa2Kw1WC6aF8euhBTSXugH8TLCPAudua1xbzopsJ55utVQnWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
X-ServerName: mail-psaapc01on2128.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: C3ILx4ZEzN7eqG1R34SflJHdl4jTSU7z
X-Proofpoint-ORIG-GUID: C3ILx4ZEzN7eqG1R34SflJHdl4jTSU7z
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEXNeKJajLa7khJMl8igq/khFLdXJ5KuCz5YDxID9gkSu5weHAQJDTMKYifxv4B
 6ZgP38ZPe/cES2RfEOyr1ujfLwvQLCoB9qLWvKaiQfu3miZ/PtWTUVKg/vzZuVSr
 Z3jbwOCEXKLtnwA8hP38UmgO9lkyO+8CL8tzn/8wV91f53h1ped0vZZBwoDdqvnh
 M5uzGvfALHHXIcwCt8xiVZxV3uhpPglL7Ah628zR9gvu9nerOiqTZEOHlTEHEZH5
 yI0x8yCY7qYJJakYj/ggKot2L3fR9iuwdgRZgjzG6KARUFonTSRhO4j1Z+WK3Ofu
 XsYdNfU8pOd4wAI3PPLqLW+GMyhhXrKfR64Uyy7zPND+rxOX1AKSE/18a+tmujdV
 /a+uzGakGukTUI5qra1EuT38cqG7Hql6TFUsgJCm7zFfboy2aK/t/1b+sb5Nwp9+
 bPG18xZAjRivBj3RESrh4j77o00NIc/JoXwUk2mmZfdNQpHFwyX67dNR34bqNvAX
 dQiUB8jHQSSOyKxqOjPz8vBAAWgYLBRCC5fsLhCQkCMJ

Introduce i_blockmask() to simplify code, which replace
(i_blocksize(node) - 1). Like done in commit
93407472a21b("fs: add i_blocksize()").

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v3:
-none
v2:
-convert to i_blockmask()
 include/linux/fs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c85916e9f7db..17387d465b8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -711,6 +711,11 @@ static inline unsigned int i_blocksize(const struct inode *node)
 	return (1 << node->i_blkbits);
 }
 
+static inline unsigned int i_blockmask(const struct inode *node)
+{
+	return i_blocksize(node) - 1;
+}
+
 static inline int inode_unhashed(struct inode *inode)
 {
 	return hlist_unhashed(&inode->i_hash);
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
