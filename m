Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015AEC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GolXdhicby5CTb6IOMECjwoFgpMzuEkwGbxpDl1FKZk=;
 b=iR0CQ0qAgBTBH0Fx15Gs6BhIEHNuYAZR9J7xdw15qGmU/AsskG8VC6fvEnI8b1w50JZDUKYGyvba
   FarB0OIaqoT6GO/K8s9r4hgnywR0BBvyqGwatFpHCBPbyjQHN9saTo4NJbjkN5HgJM8EkUwLapfi
   tWeJbKfCgerY8p+qcJdumqmi8vfNadiI3QCucKAR4pccQBbBPVtvEE+KJ1hn6KPpe/Wv9NXsEWIN
   5D/nfD1R8/0qCPTeX0sV82bm9yA+l0sIYdjWBBiS2mjeWZAwJ/zocUC9++co4Vp8dCk3y2EHazej
   dPhnthE0v1AtyKMQ1akZHoagl7URRpPFJnn1GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GolXdhicby5CTb6IOMECjwoFgpMzuEkwGbxpDl1FKZk=;
 b=fDrD4ucVZJYWrLGy675/DHdgAFwACxf8GVff6M8C0S4HqunFV6VyQVXnzdfVtHWsbOx59WKRfWQI
   SbmDKhwQSzURch4aFDhNJm06rp2Tk+rvE8wpRk56MlyWi2pqihtA+iuI95OJQVaVU1rouW33U6sZ
   yhi2kdttUlcHO83LL2Kfr2BULFJ4TJMviVfp0D4L1FXHSF0OlYxbucHXIlOcVW3deMEH32P9mgUU
   1BnKYQ3s440izN+SxNXVx2X8GEVV2jTkYlDwnyhUt2AjEUZdEtC0w0Wjioz5DoMxTNjw31q23UVN
   Wrk8n7bCQ6a+MU5GtdJweqNUbF4gLnItGgoUeg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00C3F9DEPQ80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:22:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tAPmbbaCkvVZPvRGbdErqYJrUZb0QsK/3MVtxkvtM78=;
 b=U4YAcWA4jAisZZK//5B1Q0Bz/XRLUueeIrA8QtDqWbfRoJFt6ww6ZmEUob2Y/jy1sDg3
 VEi5fCC9yWTf3nvupLHm/YIzJPr7h7ZwuiJ+JTcuJZCb5CbP7NmlaLnAERPFAnOYbOYE
 +h9ql0/JQJboCoKu9y6jxoiL5yjQj1LOXIcN8Hk7tIedSgevMXYjg6UChMxtQr1PKZzU
 NtBFsW+j6C9r8V7FhFq+QTNg0BBhAXzF86OpyuXQw+KKI1flFf3QrS7/jbrHoGmM1fXm
 GO9VW1PZsX4FHp5zwhKsd0faRseJ8aBOcK7adMvInz51QRy6VmWGQG1Ss3Z2TSDrpSxd ZA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSBpZRRjwUDHPcg52jLeT9SADDcAG3NWJKzxUGkINHLeA6wXVyF/4iAwvwuSX2R1QDaeyLsndLSQYf6PFHR8gTfK8bDD1eJWLTSqgCvgEOCsRcR0XpNjlRApTVs4GqTvS9gKd1b/XOprFFwHW+kS1m+Z7pnrHURpTikfli4TSTj72YwFkaSlU3TgHM/MqQTlVYfCbfWI1esTO8SA3KpIUKBWBy63Mb5oAyBWdspCJkafshToh4Uyi2FBf1epAiyOrgWUdgSvmPuxutNAuOJfL4C8jLlq2K20zUmw9UZQyljZyk2INR6jty6be4uD4U+vuA+yiVNMly5jKgn4eRnbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAPmbbaCkvVZPvRGbdErqYJrUZb0QsK/3MVtxkvtM78=;
 b=k5BjvrT7mBeAAj6AyRqSgKV5SxpOLh3fIy7+JYiUtVGpwWGAbS5tp+ypGPPNzrqImWMPmwKG+ndtL5vnAJ2ScfV/EAXjmcJryV5FfnPXg772NPAbtNptx2weqUJ30JuYeO/VHnd/kqO5QnY1JyJ1FtTxjK0kaVngyaoVcBg11ThaEBbjfe+YIGXU7Y1ovcxVEwlfNJqCvEQ9ZdSmYkK8nR4lPbXrQgROck8BXgwrdpvxnVduDvuhpNlk3kyLo/lP5tE9yfEf/L8wD7G9NRiqfeG7eum5VeNBSs01V89jgrIqAzFZI4FblQy5yONre7Lj112Dbxm3f9fDoZfr2yFyyg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAPmbbaCkvVZPvRGbdErqYJrUZb0QsK/3MVtxkvtM78=;
 b=ixjhG2r42yWmErYqX6gqLi8ad1BNJJ0X3sZIgDzUsDVnvPEybtD5WCHXvI13USsa8m7Vq2RRua9H8V5Y3Rf+1SCGFE+lUjCiQJOo4QegdHj9JspDKj2xdPM+v3KmpWz+pQbzTz6kCtVFXJJbexTVy7zwRjiF8v8tft+crWEXqd8=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1tub5h92g.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-21-hch@lst.de>
Date: Wed, 06 Apr 2022 23:22:13 -0400
In-reply-to: <20220406060516.409838-21-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:09
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:22:15.8957 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=878
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 20/27] block: use bdev_discard_alignment in
 part_discard_alignment_show
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
From: "Martin K. Petersen via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Martin K. Petersen" <martin.petersen@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: DM6PR08CA0027.namprd08.prod.outlook.com (2603:10b6:5:80::40)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48dfe498-a030-4603-882a-08da1845d094
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 aVqBl6yjuyv0fYITEquRQqOOtqGnwtGIXpec/IzDpwsp8/FRSaW9EtwESvIufanK456JNKFWpR+EkDnLURiyf0bEID0GeOpOHaDZe3th1pUtxBxM07esBsYSmoqhQWByM4YvHIhrLGY/NhlEVMxF+g2om8rVNf367mf4nvEVTh6gmlUSMXKQxRwYLMpgGWjcoSzFHFXHgzuKXAt1EGKMXKGZhy7p2RIqTb11GyLheAN1qxZxKG2/YF2oiUnUs9p8TuJaJKSVfjxWk+iEMv7ZLDZkcg/d+do6wANiTu7/MGq+JxRiLD5KapW1I4AXd37oTVRaS8PxEEdMk8Dbmi9vU2BGbWGYnvil/6HWA0Y6gsebf+htUwMZ6u2ezhvi8hXGMtSYOdTjO4DpmwHMb4QPKcbRULri2x7xCgvIbhPJEFtME2tD+3iLk/Wfyzb1VzADXPfANSrBiLlvPCbhWmG7Ze3/LSGvDPeoJLFRHdQUW/C2uPR5dRCQ+OPhCNy1sll4OjtnsflqamAz1qEpxZdcj2LUBh3WkvAL2uKy98LgyAp6VK3q/qpFWG0oT1/J8YyPzhIPrMtArgvNmWFQQXG/D1+moOHtyvPYoarfwSpYzVo=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 48dfe498-a030-4603-882a-08da1845d094
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 mouFQTiGIB3sqIlUkexWTCexFzQ2PEHssCgeJ4E6Wra5R4KAPVyvJyuCB6zCHxahDwRdbWgEroHmtjXA5lGtLWj+q7jaev1O8w8EMd3wEKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-MS-Exchange-CrossPremises-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Martin Petersen <martin.petersen@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 138.3.201.44
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SA2PR10MB4748.namprd10.prod.outlook.com
X-Proofpoint-GUID: wId_Sgje8zTuKA93OsZSYmba1X2QRfAw
X-Proofpoint-ORIG-GUID: wId_Sgje8zTuKA93OsZSYmba1X2QRfAw
Reporting-Meta:
 AAFYHBDeUADOXoTfqjiU5UafeJxN2ws1CoJCuRRs1V0GfxYSfB2dXvca+F3iFnwq
 fhs7ddVY+YcpHaN4miChWOCONvJL0DHr+NABBnobKlCfKJFS2jSwaKWU//NHcOLl
 V/VYaxPMY6rIDc5TRmN9saA3ipX6p0e0elw98LuAtFyFpEXd+C/gW3PH98qAUnde
 lxasgmEhufgg0TlGBsNJ375Iqh4GrOfNIhsoDgaaBIgAVuEiwJVpFXy7iA5m9qdk
 6DZ96/FFm1GeT9+QGq5t8eHViKn7jYRhAiNmBDRfLxZD4tmprbr8XeiksZ7jibOW
 U1Fc9RnZ3TtAAENo2tArZL8nrc/RxJqDgTHW/N86cDBX3o2k2doGf19xrLNnGX7N
 zB4aw0phgNeSXJTpAnU11DqtibCq/ZNDUCu7yfWf2XBF29AbXUkLBvmjiXYXZ6fJ
 gcmrBllLCUxX9F1nKkyt5w1T7LnIIu1aw0CFwHFJeWCdWnSBCB3WWk+9TZuVO0MA
 Ar633NpUEX9/VPkgCCHfJl1/Pxn5bQe7k6/Vb1RR0RU=


Christoph,

> Use the bdev based alignment helper instead of open coding it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
