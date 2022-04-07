Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3070DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6InAeO4A3LNtHx0ZtwHSFL71+8rrtMXY+IOo+ZxGodo=;
 b=UTLEM5p/uFR4dFkMOLg+YXpTBGgjLmOcSO5fKJMZ7ohFwPxxUUAnfAHTBj+Q7sORkOBfRMzvn14L
   Yws4Oroiekm5xolN8lRvzO54tt6+Evc75UUCRSfhvmF84mS1dP2lCpemJ4Jusp7rpIhcfphQ+Lil
   naauEO6XG/K9IZIvUji1wtmoWq4ATf5uX3DcQQXlIiO/q1dgvyhKDt3J47K6IUPRqRjIok7uIeB1
   DuE4DbKDIMy1KWVX5R8albQoQ698SXo22ypXH9m1B8KZzZU65uxIHM9Qka9jGvDeSVvi5nre5/ld
   5mxMgTiTh3VjZVO69N8OYhD2rstWTwIDMFMHZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6InAeO4A3LNtHx0ZtwHSFL71+8rrtMXY+IOo+ZxGodo=;
 b=hcwCT0CnTRN5oGfgmZF53HD2gbq+qRYpDaf76qcaV+5hVFNJJypbfJIu2ar5/oZS4UIDMi1lnJuc
   M7Tl6sWmXYWk+aYTlzceR7WsXPvwSREopW6AEXAQrAuQXwf33ys5HX5sS8YvRJNqfXHuiPT34qD6
   LXrVzExqkVrvqIiDg+Vo5sj8wq3HAnsUm7pnMxNj7nMN2WrxCWcFGSnOHPVxdxV3Ko5JyJYO7k1q
   9DrwMcb5G0+1JHyOAHlirfm3gieGMJmEdOSFSMPWMBSKOnt7YAKiSChO/MTiy08ktRd1DbxgDNaV
   LHfhuBRHs34D+p2AZuJsjOmLrYJOWthufhBXEQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00CSV9MHE6C0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:27:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jtZFiukrDrNaKwudMOYgmK4y6ZDoL7W+5uSf9uS4Pw4=;
 b=syOONMklItTPSXz7KtfaCFVFE5ivjGKYsK8owDdJX+p3veRe56GBeWrYdskEry8eGz2Z
 c9zdGKmBs2gZ2XoUbepmD7qQNBxG6tQ5j2ZUx60TtC8+OdqTmLjVFPsmu3BiSk4h2g9t
 iWHcR7KAWHZCsLBwzDWPwabAUA3V8+/vKC252bPJ1HkIMYaLe74IPGnWTpuUh6GI0b2P
 Tje7hyIT9B3Go36b+Kc8u8F/RbQoq1L2rEe93W5y0GZpNb9PLi1p1XDiIvz+wyNt01yZ
 eONd83VdVCQnI483aopIRy7FIm9GO4/Z/SyF64TYHe5SJpXrPVZUZw5fskMd8zi7M+Az RA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT7JRfRfh8tMHIILWi+sWlt3HXmI15Wypi3mhG6617NbZWcaeeOIoYEXWcRxB4gTmTvWIPb8I9nzY1HfBMUxwIw/krVw6zhHezCB6b1n3a5GCR6+Z00eJQ/J/nWyKC+DaYYHsVa8N5Jt8qUhELnWwEpT5xOx9UC5bgFqO7JThvYR20lVYmvsjayxr1QeW63TPMipVubO1HYtxK5IESv7JBvRh5k88AqJjMEXIQZJ1XK8jkzjBUg3+p9A0ce/6gI/i8+B9+8bSRLKOC1Qk4Y9fIPWizZjNrORCLWM55PhFove7cMmB+WEwBh+mCxzV8u2v+22AFGio0DbwxhofimJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtZFiukrDrNaKwudMOYgmK4y6ZDoL7W+5uSf9uS4Pw4=;
 b=UknKxGg1LSqh6p9l31Dsqm0ZXpDO2h9fn9aqpmHFMxkZ7Owt9xDm282ylmhb3Ypno7LKbmhfxxyIlbBNeV7t3P17dgD4lUvPh3FnBtXWmN5ey0tOiuSwlh7GctSLjcgKbCzF5DIvxtqEHLtZ/5+1wKFTzftP4SWuuZOgowgGZj0eIz4+exRdqmCx4fZFjGXqa54feJFypcaA3lK3osw0lbs5eG6X717aqdCZ1TqxkLt7g4SgoB5XT7yFKKTiZnX0YjkaCmTe0hGNVUv6lUk+s6vwzOJCPsbgtydzB/3MsX9LAtFKjLESI5hCWgMHqxwxXyqkaYrr5SIvZwLIiu12LQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtZFiukrDrNaKwudMOYgmK4y6ZDoL7W+5uSf9uS4Pw4=;
 b=byPV872ud6UtzhSrpqyEg3uOhRvGrO7cczApFnFQ3dJ0p9FE3ei0HdF3uO/IHvK1GRK5FplLRXPejqYba7YE0wwiTyV6emht4qEXc2knPPotaz3650K4WQVU2zstGPWx+33QEYIPkWNJefAAZCIe5yzRQcROdEuuExBhdaiqTn0=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1k0c1h8w3.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-22-hch@lst.de>
Date: Wed, 06 Apr 2022 23:27:40 -0400
In-reply-to: <20220406060516.409838-22-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:10
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:27:43.9876 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 21/27] block: move {bdev,
 queue_limit}_discard_alignment out of line
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
X-ClientProxiedBy: DS7PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:5:3af::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3cf4a52-2840-46fd-60f0-08da18469423
X-MS-TrafficTypeDiagnostic: SN6PR10MB2637:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 GjrZMHjzG9hdz9kJnppoYLLi2gDFqTQo1XXaT+GARuAm50Zofo/SGAVsFUm4Xld9UzqW6YpAzXq6TBvdRLtH5D4sUWCzgq/UkWSyoMdUW248MlwYn0Nn8m3nkl7TFN/bVo5wUjrT6lGgZ7rEBPu3XiGAc7JfoJ4FlB/W6MtKVdnKOuPyxNpCsMRCpsf5tfdruXzXGwqmjfVZ4OCVoUJo6ACUhv+Od+eBZJJ0AYLSBaLrGFATtTD/Z7KBPBhYnepD0BsdzRmCPu1CETT6yaqlmasBlnM+aYWkM0W7ngSuOvirSXTPTHF65pax8lNcrYGfsf7k+Y+uvX8hdVUaUQkZV0oeX3fXFghpul7+ZmbQjyDlhsQgosSmBNoVTyxjw/OEM9drcycpWwAEadedlsKIyMhoHNK4uyBPrP9XqEwiu8jI9xMG7BlxNaD4A9JSRK7YgASFaiDgAACHhQ+kyuiN4mDXAofUHkGmPtfhkEaZN9xzVUVlCcFCGVGcG2Snzn/EAUM9VW6YuXJWh1nVQgckjVSKWReDMx6VvAIQKQDYPaYhCrUasCOPPhpCoBnQY1KReJ9B3ndqSoPYt1nhKpbuUaxNSRLOSNrdlQJeFuKObyE=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a3cf4a52-2840-46fd-60f0-08da18469423
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 eyUcy9/MGctZOofiA5xyPFtM1nZ908KVPJjnyQfCHQlpI4CSGsRtGP5YZVc9zUFfqAJB8w5g9VIHZ4PeBrVg8TSsYaV90Ss0i8yVCGDR2d8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2637
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
X-OrganizationHeadersPreserved: SN6PR10MB2637.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: OhbJCQq9pqNVIhwfXmrG7PgjWbYUE0OB
X-Proofpoint-GUID: OhbJCQq9pqNVIhwfXmrG7PgjWbYUE0OB
Reporting-Meta:
 AAHMDjh7KoAMxzKlSqlHaFzEdnSs1RpHDj7v7CP0tFAbCHERuIrubQHNSIuBL+o9
 0UNw4AFH1kaV+eBA2t+ZJBgkkLRBISg2LvbvY5fzzGplcLnNxpWSmXXEE1xp/9N2
 eXCeHVbs2ffnhdvQMnWGeMlChCmBrXGFfPVP3PFkbSuXl+wqcX+tbmY/7tJypGVF
 u+lnjga36DiW9qR+e41GtPomoo7R8PDfaxbbCknNkb6lx9xiE03zGOyVImoXoUJs
 tGD6PHIG7oE60YzTYdu0VHdHDpAh5dNrbQSP8WTFwW2HjfMGgKE5QVRbt9VXQdyf
 2a23swYEoiVMJD9z2tZzxPtx8ipH3+qZdzajG7vzgVpHwsuIuYbDsAgtRBdkpb/n
 rdPCOgjshDnLG2YGCEgVkM5lSzNVN2jEERCpTD84dEd4PQTbvxEazIvZ13q87BTp
 fjF0O5nZoX8UPCMJpgoSEmI8zgZX4uOGzICf02VZgK1saTBuhDUHGFQihYHUs7sC
 PTeCg0opcYIp1sQfF3zxBSCFjY/M/y6JzsDMAn2UPw4X


Christoph,

> No need to inline these fairly larger helpers.  Also fix the return
> value to be unsigned, just like the field in struct queue_limits.

I believe the original reason for the signed int here was to be able to
express -1 for sysfs. I am not sure why I didn't just use the misaligned
flag.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
