Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022ACC433FE
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Jt7VKG/dziW+II8WCacpqvj4Ec5uZNvFXevbha9rqBA=;
 b=D4/30R3eRfQmzRTRc1H+MMKjta6JVWTZAtVwn1tXpFq0caztkT2s7zjW4b4GWto+ZxF/AJlBpXXt
   r3c0HcKxwgbxVJ5KgQzk+14sJLdrtq+fKT64aLYXpiyIvWqplOFKWibbdLZV61Ps1ukDYPCl1JJZ
   LO6QLoUXGlnCCjpqeLvOSgvF9qzue1b6iqopndzBXXsr+M8p8tNGwX1MBJJziZB0VstFdLT3ZPMC
   oMxVSAbJ8rfwv3WQQJJ6Ng5B+CgN0E1xBnJk7SA9c8zCMf2IZEnqSVR6BVjIDASiRKz6YcLAG/UC
   Mg2qbH+yZATCLJI0uU3mVX9SGiCwn1erNdG6nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Jt7VKG/dziW+II8WCacpqvj4Ec5uZNvFXevbha9rqBA=;
 b=oVQOLR4JwQrJ7t2B1yGN+yqYkP/xLCtHQRMLW52+JOmMVaj8IvJLq+5r91XHN3dGHI9Qv9aeC5SR
   351vZ/WVE9g3nJkLoJyOopzfMF9aQTwWTNeTqmiLTxZkWg30IflcoJ6dfCPyvnFSQjeGNSEJBvVn
   KKnDpdNvT4TZp/t614cDO4zYkuo/bxYB7pbwE69GuLZwsR4BlCgiNTyrt8X3TtvWVMoUgTOj7aFX
   0Y7b0wWACLEe/GCiyvppdbvEEcR27S3p4ffNtJW5SuPPbCqccz97/h6VnuYzqvcHNxo0CjCcKC5p
   V5bIbII4I1OQB5+Ub7ngkpM9Cg4pQGc5wKtjTg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00CJS95XE6C0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:17:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hejc02oDRtTMionT7uhL/jPXdYrz1VtvS0qdI7z+BvU=;
 b=HLmzvxJ3wBc8WfhU5whUJ9v/GbVRrJ1KEOYPwaACIASEc7I/4zkLyK82k7nAs5rpDsJB
 q6kd2X7hclSLT04HVeb/WeLH2EsNGJd5G1GaszXPowYZa57aoRVd6nYMRWFrHgcX+Oy3
 6s/UgHEPW8hd/T79ae2hPskB2XTA2N8/zV4yRDCZX0UN5RQ7z/QCF1YjCTOlLujGF9OP
 NldM1Ujfxh6HZi3u2SA90HsqctoR9NphIJmfbD1hLEEnxiGlVZcyhq+ev0+0tLfbBoHQ
 h6tE6oJm4ao9s23m5uuzHuCA/E+zRrIL1U2WQVZa/0qy6WCMsIBA592BxXV2ow2u9cqh Kw==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ab55DKHYF8AsZsvRKUI1AzOC51UOrQqT6ARyF2ZpwZa0liE8t0sCVvU3zTN8iFDoMEB5r0tSjg5XQHuCPULikD2jJAbr/6QhYJxRydB6558KzNtTcqVCOv8M86BI1+yVbi0WZkFKWXtIeu3tjgGm3ZPe/cwR10B/e3N5yKeumHSzzf9JK+fPchgFCjPOBl/lV9I4IvOQg4EoEWKQFMdd9GJ6UE57msoRaqi5Ga845sFoebBsiQe0W21i9olKT5UQjj/x6ADMCw74EJkwlPwAn8sGhdrU3z631diTDRPW1npwG63J6TTKL55r9uTlEv7D31GT1rimczXClypgVvi4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hejc02oDRtTMionT7uhL/jPXdYrz1VtvS0qdI7z+BvU=;
 b=Q9Rgte2VM3DVd70hpDF+orZjSlsNnjmaBaPqyVMgFSL2/0xJ7eImZaM8PBjJ2KSnIGFZpVvNN8nAIUIFEmlqLJI7e1Vba9D5LkUxyoGd2t4zagvdon+hZy70kzl0BjpuI7vnR05ZGG5iLcZVjZGXy1R/F69xrj6h2mWII4IQ2qVAl4FXtsUwFBmgeTcJuGnuWriALuncBxwJEtqC11CrwoaDPiaFCibYVSf9Cw7naxqh0ehJyvMFAQuaEu5VgrkrtdSPVzI2Hiq1/UyVH7fZjc3bgRYNy8NZrLZzQwjmdLmZPvTg8Ua8jBibn/kWbzkNZ/OL+NbcCg5VcASNGATZzg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hejc02oDRtTMionT7uhL/jPXdYrz1VtvS0qdI7z+BvU=;
 b=N4D1VCa0FxZfhy7/g5K+/DRtDOhgtE6xRD+neiC6ihd87hRZU7QZtaVfNE1+48X+DSnqGrZn0wfrABl5rOlu7e2eVcWve/XxBnonOVHiSrij7ewkRddIpf/GQFCBOijyQ2DBkxR/xiyhgnnwMi+IMYERZsnv2Pw+nPr7j5PTw+M=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1sfqpinuh.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-13-hch@lst.de>
Date: Wed, 06 Apr 2022 23:17:43 -0400
In-reply-to: <20220406060516.409838-13-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:01
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:17:45.2049 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=959
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
Subject: Re: [Ocfs2-devel] [PATCH 12/27] block: add a bdev_fua helper
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
X-ClientProxiedBy: SA9PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:806:27::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d6f5c4f-09ce-4dca-6516-08da18452f3c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 gBA+jChiFqGkgGJWEF7KQ2dv8eaH1Qc17rpuQx/4s46YogDjCyOPFYf9v3XEnddPQDJwdgyVAqfpsZaICqLe1FJkoJj90sP7d+jkSyKsMn5fwUdK5jGesCwEV6m32yCUxg+bhWDMN0mXj836pgpoXwMO/cbnuU/cO1vEzrrJGHRa3rQhvviCFh0FlIcne3N8xn9VZnmiyYyQr4jJIdjOZoGTusvEceX5rL4/GYWUfa9X9U+O5aJsxXvYTbWorKD6hp//fJvqV/PP7poG2/eWzTw7ouQuPHqIPGirRj8RSeNz5pMYtZSHQKcd7JcWUnM+OHlvX3eUkEAXMOjNL41fPRiDBGMooM/4drkgWXlTiFGhO77OyAjPnQ4vTMeBYgRhrpJf6ZglpHSE5KzKzD0MlL8a94BFQVlCXswujuXsLxbxUlujDvDfmixKU6MU5U2usRbH+Y9p04dkOUnflSOvkBqYI0PCDct5r3zJnnK6SaZl19tbn3NajPqzF3iJxeX3IkUQlt8GeeJsCzRQF2CfxMvv/CqZzBOyWLmae3loQ1pU5Iq+tRorG8E0CV1f0qskq23v01A+SOS7CoTHmp5Y/mAf0o5CtVNK/8retfhnhqY=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4d6f5c4f-09ce-4dca-6516-08da18452f3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 aBJZRnTe5Kx0LzLVx81GItdPKiCUwqUPHtBHkFL4z2+UkdDsGENVRb/GxmKjyxCvUy2HemVTsPNJYKyuHK3cHqYGwBsE2ihiVcqQWJbOMKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
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
X-OrganizationHeadersPreserved: PH0PR10MB4408.namprd10.prod.outlook.com
X-Proofpoint-GUID: seuwgJ_E7EzjWQfNeEqF7-bPA0dLbaQw
X-Proofpoint-ORIG-GUID: seuwgJ_E7EzjWQfNeEqF7-bPA0dLbaQw
Reporting-Meta:
 AAG/IpSYbjn1Mti4bYSCX7YH1CdQhEcd3v9KmSoxcALZenrPkx2WHRsr61kfh6Hq
 g45EwL9dTFMxxpjcms4aHVQ/wgnjvG0fPJ0GWzJSUHvcY/Fkk+I/oDbVmL8oFpEs
 0Wllg2tvagIn7J/NssIpfEdor7tY1DTC47r3AayRsLwoTmqD9dscI+pCp/iz+CMR
 uKMo0u8D5SYoI3KX6uHYb4TMj/MjPqquS8Ylt/eix9eDRLN1REQiYbG/BaxVlcw/
 ZpSCnLSm6GT4IVgMNbU/KBfGVua2iXF514DVAmKBVJUsnb71grje90vPVotwZfh0
 sgFVUIejA5t1IAt6gRvw3O274F9y3pZDe66Vd9ICoUkjLUTp4lBrHNIg3Fjv4jNg
 ChpJJf0x/GeY4I1fXwRbi6VOCipipp7K7vg6cDlTEvXwlGLKKnS2MD0xsw4xm+PH
 LnqSdWWmy0lTGV64JbIp01jNVl4CmdThozfTKYl8Pbwj+WrUttt9p55NA27wsE2F
 83+/J2tTWkfdnma2SfCPbcpDTGnYlGfGDT8VMoDzEdo=


Christoph,

> Add a helper to check the FUA flag based on the block_device instead
> of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
