Return-Path: <SRS0=G199=HA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDCDC433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 07:53:07 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B742B64E02
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 07:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B742B64E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10T7ihpw050086;
	Fri, 29 Jan 2021 07:53:05 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 368brkyry9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Jan 2021 07:53:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10T7ntm7056165;
	Fri, 29 Jan 2021 07:53:04 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjv6ccd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Jan 2021 07:53:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5OUO-0003mR-UI; Thu, 28 Jan 2021 23:46:44 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1l5OUL-0003ls-CX
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 23:46:41 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10T7jv9P046667
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 07:46:41 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 368wjv64e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 07:46:40 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10T7iQXg009710
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 07:46:40 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102])
	by userp2030.oracle.com with ESMTP id 36cb5y26kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 07:46:39 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2110.outbound.protection.outlook.com [104.47.18.110])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-6-HLU-IxIuP0yxxlCoYeyNxw-1; Fri, 29 Jan 2021 08:46:35 +0100
X-MC-Unique: HLU-IxIuP0yxxlCoYeyNxw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=MOCKCyUG7y8uI5e7xbpswDk7Q6DyuQ8uWfaYs53BEwMsw2ZeMZIeHdnrfiOoFYF/rRrRwsHGGsFOhZRpT6P0Xmv8k/nCWDigPQM6jvqGraVoTDj5IJ16tkCfUD6txunSPDYkoUeznVMGSCWcr7+W/wgB+eA5HNPEHs9tsd6wlID9ns21x78n+xEj+5J7Vs+VSNizwDdhA7iJQuPgNbxAey94xeqe55P781Vs9tRpHeNQ6bpBncBWI7HO+b9kuErDaJMG16gjX13OsSXLK7oBX1mzL1AdJDRRg4q+wEMWPjuUlvS3osdrRi1qQYX9HFHWfOtmNVsQjPCd9lV6htsOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=4+8EMLBZE0vLJB96NvBlKVDLBx38RnPIJOub/lpr5oY=;
	b=Vwobi3ZiG/vrxmtaWsixlDbFlYaZlfHjzxM9ULwMhCddP0C50lI0T5Ba7vfhtk2hWpSts2fUJrWBlFMiNxFhU/zrhn2d5DeKgqtf+Raa4+kGlleTkZCtAvLVdv7cB1L31sutmbqAfQt2utTPCGecCRitYIic/G6VfWbiNqvmk34OfnoqryTC+mcJRiiPEQ2DFw8QB2QT3jxtqymytn6t082wO6N2l5dYUMGVEb6hCYLP50j2KSmrkDim3fMlUgDsS6muZYkqv5Do9rP4Y3SVN9FN2kd28rqQIEy8UbwYR3aMevcoWHlB0UM+uQ4nwW/+SrcS+CKNlEewZ7Aeeo2CuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM0PR04MB6484.eurprd04.prod.outlook.com (2603:10a6:208:178::32)
	by AM0PR04MB5811.eurprd04.prod.outlook.com (2603:10a6:208:133::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11;
	Fri, 29 Jan 2021 07:46:34 +0000
Received: from AM0PR04MB6484.eurprd04.prod.outlook.com
	([fe80::6876:fb96:31c1:e656]) by
	AM0PR04MB6484.eurprd04.prod.outlook.com
	([fe80::6876:fb96:31c1:e656%3]) with mapi id 15.20.3784.019;
	Fri, 29 Jan 2021 07:46:33 +0000
To: Herbert Van Den Bergh <herbert.van.den.bergh@oracle.com>
References: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
From: Gang He <ghe@suse.com>
Message-ID: <ce23a917-0cb1-065a-59b1-3e4789fb0d79@suse.com>
Date: Fri, 29 Jan 2021 15:46:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.1
In-Reply-To: <3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
Content-Language: en-US
X-Originating-IP: [111.205.14.62]
X-ClientProxiedBy: HK0PR01CA0055.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::19) To AM0PR04MB6484.eurprd04.prod.outlook.com
	(2603:10a6:208:178::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.105] (111.205.14.62) by
	HK0PR01CA0055.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::19) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.3805.16 via Frontend Transport;
	Fri, 29 Jan 2021 07:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf34208d-89ec-4ec0-424b-08d8c429ffdc
X-MS-TrafficTypeDiagnostic: AM0PR04MB5811:
X-Microsoft-Antispam-PRVS: <AM0PR04MB5811466C8DF3EF826D001D1BCFB99@AM0PR04MB5811.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DkBGHJSFfedzR91PpAYm8c/06Ld+mGz87xBiDkrcTm9QlbGsiJQuhF0JX2WM93XX5GxZBepk91HPjwihW930ma3TOCCrgiHxfGNt7s1ILq3LnrZ6qiMXjE6T+w0ckiRbQ/3mCOLMKGoO6RZV23RWzisnNY+3nvO//CUELrlg7dzK8OG0SWtG4xGyzM+Ql5EJ1vlydewdoULIsIFCvnN3Xr0lGz48YwK7HANLWL60Bc0kPuQ2nsm805a4ifTI5ZPgPKTXb+bR1z+ejuBgnA2O4zX22+0VduT+qevB4Z4sFT5apV1lY0NWUNs7DJWPO5odGIO52hEuBfxkYUVqZbWldyH6mhHP0kTu2x3LMFS/0MI8tPUbIm5cGlCSF2QKjopaKL/EznHzyZawNfBLMvvrWVzZ107Oc5nYdeX6i4Aslkf9ZmzD3BedxfK3r1j7ZDCZ2zHUXDCblQx9hotFPm0B+0/K5jZMbuAmXo/MdFi72HKlcs2xHxs75LTL12KmxBhGqkvjRG4t72+Ny6/POGuXGf0QQDjXzNnX8Pe8+RrOF0b02VXzyeO93PHQA4raOUs/R8BI4CDnem3QzKV5mcIYZlhOxyMyyUyYcNrKxlZ7g+KiHwKW3K/2gwLNsW0DbKA0pFcd2cgSpvVD0KRQXqIN0coeJ70wofP0I6INthE5b6Ablt5oNHHw6Sly3labHgJ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM0PR04MB6484.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(136003)(376002)(396003)(39860400002)(366004)(346002)(16576012)(966005)(4326008)(31686004)(8936002)(8676002)(54906003)(6916009)(66946007)(16526019)(83380400001)(316002)(52116002)(31696002)(86362001)(6666004)(186003)(4744005)(2616005)(53546011)(36756003)(26005)(66476007)(5660300002)(6486002)(66556008)(478600001)(956004)(2906002)(13296008)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VAbQ1m4M7aIn9Q8sl6cwe1yGPGqJYaqbePaIqRD9wO+30C8KWEkl67Fp1vYd?=
	=?us-ascii?Q?2RvT8XjiPZ0daYHK9o2CE/mCBHc3T2MHJaAwHloVsHh84SEwLvCdJYVGgvvJ?=
	=?us-ascii?Q?1SkBZhwNL0WrCOwxWYzj0CVSQYy96aVFzxIV6OfwwfDVfbb9etQolU5c8GYD?=
	=?us-ascii?Q?J666e6ROVT/Q3FR/9X2+0nz2E14kE9YCsrPXTPvJ5uaU0XEPzkSL0mchngI2?=
	=?us-ascii?Q?3zW0n7y20rXk4BSYloF44j2gXqXwR7M1Hfl6nBMAhoy/u+WTR9xcclFo4MUS?=
	=?us-ascii?Q?6E8moDFVI8ik4lk2BnZB/Z0aLd9VJlpt+ajKzKW37YFB/M9eSa6a3k4X2CtI?=
	=?us-ascii?Q?/biT9J92gKGvCTM6CjHEMxWSpRZSB5e2c1mP7w2EH1FLM5uOQvssRmcOrUlW?=
	=?us-ascii?Q?sbhsphnJngMOmUxfftoGu4K99ipS4+IwVmiQ4xdsUg+3AJa56iukkEuEnxgW?=
	=?us-ascii?Q?dW/kZ/XWLYAup1I+h6pHpVh1ps7WOwhY7ZmxYCFTY48eYdIQRF0UlWYDz103?=
	=?us-ascii?Q?oARFdw+WZPvG48rwoaBQaE9XJ7OGDr+naiBxPBvY0nbrUKnwHfUraluPpBal?=
	=?us-ascii?Q?N73XVTeBTmkhZ6hgIUogNJXYN2r7IknpECAgi/EDRWimkpdDJFGnuEiBgAWx?=
	=?us-ascii?Q?jDioy+zsFXTitsdciP+JyC1/woIo1u6BCl+VFh1XKBq7PsgtAFSkJ/HXD7gq?=
	=?us-ascii?Q?WC9BVgSQQYZMT3lkLMwZu+vdSaLnQYgzmBeP2cVQNMucuv8fS3YNsclOg7i+?=
	=?us-ascii?Q?FhBPOLTjhdznsaa3/gJS1M+XIVjLfq5XoCjThWBgV6Ry85ootcmKyfr/5pSn?=
	=?us-ascii?Q?+a+hEb+z+/TJbV2ReQcaGWwTusNLuMndSRNM/m7kSemSjhH81ZmxJ9viCweO?=
	=?us-ascii?Q?sfG9FlS3zCwMZukXtruLESlWjC5jNvpXUjn2Fo73mBLOq5jmketmE99wgTeZ?=
	=?us-ascii?Q?Uh9HLyMkUUlEQKR98F3O4DkZ3s7x28W1fv+9EOqY2Dl4YTBqxzIw7D3ZDHnT?=
	=?us-ascii?Q?xzc6DJ9TizcoRNY7wF4YGAslzrct7paFH8Sb94QDzHxbff9v0kC4wG0gjB+b?=
	=?us-ascii?Q?zazrIa4q?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf34208d-89ec-4ec0-424b-08d8c429ffdc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6484.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 07:46:33.9502 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWsZvfsmcJ+lrplBpXfu1VwtMHDob725SSh1ufGGy8fkSflg1ztuygkQSMdZCgyB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5811
X-PDR: PASS
X-Source-IP: 62.140.7.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	adultscore=0
	malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
	mlxlogscore=999
	phishscore=0 spamscore=0 suspectscore=0 clxscore=243 priorityscore=30
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101290040
X-Spam: Clean
Cc: "ocfs2-tools@oss.oracle.com" <ocfs2-tools@oss.oracle.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] About the status of reflink-tools
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290041
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290040

SGkgSGVyYmVydCwKCgpPbiAyMDIxLzEvMjkgMTU6MzMsIEhlcmJlcnQgVmFuIERlbiBCZXJnaCB3
cm90ZToKPiBIaSBHYW5nLAo+IAo+IFRoZSByZWZsaW5rIGZ1bmN0aW9uYWxpdHkgaGFzIGJlZW4g
bWVyZ2VkIGludG8gdGhlIGNvcmV1dGlscyBwYWNrYWdlL3Byb2plY3QuIFRoZSBjcCBjb21tYW5k
IG5vdyBoYXMgYSDigJRyZWZsaW5rIG9wdGlvbi4gQ2hlY2sgaXQgb3V0LiBJZiB0aGlzIGlzbuKA
mXQgd2hhdCB5b3XigJlyZSBsb29raW5nIGZvciwgdGhlbiBwbGVhc2UgZWxhYm9yYXRlLgpGb3Ig
dGhlIG90aGVyIHRvb2xzLCBlLmcuIHNoYXJlZC1kdSwgc2hhcmVkLWZpbGVmcmFnLCB3aGVyZSBk
byB5b3UgCmRvd25sb2FkIHRoZSByZWxhdGVkIHNvdXJjZSBjb2RlPyBzdGlsbCBjb3JldXRpbHM/
IHRoYXQgbWVhbnMgdGhpcyBwYXJ0IApjb2RlIGlzIGluY2x1ZGVkL21haW50YWluZWQgYnkgY29y
ZXV0aWxzIHByb2plY3Q/CgoKVGhhbmtzCkdhbmcKCj4gCj4gVGhhbmtzLAo+IEhlcmJlcnQuCj4g
Cj4+IE9uIEphbiAyOCwgMjAyMSwgYXQgNjo1OSBQTSwgR2FuZyBIZSA8R0hlQHN1c2UuY29tPiB3
cm90ZToKPj4KPj4gSGkgR3V5cywKPj4KPj4gWW91IGtub3csIG9jZnMyIHJlZmxpbmsgcmVsYXRl
ZCB1dGlsaXRpZXMgd2VyZSBtYWludGFpbmVkIGJ5IGEgc2VwZXJhdGVkIHByb2plY3QgcmVmbGlu
ay10b29scywKPj4gV2hhdCBpcyB0aGlzIHByb2plY3QncyBzdGF0dXM/IGUuZy4gd2hvIGlzIG1h
aW50YWluaW5nIGl0LCB3aGVyZSBjYW4gd2UgZG93bmxvYWQgdGhlIGxhdGVzdCBzb3VyY2UgY29k
ZT8KPj4KPj4KPj4gVGhhbmtzCj4+IEdhbmcKPj4KPj4gX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KPj4gT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Cj4+IE9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCj4+IGh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbAo+IAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2Nm
czItZGV2ZWw=
