Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B9EC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=25eo/d+IceQCTbSNSvo7UqxqvPnLc6sLQYWOlSwrhrU=;
 b=hKQD1YXPpwAwkKcEcbV4kM0owWT/lbeevv8vR7U6OAj9NIknzK8cSkgBJ3g8eQmrLpTIuO0nudan
   aj7z0ybpEqZwnFVAqpchACgM+U1nqydbmXUr+tMel+6heslZNg5TemWZWAOFkgQSFqGLAQcKK9FH
   8SHcv625LL3lu5MlGBuUUrinuMpAxUqgBWjbCaShhZ7HqmlPDs/fTAMxH65wsX49LHrmNw/wGaWM
   9Cj0tLZgZSuNdCmxEITm/NcYY9Nzk6u9Rr8lXtazpYeBMqEpBrDiLkvL/MwChiFrQjRNq6B2qz5Q
   3J+AAqqdLDN1/sjMFQjoKRxQ9lQkrjQWJFHwEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=25eo/d+IceQCTbSNSvo7UqxqvPnLc6sLQYWOlSwrhrU=;
 b=lJkeCK+VWFSlrl3hShzRY1muh2g4fIeIZpdUJAk8aepms8Gb0Vwdnr/xSFxNjU4FPVPFJTV7X6kx
   Bm6GLAoO544VntLkBuyz3eyOcqn6XSWaWMgUqfKFCwJI6gKItTg/cLsr46cOnbbzBGaHuAtlZr/n
   d0c971RhDHwtMU5rnrM5338v7O+F2Ih0qH67fQgPvX31MxnrS6DqFMuJundxItjL6hBv80EqM6uY
   Iah9wcGP9j/Z+SzioLejj7KY92M/17kxDIncXR2k28UsNRyetDrAJD7RkRZ6AKgBjFzLMhi8XPG2
   +IZRMVyazWiZv4sS/t+VsCbYRQ9ICPXo9Tz4yA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y006SB9BJGH70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:21:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=U+fTrz9scjvUlmcuDEtUdP2MIqdifGmBnbiweLe7F2I=;
 b=YUMdnGZuzek/W+HawPDaaLfxI+Yo6VABZTXVZ6R8VbQc924wt04u0sirTy2Iwmbk9FVl
 /OpgKryhR1e3Y84u35EcxlrfG+CRudZayKtWXhZ58oLzkQVqUhknU/gQ/BTvDtmjSP/l
 Ke+S1e7qTo6WD0F3OCHx47/sHT7F9R8sfpJ9Uy2hQ3h1SeOp7P1QTjGq79xi+8LNUyVf
 PTMBYdQrUC/zUulYntbR8hQfeiAXG7mrqrQYIpxuy9v6IPl+ojNDqwos11kNCNNxNXPb
 iccZ7AYkq/524guLzOsAePFN112wVNxb5djErynah9vV1tKNLr9L9K2gHlamHeLCIRcw sw==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXBmIl7f8xOSz/aByYcBhoCk61Isz8izVm3gdLLG13lBFxJO4oj8fHF3Pm+UVQk6BUtrMz/yzSeubcYVvNxsnlihZ/K54n8B0ANscn2+iHiXopOt0STjxSJLCWiumayBWn9jqdaNkLpILolc6e5lYG3yGwU3ugHE5ZUNDCjyww19k30pHmkc79mInk9ssrrkpMrrrZUuiY66SvG7UHuIH1Xr1Jzw8BkGBU2B0ENQasVvKPDbTlavnt8tY/bf84RO8g2f/N7AAodEbXMJtjwfv/wvVcgKaOuqhSdWDWMCTRR7smwCwxhVHdCKWLgpRWqzBdJco165AM1Ek8rN7Wshsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+fTrz9scjvUlmcuDEtUdP2MIqdifGmBnbiweLe7F2I=;
 b=l9Hv6Gyr1dbezeXER1NoylGwlVDjRKwOPjhFbENEtbmayoqp8/U0iXUiXY3Khnymah76GcEKk1H/+qL2Ovi5+LhSBBEg/SdqqjcQCyXkmp0CkjQZG0id4r3rRLfWYvEZ79hviQCrsp4xt03IxEr56kVxM48lBWJWvhTEtL0wOxQN8A3Vv6r7lVT6GgJ3G7GOv3uZ4lc4FMaF4bHtWoWqSz+vHa4TODG6gUNy3En4HDKqZZsuAwtWuZsP/A2a5VwvGZ2aBv6j65lTT0JZw2Sk3pFb01Z6i4kmWwE9mxybJbl1pJE3jTQM+7BOdQaJcjb0zgVFPTIOCJpMT8B3koZuCw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+fTrz9scjvUlmcuDEtUdP2MIqdifGmBnbiweLe7F2I=;
 b=CDTrIJeReUNkT/ta3WlnkGk62cSLF5ROp+b56nUD2ELEs8sf46JIa34Av/1wV7lG6x/RagNSdToDmCAfNdJmwtLP3rUJy+wKcQp0mk5Uq+3IezYzK1IC1nvSckbIhVEFBt7Svjp0L2cw6sgSP5XG1QR9fkVZt1LnwcGvmI8+mBc=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq15ynlinou.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-19-hch@lst.de>
Date: Wed, 06 Apr 2022 23:21:03 -0400
In-reply-to: <20220406060516.409838-19-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:07
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:21:05.3709 (UTC)
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
Subject: Re: [Ocfs2-devel] [PATCH 18/27] block: move bdev_alignment_offset and
 queue_limit_alignment_offset out of line
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
X-ClientProxiedBy: DM6PR03CA0026.namprd03.prod.outlook.com (2603:10b6:5:40::39)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a4e7c4e-e224-43c0-eb44-08da1845a688
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 tZ4/GctAHdyM9imKFsL6A4FdIp+gYHH0DCSuK3zPuXZ54uJd+kye4T36qch+xoR2yU9ICoX0ncPvgX/H5KxqVgc9skk4XevZ03/2Lkq1S3kFJQlktSzB6Pvucb0imxyhmFKQnN/xEaQ+uHxT1G5ii/I/isTmJ5M78UOfAbN24rT8DZ3WiVrcCHtOe1oCmOA6mzEen0M/rjUMgIQFSXv8sfWZqq/0JiK+EyUUbkXWb3teChH1uVlvAZuVSs5dt5t8IPfloaldnasdhuV2b1+/rz5+c3kKbBStMWfiDsNmw8LGomPRDWY/ejl3XP5RYRhZoFlj2G+C87C39S+OYv5y5mX4ZEiAPLIfAhlZXKDSQUvz0CGBnVgPEiCzdlokYgtsjGjYsm1R7Qe7w8I4kTBl2Lu80h1m4MJBXwAu1/1Ve+rRvBtELD61xoW+J+QFqhgIyvmkde+Zn3Ci/TS+LUYmNEK07KgE4LmufiOsuQ0d/djqZc3Nm0CTEGp0dz7AfhxZHc8aXEeW7md5ExPlTnLa2/cbrjZhsYJhoHtzVXRa0Ai8QnYNohb4szrd8pcrq9o+HhGFadfifHPK+4DFESC8gHoldkeHQHOo+yGxp4vsQEE=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2a4e7c4e-e224-43c0-eb44-08da1845a688
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 T/WlI7i40n4VOjlex5MfakSjplwXRvhr2/q9rsNGMZXOqMWjhXVBrAKp8zt1ZMqkDxKK+4gPVb28EAbtiZ++8LZxftn48EIY41evxMiUqNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
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
X-OrganizationHeadersPreserved: SA2PR10MB4748.namprd10.prod.outlook.com
X-Proofpoint-GUID: UHADuH7s-8CNIdDHQ9Mfn1tVDWVEq3Mu
X-Proofpoint-ORIG-GUID: UHADuH7s-8CNIdDHQ9Mfn1tVDWVEq3Mu
Reporting-Meta:
 AAFd0rko/z7t158+RUTD3nCjREciFPr+XQBIeL9XP883CTPCfRSrjBy+bjN9zlnf
 2M5Zq2qanuT/YYbmrrM6mJ2g2ls65Qh7+y2+y3DDjgQWXapUE+lGfzSpVMfNstJB
 +G1YHeyLLX6HcDopqsO41MwtyltK5JNO3xQLt6ABptC/IATZqppMgYRhYK0ae16j
 f9jzlFpA+MJ9NOsiUblXuTCvfKkBIWU0Mz/6mo95fKZ4FXFmwJS5Hrd08gYBxoGW
 l7FAPSRucW5myJvoPLEnTLFgp9nxXpc4C9ulvUKej49nX9IWatrvWTGs7+1FGmRk
 xaEg5DDuy72csflyuOFYYABdT0Hunje6FM8B0/4coudukpoIhEqKIw+mYt7tJXWb
 Trs+2d8hoSszCcOIHx6rIJf1QL2uRxD8aUJ+n2iiVICqgjNr4/TycSn7B9R/HrMu
 BF4UeDLB69CRn/4w3iCKwuDcUYOT8l8hRLmYzM/kzzb+ejo0YoJToqs9vi15MvMo
 JKey4pnBqqgcsWWE+8itO8DmoKVWBNZOrVEYtSD+cNNx


Christoph,

> No need to inline these fairly larger helpers.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
