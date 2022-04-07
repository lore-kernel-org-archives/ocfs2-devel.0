Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64B0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vfcf8ewXwZ5iaSWh0m7LGv0Q+p10RfnAk2jQZlA21e8=;
 b=pFBxbcH/pbCALq/tbSwEpnGdANML6Rw/WB/VYNY3T2FTgtuyFUTqJNDty22HXBFuEjzc3ckqfo81
   8/WmjZmdWYmyUvb4HdqyqLdT4wk6AlCgOSsLOPPG5unj6IV64JI8zUxFkVsYSP7gOJPKgiAPQxKD
   cPnAEtu2XbcLpGRDr0Ve892YFXGtF9WvA7SklKDi+rV9V09NxpqHwRPASL+flWKW5N1FuEYeC+7C
   FCmp++AbYcecSN9FcfkOVzHg5UOGoUDUzTkS8aRwdkxeOcUb89eeI7EKThJCEhV7DuP0GKwXYBBD
   hajaCYrNfhvBeQ/bkba+YFrgdxjM5J1zCAYfPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vfcf8ewXwZ5iaSWh0m7LGv0Q+p10RfnAk2jQZlA21e8=;
 b=eLIV3TWnspdgy8gNp6yC8blfqQ8mU54Ra42foF0W9p7VkSLL1dRSeDpv/wNZvK6NMqB3UsXHk8Dx
   jvD/QxtBqscU5AT3CsdgwmeQ6pDw+YxY2zEI+vd8rsq11hqxpN4zOvjGRGUCDeT9dlYrXnkOO3Lb
   QZoH8YSDy/A5RLA3e7x+cvS/l1eUhz0D/4OmhSBGj+nIxSOsjuyrI1DVAoE9Or9fvbL4enYraqYN
   x7o02LHuhS0EVk03pajZqFCQHJm1nRA+b84tmsog+WQ2q1aCogNRrGi9McvBSWImqp3D4A4PsxQK
   XYkfPsW+i5YGCKdzDCgc5+dKdv+ArI5B+zxFXw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00HHA9RT1J90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:31:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mYq6byqIyiFjHV8Jr0Ype4Fjz5k3Y7rfnHXOHjRgy9A=;
 b=UoLG9f3rZI3Wt+K09rjVRxZ9B08Rhn+8Grv4X1PNpsDZE/RDxHcFxHCQUgwuEjjZ6rJq
 wNuNdlyjT8obYSvTpy3fP8BF876Zs+hqOsSrpBucEgo+EGYJuY95NOIj/xV4vE8YbjAM
 Vagf4r2oIzDGXZGT1bdnYp5qbnHGYW7ZJYGyzEiZs3s6Ry00lGPuyfSwiiKyo3rmS6Xs
 jIimKiYXYc+jcfhgOe5RxG0KhocTvE23Yl2MlbRB7vMxhf8ntKaiSqTtKKykNy2isH9t
 U+pUa7b3DleXFwYe6m9t9XKqagf5GTTGyB+OMYYemMPa9DZQE+veiYorobvoHI2Ri9I9 vg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFmpaPEZLPAlzqTHJbIVWsVeZ4QfIrI3jWo5jTp6iqq9/kUTDp+8lVt4azLjaNS3FaBSbzA2BQJVdS04yH8HdDx7eijcXVHXQuaRnWtmXjFCB7UA46OV5N3ly3vz2AUmf2rENznVDFaynXtsBhI1/YJTdxcbHQqoE6CiqJR32YeFmffE9takZAXCYyTAsbnDvCLkBA4tGoBeH84ce53WyOdVWDHVkCUZPITqpiED2BrxijokW8BtXyoklZKHbtg/lx/xVQQZvAqoyy47uHgwNGwFxjjEdlLwPaa/CNGO/YfHNkvXvqKAyWYmY1E5uJglhAcANa+ykbE0OqF2URH5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYq6byqIyiFjHV8Jr0Ype4Fjz5k3Y7rfnHXOHjRgy9A=;
 b=kzrzb4EilrlaWkyhI1PFROR+HPV73IluvJYapla+jeF8waVc/M6wGYgNTETxcafYzkDE3wA/U+8EKmKINszwgF2lwBc21OcUFL7oFxdhIBcXOwAxlvnnWiJQvM6og4fFwKZHVvisRutd2gM5oUOVbQYVaofFBwDIkkZEvAlI8wbRvNEBzznQQuspyBl5DLve7iyaJgkBS11iNJUxQ/NoYxd+SdWhY8hx//CBkS0l+3EBVerGrI/QYco5s8hKYnpJykjQs2GjJz+l52bArNNK3YZ6nBk715I/LVvkxEsL833liOLxzrC9Mz1yYf0pGXLIkUCj73uic3eAcR/jaBHu2Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYq6byqIyiFjHV8Jr0Ype4Fjz5k3Y7rfnHXOHjRgy9A=;
 b=LQIIjDYzWI2zWLxMzrzGLapxKOzbIFVr0kSWjCMeqqtP/m6S1bu4nNgQSPnj9QPO/3YhaVzqF6v54lLGy+rvRCtCezIQOHjSUkerXtpZmL+bF/oYOsEjQDjr23E8pDk6FEoaI1l1bvpX10+rKfA/ffdhbQl5Sjn8NAyKcCSSPjE=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq18rshh8o7.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-24-hch@lst.de>
Date: Wed, 06 Apr 2022 23:30:51 -0400
In-reply-to: <20220406060516.409838-24-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:12
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:30:54.2477 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=967
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
Subject: Re: [Ocfs2-devel] [PATCH 23/27] block: add a bdev_max_discard_sectors
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
X-ClientProxiedBy: SN1PR12CA0105.namprd12.prod.outlook.com
 (2603:10b6:802:21::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1be5c088-2287-49ae-6394-08da18470588
X-MS-TrafficTypeDiagnostic: BN6PR10MB1618:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 rH54qGpxjPA5dfaUyzjDSunwA/jERpwJUkHtFlM3/7qKD+BfkhGmjKF/5HF502ItU+ba9cLxZbLiJcmGaLJ/jWwSOywlwTB84LezGZ9kKurLf01aAT8rQLGQO/l9Hjx/OaDV+nft2iX/f9kQl0wB/EA5f+QTIXz78x2ecEl7rGyBXS9UlCwiHYD6ScJz8HQNQ3xUeUgeAzN47nnh8s2NND/XxbT84o8FFASzFtrSz9n++47YJ8h/RDMlHKtkGl7jPjAVHBTu0RKZJQFgCMGO6DflqhrznlDnXjhPsJ9jwxJVT1GZJPha8foATgyLY4oim3/kHEw3GSkZtL0o8hDPfHt2rZz07Ucp8CW/5ZyPqo0JInTgfLnv4ylwvdZyKNdXSkch35wM4rqD4cTcl9fd1iRd606jAbZXY2vhk8GbHqD2za8WkG7Xnzch2lIqUOEqtvSunOTVwAEWd+7Ogg8TTa9TsJQtfhynyWZQvQ4bJzfZzipA4cmzQNtsyH0UWonD+uiL8BdJjdAA8+ExwbUZks8Czmvhq2MCmH66JdWPiH5FAX0kTbTtpHILa4EHjgR/Ec2tdG0BF+6VWl6WpxSIpCK/msIdTJoSozB+v5VNkZI=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1be5c088-2287-49ae-6394-08da18470588
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 fZsxFmvQzbP4r8yjJO40wi4P7IVmH9WINqip+vYPN9usm3gvSP/VHIESPlyRfsIAkdL64OGdqNNYNpMQLS7mVX4jP/XZqTlg8HmQkUT1qUo=
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
X-Proofpoint-ORIG-GUID: wICoDOo7wq4nx-S4cmg3H-pWbBoxc9N0
X-Proofpoint-GUID: wICoDOo7wq4nx-S4cmg3H-pWbBoxc9N0
Reporting-Meta:
 AAEuPq67nkDOYqBj59AdxDK48JKVVyl8c0waDVYRLSucVOtNJOj/NHPFEGBNH1RP
 3L+zJ3sLl4yw+OwWOKD9hKDU4rzqavmAZ9gRs5IcKP0+V3xOclh9iaYbK+A96i1m
 9AWg9wSWhewUT+V6Qu7ROcso5cDBkYccJHhtg4QDYLDB8pzTtaycCsqNDgSJCR32
 gAvdZKZrw1vTqJKfREUSOoopdREANmq4CdshpJgZ1J0yezjRewtRl81AObWeWFM+
 RRC9doFxMGI8nSTRO/+4F7Fn0KEM6oTNQfuwmOkX1bfLjIxshFjOurugt3PZawt7
 97TiBpLp9ao5+asXgBJIz010IS1xhCwdkdvMhg4zUhzfpqxBNeP52KadBRxHipwx
 5pbkA9kzdpFbEAp37moDCyjuOD1GeljImBKpFbyqIWNbaDm4FybQhUqfN0TwbS3Z
 sMY9Zcr4ppg3cHNRej6D0yXV6uT/Pqlmk+DtYiyq8TOUwvib4UIb/k+FrB4BK7Fc
 2txGBrvtakO+5fjY78W4Nm3UHNHCN4KoxclfSf6SlYQ=


Christoph,

> Add a helper to query the number of sectors support per each discard
> bio based on the block device and use this helper to stop various
> places from poking into the request_queue to see if discard is
> supported and if so how much.  This mirrors what is done e.g. for
> write zeroes as well.

Nicer!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
