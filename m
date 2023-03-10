Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB65C7EE29
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zb11eLCS7GJl9nKC0ivBrXmP/rVC7wxUnueEJzg6x+M=;
 b=rNUOL98aVYRDYQXgeQUi0e55rUVISjoY3rtbfsuYWTogZZ6lQnD+D/P0OMyOr+aRXAerXruL04pr
   dbut4QHIoeabIdrQHzZOf2/D0L1gj3BkIxM95+glN47GVk3Qy2MTcQBrq43zwVxSF4d/M6ZTEon8
   iNhhf6IcxHtTGtIjAC7T+QSaZck+UH4/JcK3DuP2Ppg3mm/bM8J0OCTGxhtqWQKmiK7m1w3MbNZi
   oUJqe2q9qsdSmKgaHolDRq1Upvc8SJGoRyOsr6UeaEOreJLiPprJCxa90kla3qXQUCFx7g7xVHAF
   wC+xp900ngj6Hl7R4nR1CXqu4ohcmaJ/N1QczA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zb11eLCS7GJl9nKC0ivBrXmP/rVC7wxUnueEJzg6x+M=;
 b=dC3MCdoAtvYxtDnJqnHSEH5ljmW1+7YAZdikIDaBdouiA1H4UhHPedFIssrovRbKKgZ+UEi6LIuU
   yqW9HLbBdvHCADeYzGwkPhyggoF273sPCSVG0u97DNobVQTu7lYbXlIVIg9REeUWuLkEyAhL1hGV
   2NfQr1t+mfdQJMpri7HU/IL/eJC15+XXIsGIO27iNNE4aWOLy7Q640UNtKy0GsqrmixIaPDZLSbH
   FZcAJ/eInTTOPfqcLSbmfbkZuBQo4FbnGk0XQHkzZepAyI57rXyX/vt+44POQJCz3Q7qy1YhmkTG
   ItroeZG84L9GKCFAuHPvJvrildmOuEYyDSLrnA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX0070DM186C50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llbxFj5A8Pbl87w/YTIVEIrd+dLjORS5zqa4RUc90eLMOGYyueJy9tcOtRk9vbjaJZ8jBG5cK2vCFkPU/CxmbYnJ59VvLL0LKf2VT8LgjyGvWKJLQrJzqjXINcFfZ4qsBtffC9DczNIXvLa5YYaV53T2/ehEMWMRwDNVNW7PXbAfqVCpAe+3KZZzIGzzeX/+GmD+meH4R7xo+Nvdo2mMIC+59vae9qn/toqE/1HdeLgLorSCbpOG3LS70uKzfzHqzPOIJ6AnS7nHPZ4lJ9RYg4j7iY8er6ZYsfDCSKiUiup4v09uwx1k6tkHTnpH1Zpx9taGFHb3ajL2gdxIE5sebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmlasZs7L9i59O960XBl4d3nj4wDOMVdMNim3PUurcc=;
 b=VFm+ELPcTfQrL67yRFEjGfVw63ChzoYW+cofV/6UwRZdhbV9A2Imi2eA/guhgIJUs0qeShuXUZiPvWZeuHFOA7G3S/p4IAA4vhorb9oBSLe9GZQak986VkENlezLmFXiyF3o9hrteWi2VQcEW4fsnJz7Auoohz/dqA8D94LdsabxTjmd+bgRN9e8uHLShKZoM1PP+reOS4Gf+1uWELpUUS4Ic2Dq7vXLL6KE1dmZLLVs6q2K6t1fURnhPw2Kyto1ooLrMjc+lVUcaU9JHGreujZVFdl3hrWkxUzc/Z3TxAiI02R3wjTSZ17/ZxW7qpNszXouorw0lTsz3YgpkMO0kA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmlasZs7L9i59O960XBl4d3nj4wDOMVdMNim3PUurcc=;
 b=qqcZTbIkOD5oSFSGF9jmYNAyyzk9qIvGt3UaUx9dSIfZcW1tvbVCTFDCGEqdPC28mP+UUXsz2K08YW8SsRW7ERdVfAiPaMo5vfDenRFMTbcczR00jtUmjjJXcY5vJuTz003xaHZi+j/C23CU+rlYVcIj8iUWBsDrArUC+k7xhmu4RkvKTxNMDlgIG9S4Y3D5XoVrnOXH6uhiX3ErrFj2MxTZbsCNyaUq3WNhVz4DY/8hu9Im7lENLh1dR58mVM3b0dG4r0sYKZRkjsVNIWVOSr+eTCAmbKSX3FX7G54zSZ2oSIORw5YB0M9CboDmtCxLBBZ/s3TC23CucbXV/K8S8g==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Fri, 10 Mar 2023 13:48:27 +0800
Message-id: <20230310054829.4241-3-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230310054829.4241-1-frank.li@vivo.com>
References: <20230310054829.4241-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(346002)(376002)(39850400004)(136003)(396003)(366004)(451199018)(52116002)(6486002)(1076003)(26005)(6506007)(6666004)(6512007)(107886003)(186003)(4744005)(41300700001)(66946007)(66476007)(66556008)(4326008)(8676002)(7416002)(8936002)(5660300002)(86362001)(2906002)(36756003)(316002)(478600001)(921005)(83380400001)(38100700002)(38350700002)(2616005);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 05:49:13.5817 (UTC)
X-Source-IP: 40.107.117.106
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=817 lowpriorityscore=0 clxscore=96 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100045 domainage_hfrom=9103
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v4 3/5] gfs2: convert to use i_blockmask()
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
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|TYZPR06MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e9e2ca-c6bf-4ac8-d9e4-08db212b2d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 jqOXpbKKBVqWpr0dTOVpkjybpTY4ounv9sUogJZZ+14GmnUxIJP3zAmXaF2q5jNmCgcVri2kQICUNGngkbcZxAQ7Z+/Yc3jMCy+Jbv6h4FByrtNlkrjEkirZ80P7SjsgDFmy1/sWGYvMGaYx4Wna3Fup/i97OQal/uyWBENzCaZlKjWPBsPxIQxuu5fyUkvqtUjyN3CHVCZ3xEQ6PWSqu5RmcqCyQ0fSlLAZ721hSEyFvUluxBxp7s+TrrNKu8GRfjIF07fJnC1GiTq1w02QEZ7dsvYDgNvXsGynb9o3D+Q8/g1acv3PVbKSMt+HvZjeT+hn6Wuvw9YWgLTXZb0LvoWVy4HOXVZrQkhuiR0Ljcl8hvZJF26EP8nw7hG2WnRzS0VWDFZe2NhB3R7NMmdWFKgiekq1Ozq7ksitzlajfKhpJ8QdquNxo2lEQ4thaD2cLHx4gl8edCG4Brt4JjLG3U67LD1JjNm7b7+pXNS9RHhPDMB0U5hmNivDiyWvNsUZPGv1/VFV/JuprsH1D2/+5DMpaCoZPZqQeoeLs5FcXryDDVxY1HStMQxjpJNDUotM9bSuZDyD03EjGEGOPExZXsgWZfcWimjYbbVvB+5olsEBYlSKEfhZcZyunCRYgyGwgznuKS4Xk6sEDYqPxOyfpyFZhv8NTed0731r9jsM7X/6LkoH5A/Je5jON8yAwjbeGfdL4yyRW5f/On3MCbhVyzO8k6ybrm5Jc1d7RxUgtZ8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?4JvqmstesADRGcqKQDYSmBc/deP9207tey/Q/upFcxNOzhMB1TFJ+wldA2z8?=
 =?us-ascii?Q?GJ+NPJj0DtzgiUazSSreJj7+Zap/ChQIjlYh7i9ej+r0SHKGqPS2GkQ/pAHt?=
 =?us-ascii?Q?rrkyPrTaoCkroed3+wpT9DaBqWS5GXrxRVM6zSOj24yE5Szmjwku2bQ2Tqaf?=
 =?us-ascii?Q?8xhvR2P/Mc5XStyKJm0errjJmqU66o0CPrOfpoXMqanCfxq3n4CvNcdEW+yU?=
 =?us-ascii?Q?ZIyOfsurcRPJittQetAvrrK1xkWa0ABXA04PNla0/S03n+6tS6l+fLGq+/5K?=
 =?us-ascii?Q?fXgWcH3ZxcF35sfAWFHYEAYN3Dm04cz7aIA3lndtrXKJbsoeKaK5utWGl/j5?=
 =?us-ascii?Q?7EDIZ4m4hNIn2B2pcBHTNqlowSO6rQz1q2yTq3nVf0EcUfErADRixqq6xoYH?=
 =?us-ascii?Q?MZmPyJdnAWAhzORoNKI/bCgU3Z7GBaZejgvwopniG9hbEnSukC1ImKQiQH10?=
 =?us-ascii?Q?54HEaNydDISy2Fro1nmwp3BtKTD+d49TxMxqlVDdEyduQ9xwTHcrraaRICUO?=
 =?us-ascii?Q?0TMaoww8C3IyOBq0aTsybHD8vY24/+f/DWFHv9HKHCtdWUvmbCvjaN04FIm3?=
 =?us-ascii?Q?NkQYPciOtlVKLDAV5NIaIUfA/R1baxJ2aC/gA+qf/ahQ48WtN14ikcEcu8vP?=
 =?us-ascii?Q?Hh/ZrB51sPlpec8DsC5tGcaS6We2IzuGUaSA5xUKXL2JDL+UCg0IBIcwiEzV?=
 =?us-ascii?Q?/h2qEYvhDBQrzPEuClG9BD6xsYbuZahS+UDhVHV2jy5Ns0dwTo5P/CPagrGD?=
 =?us-ascii?Q?6hr6u/q5b5blPPgBvSvhN0fnenmhfz0UuezU7caHCkYPSxUsJAkNMqt7BCV5?=
 =?us-ascii?Q?JymTSHeqiv7VJ21qOC2rUmQ5MbKE1/EBgcQ0Wbwra5Gne22OsVh92FNH3TP5?=
 =?us-ascii?Q?9U9d5G7nZP6+C9BQYcgRNT1akHpNKnhe86X3o0akq0xHXrpECfwU6I9Lp9m6?=
 =?us-ascii?Q?msVXmMafscERDv7r8QjWyNYDXGDzn2S6qSP6WEdQK0fDz28EWR5lbrZVvW8S?=
 =?us-ascii?Q?nf6N7QInlCdH5Ov/HUoRTzPCw8Ca0AudjdRbxR5AkMLz5Tg4QqiCCilY+q7w?=
 =?us-ascii?Q?YksKKW6r6dS2sgjK9wXvebL7TBWijzI0LbZjixIXGndY8S1r6cnNGZPVCBdd?=
 =?us-ascii?Q?HYg84v8E6Pgj8G8lAAbEIUkmg24SpbiHnKjrstqoSIVIefVFAaAx0CjS6gD2?=
 =?us-ascii?Q?lr+mpQ15n+MTA1MGywnqjb2AbFV84ErLL1Celyrxt05R8gQlSZsnrnAqXfX/?=
 =?us-ascii?Q?UTaL3hYAiHTHCe57W2mDDARZO8dRSCEY7sLK9D+3qJmzUv0KS+zUYV4lXvkZ?=
 =?us-ascii?Q?wI29Gjj0WlISAMFBPoz7dld6xXU6hSxiec7aLITC3ZgKkOJSltb6A3PmBoyt?=
 =?us-ascii?Q?/Tsm6Zk/XJTs+y70upzL8vSmC9QFsYEDNe/hp2BJFdsoTz1BTws4c5V5r2Eg?=
 =?us-ascii?Q?Zt/bhwWb9H7e002cXIwEToeYG73IalZ10jeYTHWLLEolZiHAHddcD1YPfmQo?=
 =?us-ascii?Q?DuYX7PMN8aZJVOOFBHUhw2kXl4rG4HbLXflN3p1rzndEyrb8om+i7tEJthp6?=
 =?us-ascii?Q?mkgf7yhUII5bKH5X6HaRU8o4F3OtahxX57cKp1il?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 47e9e2ca-c6bf-4ac8-d9e4-08db212b2d80
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 kkZaT5SAT+VtFLn5GdMdMhP+iOBx7jEePtaccpqasgv/WkwLUSErXAHUKqvpIVncr5ZnpLJApNGFlGDdVflQRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6023
X-ServerName: mail-tyzapc01on2106.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: LsJ3YDKqHywzhHdO40Ige4Q7dwXplBh1
X-Proofpoint-ORIG-GUID: LsJ3YDKqHywzhHdO40Ige4Q7dwXplBh1
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAFlzmelxJYUdzSHAgGvziIcTlKXWfVv6VJzwfs81Z/WOU2w9Zp5jRQAyHpQ8EHf
 e3nAvPsXt2282S03ZKmEtNmSV/lARUO4WGi+wM+lc3Ir3x6Wzjk+bE3bPSSHKLlS
 twL/D9YOn+2/k5Tg3zerNLvbXZkaJ5L0luK3dtHsdmhtQ/2bsBTAvb5xJ1Qr1WxR
 hyEIm7u0n/7YLLEYDenCMCukEPoa4Xw0AYZoX9+K6/zWs/orAK2af3b93me/O+Nj
 l6Rhnm2jj5QnYvYFGdvmHR3u23LxSe7qYKOAm0SETeDw/IuRgADgBHt0bKN0WVGO
 tMnj2ymPbUq+AScQrMh7AmX/9LdNpr14/H61VRyxbZL1byjIVWMUb+RA3QmvL7rT
 tmgx/dpXxOxo/N3vB34+jO7BdJoowH2v5Bh6vCKaMBPomK03qBU+E/nefjrhvcWo
 ae5sD9GvpyN8EAgOwuBPAaQz3H1BOb1fSkyj8kGHImSIBdPFFUoI0gfoTWp0nvXW
 1Z0wNwdCkibRHJsfCqcGc8fgMAAiWE3rg2COOrYegDht3g==

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
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
