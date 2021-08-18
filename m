Return-Path: <SRS0=nImK=NJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBA8C4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 09:21:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C9B8610A6
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 09:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C9B8610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I96QRY002967;
	Wed, 18 Aug 2021 09:21:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3age7mt6t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 09:21:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17I9B3CD179929;
	Wed, 18 Aug 2021 09:21:18 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqkvvv3q-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 18 Aug 2021 09:21:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGHl7-0005lH-BY; Wed, 18 Aug 2021 02:21:17 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mGHl2-0005kp-4z
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 02:21:12 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17I9B7tc014565
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 09:21:11 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3ae2y1uts1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 09:21:09 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17I98JkN012801
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 09:21:08 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3age2nu4p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 09:21:08 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2057.outbound.protection.outlook.com [104.47.12.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-16-bMPwOKCQOL-xgzdSPcREBw-1; Wed, 18 Aug 2021 11:21:04 +0200
X-MC-Unique: bMPwOKCQOL-xgzdSPcREBw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=ilOhlpRiS0pFwHsCLAChWIt9WqspUVvgZoFIRtwYl3/1/O2cIOutCW5DwnfPtmvBJc4/T7LxdW5tCKbFY3bmPrzcpLM9SSib80XTc96BsnFULyS3SRfBzveOFzb0EFFLwIu9e/dMo23/BjI3nCKt95B9TuBRAgEnDRYctheiGT88Va3QKiI6V5YI6nh+nqNjTsgg4kYsTfOnUmwAsoIaj18T3nEokYq249bxxQ3dlHt/flizWyUaAmF1bwU0977Mcw/trK1Qeh6u4tG/8miSg9KbCwwfFvMMYwjw9QfqQgPvCtBQXBWrNgBO1F3HruQusGK9jArOTJFXQIN6rKOWZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=2qiCAqprNJWMbr3wXf1R+zcRHbsv/PP6HbdhJ1paRDg=;
	b=aRbv34evyRQxBcjTwxOznztA9Y9Q3XZH08uI6Mz7sipkky3mT25jeFOxWHx93f2Lfb72GDEs7EWhQfEfcKYKVODuhXz/iMQPJlhNDYeIrqcqXIxvGzoZIFH081ao8YHLEzUSgL+JxeU7Bqc3wDJgcEtTkzZx7irSmV7qj1BKMvCCyc2t1n6Z4Io0ntfeyvCYZ9bc816KiCkFp9PM8drRcx3BC3+oZv+m24NcubMf2Ssrch19zfW5PSOBL1MvndtaDygJNkUgIJSVTTZgZt774B+7WZwtdttVb7x9N16w3CudxG0l2FLqPv8YN52FhIaH0WUArPj3UCBOsqdrCfl6Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AS8PR04MB7624.eurprd04.prod.outlook.com (2603:10a6:20b:291::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15;
	Wed, 18 Aug 2021 09:21:03 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4415.024;
	Wed, 18 Aug 2021 09:21:03 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org, Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
Date: Wed, 18 Aug 2021 17:20:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HK0PR01CA0054.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::18) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	HK0PR01CA0054.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::18) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4436.19 via Frontend Transport;
	Wed, 18 Aug 2021 09:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1213b730-baaf-4bff-a480-08d962297fdc
X-MS-TrafficTypeDiagnostic: AS8PR04MB7624:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7624AB81F1616B23D63FC896CFFF9@AS8PR04MB7624.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfUwP1eTQrNrRLjuKzorK7ZOaaqMME22kreKf3LwAlUyTvGHGkznbf86msx1nY32t1bP7cj32GzcOff0EHPaYZrzE40UO0nU7lXj2G6qMgFn1XsGRsVtzVMXvMHqwGbBwjB4wonTZgsBlaPhktyGPdHr6jrosBrubfTvXIQ9qc4CTUN6eylOUEBE/lkzCOwY9bRdMfrtTyqhsFIeSyMCMu8k2Z5F1Xm3bdSkdJJ+6t9wTkZa2WUKVx7JTozEh6KA3DTP0qt1ct9Mh4mjqZbjm38uHMXRXtbL4xqVgzV0z8ai4MIyddDaoGkI6xvshGA8FUidQLIh99+L5NVN22jdG1xdQQfUzOa2nnP8vxrspY0yC0r6lKAmbcoIjYH12v+er7yte33hk3TkHAPXKMLI/PwQ7f8R3k2y9K9KrfkpVatEv0iXw5955m8LdXkFT2B+kd0GWlzd2XVrv92Q4haH5BzlEv8msOVfDkqr5Yq9cjiQIl2upnvCV3eZnbGc7jCWTffOK3J+SzFQrlDERjfJHSUHKxfoiJfYBeN9AMTNXZ7Mzrhr7WGSXJ/+9+gC6bnRu2vIjVfQPf6TsKKRdqPK4YxrThxkck6UFoGSOSqdQc44G7doBIHuNqCR6Q7XZRUgZEWVH9B/yr8jJjpWURTKVsvW555DxUMujUT60CcMU7oFACw2oxFZyjFNNEIwGuaQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(31696002)(66556008)(66476007)(36756003)(53546011)(110136005)(316002)(66946007)(31686004)(83380400001)(38100700002)(5660300002)(186003)(6666004)(956004)(2906002)(2616005)(55236004)(8936002)(86362001)(6486002)(26005)(478600001)(4326008)(8676002)(16576012)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yJej4C1Sc3YW6eB3oCPAGZ7+/USTm2k7mkcCnn5rTU9XhqQvDgNcIC2kZqsS?=
	=?us-ascii?Q?QYKtS2J/QIpo047J12m0xbGLG3btrl74/yduKEYX1paAWgkQLBxpV5g0wyE8?=
	=?us-ascii?Q?Nq4TFEI+TjY5DUBQPGL68kFyEfqgypqTXfmHh0SEBqJCXDOkpUtZIQwsbWqB?=
	=?us-ascii?Q?3N6n1VeaM/k1e7IPTynWGhtOSULeEvBOT3+PKsP6Nyg7qcXpWCPGUfj/cblL?=
	=?us-ascii?Q?fLtawAel7sv+qfzU4yum8NiSwEI2Ubs2ucDx15Kw7K96kkr4p9zih9omeHyI?=
	=?us-ascii?Q?xYRU/zPAP/qZxbbJarOY3kh/Fu0tv3TR2qJ+9JF4J9f5WCbteuo5iHaG/Ll/?=
	=?us-ascii?Q?V0/4PT+QI6R9+NwPtOURxxkSRXM2DUeMYiQwRonRywbxkyi0tl0AonSY/jio?=
	=?us-ascii?Q?+oA+yIXqCkgTSkVmVz6vbudqtz4jpc1FWkTe/TZsgZg5xDYfSv21YAU1yAlb?=
	=?us-ascii?Q?hy70JIo1NAzSh3AencuR7QpI9EUR6OpxyL7TW0sNyOye+10iJfREB5yLGhsk?=
	=?us-ascii?Q?1BgFHPdvwMi9oiUMXZBYzL6GiBcy8TapGDwKR6Ci+yyZYhjhHe/uoxrgVpzJ?=
	=?us-ascii?Q?ig6QqpsO+Qx1UsT1ZtrhWkAXliLu6kWRyT8DMdG4aIA5w1hfcB2M6xbWHipO?=
	=?us-ascii?Q?Ki0PV60SkS8QTBc0uzRt/PnSCy/MCpdQpiVR3agRokSjHQMWwKJHiRhsRX07?=
	=?us-ascii?Q?eYQBLQl9xZBtTNjC+htZBLUnpU6PO7wsYUuJEqY6a2s7WLW+k4vLF5eb1x0a?=
	=?us-ascii?Q?s0tfAD//hOdG2kx9/r8U3L8G3SetV/XYlAGMf04u1RXSacT5I+QwtQoASbTm?=
	=?us-ascii?Q?+PWRQSf9wddWO0Xzp1AxzKqiizbebmfPQoIzq2j1Ekp6eqZa7hjetH/K1n+d?=
	=?us-ascii?Q?sDzHIsDnJlJ3Hks68XhFKiUTkgKF4dJcsTMvqzBbI2Z2jGh1czrQgO3bi0AJ?=
	=?us-ascii?Q?+OVEp+ZTf1PeClYOnTpUDboOx7JkZ21TQlxf8F86xIdb6wCJHpvYdGzJP6u+?=
	=?us-ascii?Q?msmUubJJymc7NgU7S2oPmcAECHG/KHA7FOMHTnk7q4F59RC6KJoWGE8sEeqU?=
	=?us-ascii?Q?UByoQTRDH3K0r7dtRG4MDSGZqgElPsU8nDbYcboz23Dbj9hzkgYssxc8NfPp?=
	=?us-ascii?Q?GkY4/KxVuIVbpuPQiaGsg48oNdX6RfsWVCSQjkNUUkrPb3Yy98GXzTY4gG76?=
	=?us-ascii?Q?bZgv77RVibmPHVTYb2ZBlE9oT3byCHPXDSsrtGZFdbJWPtYtZXVuue2OCxgo?=
	=?us-ascii?Q?gzCd/iq/TWfyBDkGeE1vxXzYuCcufvbYHgBseCRhJ4zQHRM0K98PjUZW2t/c?=
	=?us-ascii?Q?qVbcceKFp1KLlNwEbxV1ODpi?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1213b730-baaf-4bff-a480-08d962297fdc
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 09:21:03.1131 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfHLYFg/HXhOJd5RSraZXnSMbfbw8EuwJUP+fo9ixQUw5Cw/0vTjgBYP33ACmPEK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7624
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=185 adultscore=0
	bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
	clxscore=251
	spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180057
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180057
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file
 to the same directory simultaneously
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180057
X-Proofpoint-ORIG-GUID: 9X4hQODFlJYqHdl_88Vogy5TfxEcFDQ2
X-Proofpoint-GUID: 9X4hQODFlJYqHdl_88Vogy5TfxEcFDQ2

CgpPbiAyMDIxLzgvMTMgMTc6NTQsIEpvc2VwaCBRaSB3cm90ZToKPiAKPiAKPiBPbiA4LzkvMjEg
NjowOCBQTSwgR2FuZyBIZSB3cm90ZToKPj4gSGkgSm9zZXBoIGFuZCBBbGwsCj4+Cj4+IFRoZSBk
ZWFkbG9jayBpcyBjYXVzZWQgYnkgc2VsZi1sb2NraW5nIG9uIG9uZSBub2RlLgo+PiBUaGVyZSBp
cyB0aHJlZSBub2RlIGNsdXN0ZXIgKG1vdW50ZWQgdG8gL21udC9zaGFyZWQpLCB0aGUgdXNlciBy
dW4gcmVmbGluayBjb21tYW5kIHRvIGNsb25lIHRoZSBmaWxlIHRvIHRoZSBzYW1lIGRpcmVjdG9y
eSByZXBlYXRlZGx5LAo+PiBlLmcuCj4+ICDCoHJlZmxpbmsgIi9tbnQvc2hhcmVkL3Rlc3QiIFwK
Pj4gIMKgIi9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdC5gZGF0ZSArJW0lZCVIJU0lU2AuYGhv
c3RuYW1lYCIKPj4KPj4gQWZ0ZXIgYSB3aGlsZSwgdGhlIHJlZmxpbmsgcHJvY2VzcyBvbiBlYWNo
IG5vZGUgaXMgaHVuZywgdGhlIGZpbGUgc3lzdGVtIGNhbm5vdCBiZSBsaXN0ZWQuCj4+IFRoZSBw
cm9ibGVtYXRpYyByZWZsaW5rIGNvbW1hbmQgcHJvY2VzcyBpcyBibG9ja2VkIGJ5IGl0c2VsZiwg
ZS5nLiB0aGUgcmVmbGluayBwcm9jZXNzIGlzIGh1bmcgYXQgZ2hlLXNsZTE1c3AyLW5kMiwKPj4g
a2VybmVsOiB0YXNrOnJlZmxpbmvCoMKgwqDCoMKgwqDCoMKgIHN0YXRlOkQgc3RhY2s6wqDCoMKg
IDAgcGlkOjE2OTkyIHBwaWQ6wqAgNDUzMAo+PiBrZXJuZWw6IENhbGwgVHJhY2U6Cj4+IGtlcm5l
bDrCoCBfX3NjaGVkdWxlKzB4MmZkLzB4NzUwCj4+IGtlcm5lbDrCoCA/IHRyeV90b193YWtlX3Vw
KzB4MTdiLzB4NGUwCj4+IGtlcm5lbDrCoCBzY2hlZHVsZSsweDJmLzB4YTAKPj4ga2VybmVsOsKg
IHNjaGVkdWxlX3RpbWVvdXQrMHgxY2MvMHgzMTAKPj4ga2VybmVsOsKgID8gX193YWtlX3VwX2Nv
bW1vbisweDc0LzB4MTIwCj4+IGtlcm5lbDrCoCB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4YmEvMHgx
NDAKPj4ga2VybmVsOsKgID8gd2FrZV91cF9xKzB4YTAvMHhhMAo+PiBrZXJuZWw6wqAgX19vY2Zz
Ml9jbHVzdGVyX2xvY2suaXNyYS40MSsweDNiNS8weDgyMCBbb2NmczJdCj4+IGtlcm5lbDrCoCA/
IG9jZnMyX2lub2RlX2xvY2tfZnVsbF9uZXN0ZWQrMHgxZmMvMHg5NjAgW29jZnMyXQo+PiBrZXJu
ZWw6wqAgb2NmczJfaW5vZGVfbG9ja19mdWxsX25lc3RlZCsweDFmYy8weDk2MCBbb2NmczJdCj4+
IGtlcm5lbDrCoCBvY2ZzMl9pbml0X3NlY3VyaXR5X2FuZF9hY2wrMHhiZS8weDFkMCBbb2NmczJd
Cj4+IGtlcm5lbDrCoCBvY2ZzMl9yZWZsaW5rKzB4NDM2LzB4NGMwIFtvY2ZzMl0KPj4ga2VybmVs
OsKgID8gb2NmczJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2MCBbb2NmczJdCj4+IGtlcm5lbDrC
oCBvY2ZzMl9yZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2ZzMl0KPj4ga2VybmVsOsKgIG9j
ZnMyX2lvY3RsKzB4MjVlLzB4NjcwIFtvY2ZzMl0KPj4ga2VybmVsOsKgIGRvX3Zmc19pb2N0bCsw
eGEwLzB4NjgwCj4+IGtlcm5lbDrCoCBrc3lzX2lvY3RsKzB4NzAvMHg4MAo+Pgo+PiBJbiBmYWN0
LCB0aGUgZGVzdGluYXRpb24gZGlyZWN0b3J5KC5zbmFwc2hvdHMpIGlub2RlIGRsbSBsb2NrIHdh
cyBhY3F1aXJlZCBieSBnaGUtc2xlMTVzcDItbmQyLCBuZXh0IHRoZXJlIGlzIGJhc3QgbWVzc2Fn
ZSBmcm9tIG90aGVyIG5vZGVzIHRvIGFzayBnaGUtc2xlMTVzcDItbmQyIGRvd25jb252ZXJ0IGxv
Y2ssIGJ1dCB0aGUgb3BlcmF0aW9uIGZhaWxlZCwgdGhlIGtlcm5lbCBtZXNzYWdlIGlzIHByaW50
ZWQgbGlrZSwKPj4ga2VybmVsOiAob2NmczJkYy1BQTM1REQ5LDI1NjAsMyk6b2NmczJfZG93bmNv
bnZlcnRfbG9jazozNjYwIEVSUk9SOiBETE0gZXJyb3IgLTE2IHdoaWxlIGNhbGxpbmcgb2NmczJf
ZGxtX2xvY2sgb24gcmVzb3VyY2UgTTAwMDAwMDAwMDAwMDAwMDAwNDZlMDIwMDAwMDAwMAo+PiBr
ZXJuZWw6IChvY2ZzMmRjLUFBMzVERDksMjU2MCwzKTpvY2ZzMl91bmJsb2NrX2xvY2s6MzkwNCBF
UlJPUjogc3RhdHVzID0gLTE2Cj4+IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9j
ZnMyX3Byb2Nlc3NfYmxvY2tlZF9sb2NrOjQzMDMgRVJST1I6IHN0YXR1cyA9IC0xNgo+Pgo+PiBU
aGVuLCB0aGUgcmVmbGluayBwcm9jZXNzIHRyaWVzIHRvIGFjcXVpcmUgdGhpcyBkaXJlY3Rvcnkg
aW5vZGUgZGxtIGxvY2ssIHRoZSBwcm9jZXNzIGlzIGJsb2NrZWQsIHRoZSBkbG0gbG9jayByZXNv
dXJjZSBpbiBtZW1vcnkgbG9va3MgbGlrZQo+Pgo+PiAgwqDCoMKgIGxfbmFtZSA9ICJNMDAwMDAw
MDAwMDAwMDAwMDA0NmUwMjAwMDAwMDAwIiwKPj4gIMKgwqDCoCBsX3JvX2hvbGRlcnMgPSAwLAo+
PiAgwqDCoMKgIGxfZXhfaG9sZGVycyA9IDAsCj4+ICDCoMKgwqAgbF9sZXZlbCA9IDUgJ1wwMDUn
LAo+PiAgwqDCoMKgIGxfcmVxdWVzdGVkID0gMCAnXDAwMCcsCj4+ICDCoMKgwqAgbF9ibG9ja2lu
ZyA9IDUgJ1wwMDUnLAo+PiAgwqDCoMKgIGxfdHlwZSA9IDAgJ1wwMDAnLAo+PiAgwqDCoMKgIGxf
YWN0aW9uID0gMCAnXDAwMCcsCj4+ICDCoMKgwqAgbF91bmxvY2tfYWN0aW9uID0gMCAnXDAwMCcs
Cj4+ICDCoMKgwqAgbF9wZW5kaW5nX2dlbiA9IDY0NTk0OCwKPj4KPj4KPj4gU28gZmFyLCBJIGRv
IG5vdCBrbm93IHdoYXQgbWFrZXMgZGxtIGxvY2sgZnVuY3Rpb24gZmFpbGVkLCBpdCBhbHNvIGxv
b2tzIHdlIGRvIG5vdCBoYW5kbGUgdGhpcyBmYWlsdXJlIGNhc2UgaW4gZGxtZ2x1ZSBsYXllciwg
YnV0IEkgYWx3YXlzIHJlcHJvZHVjZSB0aGlzIGhhbmcgd2l0aCBteSB0ZXN0IHNjcmlwdCwgZS5n
Lgo+Pgo+PiAgwqAgbG9vcD0xCj4+ICDCoCB3aGlsZSAoKGxvb3ArKykpIDsgZG8KPj4gIMKgwqDC
oMKgwqDCoMKgIGZvciBpIGluIGBzZXEgMSAxMDBgOyBkbwo+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
IHJlZmxpbmsgIi9tbnQvc2hhcmVkL3Rlc3QiICIvbW50L3NoYXJlZC8uc25hcHNob3RzIC90ZXN0
LiR7bG9vcH0uJHtpfS5gZGF0ZSArJW0lZCVIJU0lU2AuYGhvc3RuYW1lYCIKPj4gIMKgwqDCoMKg
wqDCoMKgIGRvbmUKPj4gIMKgwqDCoMKgwqDCoMKgIHVzbGVlcCA1MDAwMDAKPj4gIMKgwqDCoMKg
wqDCoMKgIHJtIC1mIC9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdG5vZGUxLnFjb3cyLiouYGhv
c3RuYW1lYAo+PiAgwqAgZG9uZQo+Pgo+PiBNeSBwYXRjaCBjaGFuZ2VzIG11bHRpcGxlIGFjcXVp
cmluZyBkZXN0IGRpcmVjdG9yeSBpbm9kZSBkbG0gbG9jayBkdXJpbmcgaW4gb2NmczJfcmVmbGlu
ayBmdW5jdGlvbiwgaXQgYXZvaWRzIHRoZSBoYW5nIGlzc3VlIGhhcHBlbiBhZ2Fpbi5UaGUgY29k
ZSBjaGFuZ2UgYWxzbyBjYW4gaW1wcm92ZSByZWZsaW5rIHBlcmZvcm1hbmNlIGluIHRoaXMgY2Fz
ZS4KPj4KPj4gVGhhbmtzCj4+IEdhbmcKPiAKPiAnc3RhdHVzID0gLTE2JyBpbXBsaWVzIERMTV9D
QU5DRUxHUkFOVC4KPiBEbyB5b3UgdXNlIHN0YWNrIHVzZXIgaW5zdGVhZCBvZiBvMmNiPyBJZiB5
ZXMsIGNhbiB5b3UgdHJ5IG8yY2Igd2l0aAo+IHlvdXIgcmVwcm9kdWNlcj8KCkkgc2V0dXAgbzJj
YiBiYXNlZCBvY2ZzMiBjbHVzdGVycyB3aXRoIHNsZTE1c3AyIGFuZCBvcmFjbGVMaW51eDh1NC4K
QWZ0ZXIgdHdvIGRheSB0ZXN0aW5nIHdpdGggdGhlIHNhbWUgc2NyaXB0LCBJIGRpZCBub3QgZW5j
b3VudGVyIGRsbV9sb2NrIApkb3duY29udmVydCBmYWlsdXJlLCB0aGUgaGFuZyBpc3N1ZSBkaWQg
bm90IGhhcHBlbi4KQWZ0ZXIgbXkgcGF0Y2ggd2FzIGFwcGxpZWQsIHRoZXJlIHdhcyBub3QgYW55
IHNpZGUgZWZmZWN0LCB0aGUgcmVmbGluayAKcGVyZm9ybWFuY2Ugd2FzIGRvdWJsZWQgaW4gdGhl
IGNhc2UuCgpUaGFua3MKR2FuZwoKPiAKPiBUaGFua3MsCj4gSm9zZXBoCj4gCgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGlu
ZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20v
bWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
