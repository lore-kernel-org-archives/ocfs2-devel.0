Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76B9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MWyuhwmNUxwdm/61q8uDWPCBM3xzwDTtgZDsg4SI1W8=;
 b=xU5C+QXUNGq7IAI0LSumIEzy3eXgHdzomdx29Ey8zqdmnMm0DkomQYIHBok8TlFqwIYMTJNX8Brg
   g0Ugx6nN68Jw6FevMamVWDkGY8ZSc9CsJIQdJt8Prns8xcdfdPXmV5UJUVcO71Jy4jsz6loOojER
   a3XcZ2FJfqIg3hjovo00TeudNxRehdrypMdTu8tTumWIpIDbevJ1iZWBLghxTwUC/CzUMcOYmDgF
   l1ppde8ZDBli3msXKndcafaCtfi8pwmxXxXnUd561Az1CrRMdz3Sd0eotjNMOza6hXjnOCe4jnAG
   F36ASk28HoU8UX6RxF6L0q5rsPTx7I9VSXXdhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MWyuhwmNUxwdm/61q8uDWPCBM3xzwDTtgZDsg4SI1W8=;
 b=Jc/hErYLtzMPCQ6XwXZpwB8d5VYzFweR4m2t1kjzFBsTBUkxkkGPN9kSS+usYjmMW5oAD/PCFEQN
   1WjgPV6GkZm5AU7YdraX3IkYiYOHjCcgGWReG9rIstRUHplPH+zE7lPBroLYtI6KMRb0gPRkOUVO
   uyv9b8CLNXbm9r+Q7Nxng4pIize2tc94ZW5tDp5LmFWLu9aGpeD/sEii5jTmuken3KkSBDahjJcI
   ZjNGNJrsDZOjWId57JAeaswPP1y2WNXqqcrZIj9Pz3aGiWAcvD5da2VQ8kqN9idwiRp22z3KRbwO
   oUyNgHB6v+plP/7BaGTTGcFlo6D8Jgss0DN5ZA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00CKI96XE6C0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:18:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4R18pwpZs4MCAT1nUpfEebB1dGvjB+oR2X9XNPWO4p8=;
 b=K00aU85PLQqbvLtFWFoJrDU265LTE87Pk/HdBAP/k00+nUFnbt0HzC28qXULort8/5dT
 0MHpiTEsWCfgWIp/VfQe9wiWPEAirP8mYmfSrg47AbJZDmThd0V1PsvRsYi51NPFYNvr
 NP2yLcU3EOsB2gWzmVP8aRKlbSwElWU+lSbkDiCvniySQOstZ1VwrWhBJ4RcKNHPBxrF
 V58nasvrQdpQg2m7CndmhycOsf0q09wIS8eq6lycZSkVJxROXgRbjAvJF9JwSI0MotNd
 lbjdKIs09wAmCsCRIasNHrHq321KOUHGDNEJaaEZd2owY8TuK0k2deMmuCCqk82rG8Ea 4w==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA9H8IdSG2tR81MxZ6OiJVpjgfM/Y4jk6pqbuzPmDbyqwQCZ/l3XUb9t65rrTZYSuRA7dplEZt5zAMYJ2JtrNDdw6v7duU/3q5cHQbzpMf3U+7Os0weDgsaik3I/zPDC9AkVF+/l1rW8nV3zCGcVh106TnTrOvmeWElz8IMnQa/4yMhkdtKXz/8/Qf4QBUc90uCuFDm3+XieWi2gWjdGzl0Sibd8oheleyP5IZ2ANCZCz5uAkYckyO0RsSGu/TmLH35/2cJLy86ULl9AkeasVLMUBakd8agb8GvPWd4DJ7bkP52ucmE08cqbcrMKhBQSkI9vnZddp2YUwkg/+3rZMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4R18pwpZs4MCAT1nUpfEebB1dGvjB+oR2X9XNPWO4p8=;
 b=oKEaK4sQT9yUJRq++ITxRwlUJzQrIVUlQYJEZuoelk4cRTn0iMtWJDCw/RbclabQsYQOehJ2SGeNvB0SBzUv0n9OHFOHD+59B57DWlaSxnvGgJUmMu0ooWrpRCtbEIIDPakMiiDTb41aC+9QyyKELxuIL/vDFjLe1YWNSaGMOfFbpJzaSCeiIULDXUcea8elKYSZYllbQB8G12gCr+4ooltGPYyDrYue7BaBtT+RZFklG0xzpXZQMRgtp9KlXEMx7bNiRFTdgIB3iNp3DNEmv1cYXxhG6xOWbl6I05tPtiaEnyQaHqp6k5uFJAzt6pWgPcr23SqenjgcERh0tRclLQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4R18pwpZs4MCAT1nUpfEebB1dGvjB+oR2X9XNPWO4p8=;
 b=ypnS4WJav/v7E9xe2ka108kYXAEuekzFuoxDOEIhomgJp5SdVbOEbmOG/Y82ypVTueUCPgCJrPK7DD+OV6sWwWHnbP3cdp/Gjb2i3f+3LcS118X+L4f5o2JpJv6RCV0UcmGN6kluT2KnQXz4ZcnDrpPUrBHi9XRje0uZM0lIuh4=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1mtgxintf.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-14-hch@lst.de>
Date: Wed, 06 Apr 2022 23:18:21 -0400
In-reply-to: <20220406060516.409838-14-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:02
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:18:23.6582 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=904 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 13/27] block: add a bdev_stable_writes	helper
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
X-ClientProxiedBy: SN1PR12CA0078.namprd12.prod.outlook.com
 (2603:10b6:802:20::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2ad1994-3c3d-4e6a-83b6-08da18454625
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 f2v/6B+Ka/d2qZFXGRnchGUqMFvcgOsqWNGaNGj8D5tExJnYv3e5jafbjf0BlXQ4y11/kNNeyhGR1mOGAMgvXl68HqlmGMVAFNMXtADxGkEgB3HT0uC8Sj/8maf8yJ43RMw1RhjuEGmnycQi8rdHsPh5sSM96rO+M5qTmp8s4krjyARsfaKi3c4yqvjX31JZD9QG4VycIS7hMxErd1nLAx4EonxpvFRJX3j4EHU0bbl7Vx3GdWXl3fqvkeI01WDEiW1hubvoEFGUiPq0GmGjTFt5EWhqCeG8A5Wmj2VgvwG6gbMJOhbeWtTY7XxIbut0Qj9r5LUeMe12QvMySPv943iMlTKpn/C8O5T8+vGqe4H/vcA1u/+Dqq+5w8J3Cjn0ZWJKtLm2BQuMCdje5HfApymvTJ1Ecsl/aoVxx04hCIqAvw7jWVdHhzmptPcoiWr/ViWOK3l2piWuKVvk0a+XvYHu69p8esXEixr+FPTEXckNWSwAU3bMYeGp4vrHgwRVUjFDcPI6+FaqDIuwcMTjIg6MSCdAAVNNi739twMzJQs1TD/ha1Czi0PMbW77VVu+tNJhMnlCzcqeZHQ9yrjlOS4FT/IM3olqXYJvwN2Ju+0=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b2ad1994-3c3d-4e6a-83b6-08da18454625
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 hZ9wn6/Z6Gqa+JKgYT944VbgDZ5imkniqjRmEsIQ1javdBvsN1/Na1raINqCIDzfpbrVWYGXUV59K401IhUHeyecdeVGfgDhGALhkfADxIA=
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
X-Proofpoint-ORIG-GUID: u6yMnyrIaJM_x2ZdyNuSojAqxFtoLr7L
X-Proofpoint-GUID: u6yMnyrIaJM_x2ZdyNuSojAqxFtoLr7L
Reporting-Meta:
 AAG3TATChFPcwzv/2opt1CAQPxPT90uQCr/jb9op470r3Jouxf9/WL+HlcTf+s1t
 AwY3HahRli5Ra0UvAHCa3oB6YwzWfuUN94g+cFnFFEjbjOzPHii69sRa2CXtVa3N
 x1eM62f9zN5TcNZ50qhQphvCLtrAVpbIWo1MTMzvgZGVlJYunIZLo58Ey31VlKvw
 bIUyLqarGr+ggmTBiaPDNoFueDST/3ekC82NCbSSP6A4+Xc4ZPpWp/tPVeOir4Dp
 dBsFfHfnfQ5GX9Z+W3XxECoIsmmHs7KIUZRkQ8dXlGnmxyX/EewJAkkdQ9GRlITp
 y7teCgE8JOfxijwndyQGozNZClVRKpl1EDGCypiHhPQTfcXyBMZK6G3xbPaBcxOH
 ViI1DhjG5cbrL+xov69//Z4c6mBsT0m8VRYek517K2i169B+thCUUa/uOz0eXYAy
 OjF/VidgBu7J9RvjUe9krP7cWOsm0V/CBpgzGXj5NUU62EmZ8YIY28tO80mndm7a
 hgAxBu+EridHKK7oLYtTd4eprJblwtULcpdZaSjvs6p3


Christoph,

> Add a helper to check the stable writes flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
