Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586DCC7EE25
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LYE5XtUVxIg+51WOlqZL54DGh/SRlJzVZSh9LPP5pnw=;
 b=17BtSgY+Pz+GRfYO+GUNUdxG0dIW96aYjKZ+c32fiDDJynWltbAiQi7ROUCBV6mSarjHb1swyWOK
   e/wUsMnLsmEpnAOpE8n9MfNMcPuTXnrxBGCpS4TExOLIhUzuQ+dkhIT2SzCc9kGYpQLNpZ1UDnM4
   SUH+YUtVwtbyiv+DX6FakdCJU9ggjDXuUxSJTOqumssuNp+xSHWMzb6+n6qu9ze2ShNn0weANQrM
   qzEs4ROsZ6UbIdZXSm9peLYvalpJVCHRVXg6KyGRINf9uu5AiawrHzyy7Pz8RQh6r2sxEGjr0Zye
   1X0OfXcVTAZM9CJk5fgx2fnpbnMJeKUyCZy9CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LYE5XtUVxIg+51WOlqZL54DGh/SRlJzVZSh9LPP5pnw=;
 b=m+uAAsUx72CXIJUPnVZ0iCK9y33odOO+YSU3VUxGxLjzABAs3gaibteIIebQBxWR/eHckncUkF1y
   X0sF5h3dN7WV0AZz75d4TyMbFWoOWJgBVfdjwjiP4M9JzC/n9TcxbFaS9RxSQvRxGzmeofnDCOdL
   EAjWN/R2yGK0MB/Z5Yo5s366YelT1HE10trkbdVZ/qdpilvBB+QqclSZ7NQ8phJqwfOH6GBn9wOv
   6O6wTv3cTPRAlPmJ4ZYGCACmN/zMqjgTr7D9hOFjWzay16HPGwJoIvMHeSA4FVQoal45U5V+3qOX
   EBsdQSvl9+PfjOtpeROui61CLBZww+yAdizKPg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00M7JM1AMU70@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJXnn42dupxCn/aHuoPhXc1MJewqxf5DQEi914iewchXmxgf7B4urbDMd7vy2GgBA+InpHukLnptxAcBim1uHM0F/S0O/ig47VMbCrKH1vzV4aUhgjBVAJMqFAC6bfQe30kNOdQaOMlHVOIxrbbwKbvAuOcOTcgH7a1WMF+7BKqTAGQRew8GzNqYvXvw7LNZ/Tf6TUp+mTd2d1jjb+si6x9toOJEcTgXMgUEgv8bHV4CZbxaVZhl6W+hx+9mGQI0Ed36U9hI9uwtnWhg/kagAropb7Jn8DI4jz7DMM7yQrOv07Rlg0eZp3V9HShgdtZPtGoaS1lqFPawvaZcRAxIsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaz7sro1mufIsFtGo/KmH1j43gttN9A3IKPHYDRmxN8=;
 b=Yb0s7HzDWYBmeIlYWcEdC+zUuwgh8L9PecUrJLscn2tOxqhcBmw0/JGyFliAS8wM6fuYehC5/8WGciNedFc254peauMkfa/Mph82bYpzqFwtZr7ifA8EkUeUEoGm88P4qnlB3rkHFMPlOJ47sbkVjfx8KYFV2x1iSMPPwArhtnHH0aofi4e9hTP8xHkLIOkz+lp5pVgA9oyUFRVbly8EOydBq0IvmDxMk+Xj969rRxgimuuJD8fs4Co2UiGdT/J/Q39jMfqy7RA2gK/yfjpWid3mTKluULdFOYzq14TJ/nvVfU0JzKfUleQCihL9Ru/l+/bWGRUv/25hBMqGCZ3wqA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaz7sro1mufIsFtGo/KmH1j43gttN9A3IKPHYDRmxN8=;
 b=U6V+YN+TCMI1JvM+09xhAPNn5qJLmiivicecQMHjisYYMEqLtBYBY9ZRoaSaSG5PIrKqSrNYL1VYvU8VPYDqFaFj9n5UNBRvwLav267zbhlaM9Ltm9gWMbeebRIdNpvzpEYUnz3ffoCMorwgAxLqdmbkDwEKMGVhleOJjrJGoGbR0XVycABs1lO2+bxpP6/5/oS4CFLYOQCPGA5ieAoZA1kmBMvOTKvxQffF0+7KtZyMckDiDWpGnZtXIyGhkZO9UGEXsEpko9o8C9YAq2lZO3tvwPGuZvtPciPW9oV3XAzwaW8QQjNHMNRii5a116jz4G8cSRr8xhOlDQHdk0K3Qg==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 19 Mar 2023 16:41:31 +0800
Message-id: <20230319084134.11804-8-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230319084134.11804-1-frank.li@vivo.com>
References: <20230319084134.11804-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199018)(86362001)(36756003)(52116002)(83380400001)(316002)(8676002)(4326008)(66476007)(66946007)(66556008)(110136005)(478600001)(186003)(26005)(1076003)(6512007)(6506007)(2616005)(6486002)(6666004)(38100700002)(38350700002)(8936002)(4744005)(5660300002)(41300700001)(2906002);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 08:42:07.0653 (UTC)
X-Source-IP: 40.107.117.136
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10653
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 adultscore=0 mlxlogscore=872 clxscore=96 phishscore=0
 spamscore=0 priorityscore=118 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303190073 domainage_hfrom=9112
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 Yangtao Li <frank.li@vivo.com>
Subject: [Ocfs2-devel] [PATCH v2 08/10] ocfs2: convert to	kobject_del_and_put()
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
X-ClientProxiedBy: SI2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:195::20) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SEYPR06MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: 32019a8a-39ed-457d-5b04-08db2855d251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ajOiPF8D8AeqrOC4LS/FV9TLlRp3sXOc1Vrd7DVy8SsfK+W9EUCzMPnz8vFjCAZwsAdyzGRIrBGv+t69aPf+2Zvn7MJIF9WqF3AzQYqGgpv29l+akxAYvGjBOUMPmZtRN4+KIU7TGe5iR7/MxDk/0eN6VyYy7XU7irqeVXrPjQH3DTkB6WvbhbTRURRthhmPs09Sa1hF+hfIRp9+Y6Hsnc0nVmof1HD6I6xQIFoJL3yRB70BeFB5tqgJjdTsbJMzeaNgMbxM/RFd5N2th1mtUJMSZBj29ZTg6sl2bQzsJ8lTxlAwdeYKkZIP9kFA+Yn9shLndlgno0MZXIYM/fzUegSU3f+rcNueF4aQZWpQ0mdELp/+dVbzX353qUVTbUTa0+ZzsNbxUWhQsUemDLGEoX6ZzqQ+7gLhk288yDXSoD8fUFw4zTMlI1UifQDSQdfZHReFGJEnjV/ZtcPDKKMbAouG8m/O4+wNfQBha7tcZg8HF/ez8Y8xKFgiLB7/04Wuaa+NQ8yIuH4Eb7Z2YM3rYMl8KRlntXAnDnt6wQ3ucvxV5BzYIrhYOB45Ql5Bgc5iVCKb7WaYtz0Qsi69njwx4je61IP+B/rXt8+SnydhfNN3L1K2RGDCg6OJ1An7GGLGEWiH0FyivJfvZaIddHg8MGZ9q0RYBc0x0G9XRRgMIABan+YhyD8EgPteDWG074MlT1hJGtMtxa9XXld8wB9n6w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?VlU0kjacWlZOW/0rCPcU3wNLD4fttd161KHqZxuWXlLSrZX+7hHfrQTkdC8m?=
 =?us-ascii?Q?aYWr9klOitjAl2FDKkwEkepPUj4WesqnQUI1O7TxwrIQtFA6x92XpWrhGqcB?=
 =?us-ascii?Q?xhUurv3Xo9tkKHUUrdGTwWgPA/aTZH6U3Upqx/ayHGZ+bMN3XyzrkwEyL1zc?=
 =?us-ascii?Q?t942F82EIyjZthIf9WU1OUfdmrkKFxSF7jGx2pQhv84LZfRkkOqecfVQyUdE?=
 =?us-ascii?Q?kqpqbjlPZ4GapE1W6/kynRkArFyITAov7hVhbIO4nbUhbkEd1f0fwQpIgb/w?=
 =?us-ascii?Q?j4Q0MqoUXmqTezEGtNE3XXDN+crGWrKv0S+ByKzNOQrnY3zXNNtEvqI8Wq0H?=
 =?us-ascii?Q?fQpUDBkCq5WtRbJwR5qBYXnzpCCv21cw9IoC79Zokn0+stQ9VQtqTafuvX0b?=
 =?us-ascii?Q?Nro2seUTRJwdwvG5hGM9woiffbEAtNcpFbpdZPCMHPOyhUzkGX3DOSEUjlj+?=
 =?us-ascii?Q?5u66wP+IDY3w1rDX9z3C7wJs2RBFXkETuXDtxHJ1/TbkvlkCSO0XFD8tJ8l6?=
 =?us-ascii?Q?JH9IYMRfMtYFEQY4VwtUrsTgOayLKHq/8lXxKwVPUPUjWIyZjOc7H75VUnUR?=
 =?us-ascii?Q?/PcYGCrHLdvZtCKsMSYgtpJmRBQlxXplMBm5NXTwEZzTy1G65rztfc5N5Siq?=
 =?us-ascii?Q?jfN6EPygypTx/BPiik8FCh8m7pNVlMvj6KlD+m8ct+vKC8b2BqTttEHoiAxk?=
 =?us-ascii?Q?Tf91gi8KhZOMwtf8b4BcAgN2a1laLMzHacdJBta2TLzyYizABt82AjP8J3PO?=
 =?us-ascii?Q?rFqhi5nFphq5nCwmVenkugSLeey9jiKCxu96ZMlDC2idjkYmD1ujYEfkTKTn?=
 =?us-ascii?Q?mBqndmkHgfZmU9omE+uE3V8hSAtqX35K3do/dg3CSu3A368zxfUg9wRKTQTX?=
 =?us-ascii?Q?Q1kWWnP7bQQJsQoxXM82whiitAMHA8NC3UqOcj5aM6DMomFjTsWWYZ4iqFQT?=
 =?us-ascii?Q?sjVtMZYuXqbgLCW4tZcsTNm/8OPms9Q9fn4Y/ZHJzCtupXOP1fFfxMCHtb8g?=
 =?us-ascii?Q?27qysESvABCRAjfgqHq6t+92rNbUjPHRPB+wP/LfxYWntUgPDJIPLGncXNog?=
 =?us-ascii?Q?G0lxxqf/Soi3RNfBttmeKlPC8MO9EZaNIH993D79zYuAFi8FCWpXQluAflu2?=
 =?us-ascii?Q?32tD/vHZMleGiNcgAw0FwRNX2JMqwzSceW3tJ4hrYpw5ebP8MXvaEFqKLsYO?=
 =?us-ascii?Q?pP+2sgfPATttd+IyywZAjjiXgj3efgs9gVvRvJza663bSLvF4ZK2phioMnHV?=
 =?us-ascii?Q?hwe1g4adU4N3YQ/WglWbgH22o6WuXnJVEOAAmxVhbf1QEV3Mku2p07tOKMOf?=
 =?us-ascii?Q?ieVSB/poL8pb/wtM/diBnQVSCSwkSdnBPeOaImgG9m0MR+jo+LV/bJ9XmAHu?=
 =?us-ascii?Q?+QZ5T4dCgLt1GqOF06q7KqhC/dHhly1qoHqQG1fUoSoobGNzXnUnPdixZsa+?=
 =?us-ascii?Q?/NRCM7Dhkr1TsxxmUZb8Zqqg0R2fsIK8gt4vDDgr59aJuc9io9v19n6BLSTx?=
 =?us-ascii?Q?Z55fqe4A0ojZ892pXSTGlUOyYZGdvTl/Mu9aA8Rm+HOqYBLxrltGZjT1vzNR?=
 =?us-ascii?Q?7mjp94V65G3PTcUEicBbYLjgdgg/izmzN47zsdI+?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 32019a8a-39ed-457d-5b04-08db2855d251
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 GvtUHCsDKmudGeN33oZdCIADbe75NO6GjYl/GToOAygYWhYUftcojTxBoLP00iuakud5DOUWfvS5BV5eK+dIqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5350
X-ServerName: mail-tyzapc01on2136.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: aOedfzu9ZpkNcsR7ULdsfjDkvjYTKkTh
X-Proofpoint-GUID: aOedfzu9ZpkNcsR7ULdsfjDkvjYTKkTh
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAF2ZR2AfcWj9C6hRzKffIFez1A4y/BOnktonO7NLGDJcKz+ILtJptIP0diSvwpV
 0hZMpCogTOpWjtLGGhae3ths9YiwQElOkbpui2+w/d7Vyd8VbF1i5EpiCwOH4uvW
 208YfA1S74uNdI71Rx6s5nsVIfvz0P58tgIIQpa/nwwUwTLHg6JbesQzjqEJP1dM
 DS1NMM0eOWdL9RfQOsgdIiZ4SEIPi5vLrWAXspsXP7cBZDBcGAxOZB7ubfRedAbC
 3ciHKEG40mhdY1hxfNqmcyNQMeB3IMb6FOBeBpF8oRTnngj8yg/2EAPAG8eSKTTa
 cIe4Jpug0xbqFU1veZ5yUibagDQhqs9YQp3PHbOMbitWamiHF+hJ6/Q3RdMniM/o
 XIvwez//0NdnJwh8a9wIGzPOfc0vNR9BssHYf8PPLDz/pOKC8q0T62WGP1bDCKwV
 z3kHvgNuhOm2PcTSQLA/jT/VPIG05Ta4kvc36EOtUZXQmlwQj8/x6lgEmSUXs/aS
 8y4inrFsx/3cNoZlyyjci3wCDIHLvadyPFhGLP7GAhuOLg==

Use kobject_del_and_put() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/ocfs2/filecheck.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 1ad7106741f8..fb9cf601245b 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -198,8 +198,7 @@ void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb)
 	if (!osb->osb_fc_ent.fs_fcheck)
 		return;
 
-	kobject_del(&osb->osb_fc_ent.fs_kobj);
-	kobject_put(&osb->osb_fc_ent.fs_kobj);
+	kobject_del_and_put(&osb->osb_fc_ent.fs_kobj);
 	wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
 	ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
 }
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
