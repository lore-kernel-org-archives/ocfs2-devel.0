Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8913C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 10:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BjyfFbrFxf8tdsSaH/28PoC+2BeWx7zchIeEvkmyKbM=;
 b=Pvi+kAOYZd5oL1akEcA01lJam7izBJVwDhqsFGM7/v5obKJlcU/3hsa1JDbG8hC0U/6Js70GQcSb
   AdPITcRqMD7N322xlhgsMx0MXa6APOWoJ7Ujk7T5LrJKJj6l9+zYL0iZWxX1Qf7WUEiow7DVE9Eb
   Y302CbhHuhle/zMYY0XlM1c2Xyi13FoPR9QGWaU/FWrs6T+W010+UEJxkLJSQ2xV7EMUegsXoJoD
   3GFvkBEOUW/xZTYQp1FeDzPhtnWjSJ/UgISrR7DDRIJ8LfXciEGMHQtW8p2nHlbt0+bZV5VBrfqw
   iWWQQR1Pb0VFt28xj7iYUCzId6Bqtgx/s332Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BjyfFbrFxf8tdsSaH/28PoC+2BeWx7zchIeEvkmyKbM=;
 b=t2JwL7qE++aK5xXKDh9cEI5t1g1zmRxgWXXjNXD6gwDYZCYuWiFoM52hCNMlb+E1it8wQo9b2UrE
   YkcNgkYtPHoTjcu8NK7YYIg23kUndZSn1wkAprojH2XVZxHrMLI1PtnYPr1TCY1AhZNpqUj58PsJ
   cyw2+tBpQkshwFJd1dEC4dLzpg7OMMxSTgWH9zW6+WNVBETNkxZ0WyWNzYJ9p998ae0WL+Nz7wYu
   T7tGQEfryAv5cBT2/t0eDWp7GzF5228DenMp5ImGpc67HOvr+WfhUseQW3nLf6PTnO0EmNBqvljw
   7IWJfEeEf3ImQ0VGrFYgWkrLRGYsoE+2Snw34Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA90010FW1R6W80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 10:05:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838649;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2uiCqWXBBPKrJm2qBFdAVw3E+YWomuIoLbdOzCIvGtY=;
 b=hMK5c6hk6/t3A6uU413HVTefsdp2ADgAh5ZfWFiejQ9b+XqIZpnZs7/IHJ7UT0Lsppwpzs
 FTI1U2lO8e5J24PXRRhiS3XAA5MMr7lLv4ozKtdbvOjxZQAVfCYzc9HA2Sd7WDr64MSrBK
 SB7VdEksEBhljq/PEOZPJk3yCuPdFyo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ValNMGk10hZ0aSYbo+NTDg8uoLTQBKtW9ku5ZWlVA0FEm9U81+l6DWqMt9Vbo3md7n4+CREguYZvQPaTVAFhfBnaXodwDt0ETSPEc+50LBhAUgzhg/n1/jw7/I+Ibghfr642ebjPtFaLYxAFQtYxKCtFf6LbY0sMk4cwzdHEYRWFK9DClsSAJ7BcAMOubLUS+3hHc6ovpcixfU/p5fYfAOiD2ERkHXRdIMHDDXFtiMEHcfmXgxm07DWpr7OF6FpL60kIjiC/M5GD6u8dTZ14MXLktyFgujEu8D84schsKq/RUiukeS3lgufPoNy42OQxhEPf/zpUqJna/QkuzkRURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHP/41mZkK3isCHKViJs17Vf5Nfb2a0JAuTZ6kbQVKE=;
 b=T4NbDlOwkCb+WSWatU4Zj6TjFSTRZGP0GxBDPBW7Zb3dif0YXt7Gj18hpconn9rn349wiDbG2l7jo8tm1+0UAMl/JVtLXb6xJLJtd//3vXSCAJeFujWfk1NKRoz7BWVC7j7p80d+vz9BInyFnuD/1Kl3hevN/kobteR+erLayo4/l1hX/kdl/0KKKRkn3SvUYvW1woC5kKrDmQzudyd5d3SydFixfXL3LkgzPWx0pByk7rDBjJ7X+7CBGTzmxnW18VSBgZ3ACgqaBUl0gCXy0eDfGuGMFWCosaUgyRbMk6zmkxtjnbjd9+EZ/n/gGIcyf0WlvCKDuEcml7hTDNuTAA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:56 +0800
Message-id: <20220413082957.28774-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220413082957.28774-1-heming.zhao@suse.com>
References: <20220413082957.28774-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(6666004)(2906002)(186003)(6506007)(5660300002)(44832011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:46.8826 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=225 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=166 phishscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130048
Subject: [Ocfs2-devel] [PATCH v2 4/5] ocfs2: ocfs2_mount_volume does cleanup
	job before return error
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
X-MC-Unique: sh6d_YKoOHmToiGLanquew-1
X-ClientProxiedBy: TYAPR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::36) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d5a1990-ad44-458a-a0fe-08da1d27e87e
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB81004787E19B5AAB606AAE9297EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 rmo/4mEoB/52OHOBpngHJqzLNXS2fMf/8QBy0hd7tRwCBM+E/4Gty+Gsk3TBP0nN8l8CVKNIEJ1xW9rsfEVEuykkiIG48bdO2K7qOvDbKYrQKFUzXXHI0UEHwfmpnjEYohEpr1nYuFBhYF8bFmK706YgditxWvlEUp6/Yx5ugxAT1Jbm5bsbDnsHoKMpIGZDAeRTF//fLxCe6pQdLRZDZzmuXc8DHvE60isI5sCqkCFX1hLyBF4TV+wnOilU/zjbCAikXIzxelwRJHvP8TEWOG8gI+S35F58GyhrfqrnlrtOXZvXJ7P2B4GRQ/bOAhr3IobysinnE8Bqc9ynm1HmtCJrZYNyJsL872SWhs+lp5Ot3OIfjhmqoimaAsaqFIxK57LmguIM6f6P/FWNRJpn4bV+sNj4MNSXIyZMK+vVlJSsQYIHOrCff/kq1RC+MsF++OTi+OcxAU1a75nnk21+IpuhD6RNoJ44Qwk0wcoTA5aSyZDG6OkYCnNZqeRD86OrfcTCAVuLtnvn7vtJxjJP9vBzpjTRyNqer/6O8TK8rXOveIrOTsiziuJdR43Bt26vm/WWhQGP9vVWbf7oTbnLM4GTxOAgEoj2r6unjfaJxTNoB78TwJKRrXYxgYymMT391tlzAZCx/9fOZqyMR1PX+w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?5lDZlsTWqR5f5Z+fMnI8NlQ8wLY9KEGE5gGx1f07Ohf9XNzLWv0Gth3K2SNy?=
 =?us-ascii?Q?VUgYxu14PLfjtueAINTz/fP6mPM6XEKfUH/dTw9iwn/Po8qbeecxftfmiBeA?=
 =?us-ascii?Q?CV1URoilxdpnxGZI8IzQUHS4QrDrqdAYOEY/ESBa9WOfB1MDr6rSc6tIOYCo?=
 =?us-ascii?Q?1cWzMKjDNj8LQ8LZwkgx+hEya3/7jktDpRsPXoB+so8GLfQ4QFZQRvsm3BS+?=
 =?us-ascii?Q?tU/Wpg2Allx3veY9yvmnFJYIpMmytW3lXV2jJrrkE72DjGjdjuBo/Mke0NUr?=
 =?us-ascii?Q?TnFTK/Vrb5jliJz9KCj7qmustcTuzCkceqaqh31GvXL4P4XAXlpjvTG8QyKl?=
 =?us-ascii?Q?N7NjU7O9/INbfCZF9j6lcy3XzZzQ23oP/CIGlRNFpIYC9z2fJnvp9yzyQ8Sq?=
 =?us-ascii?Q?+4bmyXbYdfV8dh5831ZzO1h1Oky7ATUEkWZbza0iXFpGRw+aHEU+od4u7v12?=
 =?us-ascii?Q?boz5xRK7HAAJ0vjd1IsZ21wr3No4qWhsn3Plin1fQRh742Crc8oeXM4nL1ys?=
 =?us-ascii?Q?QUO43pDBObnXBto30a5b6H7a9gfr905neHRtiGkYIN+58L686k8FlpbMjLnk?=
 =?us-ascii?Q?wVLd4QQ9CXc4o9zwI02Fe19BETcYdKE5emgXZtPYR5juXoDC9GGoEpphICVF?=
 =?us-ascii?Q?baMnCNHl2J/cXNyziheX9GynievOjuqUpnPCXUYxry6zz7IpewbQrTUa5D0v?=
 =?us-ascii?Q?5cj1dgtOJY0Qp9dB/kzvLauXNUHn0ER42PZj2+Xk1WUk+YqzLBRjxXjZeIp6?=
 =?us-ascii?Q?VFUqLEEXnkkoTfTylz+9DZzxCo1mgAvJKK0XJ85vWRdmTRjMQJEJnLGKTxfx?=
 =?us-ascii?Q?vD/eUr+nOmIT7wgLSEXv1z7hQATmmPG3uEo3uFfgGGNPz22zSlawCPTC2fBl?=
 =?us-ascii?Q?iYoQu0fSGFYY/iIB8f4b+FnR/DWqDh3oHzym3L+Sn+NXFDwjfzNeNPgPTVoV?=
 =?us-ascii?Q?DwS2Tuikpf624xhJF9Af7gLUv+BeNetPtkZOlBJJTrco9oYF4zRhACms+3op?=
 =?us-ascii?Q?1IlZXKBuKzuQzsFrvdn3L1mIabcQS6UP7AUSwmomFMvdrGitACLdpw4z3vSb?=
 =?us-ascii?Q?Gknmlv842MwPcoaSSJvpPY/y75tKUcDbZDjSN+jeYVKw7uDshAY83os4MSrZ?=
 =?us-ascii?Q?xf4OOf4sXYPq4R8//98kp8BsX0fnNXLQ4ZUdYv4gy0bgfduiXloe4UQ1anWZ?=
 =?us-ascii?Q?Ll9PMBOwxufp/WO7/Vcg1wUpW6xu1tKPtZIGz2bUzrhv8NalP19wlRfiSwWL?=
 =?us-ascii?Q?uCaQOu8Rgsu+yiIKhVGKDRMXV6lWCU5tzEWqkWm0TVr7sSH4w3UjQQMAi0nL?=
 =?us-ascii?Q?g7swPEnL+2diOzVbOFIuzHJ7g4/Mh6t4hAkZyA54RjEcVZb9SENQbNfbO0LZ?=
 =?us-ascii?Q?l5SQ5j1Jv9bbsmnVv/q4y28Mj6URtToQpf7MnhSWjEMX6GLAw8TTD6o04zDs?=
 =?us-ascii?Q?60UhRVC6i4v91g/yySSQwwAD0DZlTX5Py+esWuWljIdR/AyIQ5d0Oo+OcAnl?=
 =?us-ascii?Q?fabO0GpOcYBpzPdBaFOYcy80yL9molIm6yCnWt1iHlrISBgbBIHJ2EfO17KU?=
 =?us-ascii?Q?RmRPaMjrM2ICuDZwMBFMXuW7+HNWOb41uGLNIfKTZ8N1w1l8zCR6zeQbjNYR?=
 =?us-ascii?Q?/ZMiI2QBNiFjBIZeolTsY2kTEBMvDhfnw7w+Aun9yLm6Ldt0zntWDTSnaN5v?=
 =?us-ascii?Q?YmssVCW5jYyiYSxK0vAT0NvMzM2YXO6j5zM2y1yLCABY+ztxbNt33xjwgiUE?=
 =?us-ascii?Q?f4jiENpXKqE6jf3yZK90IPtd52aXqtg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8d5a1990-ad44-458a-a0fe-08da1d27e87e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 kOayRlodFeAyf7ZXtOqVF7zyssANHZyeP2owmMs3KC1CMTwoWuMpp/CfiOtmqKtwG/hPX/M6qZ5CS3rZKdZ7PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: rGkwLeSkIbWxCIVGoFVVdJL6__RJiCrY
X-Proofpoint-GUID: rGkwLeSkIbWxCIVGoFVVdJL6__RJiCrY
Reporting-Meta:
 AAEQ+Mx9NJMmmrb89ZnCLUZ7Pw9cHViJpkhtZmzit76jhAJylKQxqtXK/ZRXbiWF
 gyk6FK/P3ZTFzbAk+ljp8pfrdMPVD6YNarYp+BfatUT0pXgCoQFvAh9sYx6G+I9n
 QZucGU75AF4VgNcGvg9/Qoq9fHywoZFjkuRwT0y9KnMnKu1fgZNayQKuWE1mHvKd
 76DADYTI2+/nth98fS4iC762oHG9S1NAdvccc4IwwmztwvwLCNEC1kfz/doMJh3s
 Qy/TNw3FQYtnMU1m0K/13lElfbJZCafNg4tRgJ5Zao2BT/vQQpkR3Osb8ULvpDC/
 GQ3O4g5fbcO+ucfXcfKC3R6sRnx9mF0sESaHey7XmRHMYowHXAs7ERHQ2HT/OLV2
 3PycCqkvEYvtDo6pMGv0O62iPbiIYvthvG0R3Ax9cNoIMi6ebrvKchKDQeH3/VIu
 YC15k4u+yvKavGWga1XRHDtMo4ikQ4cVXBWafNaEXeS1HW57yorwR+BCmc6nL3rr
 bzvjjIZ+o5CjucsKiZKX8n4is+LcJdSH/vsGMRgYBuK9

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_mount_volume.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4302c3e9598c..5e860d7162d7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1817,44 +1816,54 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_system_inodes;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	ocfs2_journal_shutdown(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 
@@ -2393,14 +2402,17 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 	return status;
 }
 
+/*
+ * If this function returns failure, caller responds to release
+ * here alloced resources.
+ */
 static int ocfs2_check_volume(struct ocfs2_super *osb)
 {
 	int status;
 	int dirty;
 	int local;
-	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
-						  * recover
-						  * ourselves. */
+    /* only used if we recover ourselves. */
+	struct ocfs2_dinode *local_alloc = NULL;
 
 	/* Init our journal object. */
 	status = ocfs2_journal_init(osb, &dirty);
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
