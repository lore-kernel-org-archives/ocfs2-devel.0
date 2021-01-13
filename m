Return-Path: <SRS0=JIBN=GQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2A2C433E0
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jan 2021 03:04:20 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94EC123133
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jan 2021 03:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94EC123133
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D301aU015170;
	Wed, 13 Jan 2021 03:04:18 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 360kcyscvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Jan 2021 03:04:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D30eW5192700;
	Wed, 13 Jan 2021 03:02:17 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 360kej7vfv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 13 Jan 2021 03:02:17 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1kzWQK-0006RA-Ao; Tue, 12 Jan 2021 19:02:16 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1kzWPr-0006PV-S9
	for ocfs2-devel@oss.oracle.com; Tue, 12 Jan 2021 19:01:47 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10D2xcWe000944
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Jan 2021 03:01:47 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 360ke7jwtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Jan 2021 03:01:47 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10D2rOGI048226
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Jan 2021 03:01:46 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by userp2040.oracle.com with ESMTP id 361q5s0wjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Jan 2021 03:01:46 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2059.outbound.protection.outlook.com [104.47.8.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-17-WFYqA9E5OQa3IiPcKMqX1A-1; Wed, 13 Jan 2021 04:01:42 +0100
X-MC-Unique: WFYqA9E5OQa3IiPcKMqX1A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=fGbceG/qjsCBWiMPsG/HrzwH59pqrFWNklx2lQGFXkkz2NazxhDD88d5YIABgqPnzH47AKYCP4JabqGqsLNJW72qxp4VYrE340W6MjvtYHlZWJORCid1rzXkn+AEdJNy1ObaWZFhs69/qGhvsxfTeVThclgcTb+AMLX2B+N8l8Q2Xa/UarZ38E9ypJp1KwYcGvm2SdXa16eHw/u5F/gbkhOvuLp/F6luRPdnHyvhftah9Cp4CWrOB3ZQu2Y4BFHMuxEXz7u186JfsFFfWGwrf56IXUh7R6sydaSZEco5RHq9qWoN6QJvPdmZLYep0UY9LcnOTf4rdsrzeTWEMn2L1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=s4R/NDqgbT3dzs5PPDslK/wl1WqZZ51CacPJWBRZKvU=;
	b=lRr2lp4+bxaY8WiA7SEEwGgl74Sog6mJ++YuKizjyFuRXssCKCTjbGuef4RmhBDKzhrAUGyv+ESYMKgozJtTt+4CGZuTqBWpihiud+PZxsgmcStYZupldoJlJ69N9PTsraYk790M5xfLVSRwapj18hI3LnteJe/x1HzIPLDFWiyRZZ8rqddHWb0kO6bwY1Z8S1RRk8lrmh3caVBUZHSLTx46ln82KNtaKupZBTFFXdTyliYKvYqnMwzxYjjkucdkn+com4d/8eB6nGqKJfrWlLoOIfj31MUbHOg4/Cr2fKQWjL/nCXod5l3c0e0F3Z2IHnMbby5H5Sy+N4EH3ydimg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AS8PR04MB7974.eurprd04.prod.outlook.com (2603:10a6:20b:2a1::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6;
	Wed, 13 Jan 2021 03:01:40 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024%6]) with mapi id 15.20.3742.012;
	Wed, 13 Jan 2021 03:01:40 +0000
From: Gang He <GHe@suse.com>
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        OCFS2 ML
	<ocfs2-users@oss.oracle.com>
Thread-Topic: [Ocfs2-users] how to find out the real size of a reflink ?
Thread-Index: VCQphRZ5cdLxI57Dhih6YN3zM5c2keV/oUIAgAAFAuw=
Date: Wed, 13 Jan 2021 03:01:40 +0000
Message-ID: <AM6PR04MB64885B5CBBB61920FF15DDF3CFA90@AM6PR04MB6488.eurprd04.prod.outlook.com>
References: <2040150856.105362879.1610376125778.JavaMail.zimbra@helmholtz-muenchen.de>,
	<71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
In-Reply-To: <71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
x-originating-ip: [211.20.175.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe1b24b2-ce22-4f6f-6563-08d8b76f8d03
x-ms-traffictypediagnostic: AS8PR04MB7974:
x-microsoft-antispam-prvs: <AS8PR04MB79749B8E8AE7E10729B86E78CFA90@AS8PR04MB7974.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Saef3j7LH7CC2KEOmyCP5spL4h83aYUAntE3LYObPAAjoi7GiqLuQ0e9bXp/MMPzA6oIPHLqC+wRwMofJA5N8zPh0/ouT/Cd6k4YaE1O5oey5QppzhT8ldAmzrisBm7mVTzzN1bq0fUnrHW1uMIh5/cJdbjrZEPtqDTZ/HF1glb1LDCqDE3E+XkO+shwrn7QrPHA4gW24K+H+NDIIC1dvR91NtrSMaZL89f2gYCb0riqG9bT72fOo3Avv+dyV5V7Upr+KalZJ//FMPltmxa0l13nA98Wq1wnjv7g8CCTNzOTErkEb3gy+3spyIE+hYlYuq5M/HlTGOKnBzO+p7AQaVGyyZYusM9SIcp3XKXU58rqu8gGReW37XsRhuHl9icr9Hn5URJ96jkRZavQhsRuHM2kqbGntLmgEC5F8diIClIyG22fqqL72D7LmXmDke4T
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(396003)(39850400004)(376002)(346002)(136003)(83380400001)(26005)(86362001)(5660300002)(55016002)(71200400001)(66946007)(478600001)(9686003)(2906002)(186003)(8676002)(8936002)(52536014)(91956017)(64756008)(66446008)(110136005)(53546011)(66556008)(55236004)(33656002)(450100002)(316002)(66476007)(76116006)(7696005)(6506007)(37363001);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?dfiLOjbuDAOReuQSQDp3TM1SKHc70HIFYdL9uMV4BKyONb2lOUIiM8tadF?=
	=?iso-8859-1?Q?4VKdhheE+J1diraOo0XoGyIPOMpzqGXAGliRiPR4gziTbIW2hT+c3b1SUX?=
	=?iso-8859-1?Q?A+rJS+UFtNlVRdSFxcQKjY/ILlObTTYq5Z6Cw5FJeq0aOq+7Y5+nvX6Epa?=
	=?iso-8859-1?Q?zCKSIVGyqMKsSeTCbF0uveq/IBGdlj0j5WqzRx0JoFEjRnFgcvWJ0CPyKL?=
	=?iso-8859-1?Q?WrhOfrNwyXP6ngVTv6KnqjuQJKZoT3Lo35uvZ2WcdN8OTf3zCT0wt7gJgB?=
	=?iso-8859-1?Q?GDRRsYMcMCByEsmO5dpExkWRZFvPUL+cENtNqig2TTONfhYwvRi2zgEFa+?=
	=?iso-8859-1?Q?0oCosrFWT1ZPY/xESkWliVQBNUosgzOtbl7SIX62hDnm+rc7A6CRJ3wtKb?=
	=?iso-8859-1?Q?KSAY9GmgyKCz/HIJ3vyw9XkEG49rwr/ix9QYlL8cNIaPf4mWKpfEDEd4L3?=
	=?iso-8859-1?Q?FMATywaS9fRRo6v1euf++Yhxe5WmnxSw8pNUrJ2sMFmuF5Z+C1Jpgaj31R?=
	=?iso-8859-1?Q?4njLYM3RrYzXkbxq9cVAzksz9/bj/AJTrzpRycy60Fx2YsvulxOawoe3ut?=
	=?iso-8859-1?Q?iALmwJrGrlNocvOaP7Yaql+lmMSL3xVPlYgdaRccwyzDTxIRzgskP5DP/L?=
	=?iso-8859-1?Q?xOrtDRwvLNGBTWAF+EbNu1BrX/nXRw2joK8Yo8+hH9+eegMro+3ZUuV6Fd?=
	=?iso-8859-1?Q?GooGkTGuwrfqVIelX34k4g/xoznOrDxB1goqxs6bMRQNji4ab6TUiofSH9?=
	=?iso-8859-1?Q?Tg20S1O0o/brUSCiB8avl1km8pY4AXUMZaKqLX5tthZhZyiEZy0RTOLhgO?=
	=?iso-8859-1?Q?WA1gwPwEiNyPdibc9nfRQ9xMo2VCBV9LdmAalJ+q8KYDtFtCKYRcgEN6qH?=
	=?iso-8859-1?Q?YQ1CBJWZU4YdC4bCWI2Sa8QHEGa1zMxhfRKkK8XnfHY2pkRwG/0qEAm/6G?=
	=?iso-8859-1?Q?86ZKfqn3boRdm9Gr71JeLbW0U+R/YGarjsrpDxlhvjQ+Nsct/FRFNl5TUX?=
	=?iso-8859-1?Q?nGxc2LjFaRU9/xj74=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1b24b2-ce22-4f6f-6563-08d8b76f8d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 03:01:40.6968 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lujxqDZ1ZCNVOEvJtbhORVgiksRDHp96IpwaVlnY80hkkFw7nEwIbgqBaXRk3j5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7974
X-PDR: PASS
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	lowpriorityscore=0
	malwarescore=0 priorityscore=138 bulkscore=0 mlxlogscore=999
	suspectscore=0 phishscore=0 clxscore=173 mlxscore=0 spamscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101130015
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [Ocfs2-users] how to find out the real size of a
	reflink ?
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130016

Hi Lentes,

you can use "o2info --filestat yourfile" to identify how many data
clusters for a cloned file are shared with the original file.
Of course, the cloned file does not share meta-data blocks with the
original file, only shares the data clusters.
e.g.
ghe-nd1:/rear/test # o2info --filestat dd.1.ref
   File: dd.1.ref
   Size: 8589934592      Blocks: 16777216   IO Block: 4096   regular file
Device: fe00h/65024d    Inode: 355844      Links: 1
  Frag%: 0.01            Clusters: 2097152  Extents: 157    Score: 2
Shared: 2097152         Unwritten: 0       Holes: 0        Xattr: 0
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2021-01-13 10:08:06.561968304 +0800
Modify: 2021-01-13 10:07:52.74642661
Change: 2021-01-13 10:07:52.77958163

Please refer to "Shared: 2097152" item.

Thanks
Gang

On 2021/1/11 22:42, Lentes, Bernd wrote:
> Hi guys,
>
> is there a way to find out the real size of a reflink ?
> "ls -s" doesn't seem to help.
> And shared-du or shared-filefrag does not seem to be available for my SLES 12 SP5.
> I know that i can calculate using df -h, but that's not convenient.
>
> Thanks.
>
> Bernd
>
>
>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
