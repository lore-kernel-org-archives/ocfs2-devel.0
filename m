Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D85C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vPrwxnVmKQo8e1W4ZXLLU9OyI3I5LnYn7hyL8rQ5M9g=;
 b=EgX/Jun6YlmPAkIZ6pTlqLFTHOz+0T3ZfrpdZB6sx03cr0N+TR7F1o3Cf5C0CYOlWb5Rn36xLfBf
   ODZFBTVQhCG1bC+bO2zxRpSlouE1lFNOBtGJge8L3qxhdto7aX399hoQ8BjUCZCDFvGbifApyiiT
   YUPAyu4/DVeBqizTgyzIXn1GGvOBQFpp2mDz5ONrGtdYSD4STkzfMMAUN84lHqSjrdN7m4Q8jFrV
   VAC7rZQApOT+QuXsiO6mQcUWn1aNWuUYywgLoL5UDuXMgtldry/yzIxClerTaN3EZlzvqZleACQ/
   EW61YPxeOHy90iwYNfKWYTr2+nvw7PRQZA6M1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vPrwxnVmKQo8e1W4ZXLLU9OyI3I5LnYn7hyL8rQ5M9g=;
 b=qkkaGGUpqt/BjNeyzCjFitrQJoUPWPuswdZsL0EOoxgg4lD6N9Vh7288t7uJPX8sZ/1IiLfuIDtT
   c86hTwapsi0n/qFtGPNc2wYX+uOJh4Bo73oajkhRNvGICmF772x9CoE+YX0XTNgFJaopa9ef2OTt
   PLHkwOCFQ7Bvh3HwWilCpClFZibwm7rLGBjKAwh/fMclNL8Wusop0EBPa0qrXSeu/XEOXi0Frz/w
   WP85drITo7zhbSlqzPPtNrhocGM6PKLCx/ERFwNjVMWnzWRTc3S1+35a7WSd/+mTDNi5KVmlb6XO
   NzpouY8kKFVWFGY+1rSllI+yiXi8pL8x1/7+Lg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00EX49UJCGB0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:32:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rtM6WQf1X5CFX+vgnRgQOYigjQ6xnz/J1uu/PU11Tp8=;
 b=eHUph2bNrH8sJCZpXfwCiY5eudCWKAsSl43XDtCTsBQtI2OHAoWMdLFE/AB4RtpkLDOx
 54w0wxzP5iqXInt1LLMcTIZyUIRzDmq3kH3PPHOEpDi/nB0hBWtwGPTKA9ssEaWYXe35
 wSXAjvgDZLbUzrtsepfTSwWU9aC/LFEXXgeLPpWTK3JGCgj/VYojCHhdB1+/qlHzr0mG
 iCQVphtYo1YXLxBdcTSD1OIOXSqRNVlN1kE89zsLQ6Ou9zfAAehK5Xtp1i0AFX6zMvH8
 w/71ngjIhEZLLFAUWtUf3b3GqbJ8u7Ewgenmek4KqglQ+jox2tcGAMvY2GvSbom0VN/f Dg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgKMEmrD/qYF8MkD/UCCrsznzJfOfWE4hARNtrm8bHosW/XjGfcVo0qtyfb8+AWp4i0TEvCtYge4j0PpQ/41z4kesJ5VCgOL4/DhdwhPqoJHydhmpyhZxkESE+ZeUmgwotbvibh4fA9eGC8ZpEy0HnMckqmdgu0btkdcJDo8RqJ4twcX5EYi0ylKXByd0UT9GkhxX5RnzeuYbvmME1sel8wOglAz2lWZHLhU2DKowG9LhuZJFz4hVXlOkn4nC+GggR9SA/ooSfSjiNtShNtPNUlA89igfXhrIp+F3M3Yr5Gk2y6K1fm1agg/Kziq8AOokbMcm1ZTYPdnosAC0SRcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtM6WQf1X5CFX+vgnRgQOYigjQ6xnz/J1uu/PU11Tp8=;
 b=Ug8Bq3Rl5R0gt5SUIyB9pIK0D9nMj7RM5YVCx1JJ/wg9z8QFicejloxLhiMbEngy05/T6mUoIfxn3pKKJrztK4nYveqdjaITYsks52MUa/IJ0Fxlh8KGLO52UdEt/3gMydFFz0VfeZrKxzm7JzsX2xrUNKarfD/2cTpfqzUZ+yV6Hz2Uz7TZ4kZb06ChZgqwWQFWUdPuxscGyp1HNYd8762A8mLXIYUmh+HkYrav7TsFBAtJWLXERDCIMxchGzxvqB87MXkqqUZyUVSAPD/iSMpsY8M1OZWMi6NPFGrQBHIQVkdUhHtREnsL8pUncqEl9DALjPrea/IIksFshMDZew==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtM6WQf1X5CFX+vgnRgQOYigjQ6xnz/J1uu/PU11Tp8=;
 b=CJ+6kTqcnxOwAlmE5iDZyHRO+cPt0GlZ7InqqyNz0+rD4IKx1CSclHFi+p2PpffWvKbuNO+hwtxgelseF5Qoo1enPG9V8p/5cCyy5ED2KNd/M/UsfLbAJMF/xSU+UYT5241uGWwHu9Zt6v8Izsx+2oJITTX3FT/tz9rz7eplVMg=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq135iph8lc.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-25-hch@lst.de>
Date: Wed, 06 Apr 2022 23:32:28 -0400
In-reply-to: <20220406060516.409838-25-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:13
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:32:30.6416 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=883
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
Subject: Re: [Ocfs2-devel] [PATCH 24/27] block: add a bdev_discard_granularity
 helper
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
X-ClientProxiedBy: DS7PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073c7bad-f00d-4d5b-ec41-08da18473efc
X-MS-TrafficTypeDiagnostic: BN6PR10MB1618:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 JERinJT2W2Ypbl8PsbtxeIJoPC83Yz4TMb9N6yOA0AMqIRBhLSFgns5FW9KcT8R3manJGfF9PFEkeLwEiTIo+VHsKI9zuIlsu4aW9Gs85piqORIK0Yxu5A50kZAtCNHdBRtz5Fp9n2wCIAY6/2qZoLd1PgmLHvbYjfyPb4EzQpEPQZmIsxHFin4hi3BeSNuKy6AvKapLdD9NCboqp6a+cxChjxitj6/U9ELZh7QFTw8aSTdd/Be5RU4WzVF7qWZ13udXVn3fYqsaBR1P0sbH0YakvtuNbaRIb44GITtLn/0SAH6iEvxdebAhExYhONDgtKP81/7x2WhG2AKzx3LnQ/gl52YatMwTu7AzHiu3DaViEBzRiDfEbOCrwLr+OI+Cbw7VGxnY8AcZo5odoX8EfW7AZ3jgLyLLBEky33NP4t4e9FK9ax0klgde1/XN+3hX1B1N5QEEkztdEp1Lo1rfxuWrrqmBLXB5hsjj1gT4KbVEVFAhJrZzfwkMB/Mzi+5ebHoelWItX3zki+M4Vo/0IopKza5kxrQzBDGbw+Ug5lWDi31HB23/I+Ok+CKGqX4lfpRw4AVijhEnH/YjTO6/jkSP/eQ851t2AW+sOFjwlTQ=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 073c7bad-f00d-4d5b-ec41-08da18473efc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 hwGzzH7OhkF8PNNh3yM9ri4dh2R9VUt7jXac7Lm4rAo/rmhpAzJ3fZmkBEtZO72lGTEl96s8zj4YXk68qPq0GSp3vjt9qNgWQQclO0sGZLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1618
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
X-OrganizationHeadersPreserved: BN6PR10MB1618.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: 8GXF_cAcoa1su41atb59o7l4paqqGtWt
X-Proofpoint-GUID: 8GXF_cAcoa1su41atb59o7l4paqqGtWt
Reporting-Meta:
 AAGXVUA7dfur4hFsh8w6RMZTx5RUqrVw+tO6HHGpQObG5DX5alPSSlzkgCbXEfMb
 AcnhpUsI6SXHxyrti6ItrCKnqVZS2tMrQUyi9aOZ1idTw+ASBYXPvRMdeUiMQR+n
 FSFmCxvkhEKdhtj0c7QtAznlmGik+YUZzyG6Q4blJWrtmXYi30k9q5sMNZxFgB3k
 Ma2OObsOoYwUHSIrLI9ESpPvnlzuHEcrXSZkOUoZzeDqIrScEihYC1Ciwm/vzmUa
 0eTrx9Hsrn7oOGtMsmeLZkMRQ7coRVCltfNt11tTqyADMl7dsB9Vj+xKeZ4qUJ+G
 +W4y47NmR0MPvHd22EI1UFREsiQ4MYsXbhStZUwv0k/Fdpl0uQ47DnZQFtnW0/66
 lGPkFvIiq7n6kN0qYsEpN+eHS6Z+qKVM1QLxx3lTcPAP75tkhtX3FZ7iBMx0QWKu
 m647U9BYgMerp52vjqpk+m5Zj24mmzuHAVECJJ0p2a8E+P6XkFDOjpOPbGxpRIV5
 h/ror64yQQeZzLn15ZYzfwIY7gIue6/nT8++eajgGGs=


Christoph,

> Abstract away implementation details from file systems by providing a
> block_device based helper to retreive the discard granularity.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
