Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9EFCC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EonWfD5oayTWmLVCw6Ee4yHLqdab3EnLtrHINobJPp8=;
 b=kLfTxyAszDNaYSRalm3NX4nTDghLeBaQkgdB1UKnJNwn/L6XQrE8fLg/5JDSr4iWxPIRiOKZ4D0o
   8eSi7yhvYxHBH5hkMbmZs8oyjgejFwf5rRD6IFDC2pO+ZzG07EGtXeSEcq7QeS7v6ZlDX63tDDJX
   uhzTvCtTE+Ji3kMBum/AvK1ICEM70OkT89+dA/L3ljJuJechsgLDrbRBKlEYoxT2hwoKIYtbE7+3
   TOoutI0j3KfSI9UuZo/nh6Ucu7yia2CQs4o+ZrQFnsBRvKN/EwHqGbrP+A3NS5Wqc/HG3fe3BvpZ
   16Png6nqSlkQPrh0/fZjjE8qAYngEefEnHZF3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EonWfD5oayTWmLVCw6Ee4yHLqdab3EnLtrHINobJPp8=;
 b=Q23c7CT/6cldBBfquBdOLS1VzOt727yfX8MLyGVvOu1KAW3lPrTHbZp4cm3PLQTWwUcA0IlIDUn6
   6u5Z+504XNjOMvYSzQwXfGiYpH+AxyVcdRDVG/rFMfUE7vwRX1sHVw/LD/QEkVuGb1GlGFlATUuw
   mGHYTEqq1NvP9/qd4zWrr5D1suMB1GWGy5nqqeRo44Pstqpj3gD1kuIC/RBpyL6cDREk94449+hw
   D6ZTia13vY+7b4oLKvNk5uwZox65CDMo/MOCSlXCZ3MsSSJPLjirE7gFnMZy2SHyysu1/SXJTwtO
   RzucdJ+WRjAbi/WpWiWu1lcu8Ej8TZ3Q6zaYyQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA9001ZOW0O6W70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 10:05:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838628;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=w1fN5PKVHQ3C4Na1DwohHEyVc/EpHkk6iJz2kYgELLA=;
 b=ZrT8Q4ix5DJk8UQx38G/tZH9sVjXaFXDcSJMfhxzYd6Q/18dRuHHZb32a9W1JeuCIzdSqn
 dsA29VU4p3W9y2eP4CVGAyK4alYXqf9BD8jtP9BSxms9vkkbxEH/Od+DPXlOj+XMS/jmOM
 tDgdJm5GT7UBUlXlvfc53/UcN3ZwEwE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlXvnwUL3FCkBOPJQJwyW2vlTGoqC7ZeUEhqXiCnLSkIGFS+pWbYaKyebhaEpF4VNvDNnVJlsV6dJUGXFDtq8GaQzoydZZOM1Zl2+uO8BCIw03rVK3PykmWnPW9sI4r8z2wGCCGZ5jZlfpFrAFlqe+siN7IYh6FLNRlpp18RCEdjUYw7DfMXL+qVY9KEeY07Xuo0wJVBATuSZLdho9Cr+VjOZdV6rrzbU7trUtVY8din8rVzDmjnWUmSRDneoTFF/COj5IxTHIjXRZJwlphjAwaY8WgQWX6f8lI+UOk5+H3CvFMacgqhFUlSS44GATyBr6JvTthrEbW7Aaph8FuFeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BzVf/NOcs7f5uTMYB4NRc+D90MHqXSlaIPSWccqPes=;
 b=gBAHttxgAZNnerRdUGMmRcb4lBdEyPcsFTe/E5S5vNplosNnlJrqqD3liO9bKVXxUiE+BvAWjTUBZu9hS9kvCFk+cKFjHl2TJ73ZeM4paccguDPnu9GpZ1rm3ttSe3sEbFPgRvGrrFptcVHR6Kun59RP2KIB906DFLMYCZaGmdDRZO0phzgFyZaBIxpYmngk5m/iKHcGoFeUkFUgbMfexBMQHUDnn3NnELPq2BvsrkGeG36F8oPIL/iDw86qwsd5Lrz+YcmIAOAP9FU4fXibczFYJsBtUmuu07jJl1UWVHNihfok1Nm+1dxnAVxTL2zLivaw8qLZ5xtgvGe/z+Ob5A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:54 +0800
Message-id: <20220413082957.28774-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220413082957.28774-1-heming.zhao@suse.com>
References: <20220413082957.28774-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(6666004)(2906002)(186003)(6506007)(5660300002)(44832011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:27.1029 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=225 malwarescore=0 clxscore=165 phishscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130047
Subject: [Ocfs2-devel] [PATCH v2 2/5] ocfs2: change return type of
	ocfs2_resmap_init
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
X-MC-Unique: 58FL_ohmOe-Cboi8jpMkkQ-1
X-ClientProxiedBy: TYAPR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:404:15::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c70d5b54-8dc9-4a31-7ab1-08da1d27dcb4
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB8100B20DEA15B2FE4062E5BD97EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 G2aFjRSq+7IOabd2RrxM3SGeXlz1/rn/jW3jELVCYVD/VD5ghBoDcoZNTDwoy2WjrEt2AlgO6qiRIxfol89V/q1FpT0F/MXey/MgPa7/fpPvxizQ1qY8d7s/t5zlk6Fjnemq4ebcruL3NPMLd1mhbSBRW0vnjzWxNEsFV0QkjkaErhQ2mT0rXOKZ23UZbsVTiFYhkhJ4mYddtDeVIDo1Kx/fu1CveGBLOTL+ik53d2GywYZc28JaAucO6lpOoORgapj1fGNzfSD3Qb0toPszymt4so44RuP3OjNEP7+VOtUcF/q3XqmecbHYpD0slHFVYx2gw4Z2eaQnQwtcMXCa/2gCfIBFNAQ1s66HWUXLD/X3JLMnr2dDm4PchNn38EHBeENTeHO3BI8HcxrZjozGYfPIzZH7JJynZNdqS3nk4Pnn8kk2YPaJxm7V5iAKBAJ/h1vkAfrWOkboqfB7MSEEUs7LLN/uEAS3RMGAAdQo6aQaAYoD85F6srkPXjqUMXwgvlNeQinAmMkRvFle8UzfjF1Dh1gQw+TwAbKVf3KXOxX7nb/ChcJ6xCqRFZwym3ZFW/uzJ/0RVZBuE00Om4u7Z+7k/jqVOQpHfDbi0VFKktbRjdBMFD/2bOiXBIWqzSt7cP+66u3sPH5hw05KgttqkA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?G4rZ1kOtgy/gbQxs5Y3Ww13i0wFUP1tRJXvXTNDhUuyGs4aR/B4tUG1usgeK?=
 =?us-ascii?Q?p7Gjva0bmjMdU9qQTCzHGLuh7u2nGl6+8zqRkViNOhR+kNRNvo3jczpfMYif?=
 =?us-ascii?Q?u7vRamXwyld8HKxxU7zupIuFBVGCnhVqeDLhVWzJOpZPO6iMqafqKh8DN8o+?=
 =?us-ascii?Q?WNZpUhvmWPmDj7kXZwOmOMsW55rOn1u4C2vyhcsravD9VEb1sZXoDHgtttK+?=
 =?us-ascii?Q?tsNJJRC7efX6xfdhQZTi6Jm1HUxuuSfm7C0bXZyu73oA9rCH7gpv5zTroUhi?=
 =?us-ascii?Q?3uwTsJurd5QKCoInaerQo1tuEQEncvNhHIqPWc5XVZ244NEXxxWYqaJW0HyN?=
 =?us-ascii?Q?uEyYmSi4PqqQz8o9bCwnLbhYaQbPG9VzeYqR4RM6R9QQ3g++o2RlWj4paPM/?=
 =?us-ascii?Q?jWzSM9D1FJs3iXXwPG4/3kLHQN8bsIm6kVzD1rle+HYzCzkkcewp85LMTrPi?=
 =?us-ascii?Q?ilZkQBfORGKTgJN402PyhH2inJyST1DLYxq3FA+WPgQPxHdipswcbbLVVQSw?=
 =?us-ascii?Q?BPGTOCE7whvg9ZBYR1l3m4WOvN48b9pKUdvZmYLkzzp7xu8IfT+0/iY7cqDJ?=
 =?us-ascii?Q?LTd+ouhnD69yXy4Ws2a/ejBV3lUSwGkkF0Mz1wXNaymQ7dvxdO2uVBlg3G/o?=
 =?us-ascii?Q?u1RcWIc8eih0aCfITNcDezACh8Ch5SXiOKkPZ7dmL4aLMJN5vI/ZgOzOUgmV?=
 =?us-ascii?Q?o2Wy+BRcn7VksQZ9+hhysMmTTw11ARB9YDYpgnVL2I8MbF/CM8kGk1erppCq?=
 =?us-ascii?Q?junRZJyZv4aqSaUuqTMTtLf6KCnNe9AgiNf6cAVebO8oHSjsbAmhFDPK5TB7?=
 =?us-ascii?Q?VBmIA+sWkcyfagafVzZC1tXSQuzfYWt1nmDLKc3KIvdRYo11UMDqSG3m0Aho?=
 =?us-ascii?Q?J0Q4iR9kczjnAQA0l7tRd4liFYJx1DjCKjRdr+BjSCkUBHOCTdI8chV2RVTx?=
 =?us-ascii?Q?q9C3nliKZGemQ/daSWjz9ecMWaLxjdJkcQt9vV5DDqQHmppR20cptApD04YP?=
 =?us-ascii?Q?BrjlttNUVXlJTKDAXzcWmRNKglUmIvMCFEPEiFMr5mMmLdDljAfCqrACmM2o?=
 =?us-ascii?Q?oamQAMDMJY29w8uQEmWBS2QY8nVJirgWkrQxwnXjOf/NRWIpVJd3H8glZAkX?=
 =?us-ascii?Q?TLitZ65VF4BWx7qJCyJaU6LpJnGKW7atOwZB7mfj27Cm2V0vb4Kwb3vJi/+G?=
 =?us-ascii?Q?4uvAbIqdACbg//2A6Tv2hbyeaTRKbJ2Lvb7kwmtSF3KL/QqVnM2qcQXXglt+?=
 =?us-ascii?Q?BxgK8lyZNRKhAZicAnhJa42weRCF62DAbEQ4o4UPnsJIH0SW/x9udV0ws5yi?=
 =?us-ascii?Q?5TmHXiHW1FomE81qsfwUpS/krA7LNt8cr8HIgYQaVZHgVIMm2bof4tOnhKix?=
 =?us-ascii?Q?5er+FjRo86m6zVOIZO4zlnmml+y2hy72TB26HKtmlvmfN07RQ0pLetKX24xe?=
 =?us-ascii?Q?HmKRiGQ6OR5wfkH1N3KqqzuipluySDHQM25uwxJzYrqeG5i42udrcc+y7vEK?=
 =?us-ascii?Q?v+Q1/XLCYgHz2Ljb9hm+1VFrtOwU0vybT5S9OCB6xMArl8ark1Md0kll2bFO?=
 =?us-ascii?Q?ZdE/AoPxvMNhIHc6EwOzVxxVuTbcUFuouina6PIlCOsakIWSpa27XsHuO5Tx?=
 =?us-ascii?Q?eTnyvO8y1m08lN7KM24xOxl6QwHisWMEK/Lr+kEp2/CAJQJ8/eh9fJs5v/3m?=
 =?us-ascii?Q?JHRmXlr3wtvCgJ2NbDhjLUGox9sHWZFZN6EW99Yh/H99kuIHOOC0nkQGTw/w?=
 =?us-ascii?Q?mEIfQHxKxQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c70d5b54-8dc9-4a31-7ab1-08da1d27dcb4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5e27c9Ph4Mu0KerAz+qBXn5gLNv+kMBG1Fe2r/pVNLwN4Ulmen9JjX3teSRTwLRUD0RQxum9Fu2P8dIwlkYYKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: kJZPrOgzdc5TX3tPvj-GTIFG0Qzx2DqS
X-Proofpoint-GUID: kJZPrOgzdc5TX3tPvj-GTIFG0Qzx2DqS
Reporting-Meta:
 AAFRRFPzCOYA7scLqU+Bh6De4YR3aJptXLz2lwKMY4AFW2UjnI4G6YPVlBWKTEy+
 85membudIqfGt2LRoYCQudOcBFEQ/MOor0CiXsUZ69xzgGA8cFQSWNbJ4OFCFN0x
 mAUMfb9/6pBxbwtNTh4RWGChZyP5JlbWV+edhq5a/3G2gNN3xwPxyZirA4WrfDWG
 wF9Zktn22sq4jq2CcMIeK3atOLDNJrBg6POXb97TkRqesMTRi2bBSwn8DTidYGwT
 uJf12+xTPt8TmQ67coadknWbZVTDBa6tV8uL+FPeo3Vfhm2IZlkagSSaQaOB5Azh
 1CuqAZNdjTftQUL3SsdqPpJOI0l9T9j1c2EqzcIRKPmyV/Lrc3Nk4LLzQzUplYpU
 uCnXNWsQq9TCffE6h3we4YoBoyTQoML9mnK3dpQvzOMbtLWIBXktRekXBgbLGmhT
 3cp5aWVucsaTDqpZniBXcV3i6AirprIV+JGmPci8lWWTC+4g1UN6y9OiP0cTfYNc
 b15x9lUw9DtYS5fn4dUgQ4tEUGOjiG7rZ99/bUUKXU4=

Since ocfs2_resmap_init() always return 0, change it to void.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/reservations.c | 4 +---
 fs/ocfs2/reservations.h | 9 ++-------
 fs/ocfs2/super.c        | 6 +-----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 769e466887b0..a9d1296d736d 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
 	resv->r_flags |= flags;
 }
 
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap)
 {
 	memset(resmap, 0, sizeof(*resmap));
@@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
 	resmap->m_reservations = RB_ROOT;
 	/* m_bitmap_len is initialized to zero by the above memset. */
 	INIT_LIST_HEAD(&resmap->m_lru);
-
-	return 0;
 }
 
 static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 677c50663595..ec8101ef5717 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -73,15 +73,10 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
 
 /**
  * ocfs2_resmap_init() - Initialize fields of a reservations bitmap
+ * @osb: struct ocfs2_super to be saved in resmap
  * @resmap: struct ocfs2_reservation_map to initialize
- * @obj: unused for now
- * @ops: unused for now
- * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
- *
- * Only possible return value other than '0' is -ENOMEM for failure to
- * allocation mirror bitmap.
  */
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
 /**
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index babec2c9d638..7076125f5b46 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2111,11 +2111,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
-	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
