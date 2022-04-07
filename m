Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D71C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Y1BnCzmCFHuz8KJLJKxXEexGYZyVlEdF1Os3YGujv6w=;
 b=eDEfuxECF5NUcbnBnT1nt/mkS2Z9k3gr6p9HwdBbF2FY0MKEO/B7vZbHj0OB5cYn/GBloLc87yVu
   qa6UOHTRypw36J2zYthNJt3XwOBm+COwXSrp//wrupwIfLrK6eLfZPFfZICL8NcN8QLF44TVrU2W
   Kzy1pOrM1OzQmVWJ3Slk5ymRSBKrZ91gibpINpXIp3R+YwKvUdlr1rkZcQhC4/88ojon9ac/xQRn
   vUaHNdvFxERdfPp9pgV8vK+vF8xm6W6qqw4DKa04zqVhaGRwzaI9sRZ6fTWE7cVR+4RAiqoEqTkt
   L+sGQVl+iL4TpDSZ95DLcXohRBnufkBmQmZOow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Y1BnCzmCFHuz8KJLJKxXEexGYZyVlEdF1Os3YGujv6w=;
 b=HP+LhnRcTPr8z82N4EU6CcJioC82L1Cuk07LOWyA0GbidWNf0vGCfqsmSjSnp9UIfNBRlNmGyd0p
   4EfvEylK3V2xQ/BUEm+PQ1v9jPXHmP6y4gNnYoMJ0E6H70L4E2se+XQPGCL4Ko4pk0ckT8xzOIAt
   JZKQEaADKoOv8uEOtw+04eBo1QKuyHZGA+HnpadPyuMoiZLc9iAGjFg5M49rzLgBAwsgJWVwCi8c
   xTJeinRbE6cu8mXZtTKWdIceXL5cP4ankOonrAFbjQRbEM3Nq09NOPcV36rNjetna5vxS5bGXXAr
   NbmCiTZVppNLBe6xMvJOTliYGAKSZx89zqvVZw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y009CS9XTG960@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:34:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Dhl90G26tVGJN6+0kzY1Z14efJgXppesGyE9OgKXAkk=;
 b=PmWQbEvT5swaS4vnVygPu92hJ8vj9PPRJ35STBFd0uTjMDBtw30xhHvAiJruGGpVwLHx
 ti2/8OaT253Rw0q0jzCD2wpbGM3BMDOFI7D/udzPEa4HSjqaeXyQag5ZE3xeO/dX95CU
 N2FMQ7BsIMJyIrvO/Xzwub/4DYYUneLv17TqrrGGBhssbQHb/hJ713GcdcGwZGtx5zuE
 3eXhwo6t8CtBWgTHg4Zcg3CTGaNd/mzT6rssskQYsimiO7iUoi93FNQp2FOV83z/seNf
 8+2eoefhbeNKaoMOCxk6Zp+fwGSExFkW7Ur+QewXYs6KWMVcbTN2Fw9//5ZNE+Pu0v2J 9g==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od8EUXsyrrcBWhr8v6u6g4gbtVOQMJGIrzoioMtAA4xYh0M2CQj1bqYdfBT/UzGG1viSQh2lITSXnnxGhEycPkZhou8vCEL6vSTsZvfrCQz3V7T79q88WenvesLprB48xxD7ifl+emQLz+q7YJ6OS0eTE8u+VxxC7pP8uck4sPV6G2h/Qcy5L585Vm0G4G+L5DVCQmFStZ+AaUlwTULCaG/biHt/Pn8V8ddNLoiql4PGTLglGWLgXfwnLPGavq0nHMeid6wa9z0TVB91rFHxZAX6KqqEHDpyZhMRQDC6wUfukqDUIsrMUYI7SjmMIQ/POe23TtAIuoGZ6x4g+7/6/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dhl90G26tVGJN6+0kzY1Z14efJgXppesGyE9OgKXAkk=;
 b=W0xwTZAzA/ohAkitkI4qpV5zd1PsNyqlVraF0w/jwMhRRsemqmh84dzl8/yZiHXhj2fi/Bj6LUKrOXRJJHZJfUrWYnbfl3x+iwAoY5GDqtCrVrnAsJStR5yA3rjgu/rZxakr3OmHDSw/uypaf4mAuQQrcCc1SgENCx0MrTWvrOQy+EfJYEE1a6xeatNV1X4JEhGc4vSaiFpzoj8Vb7oZta8XX9/gxXgcclCfhTxA9+Zt3PgFt4y9uHOzaHQsDTPrabcA9YR2Nyd+TqfL7PzGDoybz44l9X2VMwRihQ2B1UvRnmvIpceVbohdy0VzUsY1OzOItcK0u8+yUCcw0HEUNA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dhl90G26tVGJN6+0kzY1Z14efJgXppesGyE9OgKXAkk=;
 b=N/esfDTinpovnMQbSzTxkEI9GdcmaK27swuwL7tLeTM76L6jnu9GH94XI8jiZUqEIpHBxzyzgfBba/xSV1P9b0ZG1fqUtEPZ3IZpj7y2Tbe+bPxUkC7R5WlSyEnpJYxjskoqy8CSueaOy3vkOqY69P/rL2BIFtBVrZHoZbQ4iuE=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1wng1fu00.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-26-hch@lst.de>
Date: Wed, 06 Apr 2022 23:34:27 -0400
In-reply-to: <20220406060516.409838-26-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:14
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:34:30.8111 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 25/27] block: remove QUEUE_FLAG_DISCARD
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
X-ClientProxiedBy: BYAPR01CA0045.prod.exchangelabs.com (2603:10b6:a03:94::22)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d446413f-1c36-4dd0-b7ca-08da1847869f
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2200:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 l+YUOXROV4QidAAN6O3k669MFd7QItBIngBYl3sqSeIhjaUtcTk3GjfphFvSTRN9hvEh8kc0EKG4YQOEqVHlHDZ3qP9sIcFFpHF3Ap2BJR+8Y4jpXKj1mkLbEGUH3WvKjAaXsUk4vQI4177rB1A3ORvFpRaEpmh+nWx7lcTfYnMoAgNSsQyQcoMUNefQIYIKrT3ecXrQdDMUUF/TKcdaqCYei/iUUtHcqoBXpbupJ6CvO+Q46+dNqZaHdq1FgVL4GAKNvC0xGNRkHd31UP3RqHzOX3YSxBBqaTthneGlevH5VcS8AR+szO9U8CKNwwmAlnh3m4UckJBTXiEMVkvzm+b66SsvbQODpxRQub/bGgCiYmcYow3PuhDV3PizQPiz+ZjsclxlLEzVgZou37HvgityWj8hy8Yug9GAq+7Z8ncorpX3NWeXRD+rVS63DJ/XuYXIX1oMOt89Ob5y3AS0T+8K6kOYvAkQ0rdqKOQ8tPExH1qWPmbZfdxnZf82TWtLnLaxZM2Gagcw2oRU1gsV3uXxn+JhAqyu+DBYpFLUjjI5VLmtQyg/jwEDUn6vQ+yVGY3t6zTCNfbm6pRwmpq4MU4YmlnhflvqKZv1Tt8rTQw=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 d446413f-1c36-4dd0-b7ca-08da1847869f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 qi5ZBTiCMEHI0hzCpuN8Suykv6oircyOFfbm9FhjnlsASopNs/FgELDlEAXqhXKCWz04v0TbcTa07lyOWMxCueyQiz/XeHZ45dT9SsSwQvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2200
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
X-OrganizationHeadersPreserved: CY4PR1001MB2200.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: t-d5O15mh7RPv4Y7susWA0g1zlpRNQlv
X-Proofpoint-GUID: t-d5O15mh7RPv4Y7susWA0g1zlpRNQlv
Reporting-Meta:
 AAEGUNGwM6r36pop4WPIMGWIlVJPTZ8ITWVXDOMcR1xsNzC8ipnKwHABkDaFSnNP
 bhu7VD7vM56elIC/TCJIPKmb2+lRdIYRIyUYSyZLANhMheIyrf1z4vhQ21CAI7yf
 LVNIdoX4/WuUCuJE4TMSX2aw3ji8rhoszC3M34qfC6E8VG47MmADRWiiy0XW1mwk
 5hb+8vXIludgfmhS+T63eoVK/iLHiHmKnii/s9nc4oQ2HYs3/AXsytKYFwP2XGQ3
 Bu8rFjRIy/+X3GTu0N2f7quK6+UohUTw8FPAepJTaDJCEFUVMAnHI0jSfnWDxRMI
 BpZ2mHaoZq9Mbcl6WQgDKzx1b+RmbkGAZkAQrcJhGk8J04MB9J9Fx878CyW9rHH/
 C+/JGr3l7L1RDAGQMKK5LDyNGKaov+tAAxyLebAQDTDIGbnULHwbwKP1Sy4gDc2A
 UYMztUkU0GkMUgjuBlH36GqtLzgYPpripVp46DWigNMcECedJ2dMtqFkW2mJorcP
 O1LS6EDsssizfc4XYOGMpBhHhDp+e212WmLApqisZkku


Christoph,

> Just use a non-zero max_discard_sectors as an indicator for discard
> support, similar to what is done for write zeroes.

Very happy to finally see this flag removed!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
