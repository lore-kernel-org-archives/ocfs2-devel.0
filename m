Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAF8C433FE
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yVxMkJQn/6EzEPyOH//X84qiv4D3h32oLYXyLatW85Y=;
 b=DLVsUr9WGE3RWn+udo5F49CBO8Uv0M8IrE+UozNzSl0/FcH00GeXKXGCbDz5A/G07GQv5FDH7Nu0
   eWGM3+pOKU0rwdDmx9+DmTxSyWiavpFDK+LSDgObcYNX1j4HwuQZB5wS1ACre2RvY6hDBq8AkY7x
   8tE/+fz6a0InnZdh3a8/YtNCBnKRR38+ISSZfYfO1o/ZOr/vGPx9jH2dtK59SIPn3JvH1YktiGj9
   pI5C1ooqMw1jW4dLqsIZUq5isjTUOMjY2wVJVlbman6hXsiF6zjBMxALmAdCSREC5yuizxkWLlQ4
   TQlsWeFm7Gp6ITIqPZU2dWIDHy/mrxRtrn65lQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yVxMkJQn/6EzEPyOH//X84qiv4D3h32oLYXyLatW85Y=;
 b=CzD0QrHBGteOkkLpoSI7MBm77Dj/yraZiTalDGW3oTXDL/5bkwdDTTTcCbWN8MOPKAqrRoI1TToR
   YjJj9O8K5zz40sBKxIk2etwgKZgfXFM99MwEsOrfeKiQzOtoy6eXwsmFesSHdb5J4jmAa5lBgake
   idI8cZjSq5Nxr0HWFi/uMMKPhyt2t38Z7Tt6CC/NmOQJTxNcc1ziVW4y6c0dSG2WcCACcAzvgDAA
   8tmLTqnaAM7XU+H6i3YjPQK8HrFhVqR/M+SKKeUGx8Kr2dzkEenISR2hZSgPLwZv7I/bMEv/P5dx
   eTCYQCFmmomLiLiDqmnWJ0FoyKLYnvjtI+sQGg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y006MJ93RIL10@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:16:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=W1WqCICKHnvyvIEevFUyUtdGDLu7sKYBjmUGmhlgDFw=;
 b=Ijw2Hbs8JlfO85BdJ/ePlHYrF2UCKxnJLItzdWFviUalxElI3wDrwqjNlyiB7i84rddJ
 LFAlhUCGk+g1Qiv/GNS3oehC3qPVbzzWFH48CUBLJZLeqKLmA+nzGF7CFwDmAsCUR4DG
 g6JzSWOAHIDuyYwrXKfwzYmvCgQPE04R/QmdQSE5q8GaqvzJ2dfuPVDQJbClBaWJt6Uk
 2yQut1Eh7TwRv8dlTTuLi0zBfffH50lZT5l7pAWvweJY71CPUr12IN2nu/3nLikq/61m
 UYouBqsKJVTAyLHMoePtKdZR7LZbm+/1Nb4FYlCom29laVhilgBW2d/i+YxuiSCaoVLj xA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1O5k+QbXI4flia8skUzGRS588pzWmQOv5nuFNfwRlWQwPqKLSAcFI4DMe9jqabtUBizFLEq8MFtcti0/ItLlNfLVvSNjYzhNUrd1sQkowyGUXt0Zy2JioBbHnQcS7X7GdiHv60Ek83GtrkrSKWY0S7rsA0cueQquTs5jEaUVvgDOH1Ucwyj5Kr5LhTdp3eGg2kJvmafbywL9DzaGI2Z3n1dVqiSocFZ++mlLTTKhuJkViajohOWPYifM+O4fOrPvvZsPGBwwCu7ff9xuLbcJ2C4mmbVSJxPPHAdUokZKuzqrPF8CCYhfuwxXAggZkMn5PV7LrqzOvpnKkfj66BMMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1WqCICKHnvyvIEevFUyUtdGDLu7sKYBjmUGmhlgDFw=;
 b=F9Nvi6FQsKNS2UTlFgU/LFSPhfXO9A5SEfnxzras/lM8lhy64MRuUdFAS50c/4P97qqwk8G5b15GfMjuw7l0kXDUFnxoj3QSskWXZ0M6EvaZgNF/9+rvOKnVL36zNYGkH1h9E6Z8U7PNR/UvdF6U6Ffwk9SFm8VQ/URP/MYn2ciUsG2nlh1ZYbkEbQ92q1Kar55zV+xq6jts6MHfCWlc7cw/RNx3mlVg0nmBSq+qNJAH4SRnTCDTaCNov/LxEDnP9Ij5A1oujYbVMYE+iEr3HKsHb5tTNVHj7lSsW40bBS1toAdV3phe3f1RgUebJTOO3AnoUpqPG755y27P4lfuvg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1WqCICKHnvyvIEevFUyUtdGDLu7sKYBjmUGmhlgDFw=;
 b=JF9rFCcgMcxF+ceIpnrribmeZ0STF2+TjWM1X5xBk51EsWd9X4pFpBbdtfV3uFVfRVY57VYw6nxA13FEEtaHTJJoyaKCT7a9v19PGrsaSVy9oypBMJ+LM7qi1WfCDJ24d2Nkkb7ZokxZKpjcyP5z7FXsY7yLUHvHT2ujh+hmGxo=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq14k35k2h9.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-11-hch@lst.de>
Date: Wed, 06 Apr 2022 23:16:22 -0400
In-reply-to: <20220406060516.409838-11-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:04:59
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:16:25.0831 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=909 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 10/27] block: add a bdev_nonrot helper
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
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f462271-2218-4474-a0d3-08da1844ff73
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 rBIVFhAoNshURkv1HyfqBFxfOYfm06KFXhMgA4EeD4zv08QuMMjbiCbsS/OWd7vYhiY6T1dhYNOOjHZ8V2ljvo9vFxuWTvilkhLJTpe9bZ8NPWAAgXWwMNHQl/ENgQciCisKsG3Jdv0Tk2Hk0JC6H6btHMFxK/jPH9/fJBFas9AR64IoDB8MrCRobD63hJmLBtRraGDYcmA318FcrjPX3t+yxGbzOF5LUQ2L60yoYvF4jtBL6xNyt8XUpDt/Nu9IL/ni5Dsj7VYaskkGq307cjqkQzVaHy8qBhdBMUcJ5R6bejTR96WfrOVZgGmiz29lGUyfQJFC7Ia5IguzwjrnPboEZJWo9AiQ7Lo0AvVjVX0BOJyzkEXwUfX7llHrivxytGBsxkHAxeTb5pgIH3OMGv24ytmE666k5POtEIDtlYhmQRnO8Eu9T3Wz90SXr/RGY7Jc7/PRip+55wuvzFXUKjlAVxSAR/M828nlVhiisJJPznMY8hY+WJvRxJKNvtAdIPJw7m50/r/oP857qma4JnacWPOWzbrZmwzEaPsJ4UAHHzPRpesNt0Sqizo3xCENpMFK4ITK3TJmbBa+g3ijwthrQkTsfYOEQ26DK2MSEfc=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 0f462271-2218-4474-a0d3-08da1844ff73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 JXFvtoZt+QZMvRB6K4PJ4QiEIxz8aILvosFrOC8hdGeBDG9wKGnZ1zG8skw3ymsA5ydm145Ye8FME6355LIf/PPAyCH3Foo/UE50UBcpBQU=
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
X-Proofpoint-ORIG-GUID: z3z70Kt1mp-mQmOCghIudbS6zo3COixC
X-Proofpoint-GUID: z3z70Kt1mp-mQmOCghIudbS6zo3COixC
Reporting-Meta:
 AAGXVUA7dfur4hFsh8w6RMZTx5RUqrVw+tO6HHGpQObG5DX5alPSSlzkgCbXEfMb
 AcnhpUsI6SXHxyrti6LmqiKnqVZS2tMrQUwfRF1az2gT3+lskC0cFr7wY0n3hd1d
 o4tbBRI6o16vRU+VSoil6QSNGos1POcX2MuNzcHcPdB7lqCVpF6QugcL8MONYm2l
 OEVzHlPODwfm1CkbnkVR5moTOjp6i/Yz+AIBmVlxlN8T3iJ+KBkS5ImEWZj2AoKN
 Aml8HDy394ZeFyHW1ozZbi/4gQGkDJ1Ny0mGi3NVe2bZ2ZU9VZ8ZD7nmYd4Y3luD
 raNvncApZicg89FEUzIK9rROTMPyNAbmHCAS5X75sg7k7GZIqnxOGjgAmr4xRCju
 b6DBYqob9UsPWMk4WWmMJ0cg0On0LDhT5iPIFZAj9gReCuickLHRYqW4oP+8AgIO
 FC00nGiUCSfxu+2RyqNLRXzJTPKtwWEA9VnOOzbvepDTHK7SDI6dDYBeaefpUzkT
 6OUUtco2GE+k08nmhhl5LSjwzgUEHHo+v+SShnRkPCgo


Christoph,

> Add a helper to check the nonrot flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
