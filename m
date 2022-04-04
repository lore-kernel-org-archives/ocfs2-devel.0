Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1689C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon,  4 Apr 2022 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1G5fbF/cXPOGJ+iHHYOz40cxno8RA2ZbcW3SK0Anhhc=;
 b=oMFbj5U3IqbKamA3Xh4gWYxvuoVYoKig4ZYnt3aafUKsSAqs33qY3tFMRRKVjXR41T25jQCWj/nW
   ShyYFb74EJOUzQND/TVl2YDTcaRl+nbsPSj0Nb5txAnEKBUYw+UFjwf1ljZ3KK+zfgBAbw9LCqbA
   3lYVq3gDO7Ws4lpyUmPIh1q8YqeFJoFvNhiWaYkl6xss2dfkd0c/MZQg7UBb7MbAtU8SH7IlKqME
   TkViB7l+rTJbS6cYcdr0c00yY7WZRHlisUd5NAPhWBUV1X6SYtf+ZcUMw+CNn+g5yTH5c2xKvXNt
   V1RuJ/CREWA/+sB+MGYmV3gN8zO4DbmhHyJLww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1G5fbF/cXPOGJ+iHHYOz40cxno8RA2ZbcW3SK0Anhhc=;
 b=jrVh56PRhFJn0wL5MM7gBdVJJnqsICraCzqFYYDEIvsj1k3PAoJJTP823ym6kdz+iJLwhVqhkUuB
   pWj/iifT4kUkvOTfscD3mntQ7d/gI3zM8vI73iOjjbvfe31cFkwbx4J06rrMy3Q01AR7A1lxfDc+
   fjnKGONgWBrIbr4M0bJE5mHoz+mPgYjh0aVucCqZOL7XftTt3AnQKbq9eMjoQDywrIPSjsSCBE2p
   KUsb8LXVU8XAqVBge2BO/ammGuSuZ0+KJdXh7IeHWGIH3+3BVX0FOlFgTVDhfzWkF/o2GVlNFRb1
   A5dWNX8miuBpS1YHsHwH2bEUBikaMT8rjeklRw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9T00BDBQDA21C0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 04 Apr 2022 16:41:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649090477;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=hOQwaCCa6ZE02CZVQIeW54FiFGmfvosG3R9XjCFiBFA=;
 b=ghwBsgU8t5Nrr5ZfkvTOG4N537/wzkiaS1z9nv4iqS16DO7q7CdQaPWXW+mY8K32KcU9c9
 JdPfnDUY7inCLqxB57mH9mqy/Rhc4MayyykHKVpAoHWsBF32fa7s05WvDJ9uP6HN5zS7fj
 uaJJq27PDJazwPC6sYbn8yPtdkuIv08=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtk6Syh9nBKgOFbAJ++uuij0JzSQW4YxQV5p9hHT4pOUzKV+hVNUGDAwJRs2AefKaNo/F4FGa4qyE+dHVf6pg50yeKRdh8gZC0aHtTdUhe0CjN3EVBfWWdOe8e82dVqNKAjRdWPOOl2T/Oaxw8fUkBOhLP7KgNCr25JwoNVNu6jfd2jkD43Xb6BJTMearIsUNnsOEEdlUeAdhUXiPSBHWTCs9dFZQF/dxfIMGSDfwBCe0OcUc72zV/W8ftGRMTf62A/8Hyb9OrlKqQokUG+hSXiA6m4JZ46UzM64ObcJqwUKCFfcvldctn8fl34SE69VRLPNt06XPQFmy8+GMazw+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTPkdrrqMM1I3WaamgoXV385bVFxn4cQUzqz/Hh1Sh4=;
 b=V0tGdEQrMfKqLekei6vGwr/3rZxc7Wm4gJVV7NyHgGafc9vzZ0whNsiymfiHwIaxF+01BHawo9vWGB+lk5XqxSUdxg/pK8izbtYfBgOyPgxUwsJAK2F76uA361WCRWgDvOuSm+2HfMXC4E+XbYKtEewrZPw9RCx6HtcTDBcX+PJbeXLTH8g3SMe1FdgvGmcbvwyfe5LVt58Yc8GnjxtVNXTgxVIqgNo2xaOxiX6zIG548rWd+8Eoryicufcctk341v+VCdCjS7i3j4LkiJI3j+Hg8+jSmqnXBnyu4RGmCFN+07g4BqAedUsJIFVL+uPs82dXsR8qZA+dK1e7niFeuA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Tue,  5 Apr 2022 00:40:55 +0800
Message-id: <20220404164055.1434-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(1076003)(107886003)(186003)(26005)(5660300002)(66946007)(2616005)(83380400001)(66556008)(66476007)(38100700002)(8936002)(86362001)(4326008)(8676002)(44832011)(6512007)(508600001)(6506007)(316002)(30864003)(6666004)(2906002)(6486002)(36756003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 16:41:06.4220 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10307
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=136 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=189 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040094
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix error handling during mounting	stage
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
X-MC-Unique: 4oI-Mf9XMXyTtgsohXeviQ-2
X-ClientProxiedBy: TY2PR06CA0039.apcprd06.prod.outlook.com
 (2603:1096:404:2e::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a71602d-2da8-496a-e077-08da1659ea1a
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2872:EE_
X-Microsoft-Antispam-PRVS:
 <DB6PR0402MB2872E17A557DACB41308F5D897E59@DB6PR0402MB2872.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 P0sIm3ypDlLX7x8l9VshwbIi04it90rxXKGf497Rj+ssqK38lBcGLeXjZZ3sQL/xOyvOabT35dQ8s24ajrytz9+r+IvgkXT21R1wJUJV4UK/baLUw87tEQBtk/Yk3pg2ZjdG7PPe+NvYuLTaGY7DFRlfUrXGcnhXsFKeIRRaWeqtHhUqGfF56e3GbLumHACX6FhNY87iVyE/nbx2kZ0pwiKwCRJaxEdXmgKUmqaWu+tOge2jg9LNwuBvAIMPZBU3Mxt3L02ihqi69kDBa+S+OwZCe54d6m3husxYdeYH0W8B5fZGqUXpcvfGQF4AAPoRsy1BPU/Ju/WYobpAvhKlHs9e7Yc/V6c5V0o1QoKSU07aApbtvFxQrMT43Fict+9V/wD42aQZH7gLQ/IkxquV+fXRO1yq+5NA8VCwzHXUdE27x2IRQoY/8/9WQXSAi+eKSmXSj/x2C/wGzDQJ/8UdkYUROie5at1Iw1dO+03CUc/AkFah54t2RpgjTY1nA6g1lfnu5y8bLcoGw415ra1BHb3Ht3olXlbzV7nWR8lixbaknAgP/zEVmMQddQKjHLBOZus45bBXLlt4dWKtdEEVLf/aPBEuUzAgwu74goBxpyNTQCjvZw6+J2QuTP1Mlq3Ea7477ydHfub1hu+ob5VvfQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?cKCbGRXcc1cx73btMROEsMonhNdW11CJgI7OcJ+G1nHDZ1wY0WXu8Hfjj8Sl?=
 =?us-ascii?Q?CWRpMfg4Dg+h1E7KNzNlXqiD/leGOEDfSGfAXoYfRDl6tnL/Pd1XhEa+SvZN?=
 =?us-ascii?Q?LQKL8XyAloMYRUx/P/IGV+3BY563yQAoObYNycZH8yin2VTZznU/7B9MQXUG?=
 =?us-ascii?Q?tvdtLD0lrd2rotxNL5yKIRgDc3Si/AyX0NVpajQJPaM98s5Y3uu/NykMnGmq?=
 =?us-ascii?Q?dSfdNFTxGosqhryNTFoQXzbBYBCzOt3NdH9+FX9deQe8Y0SiHAtYKj4e1WJ7?=
 =?us-ascii?Q?85GFCzR4L2jvpYbILr7nHJRA4f+hjG1WVprfBjdeBrEI01OtlKldlcDXDQHH?=
 =?us-ascii?Q?ZJwXUtLF7rZ9+l9xGoXNlle4Cnt9J9wUwmMCuutBSOPcPVo83LDB9Nd2wEbL?=
 =?us-ascii?Q?ncZkEikG+a1fL/OoaUu17z7QlafTg0jJmOAeVpsr4AVG0dQmwZnf9Wj0IFJo?=
 =?us-ascii?Q?umxASEzuCl4QD/Mvov7llZhoQpl3nhusS0UB+qKF9FvOL4NWukkmvsRceEyo?=
 =?us-ascii?Q?TU9UcgqGQBygX0PcgLJ9SGUuCA6i/DJAEyXpTTJOdZo96DMoxkBF7qyPXsrp?=
 =?us-ascii?Q?rr3Zc9EhGRVr8W+WFmS6DY/ePcYepStgudCgfypW/wDQRK6L7u7DfWmEJfla?=
 =?us-ascii?Q?BJjzTYvo2HD6nkKx1MWAV1Rq72ZjoG9K9IsdjAgHHJ4/P1ICj6Mchxs9aguk?=
 =?us-ascii?Q?NdbG6rvar6FvjZ1Yi606n+6lPKBnWYUepvBdAc64/UNoOXLESpU8mlhm+WDz?=
 =?us-ascii?Q?8mCABnXHpuDpnWilenlRHTDQlIjqHOyEkti+p24EdtZzkZLeWKCafRUQEPFW?=
 =?us-ascii?Q?2gsQi6hQWHLA0w4XuKjdpWElCcukm/xl4w+Cd3WOCNaPyqwx7HC5wETiekwq?=
 =?us-ascii?Q?CJiU985qlA+S6QEOHyEJPywPQDWScd6MItnZBF6MU9nAdzeHCjVWap2LTPtb?=
 =?us-ascii?Q?6VGD+HAqsfcZ4BdjP1/ZzR8gIDNd49hLoV3YJ1aaob8bgnVq55kLMhsLteuK?=
 =?us-ascii?Q?qlaFetcNojVqgq1DPDbqFotIaobRmyiOa+xMCTX37HgGk73GPTNbpmswTnIm?=
 =?us-ascii?Q?iNcZV3SE5FEZIak77A8RkP5AxG5sJehk4aAURXk2ngo8oz/Ykw8WArXhEJ5V?=
 =?us-ascii?Q?iMJ747tctuJks7YvTJBbj/GuOxV4b/xIgQOjJIzdB3y6HZ8DXey6EUi3vzT0?=
 =?us-ascii?Q?00XzJnydCkI+SywouwpWdPIb9XNgi3V82kyE3xxePynUBGJnC90iZM16H7ph?=
 =?us-ascii?Q?2fwH47Y0cSE0Oik4jzF/CkBgjKROkrec7KTSVEWcPegGHXiTxTB2if0uLo2p?=
 =?us-ascii?Q?EH2INuAxjZYrVJ+B0lqhnDmuWZk2gZCuCM82rJFW3z1SX4G8eqPanz8hXb0s?=
 =?us-ascii?Q?n5RFkb/+V/4o4WjmAuWDiNDPEKrrasLPLGgiojZSVQTjemv2/XBznpFeqBhn?=
 =?us-ascii?Q?eADbZ02H+AcdCZBVYmQGgPgJJj/dYe2QGU0xMlQCSWtU3lnP8w+lMNUKMnbK?=
 =?us-ascii?Q?OqQwa04Vu5VvhoHc4mzGBjCqMw9LqCgc6PiHAf9h3F5VbpiJNQrirI3yYK+6?=
 =?us-ascii?Q?XPuxghszVzvvuLleDoQmhJlDoY4okSwqRvMmhPUbPgqNMKR6CKSF5GD8xCeQ?=
 =?us-ascii?Q?f7s9g02VzbrFSXrlWSGirnp/enYwDonRN5dRtMHUfLDUD1WbzWjh3GVfycKe?=
 =?us-ascii?Q?ohri2RtgvpA4dTUYWp4lpOGmIMoQShEpT+d6m/+Fg/yoxZrNgHSN/DbFrLIJ?=
 =?us-ascii?Q?zZXlIjR8OQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4a71602d-2da8-496a-e077-08da1659ea1a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 4a1g93YEodpCFaYSK55qzJpz9ExDNflzhavPV6Mu4cLAtHu7oMq/hDyPLuSPBUX77vf64bQdIvi2YRtvTiI0yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2872
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yUXqw4z0ZvUj_Vehj5IhxKoglvTl8HXH
X-Proofpoint-GUID: yUXqw4z0ZvUj_Vehj5IhxKoglvTl8HXH
Reporting-Meta:
 AAFC6Dkyzkk/IIzDwnqKa4xzTODBrI2mIu1AYSl4c/0IV+vjDcBTajHNqe/Rvmsq
 yAYtg0GS94j2lVBzdE9Tk9RHZQYnLpoy+MiGBeOtd1th5BeXVCpGwayBfaa6vLZU
 r1UzwS7daozvr/r3W66M3XQKzAzEiw3jJGmYXb5f4K1ZyfEebWTNRgonBcvOlr+O
 U49lJ9FNGNwE9lkmqlyuNPmIp91tiFgFRxX1GsHBTv5gY+/Cwz4OuUh6MXoqGo5Z
 p48x1IrUaJs+wC/L9h+/S12/6hp+xGwZItp61QvV8sFPih/42rHw6nzRAisTfoxk
 cY2tR4NpFkD2JYWmRcCGOwWdZ4//9dVzqGG53KlcfLQo8rN1EWFuSgMjfvF7Y3e1
 fSXBNDZgyvzEuML6ZolYvuj1Vdtf6yDhkjoHwivgdYeEevkb8utUPH0K8e09xrHu
 2aJGu8lDCN9JATnr960WqIcPAlmp5TfKV0vQp8+SMo350zfdLyNIi4dhAC+s0gbJ
 26uzG+4rtuzlw3ReDF6NghoTv0LaemNa1tTwXxmWo5SU

This is draft version, It only passed compiling & mount/umount test.
I want to know if my idea is acceptable for maintainers.

There left one issue: mounting crash when no dlm connection. I still
can't find out a better solution without directly free inode memory.
So I marked the related function (ocfs2_release_system_inodes) with
comment: "/* FIXME crash when no journal */"

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/reservations.c |   4 +-
 fs/ocfs2/reservations.h |   2 +-
 fs/ocfs2/super.c        | 156 +++++++++++++++++++++++++---------------
 3 files changed, 99 insertions(+), 63 deletions(-)

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
index 677c50663595..6e5559d6940d 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -81,7 +81,7 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
  * Only possible return value other than '0' is -ENOMEM for failure to
  * allocation mirror bitmap.
  */
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
 /**
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..04d7bc7e1110 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -112,6 +112,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
 				  int sector_size,
 				  struct ocfs2_blockcheck_stats *stats);
+static void ocfs2_uninitialize_super(struct ocfs2_super *osb);
 static int ocfs2_get_sector(struct super_block *sb,
 			    struct buffer_head **bh,
 			    int block,
@@ -458,6 +459,7 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
+			/* FIXME crash when no journal */
 			ocfs2_release_system_inodes(osb);
 			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog_errno(status);
@@ -488,6 +490,7 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
+			/* FIXME crash when no journal */
 			ocfs2_release_system_inodes(osb);
 			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
@@ -989,28 +992,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto finally;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto finally;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0) {
+		goto finally;
+	}
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto super_out;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1027,7 +1029,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto super_out;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1041,7 +1043,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto super_out;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1050,7 +1052,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto super_out;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1061,7 +1063,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				     "unavailable.\n");
 			else
 				mlog_errno(status);
-			goto read_super_error;
+			goto super_out;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1079,7 +1081,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	status = ocfs2_verify_heartbeat(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto read_super_error;
+		goto super_out;
 	}
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
@@ -1094,15 +1096,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto debugfs_out;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto journal_out;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1110,7 +1111,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto journal_out;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1119,14 +1120,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto journal_out;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto journal_out;
 	}
 
 	sb->s_root = root;
@@ -1178,17 +1178,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	return status;
 
-read_super_error:
-	brelse(bh);
+journal_out:
+	mlog_errno(status);
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_dismount_volume(sb, 1);
 
-	if (status)
-		mlog_errno(status);
+	return status;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+debugfs_out:
+	debugfs_remove_recursive(osb->osb_debug_root);
+super_out:
+	/* FIXME crash when no journal */
+	ocfs2_release_system_inodes(osb);
+	ocfs2_uninitialize_super(osb);
+finally:
+	mlog_errno(status);
 
 	return status;
 }
@@ -1803,11 +1808,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto finally;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1817,44 +1821,54 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto finally;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto dlm_out;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto journal_shutdown;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return status;
 
+journal_shutdown:
+	ocfs2_journal_shutdown(osb);
+system_inodes:
+	/* FIXME crash when no journal */
+	ocfs2_release_system_inodes(osb);
+super_lock:
+	ocfs2_super_unlock(osb, 1);
+dlm_out:
+	ocfs2_dlm_shutdown(osb, 0);
+finally:
 	return status;
 }
 
@@ -2110,17 +2124,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
-	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2129,7 +2139,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2139,7 +2149,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2155,13 +2165,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "couldn't mount because of unsupported "
 		     "optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto orphan_wipes;
 	}
 	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
 		mlog(ML_ERROR, "couldn't mount RDWR because of "
 		     "unsupported optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto orphan_wipes;
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
@@ -2182,7 +2192,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2208,7 +2218,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto orphan_wipes;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2220,14 +2230,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume too large "
 		     "to mount safely on this system");
 		status = -EFBIG;
-		goto bail;
+		goto orphan_wipes;
 	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
 		status = -ENOMEM;
-		goto bail;
+		goto orphan_wipes;
 	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
@@ -2247,7 +2257,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2256,7 +2266,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto dlm_out;
 	}
 
 	/*
@@ -2267,7 +2277,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2280,19 +2290,47 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto system_inodes;
 	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
+		goto slot_info;
 	}
 
+	return status;
+
+slot_info:
+	ocfs2_free_slot_info(osb);
+system_inodes:
+	/* FIXME crash when no journal */
+	ocfs2_release_system_inodes(osb);
+dlm_out:
+	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
+uuid_str:
+	kfree(osb->uuid_str);
+orphan_wipes:
+	kfree(osb->osb_orphan_wipes);
+slot_recovery_gen:
+	kfree(osb->slot_recovery_generations);
+vol_label:
+	kfree(osb->vol_label);
+recovery_map:
+	kfree(osb->recovery_map);
 bail:
+	kfree(osb);
 	return status;
 }
 
+static void ocfs2_uninitialize_super(struct ocfs2_super *osb)
+{
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+}
+
 /*
  * will return: -EAGAIN if it is ok to keep searching for superblocks
  *              -EINVAL if there is a bad superblock
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
