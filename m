Return-Path: <SRS0=aUy8=GR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED64C433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:31 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F3192343B
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F3192343B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10E1ntHh003261;
	Thu, 14 Jan 2021 01:56:30 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 360kcyxcdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 01:56:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10E1onX7031230;
	Thu, 14 Jan 2021 01:54:29 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 360kemdr2w-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 14 Jan 2021 01:54:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1kzrnC-0000Vs-QB; Wed, 13 Jan 2021 17:51:18 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1kzrmz-0000QU-Cb
	for ocfs2-devel@oss.oracle.com; Wed, 13 Jan 2021 17:51:05 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10E1oCX0128542
	for <ocfs2-devel@oss.oracle.com>; Thu, 14 Jan 2021 01:51:05 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 360kf1jr30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 14 Jan 2021 01:51:02 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10E1j3dI035474
	for <ocfs2-devel@oss.oracle.com>; Thu, 14 Jan 2021 01:51:01 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by userp2030.oracle.com with ESMTP id 362a7nskck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 14 Jan 2021 01:51:00 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-13-7FyHiMUNPmKcMrxYbND2eA-1; Thu, 14 Jan 2021 02:50:52 +0100
X-MC-Unique: 7FyHiMUNPmKcMrxYbND2eA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=NOtqHL/MyIq61ZDr7IF2GSpBUVdWxOz4a4cgk0bIGrIXLePPmTeTLJf9XR8e/97UQrevSOchJdXZxVIwpE/h9qw9MIm77k9QHhc4Z4znEMaM0AJxEnqseeQymJyfquA4R+2W8/UTkap32UqvSJu8xNcHuSzwAtMUFL7bvg/lMFTKjtWEsmBGL3vJ/v/J1rLbdWswnrnAzsy9DLKhcreXYBMUz5uAntVD63HI9pY0UQ5bkc2/AeOJuDr7QDYdyQjOud63NHCk0K+0IfCKa/Q4jgz8nGjwStv8sb1DXJcaMFY9zQOmFg/jWUSnvcWcyjJu34SeQ+yZ5Pv0SUw4znpjjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=6Fv/TB7eUWjXZAe4T80pcm1hfSOYUd2XqMP+NnswDTM=;
	b=n+e7oLcSaH5WUrqymKVJeFCQSel0bBoLvSmr8MgKykL4a8ltIV/yzyE6qmNNMrjs1NK4wQ6ur6HxtWe1IGAxi2NHwQl8m4/JhnSdEyEwgeRQkWrP3kcCyrz47XSKLHFY9L3pRyahwjCZaxQKrtAnh1f+lTwJWNO1Zxe90fwQxUKzvgNuwPB2Ae3QTp9LzH4m9NdVvTJVV/5eNg3KBW/38z3i2gvjZqHE5sHRznBefy5EzoAZmM+x97kHqAI+iCTn9lspEbUwKRz1ML58xl/sgAtNBH6slkFnUFGTTDV0mUCsZDPQD5x0ZdP4SndZu1+fxhkysTEO0cicpwQNfrPE1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AS8PR04MB7974.eurprd04.prod.outlook.com (2603:10a6:20b:2a1::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10;
	Thu, 14 Jan 2021 01:50:51 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024%6]) with mapi id 15.20.3742.012;
	Thu, 14 Jan 2021 01:50:51 +0000
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        ocfs2-devel@oss.oracle.com
References: <2040150856.105362879.1610376125778.JavaMail.zimbra@helmholtz-muenchen.de>
	<71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
	<1400213487.108454266.1610546335237.JavaMail.zimbra@helmholtz-muenchen.de>
From: Gang He <ghe@suse.com>
Message-ID: <5dc2903f-d59b-31fb-dda4-3fb0fbe83798@suse.com>
Date: Thu, 14 Jan 2021 09:50:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
In-Reply-To: <1400213487.108454266.1610546335237.JavaMail.zimbra@helmholtz-muenchen.de>
Content-Language: en-US
X-Originating-IP: [111.205.14.62]
X-ClientProxiedBy: HK2PR03CA0048.apcprd03.prod.outlook.com
	(2603:1096:202:17::18) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.105] (111.205.14.62) by
	HK2PR03CA0048.apcprd03.prod.outlook.com (2603:1096:202:17::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6
	via Frontend Transport; Thu, 14 Jan 2021 01:50:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f64481ef-e7b5-40e5-9a03-08d8b82ed261
X-MS-TrafficTypeDiagnostic: AS8PR04MB7974:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7974CCB212E674944CEF098FCFA80@AS8PR04MB7974.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEGbN1Eq2VvIaizklDUCCUstXIlLxxolPk4k90WUlbGfYtcgsO4idHSsvffWuU65aI52f2b7UaNrgxkiyrJn3d+LxhS9qu5SANqGJPSd1ZUSqsusaoaZ9T1SOMJGCsbhAjH5XSnFB7uucpSI8E3GE/ZvpGf8kI81bYdpcj1CKxMFZufFybDcvHUUnXp8rpji7MfDXlcfke+3BFPPfNA++9Wwu20wdg3kiN/zFQayJlu51JWtswyWP+sudaHKZwJStRSvYFqxoJAI1wZPpjQ9D6kXyxKi72dc14qPq9x5Q7CjaEKHhO4WEUC7YnN7ki+bEv/wGjCcJcS9IZc5Rxouw55YRc2p1EzncIv3AXnGW1gOy6pQhuLO8AqLM2SbonQoegchJBKMldWlRtzshz5cpYe/RAXM/Db7mPPGR9q7hqH3OCXROGDIvsTpICauuRc78dskX2bRk55GDHkFH8lCCl2RDP9syysRHnp45IzrVbDdUUuo5fc7ne25tg2kxNmHlaHiZb3YeMZRIVSLVRhTZZcqik6KmlKAWW2H9lo+IojrzK6IsFqsewgA7OosReoeWjg6Ywf0QPuT9r/lQcAROo1jZHgFRSM/JLjRlpzv6X7vsNfLJ5SeMZUALKjoH1FONUdnrDVuUPqCKw30EnaBNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(2906002)(66476007)(316002)(956004)(83080400002)(478600001)(36756003)(66556008)(8676002)(86362001)(16576012)(2616005)(15974865002)(26005)(83380400001)(52116002)(8936002)(16526019)(31696002)(186003)(6486002)(53546011)(66946007)(6666004)(31686004)(4326008)(66574015)(5660300002)(13296008)(37363001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KWB3d1xd+yZp4SZdUenRRhrr8rQMsdO+KrdfKovrNgN3rxnMWQzumux0nSGs?=
	=?us-ascii?Q?hT4vO+E+Yxpd1e5IXKvaZNZTfXFf7fFAq2jMRRe0mRt9axkCX8r2w7kQoWi8?=
	=?us-ascii?Q?/cex4/A0oh83KIpssTohDvtqKM4cFPXZ/pRV5kNdlpvpiq5Uh9QIuw73Yyk1?=
	=?us-ascii?Q?XTRB2uZtsSQ4onFsk2M4t5Y9nQaEmHGYXgtGXF1S+fnx3qqSrIoR6/SkIKwM?=
	=?us-ascii?Q?dbXG+PvmcvAEqeJADscIkaweS6N8+XKsjvZLuyQcvZ0NimGR9/QCjTlzJEtd?=
	=?us-ascii?Q?1PhlFaReY8hdNon4dl9ZBCrn0pJXYep0LVG9itX0uzEStwlQbu8zYnKrdRux?=
	=?us-ascii?Q?VV5Ta/QNKQNfrDbK40hr3mMztwpPJR5duz0bf5IxAWtkX5VTCtVVvq0iLySs?=
	=?us-ascii?Q?lIpv0fXoAWlEWvg2cV7VIcXtn5YOjz6Vf/6B0B4/kBFSKvFr8eIwAV0wJWht?=
	=?us-ascii?Q?iZerfIG7IR5Npmhy2VB5c6SlVRLnv7E4C+eLvtFuY0iut3hLJi4XMhy3r7/Q?=
	=?us-ascii?Q?sgYig4qt8sZbm29/zn1kxH+aerojRn/hDjc40ufiR5sJS27wSJme8R/aJcfA?=
	=?us-ascii?Q?6XwuUtpdSfRSUQ2Ppxx7raCy+bhipmqJ97bafRZGK9EhXYt4QYYKDeLeUvSL?=
	=?us-ascii?Q?LDt5+jfy4prFGfK2qi64LSsDs6TRLkAm6w5RJgoYrNoBuM7Gn008EBtT1fyY?=
	=?us-ascii?Q?WRWsquBXjs8jdp0iulkWlZ/WNPx6Lz28QjHYfQjHMoVOd7aDl5etJ9lrQUDK?=
	=?us-ascii?Q?FUo1SCxRvgY54zIFgC9DmX2U26N0P9AR4y1AHivGp6VhfNHimSNFaQ2m47P6?=
	=?us-ascii?Q?SNqArSfhsfJDHPCePc3mGrP/fzsnA4pcxrud4eAgd2OMag6C9Y+gVJAPYeA6?=
	=?us-ascii?Q?+X6bzKM4J0OGtPYpps07pDqWUHjSTASNQ1L26IsKx0nyS9VJeHuWZvM9RdVl?=
	=?us-ascii?Q?7iGwrJAWgXbGNu1hiJbNW1HiA8m/H9Tbl/vk69Y804RYYX7QbP7aHA2cCFmD?=
	=?us-ascii?Q?H4tD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 01:50:50.9663 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f64481ef-e7b5-40e5-9a03-08d8b82ed261
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0tI9DYjVBbM3xIeGv3CW7CGuAFb+0QAbjF1TdVJW86G/wFOTiMllD3MAhbnrFzI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7974
X-PDR: PASS
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=174
	lowpriorityscore=0
	phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
	malwarescore=0
	priorityscore=48 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101140004
X-Spam: Clean
Cc: OCFS2 ML <ocfs2-users@oss.oracle.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140005

SGkgTGVudGVzLAoKc2VlIG15IGNvbW1lbnRzIGlubGluZS4KCk9uIDIwMjEvMS8xMyAyMTo1OCwg
TGVudGVzLCBCZXJuZCB3cm90ZToKPiAKPiAtLS0tLSBPbiBKYW4gMTMsIDIwMjEsIGF0IDM6NDIg
QU0sIEdhbmcgSGUgZ2hlQHN1c2UuY29tIHdyb3RlOgo+IAo+PiBIaSBMZW50ZXMsCj4+Cj4+IHlv
dSBjYW4gdXNlICJvMmluZm8gLS1maWxlc3RhdCB5b3VyZmlsZSIgdG8gaWRlbnRpZnkgaG93IG1h
bnkgZGF0YQo+PiBjbHVzdGVycyBmb3IgYSBjbG9uZWQgZmlsZSBhcmUgc2hhcmVkIHdpdGggdGhl
IG9yaWdpbmFsIGZpbGUuCj4+IE9mIGNvdXJzZSwgdGhlIGNsb25lZCBmaWxlIGRvZXMgbm90IHNo
YXJlIG1ldGEtZGF0YSBibG9ja3Mgd2l0aCB0aGUKPj4gb3JpZ2luYWwgZmlsZSwgb25seSBzaGFy
ZXMgdGhlIGRhdGEgY2x1c3RlcnMuCj4+IGUuZy4KPj4gZ2hlLW5kMTovcmVhci90ZXN0ICMgbzJp
bmZvIC0tZmlsZXN0YXQgZGQuMS5yZWYKPj4gICAgRmlsZTogZGQuMS5yZWYKPj4gICAgU2l6ZTog
ODU4OTkzNDU5MiAgICAgIEJsb2NrczogMTY3NzcyMTYgICBJTyBCbG9jazogNDA5NiAgIHJlZ3Vs
YXIgZmlsZQo+PiBEZXZpY2U6IGZlMDBoLzY1MDI0ZCAgICBJbm9kZTogMzU1ODQ0ICAgICAgTGlu
a3M6IDEKPj4gICBGcmFnJTogMC4wMSAgICAgICAgICAgIENsdXN0ZXJzOiAyMDk3MTUyICBFeHRl
bnRzOiAxNTcgICAgU2NvcmU6IDIKPj4gU2hhcmVkOiAyMDk3MTUyICAgICAgICAgVW53cml0dGVu
OiAwICAgICAgIEhvbGVzOiAwICAgICAgICBYYXR0cjogMAo+PiBBY2Nlc3M6ICgwNjQ0Ly1ydy1y
LS1yLS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6ICggICAgMC8gICAgcm9vdCkKPj4g
QWNjZXNzOiAyMDIxLTAxLTEzIDEwOjA4OjA2LjU2MTk2ODMwNCArMDgwMAo+PiBNb2RpZnk6IDIw
MjEtMDEtMTMgMTA6MDc6NTIuNzQ2NDI2NjEKPj4gQ2hhbmdlOiAyMDIxLTAxLTEzIDEwOjA3OjUy
Ljc3OTU4MTYzCj4+Cj4+IFBsZWFzZSByZWZlciB0byAiU2hhcmVkOiAyMDk3MTUyIiBpdGVtLgo+
Pgo+IAo+IEhpIEdhbmcsCj4gCj4gdGhhbmtzIGZvciB5b3VyIGluZm9ybWF0aW9uLgo+IAo+IGkg
ZGlkIGl0Ogo+IAo+IGhhLWlkZy0xOi9tbnQvb2NmczIgIyBvMmluZm8gLS1maWxlc3RhdCByZWZs
aW5rL3ZtX2Ftb2sucmF3Cj4gICAgRmlsZTogcmVmbGluay92bV9hbW9rLnJhdwo+ICAgIFNpemU6
IDg4MDQ2OTM0Mzc0NCAgICBCbG9ja3M6IDE3MTk2NjY2ODggSU8gQmxvY2s6IDQwOTYgICByZWd1
bGFyIGZpbGUKPiBEZXZpY2U6IGZlMTNoLzY1MDQzZCAgICBJbm9kZTogNTgzOTUzICAgICAgTGlu
a3M6IDEKPiAgIEZyYWclOiA2LjYwICAgICAgICAgICAgQ2x1c3RlcnM6IDgzOTY4MSAgIEV4dGVu
dHM6IDU1NDMxICBTY29yZTogNwo+IFNoYXJlZDogODM5NjgxICAgICAgICAgIFVud3JpdHRlbjog
MCAgICAgICBIb2xlczogMCAgICAgICAgWGF0dHI6IDAKPiBBY2Nlc3M6ICgwNjQ0Ly1ydy1yLS1y
LS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6ICggICAgMC8gICAgcm9vdCkKPiBBY2Nl
c3M6IDIwMjEtMDEtMTIgMjM6MTg6MDcuOTIwNDA1MjIxICswMTAwCj4gTW9kaWZ5OiAyMDIxLTAx
LTEyIDIyOjQwOjA3LjgwNjc1ODQ2MCArMDEwMAo+IENoYW5nZTogMjAyMS0wMS0xMiAyMjo0MDow
OC40MDQ2NjA5NDggKzAxMDAKPiBoYS1pZGctMTovbW50L29jZnMyICMKPiAKPiBoYS1pZGctMTov
bW50L29jZnMyICMgbzJpbmZvIC0tZmlsZXN0YXQgdm1fYW1vay5yYXcKPiAgICBGaWxlOiB2bV9h
bW9rLnJhdwo+ICAgIFNpemU6IDg4MDQ2OTM0Mzc0NCAgICBCbG9ja3M6IDE3MTk2NjY2ODggSU8g
QmxvY2s6IDQwOTYgICByZWd1bGFyIGZpbGUKPiBEZXZpY2U6IGZlMTNoLzY1MDQzZCAgICBJbm9k
ZTogODI1NzgyMSAgICAgTGlua3M6IDEKPiAgIEZyYWclOiA2LjYwICAgICAgICAgICAgQ2x1c3Rl
cnM6IDgzOTY4MSAgIEV4dGVudHM6IDU1NDIxICBTY29yZTogNwo+IFNoYXJlZDogODM2NjY3ICAg
ICAgICAgIFVud3JpdHRlbjogMCAgICAgICBIb2xlczogMCAgICAgICAgWGF0dHI6IDAKPiBBY2Nl
c3M6ICgwNjQ0Ly1ydy1yLS1yLS0pICBVaWQ6ICggIDQ4OC9zcnZHZW9DbHVlKSAgIEdpZDogKCAg
NDg3LyAgICAgbnRwKQo+IEFjY2VzczogMjAyMS0wMS0xMyAxNDoyOTo0My40OTY0MzIxNDQgKzAx
MDAKPiBNb2RpZnk6IDIwMjEtMDEtMTMgMTQ6NDg6MDIuNzQ1Nzk0MzE3ICswMTAwCj4gQ2hhbmdl
OiAyMDIxLTAxLTEzIDE0OjQ4OjAyLjc0NTc5NDMxNyArMDEwMAo+IAo+IFNvbWUgcXVlc3Rpb25z
Ogo+IAo+IFdoYXQgaXMgYSBjbHVzdGVyID8KPiBXaGF0IGlzIGFuIGV4dGVudCA/CkluIHRoZSB0
cmFkaXRpb25hbCBmaWxlIHN5c3RlbSwgYSBmaWxlIGNvbnNpc3RzIG9mIG1ldGEtZGF0YSBibG9j
a3MgYW5kIApkYXRhIGJsb2NrcywgYnV0IGZvciBvY2ZzMiBmaWxlIHN5c3RlbSwgYSBmaWxlIGNv
bnNpc3RzIG9mIG1ldGEtZGF0YSAKYmxvY2tzIGFuZCBkYXRhIGNsdXN0ZXJzLCB0aGUgY2x1c3Rl
ciBzaXplIGNhbiBncmVhdGVyIHRoYW4gdGhlIGJsb2NrIApzaXplIHRvIHNhdmUgbWV0YS1kYXRh
IGJsb2NrIGNvbnN1bXB0aW9uLgpUaGUgZmlsZSBkYXRhIGlzIGNvbnRhaW5lZCBieSBjbHVzdGVy
cywgdGhlIGZpbGUgbWV0YSBkYXRhIGlzIGNvbnRhaW5lZCAKYnkgYmxvY2tzLCB0aGVyZSBhcmUg
ZmV3IGtpbmQgb2YgbWV0YS1kYXRhIGJsb2NrcywgZS5nLiBleHRlbnQgYmxvY2tzIApsb29rcyBs
aWtlIHRvIHN0b3JlIGNsdXN0ZXIgcG9pbnRlcnMuCgo+IFNob3VsZG4ndCB0aGUgbnVtYmVyIG9m
IHRoZSBzaGFyZWQgY2x1c3RlcnMgYmUgdGhlIHNhbWUgZm9yIGJvdGggZmlsZXMgPwpZZXMsIHdo
ZW4gYSBmaWxlIGlzIGNsb25lZCBmcm9tIHRoZSBvcmlnaW5hbCBmaWxlLCBib3RoIGZpbGVzIHVz
dWFsbHkgCm93biB0aGUgc2FtZSBudW1iZXIgb2Ygc2hhcmVkIGNsdXN0ZXJzLgpCdXQgb25lIG9m
IGZpbGVzIGlzIHdyaXR0ZW4gYWdhaW4sIGl0J3Mgc2hhcmVkIGNsdXN0ZXJzIHNob3VsZCBiZSAK
cmVkdWNlZCwgc2luY2UgdGhlIGZpbGUgc3lzdGVtIGhhdmUgYWxsb2NhdGVkIHNvbWUgbmV3IGNs
dXN0ZXJzIGZvciAKdGhlc2Ugb3Zlci13cml0ZS4KClRoYW5rcwpHYW5nCgo+IER1cmluZyBydW50
aW1lLCB0aGUgbnVtYmVyIG9mIHNoYXJlZCBjbHVzdGVycyBmb3IgdGhlIHJlZmxpbmsgc3RheXMg
dGhlIHNhbWUsCj4gZm9yIHRoZSBvcmlnaW5hbCBmaWxlIGl0J3MgcmVkdWNpbmcuIElzIHRoYXQg
ZXhwZWN0ZWQgYmVoYXZpb3VyID8KPiAKPiBCZXJuZAo+IEhlbG1ob2x0eiBaZW50cnVtIE3DvG5j
aGVuCj4gCj4gSGVsbWhvbHR6IFplbnRydW0gTXVlbmNoZW4KPiBEZXV0c2NoZXMgRm9yc2NodW5n
c3plbnRydW0gZnVlciBHZXN1bmRoZWl0IHVuZCBVbXdlbHQgKEdtYkgpCj4gSW5nb2xzdGFlZHRl
ciBMYW5kc3RyLiAxCj4gODU3NjQgTmV1aGVyYmVyZwo+IHd3dy5oZWxtaG9sdHotbXVlbmNoZW4u
ZGUKPiBBdWZzaWNodHNyYXRzdm9yc2l0emVuZGU6IE1pbkRpci5pbiBQcm9mLiBEci4gVmVyb25p
a2Egdm9uIE1lc3NsaW5nCj4gR2VzY2hhZWZ0c2Z1ZWhydW5nOiBQcm9mLiBEci4gbWVkLiBEci4g
aC5jLiBNYXR0aGlhcyBUc2Nob2VwLCBLZXJzdGluIEd1ZW50aGVyCj4gUmVnaXN0ZXJnZXJpY2h0
OiBBbXRzZ2VyaWNodCBNdWVuY2hlbiBIUkIgNjQ2Ngo+IFVTdC1JZE5yOiBERSAxMjk1MjE2NzEK
PiAKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2Zz
Mi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9v
c3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
