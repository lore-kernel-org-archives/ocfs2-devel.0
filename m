Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4807C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SR810Xmc2DszfNXNPsOsbC69kpKWBU9VtyFVnxOGFnM=;
 b=nketwIZ51AHttkTFn3fIB3HqI4Dd52rrS2tlRmkSfaG2VMmUSHU3QN+fxoFduBukgKLgddYfP2Rr
   Q4yzMUc+NzwqInry39CvAA/0qqkI6RxzhdQljyc4vXUJQD6zftJrssZPajnRQPFBXvPY4K5N/t6x
   7jmmrOr2UU/3c9qyNOZ0W2ALPXo+AU6GZ9Sorve+vKv1FfDvru3Qk1nADWGBh5PK8/jo4TyK/Pya
   La6DNnIQZj5k0eETW2y84iJ3wxRYJZSvkmBLHP/4R21jQWFuW86V+BTrxmfC4Mh4DAuUr2erFo2k
   AKLD7E+EiY4E5g7lypgj0TdfNX0qgJpzrJnpIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SR810Xmc2DszfNXNPsOsbC69kpKWBU9VtyFVnxOGFnM=;
 b=rNgDCHFiPT2wlgEyFHJtdUKxtU/Lb/WnNt3MkJnF4RIrykLf2A73WjNTGQG/O2c8zdv40iym0JFF
   9Z94MVIjhX2gkaOwEygMBWPT24vvbodSZbLAiKUrQtyL5nOAvH18XngGhY3ZzJx8FqMeou0zD7TF
   4o8D9FT+d3f3VzlmXgOQffTa5akKZJOJsrb18/ZAFRqw8EOMDfRZoQ2fFrlHSxQubZnj24PfobRk
   qTTdFeOoLphnOVSnj6Kt4pKFnETBlyWU7D6VW2MfOFQ41lVnVNAusz2GXErSyKl+Go61st/8nna4
   81yz/vvVsAkrc/5MMySeD57doCx+03yGsPaznw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU00G7RHXWRP70@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805826;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QmdR7HRCZ8cdd65MAbsUHLpB7BZ7MaC4l5MJwRnhCR8=;
 b=eKuWoIkcV0EwoL/D/3Uv+3l30mqghQ5znI45bLa5xRYEp6DmjiZzNiY4e8WgPs/xo8SipN
 8TCkiEqj6TJj/BMgCncTCpIHM3e2AL9xOpIWWdvzt6wZy7ApvfxbHBsik5CnfyjfgO1dnm
 fWUKB4P64dBANRXP2euhTd7hcxHisiU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQ/Ma5Vli0fhvSsbid1uJMxHpzI71HbkN206QDno+7qvhEPMvO+WgIWwF4GPhVrTMy4eiOB7UkEJcLlnMuZCb4l7DrQ2jhdD5tBJxFx0d9R5KG1w9hUmueQV//6A5/8iQKPT6wv/qahzMg4uv9ymUJUDLq/1kSfOzoGkq6/tw6dYERrB8F51phYpZ3Ds5+/Phd7F+i6iY6o0/FU4df8+OeWdVofzUX9OFHffAC5vXySg2EtebQzs+CIg7kjVuBepgqByDGbXuBCQeei+UiGKnBPgPLSKmqoeR/jblCJ7DASIwD8Yw5us00IYhZuREQJ8UkCYIBMkpnuPSIBH3p2V3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqdqgQtEAM9g8Q+AYO6SDnxWwGD0OcUygz63Aip+cWs=;
 b=Q5sE3rBPEkAw4a/K0mXTwlXyFCE+8go4XXU0nj04cMeqZ3RclXlLV+leTizRpvCsXT5PZYb9A7fqjCLrnf0H1mooAhY/AvTBuk+leskIFc5gW7fkfInFApV0vFQvK3MXdjktUG1vMSy2pSKxzFRaygP6Ypk1fqMkHFJBlmLgGfO9sJhc+wK+rGzXS8CVo1YA9kEodPIxp5BOIzD97cPv1JbT7gEpkJsbM2f6nSAgpN8CpS9jaxh9eKb7z/W3dzs9uSBQTckNEb5t2yXUWYIgRcREE3b4KkKyhSFj6CR2q6V8lF6Cv5LCEV/D6t9kmE8+fZCaJoMX8KELF5RCrwzZmA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:49 +0800
Message-id: <20220424130952.2436-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220424130952.2436-1-heming.zhao@suse.com>
References: <20220424130952.2436-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:16.8381 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=148 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 phishscore=0 clxscore=171 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 2/5] ocfs2: change return type of
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
X-MC-Unique: bLvbw9h7OHabpsJrkegqvw-1
X-ClientProxiedBy: HK2PR04CA0080.apcprd04.prod.outlook.com
 (2603:1096:202:15::24) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 916f76b8-d507-4fcb-0587-08da25f3c697
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB3344BE70A63894B274DFF29597F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 nj2aGpfubEXCTea5pc9I7Rlk7mRIbl07ScDWHJKOEqzqs9DS03+1Eeb6yX4uZGiQEBfS7FYnc6EcfQ/RecHfgxOwrnVbsRmwIo9KuDVLLcsI4N2Y3QucNH1zp+jj5w2Vpv35D+8D8mUbFR7p0s5ov/uhaP+q34m/FuIu8K5H1lY/et+J2lEFv2oKrhJJORjoqZRjE9nBa4c5f81RMl7t4wTIttYrj2BSOPNaSCNT6+m6lN227gHeChcWvSrmFoQEWewKuBc0El8uROH5MGmDCpgQMYua0RPVd2WhYzKcwCtDEWGBoZVUstq0J+6cIavsKGX0l5HdWjMBV0pfDG/ca3Ny1i4ob/xTBww9IbTSM5ErtlNrebasutpzmSKTRBcg0HC2sgARXmMC3RRhvlxxl+bvqgQ+qwMBZuBnDzQGF02EKw9zMzX+c/Df7KrIXVXZ0KfP0CnX0E4c8GEt6BRSK5tRuATeW5x0/znyTYaYysf2G5eeuxWKTKfeVZHudsj67JorSOX5Q7qOggBlIRPDHdblIuvbdOP1esTfJsdken1sUuh9e3YNI7sKmUkJVfTNBcx8SgWsQYM8BAY4oFRUMDG8QAgnbFxq0qATGV61SFCOVMSB+PkANAhr2q52LKfgFWmJCVb52jbEX2qSjCy3Cw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?beekhSVIHttZewO/P4tNknnGv8bGkQ+juryT2mnEEqajYKRyWx9XcVNa3UA+?=
 =?us-ascii?Q?V+09AmfPp2EBfkbQ+/vbAFknc9R90dGicUfz1CJ9pXkeHlvc2a7yvuj1ykyh?=
 =?us-ascii?Q?TZguvLZNK3Pty1q8ewv00dBBKI7AxtU0GilwX7zwscsdvbsytlqTKit83eB/?=
 =?us-ascii?Q?5BQZAGTVdCC4X5ntYdTR5gF03s/uRKLpY64gh4dk8V4YxrQI7XHoSrdpOmzp?=
 =?us-ascii?Q?kS98RkeYcDCo4QqscPrIQOACDB3H+yyWsoVzVpXNO7Bk/n90o58pQhmE7K37?=
 =?us-ascii?Q?GpSO19J0FyUYlkVA4A1UEi5zJP1L7JYE5QBeYzhXfaKtkBtqdDTeepS74xwC?=
 =?us-ascii?Q?cL2LOir/5YWQ4xpgtaY3BZmBs/IV57fkO5Ds9sbdLN24lcvUr0VeECYdKP11?=
 =?us-ascii?Q?NliPjevBAMmO9be7oAsraDWKwxD3HiUxYcSf5kRoBNvfiB2UtDSRe1J1yjvp?=
 =?us-ascii?Q?XQG1UtG4qI3mMyi/AJfGukFRNBHgo9ruq094wug0+QzX6Peu4nAErsQBE/Hi?=
 =?us-ascii?Q?Zx61V2o7oUNp/t+RUX4OXWBCTxWTmD0Ol7pEntbQ6oveuI8meMCMx/KMeP65?=
 =?us-ascii?Q?ae0qUoXox9o3sClZciscKROchNRtV/xUAG+5O3vCSsK22TN7Eak80k3MQbTP?=
 =?us-ascii?Q?eAA8qNH3EjHMEL1MSSP5P1WO+glZK3O1E5Mb0G808OVwxOTl0RPRYQyXEGTL?=
 =?us-ascii?Q?uiPXEyTKVEfqq3Z+a8QdfgVjakFnvwaol4hePUyf3ufbMwePIWU8XwgHG4s4?=
 =?us-ascii?Q?+fgjil5Sw/RDPw1xi7dNDPO+np7P4igeZ8zyHqo95gXaloD4nqy3faZgLGwo?=
 =?us-ascii?Q?XNB4yE+JUSvcX/cepJGqgXqN2f53TJe5iXw/8kuIgIDbDY1XKtnj3RyhbkPw?=
 =?us-ascii?Q?UerV8KCScPrlME0v7f3s1uSstSd1JtM64qIA9CqcR7dZna/Hv4HwU/fmXmyc?=
 =?us-ascii?Q?bUTuzrDaS4vxLfo2EeZZOKU2sn/RGxNajMF3FSmlwJHOrWhSceDukFfbKFri?=
 =?us-ascii?Q?9EHDx9h1Lbgv0y7Ep0pTCLSBnF4+9ZC7MA9HFf5wCbbi7V+PXpGeRN3L9E/e?=
 =?us-ascii?Q?yUlFJ0NbnvGDvv1PKl4WcG57ihIJzSlYf2niSOV1Emai1uc3j/cAFEzOfHlR?=
 =?us-ascii?Q?/IVGu+iC9HM779EKXOhpV0i96ko02Tuc4f3BAvhvmdBfZY3cf+ZUoeteALIs?=
 =?us-ascii?Q?gYUBxxXL4s+4ica12k+bd0ChqNVJ4uo40CWbIZOXI2uMKqaP14AySdLiUzbL?=
 =?us-ascii?Q?2U6ttMGmlxtpLg3CdKa35xL+Sc43uCy2fmUUcWhYnAml2FftgKdLYNOoQP9L?=
 =?us-ascii?Q?vF3oY6DCQ4MfmQmyyI1eI7SUI0cIyolL0ahaxvBr9seYAOaXYFNio2b/d+Vg?=
 =?us-ascii?Q?nohVB8BUcc+AoBrIM4qkjFEBBwQhlkyeXClextjPjZ0heu4wpENIDbdg8h2I?=
 =?us-ascii?Q?rj6cmEgjWBqS6cPH9Y0RDBKjYVtbSzbWm87X4OhmbDCqfj2FSEG1pJJt9fQI?=
 =?us-ascii?Q?x+XY25vMcRpaFRMneSEJZ1lhxxU6IfCVLLlPKSFNef+BSEc1O3+NCrtmwSz6?=
 =?us-ascii?Q?R62jzAPHx9On6772ZGHC54/9BN+NTahKxmP+PI7Dc6CkbeHzIsScQykN1hxS?=
 =?us-ascii?Q?LNLQSSvZRL7ipgDZBcfGr5v9eHKf70n6k0QRnk0+rl7RjnHAZ1sK0SajyCLb?=
 =?us-ascii?Q?A6oECEy1XotalcHM7rzekxNpXiFm3QDSfZCuoSayCbfPEc8WLoD/zYcgs/7E?=
 =?us-ascii?Q?qN6jj6dwiA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 916f76b8-d507-4fcb-0587-08da25f3c697
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 U0+H5/aqCYgmQmTLYgYBLnn1ePzlOY1X6D1/6oxmWuGQBWB5WwZdmwXJInTZn42FbVxjVmlhS+rqpO1rZQjFBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sGMrKYELsBQWQ6IEu4GhQuDtzK_JtM1L
X-Proofpoint-GUID: sGMrKYELsBQWQ6IEu4GhQuDtzK_JtM1L
Reporting-Meta:
 AAFQWSoCtDpt5U4ul5LVFkfv5tyiXw50NnHArV/k3uDuAWTVDgA4e/laNT1z9yIT
 HIxzyV9oGy20ITBU166lHxCAC8CDqxAMiUV5PXVl1PWVWWvooqmuZIJlyw2lp2dr
 ZFNKO0azGwIypJkCNYDrnTE3ZA8hOvTwDHVX9llRsvhKb6gWThkSW6MzgFOTLCTB
 H9CVU9fiEEyM5acxeDP+L6juZD2alRK9lfiqy6OMiWiy/Z2MudFpoYdmzzbu+X9l
 +lrWRgV4uhbq0NBmnvkqoET0Z96bMGO3woIFsUSiz2kMgVtErAiDobBRp1GY7uCh
 U068U2Av6jlWFZZmu3eNItMgyy74WoGcFsNvM2OW/+an5eSjt+hAxKPCP5CmSnmg
 MQ72QxxA+HKVA12W3MY1IZi8X9LSvE87PZOeyL6tafNwPjPwW0q4H40UFL/tcMZx
 xeb9AWz8A59GsoMNDh5T3kpTwLcUeVrkOl2MzwV9O6iLBJGfvu0BfmS412C03T27
 LhxcZcqz3uoQdJsV0drWdTPzK1leCxJUeNfYER4zk+9R

Since ocfs2_resmap_init() always return 0, change it to void.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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
index 311433c69a3f..8014c690ef72 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2110,11 +2110,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
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
