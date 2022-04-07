Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD29C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DNJukxIU4EhJeWcIcyH6eU3bPJBKyXDWE8fPhmjdMYk=;
 b=NdBR52AjWp5effvmc7jxRr9Hkyp/qCZ3IdvEpHMrFD00q34IQ5Cjnsz2zHnEjxmf/YqjQBFeVFPg
   +BuYZZ14xc6vafOpDNdv+jovXpo4TzhZq+tArqGZSu6WBNiL+9AZYWp8LvD8+iFdqMRjF8tJS6Uj
   4y5zVJwp1sy0QqtHrrbnl/U33qMZun2LK8oTVJw1dwRErRfEg0ifGpuEkpyDy+tnpfF/brjgOXiz
   jVTOxstVYy0t34QRCBdikDydzMONn8unJwsxKjfVTnkWCknCmvK+QBwpopnVxPbHLPiNBDLJJezp
   3fdkwCzAP2eLmr63dK9YWpB0pzHtf1Xpjk8zYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DNJukxIU4EhJeWcIcyH6eU3bPJBKyXDWE8fPhmjdMYk=;
 b=Z3rJwJ4jmf4NWo32HDBSgleqS4nGpn+VC78vglCC8+g8ybEH4NB7FwPSvJqLDPIjS5tLkCEAp4B3
   Oz1+ncWpbLsgoEhwG+RYOJbZ2zCpsdwRjDKUmtuHn/lq2CfBZb9TSqxfIyzrvx+O6h0k9qrXyq+z
   2QFBRDiWU6VhLboVBzns7DzbzNGUeCMIdOse9cIoXCvjY7aDwLti7YC7YFTdMWIBcCH7Ha28Pfsw
   1CEn/ae8awNX0SWJ2z6x0MXXjZQig2NmZ6kNSgRfsimqUYQ8tQcaXZ8RYveft3Mpc1Yq0eP7XElj
   yFKMB5CA8KiQtiRZG5mxUDNLtNwtKTrNpOJ1Cg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00C6T8L3E6B0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:05:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YsLEXwzHHuhF8Y2ubKs7WB5IRORi93e0Vmn68Bi4rNA=;
 b=NfkaK2NCMW3x6JiAe6CyDENNOARvHDPb02I5fwoWxOu6QfcjwiXHY8Xrx4mcDWkinikI
 6y4iSHee4zyBe8QJm5tGfgOkAj83SF9OykxjXn7vNSW2mJgWYrf5/fUSzDfg0XfmCs1J
 +oAbW8F3tDhDUqTy+eCamQ91BX21vJ4MJB4EGZR8HynPhZNqhlYoDA/HLfQDBP+Bo4CR
 x9rTg/eQ+/XOfhq/Ik5Mn266beB4VlXnYt6pQZmsHu7vA+BBuG6FRivVgrT/mpZl+pEH
 mlVBoOLNp7A97wLDUSOK5yHa7XAT643O9e2NZAIcfD0zc10YNOs0pYfWr7nlIIE2mlT4 XQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+a7tflLN4ipr4u9JRNNOvO+9C3u3LZNg5SLh2S7T1zjlcpo35MqjIp1GkSCwzilziodg1xxB7flG12RqbeuCTyTIm0sCdaa6E2rSk0TPvsPV3YfVsSloDqFCqdyqAGxnNDusQqvjrZBf4ZZ+NaOoBnd1EhcO8hyfAUf0g5FffUjB6wlPSocA9W3RxJ5Z3wkFoMSSva8oBZd5LoC/VfGnQiwhRlglxXaupvyeUA+sj7zHbI8pvBuSYPKDMZQEEzHVlv8mowO0UsjOwq/IJDSPoZU9SUp7EYwSybadklZHDnWpI+WCmnIrh1UOqntyoF6Zi1mHyVYsFsegT9KUg/XeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsLEXwzHHuhF8Y2ubKs7WB5IRORi93e0Vmn68Bi4rNA=;
 b=bQoEkots1pxN53fG+rRXYSt8gEzclo+T1olSPR3BkipGeDhrT+bCBPf6GPJGf1j/LCqwlvCXGk7HROmvJiSgfVvn39IvNPYBYGNE64HyQiDY4+3jS83m4zRA1oCx+WsliYmakTDuXbVbB9+oIrvCcc/9TJYdWTkYGTGeHjua160BRaI/4Bbfw/oCCoK1niX9DelNT1PETokfAD/xMTmVaO1Nv4tU3ku+0NG+aI/GqulViXrHUg8a56bwUUTUVbx10KJ2ckd1XIIDy+7/aZTMF857gjZ5RbyRpT1XxRG0r1NL8RAWn80Z93aM1sXDIzB0+W2LBACwHd/Kvo6vKNp4gA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsLEXwzHHuhF8Y2ubKs7WB5IRORi93e0Vmn68Bi4rNA=;
 b=pdNVl3O2r9iAb1/lv3IjlECQUU9l6Lb/Z9mErdB2l/L4Rr5xWZdJoTC5fUY6S2pX8NKp0bbvViujJNWNvoRVGjkppkCYZPiNx76KEcyqIsjiGuDwKPnJDSkHaT8Z9a6x42rg+dvcS0IIldzVS07HbsRlKVW7izdU4OEt+wGEp/s=
To: Christoph Hellwig <hch@lst.de>
Organization: Oracle Corporation
Message-id: <yq1wng1k2zn.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-2-hch@lst.de>
Date: Wed, 06 Apr 2022 23:05:13 -0400
In-reply-to: <20220406060516.409838-2-hch@lst.de>
 (Christoph Hellwig's message of "Wed, 6 Apr 2022 08:04:50 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:05:16.1549 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=911 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070015
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
Subject: Re: [Ocfs2-devel] [dm-devel] [PATCH 01/27] target: remove an incorrect
 unmap zeroes data deduction
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
X-ClientProxiedBy: DM5PR07CA0068.namprd07.prod.outlook.com (2603:10b6:4:ad::33)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 446c5253-2f86-4e5c-b24c-08da184370bf
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2152:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 qLB8Wf3UwOpgNTKWtzuyahya6kMvMPS2V82aP8/odwYU2Yr/oZfQevn3jHQaAOLHaNvEDYGrEAyRJiqZnTmAvokSAs03Tz5dypv2NW5nIYnL9B5ReaOX302tmyZ+6/Bk71NbLtnAIH4A9u5joiBC4CcC6DsNZJNJoviDy2dO9ou9ic0lY+O3ILA1zMP11tYXeMSQvZm2TZ1Y7qW8Gg7QWMSlEyxf+iuA9Puyz1iqYTZIdcMLm+di/D8y9Ui/Ijtzs/eeoBBbZueNcnHKPnK9kL4mJNnKCXYbH64cXC3SE/M/JwM95Z1ZXpeAiHeUOgb2U0F8FJlm0EUjFfM1svjzI+kXzAgcX9R6BXEjwQL2RdswNRYTDoQj6klPWGjNcheC+eINQ0jhMBw+TiYqemHl71J99QO5Zp0+IntBeMJPokUdZQl/PGON26fdSSgI7w+zZmfGPUq8ny/5zl3chZSUehFD27NtXYJ0piSprNMQIghi79E/hBfUsvOtnNLjFEr+doly9zpp/HeMrUHE05iFX6/psSeSiw5dCmZM50En1/bBXD9EAvgz4faKT6YowdmEdAVhSHoBUQiOEobvVxRf23eJnSJ60kRC+m4m/IABtBc=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 446c5253-2f86-4e5c-b24c-08da184370bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 8wd1AdPWpIjcCjxsi2pbd+ciWqzHOAajRxs38iCvhynb2Xri9DgaS4+iigUZuPE6wN79jbNBsZ1lsFi5zU6X0feZ+MmPZxgDmebjEXCo6PI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2152
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
X-OrganizationHeadersPreserved: CY4PR1001MB2152.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: pswP59MvZSesmtZHBnFhhxfdnriuwRrY
X-Proofpoint-GUID: pswP59MvZSesmtZHBnFhhxfdnriuwRrY
Reporting-Meta:
 AAHDQt0tHTgrMViuJmc1MPqvgPzdsWBmdemyIciwuMTvV5bRvY8clzNrlkdY1eDT
 Fhkn4w10Xjmc+OdJmh8h2AB06hTbtQUJLu25S5Jv2Hx8Rzg+aIj1Yel/2RZIt6m5
 XeKCjI8jCN6o0WJ3IwRL79ZMZQZ1eZa++1Mfed19EWtKBpX+cHOAAEvBjnvQ8u4w
 Ng3pG/UFi4vGw4m2qTn15QgQM0DZpEQRHO5sTtyQRaDmLGrAyUg+/wMJj9wKIJAs
 ztWp0igMMTsibpHoNfMQZ2UPStsGeH93lrJrWrH1LM4BB+gqA57XS18Bd7slws58
 V1u6NeRt7pBjxoZs/JRhDkji1eA7psZYfnOaAFkmvyQGOBBozNmb9DOgAYcjZ/Xa
 lhMM9qvEcFjCPGNqt/L8ynljVgtq17l3xNtEVp0UT7G4jsl4prsptpAgT2WK1tjO
 cL0sJIFGtHcq5NtJa5lLGdlH+pXTVS66JsgftF+2FC7cC0VD4XcfWlkBQhiOVlL8
 d7ggoyaquEvQQM62Unv9VuezBAXnTrJ+vhoCHTsNXw50


Christoph,

> For block devices the target code implements UNMAP as calls to
> blkdev_issue_discard, which does not guarantee zeroing just because
> Write Zeroes is supported.
>
> Note that this does not affect the file backed path which uses
> fallocate to punch holes.
>
> Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
> Signed-off-by: Christoph Hellwig <hch@lst.de>



-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
