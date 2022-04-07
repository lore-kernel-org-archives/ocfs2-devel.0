Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44745C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=USnFHLanibsANF6kRrQlO5v3eJiYdsOULSSUJJltLCM=;
 b=wN2Rlcr9uo3RkOntJEjxwpIxemXTjS80WUw7sv/UfqMNdk/pLcacF31FM5lkovBQZKxyNuiuGM3z
   bugONDYwn2ryV7c1CVgQt1o4Ya4NRWndlELuK+IpEdDBB1kxoTbknES3WLSf8ab2X+0LxuaqdVL9
   TBPigvia3Rj9m001g+7aAuw35abC4jDTvrhamy4hjgIj2QopfDVbjKAbqvOFx6N4erG0gjZRlc4j
   F2Msprl5VhpJISn4snrBpevMECyWkeKce7gaY4R9l9PuzvdPMOEQHicJy1zTcBdX6t8Gnn8yQQoz
   0Cs6H1fjS1uQ2aF42ulTQ/q3OHYXHVTYRfMcwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=USnFHLanibsANF6kRrQlO5v3eJiYdsOULSSUJJltLCM=;
 b=nz0M4UN0I45pYrDW0w4JjKiK3POPhv6hbGn0Pns7/pjabbuInfnxm+hlQeYQSUZ5hLXEBUyoVkH/
   5a3krAf6T6HL2+ek6kg3gDQWyGl/27Zv72xgXW9AvivBZ1IA9SVILhqfxgY+JxVyd3nuObaAIAMt
   lmCjGT3xYzmozsesg9Zhugg+0Vt8MOPBM2+48FNGvsw8ENk6hOF1S3MPQDzK9zU2uiu8srAn5+Ln
   Z/d7QKL2hbRvSsBF1Om7Xn+Zgl0NbJBBNYHjDiaHxEhxJa6dh0ZfJN+QS/CU1floquz3j5GkleAK
   4CI/nIh3TmIASMxUmw19kwxRVqOCzDtf3dadog==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00EL991YCGB0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:15:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/31Aq/ogkEv3D7v1WrDP1er8ISBaDWd1x7R1AJi/49Y=;
 b=fkJ2mbsXZbZ0/3/iFv1zlTG9gEFJm0maqWl06jukCCkr2AnJ0aM0Ey5INnLidVbzeSht
 eXDlf9+L3fzcP+hS32NxnQonQ6Mq2pS2JyyXWG4rU6upIYmgHesXCCyeBw4UIrvQAUqh
 mjpGELWXKLQpFVTUxeLMLabmeSf7uXpGtjGRpVnQBl/dx4ezIQrlpX3lX72A7GUmgtIJ
 8aX1qOjWiZ1wh4s1WZyMbpZvxwvqiqYSnj9NSpDnc0boGLa8RowHe6IR9MUHbhTq90Ev
 x6nQ8TFJ/4GM/IhE5D91uWWUoXJ9KKPTEovSaX75FkTKjv7uVI6igk5wKZ673/zU4di9 qQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUGucES/Ten2MzLFta0wHCePUhyDQcUypwMW3rCOnyzKmXjTqcmn/vzeP7XzMDfmoAkwFC7GGLP8puRbAXB4eVc4S7wKiglj8SrbTQUHZoIWJL0A3a2WqrWPh8ohIOzEm74ScXOlRLVPq0PiEuDYKavAzdH9leeEiOtwuy89g9hTfEsF+JNZBJqXT3GOLR2pdj5znjkNVMvDsMp5OInZKLryPCOLBJQYNZjWPkCutl23S+cAhHRu8+swmUWRVeT0Qr0DcDVnKMsqOcBjatkm/hrKuZXeWPF/K5MpbsfmvPvZDzwxtp+5IrW9t7T2OwxUb+j2m2eExBIzlxymdKjvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/31Aq/ogkEv3D7v1WrDP1er8ISBaDWd1x7R1AJi/49Y=;
 b=Y3NnFdIqj48VyM7oI+SRYW4eJO1DntWARaEn3zUW4VtjqmlsYAGUNNZ9DuncCIwAvRm7kBQGzeNcyY2FGr6PAfnY/53opmuEqsaA226dwuBE/BcRiMTrgp7hCz6SvtHzpL+tpxyWwRqvtSfmttxIbP8u4P7h0W24xx5ko2pESYa1twH0uI4FkV4zw6b65sfsCkzRlPni5vy03li6cNMCcniUBQAXm/+snjdS5T/Oe/4nmBg9fWVx+aehvxyRwSw+yfbZS7eoxqYKC37/oKLsDOR4r7jsgm6x3Mmde6zzj3oerVEyvWBXWAoWFXOaV4Muv2iR63JJWo8O89mtWIpWIw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/31Aq/ogkEv3D7v1WrDP1er8ISBaDWd1x7R1AJi/49Y=;
 b=OPcEHHxN8foGwSnDW+ZL7gJB/P8L4oXJM5rCBNrfJH7yTtPD/OSrEqFhJnDMs+LrkAhUOLImfMZ1EgCmeiL3D0OVKXhDDAm2StKwcelRCve9U3XlNUQoEE1yF3XiObd9stt43JuUKRqV2ftCTwrJJNmkZ2GaGjz27Qlf7tBS+jk=
To: Christoph Hellwig <hch@lst.de>
Organization: Oracle Corporation
Message-id: <yq1a6cxk2io.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-15-hch@lst.de>
Date: Wed, 06 Apr 2022 23:15:21 -0400
In-reply-to: <20220406060516.409838-15-hch@lst.de>
 (Christoph Hellwig's message of "Wed, 6 Apr 2022 08:05:03 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:15:23.8630 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=883 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070016
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
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [dm-devel] [PATCH 14/27] block: add a
 bdev_max_zone_append_sectors helper
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
X-ClientProxiedBy: BYAPR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:a03:60::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4633d708-a1a2-4a74-c466-08da1844dafa
X-MS-TrafficTypeDiagnostic: MWHPR10MB1711:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 GpY57SiI3gJzlcZrWkeyxgpuqKBkg03MfrM8kyKJrbamSAcMIMwhvFMJdX5XoBo2Y3WvewOESseRgpw4y7rA5REMZy1Ck9SMkmNBBntsUUrtku1UAqtADD+1BfIoKQPgWi95Gd2lzSAx90B6snsk8rAnWAE8G7GxEQc9T+LFeRsWqixPkXHRosZoDxAZbYh5zvjGiGvqjqLsaXZ6C1w3iitz7HANSWuxPfwEhV4kGrM8zlLN3+R/WeuU3mxD7g0EUMS+daeQeHdp7Gds9O2eBpBw4nXKIcv/tkeLABioukItsC5zF04VQM4HLa7ver/KozjVlb7qUgiYeJQc7Kms3dAn0brRMl02qQS42okdK7XzEYItYQmeSR+t1kpImijbpG9I7xugWXYhcHg+GYyaeMvhyE5YErP4GBWEGB8srYYCFoxVPvDviH55YToqlDRiXlt8wvQrbGjiIkghpM5RvEbqQ1FlPHnuw8AaEg6XSWmJSXjAXvkSB8sF4vM24EOXXNjhGvef9gVLnZNljfiltZJ6C3PK4psiaqy3RpyyAMQqmBrDLrLQm/ixoj+qhuPIquI2Hf71pQYAiOlIywQFuOa6dSGlu5wPCRtoKsmq5Ls=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4633d708-a1a2-4a74-c466-08da1844dafa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 4rE+Cty+MdB1lsa3xpRQOVZo5AIqezB8UTRn4pi2YZV5q5rlU8dbrHhIEVkj8tZ61PJI35Q7kugW5WJ/ugaefQRi6DJb1C4qHnVNCBMTQUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1711
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
X-OrganizationHeadersPreserved: MWHPR10MB1711.namprd10.prod.outlook.com
X-Proofpoint-GUID: COdVuAca6jR1ThyZ8feEr6S-qNCviU0d
X-Proofpoint-ORIG-GUID: COdVuAca6jR1ThyZ8feEr6S-qNCviU0d
Reporting-Meta:
 AAElbnLnvbSul3NM8STix3UUcJlNI7zGYC5xd3SUGhR0ZJZMpFupz73D+SNgv1K4
 ftk/KDDkyJTInbcEFHUOlt/vIdImxnIaDSysl9H60Wt/UDNWBKr4bMeJC2/OMsWZ
 JtkWAFTUqSjV/1yGWJQ3SUcEmE5AybxvKgYZT0+5OYacaHbnua3/tSzUoROpm3Lf
 NQZ2GbjETfdlVPFpwB4Bgeoy9md6kmeI3P/09ue2PRZ3dsvdnZc66D8XXYOR+5bz
 mNz8jCDbCdP0zTPB6DpmFxahNMR0SY328SPScDvHZFdrhDfs5TqhqW6Op34lN7RB
 wIeMIihzhTFEjCxrLRnRHwm6kTOxLRL6xYHWhML4wxMsbpVacAt60XJJWbsHUIUR
 JXqcF7kBcUK/mV/GCBjxB5pCCPmEXq9HBZKFHGuErE2kmJoZKHdQWMOQ/9G5CJh8
 NHp7brEkrOxTApPJ1699pntcJaym/KkeTX6wzlQMEFZ0DCXOYYTRzeuu7VBCqADp
 eT+XkrvUC7SEcDgc/OgvjAR1u63i9IFxyLiYhcJ4d9/j


Christoph,

> Add a helper to check the max supported sectors for zone append based
> on the block_device instead of having to poke into the block layer
> internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
