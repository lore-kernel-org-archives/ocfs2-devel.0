Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A3AAC433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H75oGECxSkU+kcmGbE0KVXEEYob9qcRQCYKZ0x+L5jA=;
 b=ETtrrkDmR09+a4ulydpMv5L383Xr44SSr/kvTHVPD0V2XA9dGfTWfs/lonpjxOheUAsgO6tx2dOy
   TstAOyF/UiEcK8iEQ6ydsvcs5kgJu/6T/216Q84S3rBxKesPWo8J2b5wj9IQOH/oQpOxGuZyIukM
   2/fQta3mbdLYkBVc0pMc85fd/o8tYY/msDc1zyutboo8OT6A3Hkrl5HmL7tgF0D8rNbieHyedQcw
   KZoBoJqCCQ8nTPyiFgkNcyQ0winql+2QtPnp8UR3g1gx2UySgxHph6V9e85WkrrZj+FsZmtvpEvl
   kr7Is4fBh5xNELiyp2EvaTJj2IPNKTYosDWneg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H75oGECxSkU+kcmGbE0KVXEEYob9qcRQCYKZ0x+L5jA=;
 b=OylKl92pWySknA5aVCl1DhAnZwr7IplnO7+OEKMab4qEXhO+5tu8J2TZxHwODwZNabBnpFGJJV/w
   FcLMgNf8jM9k66owW988UMn8al6yJlIqRCmyJQpTKP11+YmCmCLTGA2h2gQw/ZZfmXLmzskOveMQ
   hrYQ00OVhuLOZpRfHA4s/8Qxlbbp04iBhrQXFG2Bzev8yw5sgPCjUDvawWfegrcDn+X+QxIJWto+
   h6dNHW2TECeACVlquLJEgcG7HrNF8fyYvvNbvNmnQnNfGYgqK/HbUrb1sYURYMhRMpW0Gq5t4l8D
   Fvj/G3WVUPydGMdOIjtC0xoZgjV7ecnsrCFIhQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000GTANVQ7G60@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:31:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413835;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=MSaYIBK+uw/64SIP2Fl5P8sgTBn9xdRYvaxvQM4YTnY=;
 b=V4YgnOtYyV0utJSgJHSMRArr2hJoIJkneIGinhirAmIMmzfKBsB9pxpN/ZXIW72A9nCV8I
 QtX+OioUMZfXGQllLIWKG5pUTqAH3qEXErqWGEJI/rR/J1vAr7OLGZWn/ENVb0YmqNIYXQ
 UaPzBaqGrMoq6OfndDG2nlCJ5RLRhEc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeHwQ7Ekf6U4LKt6g73EGEj2nuuTq1SyrANVcHfyK4O/Rf8VzphBsUPc+AeqEfM/02nwwBEWLD3Z1vikJHXDCkSOIUS8eKbOrqGIMEo4uQqW8IszXPOJcpHxDDr0gTH9mJOiekCg6dOQHpnkcilgZ4uZU8IFQ/iab3HJqrOXZsvLQA3WbWQaoFGZB6FiZgAry787BgJZ/xS2rKAAYMV6epmsi7B/RILrwNDR3HCDVYlyegsvPBv9zEqMAhaxHhMci1sLpjIXLfG3hGsIWWXWfJOVtqsqlYq/A2SCPnK+XP1/nnE1jcKbZCE2KlIqa5XtuzpXE0zxDuA7ZYjMKAPd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqJNShyG1ZYGnoDu4+EJVLe7A/9fMXHhZx69tdlPxRQ=;
 b=KtFwZ3VHS8Z6csrUsHXJxbTD0tHd5Phxy4jL4u6exWp6hhx2EaYQ5LNI+n8Hdw2Vb2Bwu5k2KIGdoZPSaNIZJdIBYJp6WcWhpDT9qB6sNYa4N4wSED4x+uhVEKtJ014n9QSb6qXMmxw1TUljEhj/38RPAs5MVAOU94+AbF+V1zUVzJ2kuBg9LlicebJP+1NhWiVzFrR2ldbB8zt2vvF19XQSzJJ45wPtz8r7X5wBNf8qXkYINe3vxT21Tlx4bd9N8UHr1VQKTbKoHz6DbfRWhiEYuJcftYMpG3rUAPvvf6sAos3EZLmycYPBmt5p8V0eQqIXKkX24bdGp/5a/a6rEg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:07 +0800
Message-id: <20220408103012.1419-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(4744005)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005)(21314003);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:30:28.2766 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 suspectscore=0 priorityscore=226 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 clxscore=176 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080053
Subject: [Ocfs2-devel] [PATCH v1 0/5] rewrite error handling during mounting
	stage
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
X-MC-Unique: qa3AV6DZO76YC9MDmNFLgg-1
X-ClientProxiedBy: TYBP286CA0002.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f62a6b7f-2e41-4afe-3eeb-08da194accdd
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB78405B3FADF3692E7806B95397E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 O48QrqZV3cbsn7AU6C7sjv/qAQg1v+U7KtXmjtPlXH64Jow/oBC9zseQFh3Zo8/iXpPctImSCrZoA3SFvvujxTv7FdTxnbx/OuqfcFA0dW/m3hpuxONuQTcti6bRxlKrHG3GXoAv5SEc/VFhdURRlebGSLSdg7GyBhITa+sHX5c7DZJlTO9bNu/aUhOUsawGLOVTKPyrzrV78NpXv6L26OZb3FWW2B23Q55EgdeOZi8i0QHvVcbyJn06XyB9NZ0sRb0i47aXAq7bRuwV63zoC/BbLDTLvQzua1aOfLS8uxMdIX7+vgpi1Dy4xFqna0WC8kPdzskzDoNvvBBLTIEqYn28lxXE7TU3mmshNHHpdaqaos8c6qQ/2VfEtqLBvj14S6micI7tZFwFKNf+hj2fKoswEOYIg5C1kSWNXRccxAo7ZPY9KBFS+MjYOn/J04MqDIJQ4OK5Y6Jn9Jfl9JabgkVhMl+7JfTBLRanRDE3eRQy18IO9/agr5TVSNmeTl6+3Jh3KKnx7rgbGmPcBoqrmkVexy4F59UoBX/MH262SDtKPLGTKSO67pMWeSdg7iqVfu9w7R7WiFudq5INQIwKa/RA5MEIvzPeBQy85zvlfhkmts6sXeFQSW02aCYVWZtJ9+0ODRDTn+8P92cV/CmencBaEXaFTxPYU+Q9xyQiiitEX23dZ3iM2SE7xU/yhK9N
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?6gTYkY8aeLo/z0OKxM08Nsy0n1+goMEnKtFe21yq8h/Cdp1kABaUlBEg1SGA?=
 =?us-ascii?Q?dNI1mJO7SFBXd4+1sda1+sy841zmeVDLeRERml5OIMrtPj10HvQ4r8G0MXjD?=
 =?us-ascii?Q?/UaypnP/L8xF7I+o5iLnPuelKSrYn0a9SgQjLikGaltvtZxkrbNNgJyjdYJ9?=
 =?us-ascii?Q?dlE3LMjNu6BTidgqAniNr5tLLl5mGV+DnVE+R6o8S+SkC/qu//MX1m2FZdvZ?=
 =?us-ascii?Q?DL41HV4hIyAXF4av8N7oyeXw11AQS7K8FfNDMxmzzzy+9/9ikp2QA2+BKPG6?=
 =?us-ascii?Q?lcd9SdzY0Uvde7USzscv+ao0n1Kf/xqMM4vuU5ZeqGw6QfuQrNGzwXraR9K0?=
 =?us-ascii?Q?LNf353fQFSErzCd7de6EDajR71u/ufDlLkPQFeiPZKqKGoKok8qujDnxvlgG?=
 =?us-ascii?Q?D8JFjHulE+TbuAAp3KvuPW6FExVLNy25nN1f8rL3GFl4CUpkxR8g9EaJ1TyU?=
 =?us-ascii?Q?7RzEU+QT6IYrhNMh7C58FegAjf9OnnW9wz4eQYm3SKoliJd3aAC7hQ1KQjEK?=
 =?us-ascii?Q?V8iGtIKYLsYVxC9w9EODiX4D+VvInRm+Z+YavEBEZSj/MN2phUVU93Dcd03D?=
 =?us-ascii?Q?CRb7GBZywkMXyQRYU0aUp7PIj3rJ+Qwzn1i5+h+Xg5n3vznPAe2m6R1pio5Y?=
 =?us-ascii?Q?Xiju1ng4ZxIdcp+qL3y6ucSv5YT/4I11rBY3yiuqgeUjBzsfmca0Fm9LqPlp?=
 =?us-ascii?Q?VDBh/b24uhDswHN1/kVITKSWaBtzFfizeeEBiOytH2ik1nHztFQD30OI1ZAt?=
 =?us-ascii?Q?F2k0D9YgXM8xVEz88dKJv1TC6O1qKKv1AYZfjF44gajyD/eBxC4o7ZStIpaT?=
 =?us-ascii?Q?vwgp/DRzgWJCHL+B8DTSsnK3KiJou5N83VrpYUkIGpRR8zs+rPt0yGcjs31L?=
 =?us-ascii?Q?0bC3atUQes0nHNAxBbxJh+bmmM3XjPgh7zJ3iAU/9U76+N66aONRBNuHZnDc?=
 =?us-ascii?Q?emOgAoLX5N9vaUilG9+xTwZWKj5zNnkiM2xZZs15RURydErbIeydcULu3sCs?=
 =?us-ascii?Q?91B/RvbqUV7wyMGzdE9XrcHJeISKe4rKgc1jFn+f2kAjBZzacdDoKYsRAuBr?=
 =?us-ascii?Q?AldhHwAUqd4/S/BVx5SsXtqZGlWGWJNsU+FCUDKpqv+UyrfCOtnjY5oLc13E?=
 =?us-ascii?Q?2TUJws8+DyGDTc3HhYjvvHUjMh/ZhTeFU/sp06euPrUBegamvEOfp0hDk9G9?=
 =?us-ascii?Q?l3cNRXK/pBD0f4amSVGOrUONw7kMmi5RFFSKDQgwefulU6S2HjZM/81gz7nc?=
 =?us-ascii?Q?2fn6UHFtPi5TEnAZXXrrONb587X87yz9vZXk2o800BcWydrT9QyItngf5d8u?=
 =?us-ascii?Q?y88uvpY3mkb/fupoa8TysL+CRt3MndzlLtjqC2wZkdb7HpnbgXSZflEnb8F+?=
 =?us-ascii?Q?2xtV5py8qkZkthurNciIGJoTLaMKub0ZuoOixzeIsnjx3TE21vvIA/IVAh/w?=
 =?us-ascii?Q?nkvKVPwIhUt7F73VO+/Zq7UyicZD84pDkD6xE4AzF3kbcsyeWfCAIaUoYP6D?=
 =?us-ascii?Q?YUvUdkQ0B0SQ6fgRLhlTWdb8tcIZEodntb3yYzCDuI7uxI6ITI3JS7rnknIh?=
 =?us-ascii?Q?txIYu/Q2hdpA0vXJcs6daQsl/gZpHoWMB7OITRJAhJ+oecCDJXL6td1zXIe2?=
 =?us-ascii?Q?zh0pw8AWO92J5AxrsnII+1I6NY5D2Ie8IRyaLY+9aheJoN503GOGC6gDBXB4?=
 =?us-ascii?Q?lQt+Vz3IHOBYn9nioj4MzBatTXpQrxpUIyZzb+bMF6QGs0RRmF2Aysy0iJLz?=
 =?us-ascii?Q?mEg+FqBWSA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f62a6b7f-2e41-4afe-3eeb-08da194accdd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 jn/P8/RVF82ibJk/daEN0qnhheCahzaM7muxILkN0J6VT026rkyMdmOT6cdyx+Z73pFBaNd/JGFlIV+Dwb99Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: pZWOGsu9eAGNtbdYoW13C8-FGWZdWTq9
X-Proofpoint-GUID: pZWOGsu9eAGNtbdYoW13C8-FGWZdWTq9
Reporting-Meta:
 AAH2jUUd8w6e0ZVanTJzLPd5T4Vt2UZaoIQDb0O8vyQHJBnJbVBYzStVh3qZWDTR
 NKMAs2jUpf27Lb2l4xWo2dfzBfDQm7JYhSLnQ798Nsx3A1dF9sIHiKFza5QK3VE8
 SH77Ix/NeqHqlzhNA6HR6bsYuw+XpRClTCdIUnUBTa4bLThM6Iqgo+cPR4X8DATM
 DQtuX0lYvWPDFSDXla2r6JT8OpYXcX53gOJmHaT17nvULlRI5hw3N0joWhT3FAXj
 rqm8J3P8dnFiaaOMrg63BtBnL2kEaeLBhikWeuG4z8xA+Mk2sg1r7CTMCpPDrKrP
 hOa8FLMTPyJLAQD5pCWMLygEGG7UMJA6ssDLhORKbU1PWrD/f7o7pTDJ7BQlxCBF
 +A62wQS3NoDosRys6HmXDUkejtmcytfsRo4jLPWtuqTvIm/JK3C6WwnTS8Kss/te
 Yn6a4Pb61xgNzHKKLdsLlFqLdz2iwbGWi+/Y9eoKV+2hKMJOEJCVzfUKhpg6Tzzc
 xL3UGp2ZU89JE3H22OIkBgDXgCxpQYdLcgeWIdT4KF4=

draft -> v1: 
- split one patch into 5 patches.
- goto labal name change to out_xxx style.
- only test for mount/umount & 0001-xx.patch related issue.
- polish some codes

note:
I didn't totally revert da5e7c87827e8, just revert init part codes.

Heming Zhao (5):
  ocfs2: partly revert da5e7c87827e8 for mounting crash issue
  ocfs2: change return type of ocfs2_resmap_init
  ocfs2: ocfs2_initialize_super does cleanup job before return error
  ocfs2: ocfs2_mount_volume does cleanup job before return error
  ocfs2: rewrite error handling of ocfs2_fill_super

 fs/ocfs2/inode.c        |   4 +-
 fs/ocfs2/journal.c      |  19 ----
 fs/ocfs2/reservations.c |   4 +-
 fs/ocfs2/reservations.h |   5 +-
 fs/ocfs2/super.c        | 195 ++++++++++++++++++++++++++--------------
 5 files changed, 132 insertions(+), 95 deletions(-)

-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
