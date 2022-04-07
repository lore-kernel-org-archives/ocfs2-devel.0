Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5C7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WLcDYm/ASV9CJ30sFu1QMlmrezrcl9PyHcgqfBkLIHM=;
 b=q7m62iINwct5iW4XtaHVjS2iuYncrzE0q5rzIz9B0aMtKKZnLFL2MhuY9sw1GS0KpAlKGIRds+Wk
   qT57d54xQz6q3zwhIWhA+A70LgyR6KiLrYVLCtjMqL8eu5SE1zYLgRGGckkxHw7aBGmP8xYQHhI6
   A4GGRGkIJQuDet/XVeRxG0TLSNkKxB3BYAy9Qf3S2kDqbGgPegFGYt0PKcPUhuNMuodYKO70+0Jz
   0SIVRo2IvRzUZrjKJ5QfWbQ3y1EHkxJ1IsFIFUFSLX2JA+r532XoIdtKsKy8qKMzEQ/xDMwWH6AP
   6j+NfrquqWDba9uibtO6dnK0k/TlU1LqHHoFAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WLcDYm/ASV9CJ30sFu1QMlmrezrcl9PyHcgqfBkLIHM=;
 b=iGTT9Z142eHqn67dlAM7ombqQ2uo+SPr7L1jPBCITNHD8v834xW+sQMzMh4ut9LFu+sLyLsDYUAn
   Js88DNsaeVu2KHsn9qYlJQa2YTWIMn8L5VXuyE+jPqDOdPVq5kMmzwZERQNEf5JGNmEM85AHBgBW
   j6fSv/d3iDckqQdf4yuPeXtJgktf9Q2qT2do5cDUxF0VW146pfzX84FFftNUuQIrC13Ta8Y3sgCV
   2/Xg0PbCN5xyE1HjDOz6xlMz3Q4KX5Tjsy0cpGlV+CntGDa+xgbIMz5to3fII8I3vYHYnqC4swsA
   TYY9RLAcQrOhvdOUpuH1+yajGu9u8h8kh9drUQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00CG690TE6C0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:14:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/V0Fwxr5Zm+y2aUbPU9s25E9VnsikKMkCQTHQ7fjVfw=;
 b=i5FMU2e8LcZtJnTYkwV6E8F1CmXHTpq432Z3UWXvhHLaaqaB1qLy6grINx2kAbYvfYer
 SN8+/U4jQlO+0tJQjU+RPhn990QZ+/KevL2vFVzK0vh6BtHNWBUaW3rP8TJIRu5RxPuv
 5q2FGGgnsw+BcWFF1Ul8Va26S+QruBwCczAAZMsHEiODM474wY/Lvn/qpjgofktuHQbB
 rQLE30y5Jj2kFRYSzXmvZ2Kccneww/aRTF0VL25SLIHueHK/uGvY09oouCorc2CXAmuQ
 F+gCGaE5kiQpxNaK/oVtrj9/VdkTmpTFEg/S0107fuEBTxgj0Cf4xnG1niTDoPoQ1Vjv dw==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHMpnnKni3gZgjHamJuWK9V1h2agAY7ZBpYXD9eGWzb/+CiLujTNLXJbT1J2PfrEpWpaZvZjRHbefg2aySt2JXoJ1TM1GIPUKpQ8FjG5xmfKnwCbybH+7wJIjhhocG7EAG8y14qIOAhcRcY49Tz3M7r40Uz2x1MJ0o/GxnKtWMtTGfSBbt/H5kMiA/1dUAGjl47cp+NlXCAv4XREqAMK5/K4DODC+vvoeM4V+rGibmz06Lthy9uVvY3+1YMQfPjE5F4Ht3DMN5I5RGoHavFap3X9yImCSXu1/MEgCFzBlTudCMr2iDI7D2yW8pkCgbStmHVDN+6AoXq9LODappaiEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V0Fwxr5Zm+y2aUbPU9s25E9VnsikKMkCQTHQ7fjVfw=;
 b=mKflAUef7k31Wg4IE+ykswDV3BVMXe0z2f+R2+gK5Hd1XRTqUtOV12X7BglOxFeR1IO8JO3BpUI7YrIkrn4odVcNqr7iu4Ag7E4ikF7kS/oiqI+XuMasfQstNO4remOwIeiD72c1fJjaP/jLJAFYtEPd9y/Mf5eFEK2Ksg0vFhN5G4h54/XCa1XU6R0HmZzex4t+U3cBAkiw0Ew0g7n5N5t8ejr+W7UuKdU3sDWVQXLz7Hq1lDZZBbFB89cAPlOYICcX/dMm7ayLdfqHXm/b6A/hx8LwI0YxjnOOQSt5DW856PpK5KCHMsfnPNdpXuIIYXVNNVropYbDzUxb29MJww==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V0Fwxr5Zm+y2aUbPU9s25E9VnsikKMkCQTHQ7fjVfw=;
 b=Onxn5oqfha0H54ksDQJE5gB8asA85dTWMH7o+/5O3ZrP+lKhf/7qKyVy50KPz2EeGOf54PYsUS470mJl7jf7JJ7aNNM5tFeVWGPNmkgH7twFnQWoAQtc6AYZPvZamNd4ljQd/ZRMm75Hz2KYYSBw+tRmyoMcX3LWFlbLwnQoGRs=
To: Christoph Hellwig <hch@lst.de>
Organization: Oracle Corporation
Message-id: <yq1fsmpk2jw.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-4-hch@lst.de>
Date: Wed, 06 Apr 2022 23:14:35 -0400
In-reply-to: <20220406060516.409838-4-hch@lst.de>
 (Christoph Hellwig's message of "Wed, 6 Apr 2022 08:04:52 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:14:38.0462 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=907 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [dm-devel] [PATCH 03/27] target: fix discard
 alignment on partitions
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
X-ClientProxiedBy: DM6PR02CA0103.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd16d686-cc37-4a76-3d91-08da1844bfae
X-MS-TrafficTypeDiagnostic: DM6PR10MB2698:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 FhpogdH0CVxlLPx54Xn8tgjrtpEvg8r74H6+qmYxgcea6vnGuB2WT0guW36Cv2P+sxGsyqNywbt1OFS+NBtRVuRm9UhOIB3doySQMNB3ImolMIfOtXBHP2rnR20RCCA4zGTJb52f1I9rzNEKKmmgvbvnmJFcfItKLwSoPaINSN9aTTjJmS+ZoXuSzkkeqEWGplRnCB+RTvUsm+2RCeI+2fNPM0xUX0N6GCFCidX3rLGr+ycj/iI2Xa1v16+K791ThYbv0B4g09AOKXNS6yrYNm8EQ27WK20DYkeTMcyNYK2kTvvBsa1gXXG0V6C6VNK605r+oinmYutBdiju7O+GNj7I5AUb+9oHgCI+Szrl0ig7plaKAXTCD6d/A6LpVfl3gOpXPsOGH53YeKpVhNvz+QR9TJz0Hjlk2pfBL58QW5aEemJdavOF9qKKOMxIJhKz9Ywl9f7HF7bxgqLbcdyZaC9BdYb0mUGlfvySLc4w/iSiaSIi74LJQZgVN1kIHs4SI9B2MSDAzoBIxohVwt9wPvlSXymlPTgEBsU+2ueSzA3vGF+fj7X46de0WhYigUFUWxaygfNSUy+RGHqQHRFe+BjWlHAVaEuI9fD41Up6f6o=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 fd16d686-cc37-4a76-3d91-08da1844bfae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 xa7XDsF2TUSmbTPOLGTD/Asj3pN0wQx3E3uvOsKaxFNEGn5p6T6o4mitNxIXls+I9gNOdTohIBjq9Or2InsQZNGmqeEh2TEB3f7kd9F/mXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2698
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
X-OrganizationHeadersPreserved: DM6PR10MB2698.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: g38noBEthgErlBEBLbGZYEE21uhy_x5m
X-Proofpoint-GUID: g38noBEthgErlBEBLbGZYEE21uhy_x5m
Reporting-Meta:
 AAE5JQcbrvkHqOvmwIaPC7Kg6YE8aPA6DTFuQGR+D1pdofA8HLzgY4GQD+/T7ryI
 q6wG5/9VO0qcRrhU1T3SvO1M5k1lHF4CoDDKWvZkCF8r/f4V0mpQf96gSa67vMHF
 pvyqb3RlgoVcmC6ob2sl7aGUBIp3ggQHJqNLgJMdvLxvIQ6zZnjaoxThOEAJxksv
 Av69OGW7lCkgd1oiPfaOI/Zcl/pawIpeFTbFaUwIWjXyFkZphQnsSYQvHzz+e53l
 Tqneee/1bUYro0cL7rO1BA6BkV/TkZTbet4KMvG5xxHwgSud+Q060xCCiJo0PaKw
 JbkTnSTjmzccRU612cNt8Jym9YDtSOqkXOS7ircXyYiTX/bpJuEcb/6LImsYlwz4
 vAMTXipnAeUTPD53oAkBz3HYB0VGlrkFgE6Q3Cp7UwWyNNOgnyocxNz30NFlg4SL
 1b1YNjc7g+UOddL489SRBMQrRBDWS4JArDaj7o5O83eMXqFvwCgMLYk/BKLtaQ0Q
 Sc2VW/wKGkLjZYp+m0QHJIFkVl33zaAxQMeucr4c5hxn


Christoph,

> Use the proper bdev_discard_alignment helper that accounts for partition
> offsets.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
