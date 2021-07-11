Return-Path: <SRS0=ixA/=MD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588D6C07E96
	for <ocfs2-devel@archiver.kernel.org>; Sun, 11 Jul 2021 09:23:07 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC95F61205
	for <ocfs2-devel@archiver.kernel.org>; Sun, 11 Jul 2021 09:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC95F61205
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16B9HDab019546;
	Sun, 11 Jul 2021 09:23:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39q25095kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 11 Jul 2021 09:23:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16B9Kk3T013887;
	Sun, 11 Jul 2021 09:23:04 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39qnaqw6bc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 11 Jul 2021 09:23:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m2Vfz-0003IQ-63; Sun, 11 Jul 2021 02:23:03 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1m2VfV-0003HT-0N
	for ocfs2-devel@oss.oracle.com; Sun, 11 Jul 2021 02:22:33 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16B9KL76022304
	for <ocfs2-devel@oss.oracle.com>; Sun, 11 Jul 2021 09:22:32 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 39q0nw4aky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 11 Jul 2021 09:22:31 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16B9IExx008696
	for <ocfs2-devel@oss.oracle.com>; Sun, 11 Jul 2021 09:22:30 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 39q34480r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 11 Jul 2021 09:22:30 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2057.outbound.protection.outlook.com [104.47.2.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-37-KQU2VRT8NF-2ykkC0RPEqQ-1; Sun, 11 Jul 2021 11:22:26 +0200
X-MC-Unique: KQU2VRT8NF-2ykkC0RPEqQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=TCpvVRi8ms7PXos2DaIZ9/Ahz0f9OvvWQw9kztg++H29nRZwo+TYPy8Evk4XIw6gbMMprxkFe/aCDxuqFK9q6DHYd7UEmHkJp44vrJugmbsmx93LSLxuA1/VD1EnEgm4LnMEISz5fx50UIXsZtvIe4lZ++qRZkGGQuzZAAOBdJ4cllpfm+7n/JtTYxFvCQh8yIaFMThhr3GdN4EkaRSpii3/GBttAYKQU1W5duCCtoEJd0pQNQWZJQDnlnPKXDFl9rZ4ddL2sOZ+yRuYyIv0fYK9PtdMMX72KZ9d+8yNGKBvFpK5OwyFlmNgp1fRHXg5SYWdiERMFtkpHBN2aT6kbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=evcIftyL/81675TeW3QAMD4XalXuSKU4AlmC2KOTvck=;
	b=RnRfx2gNY1RHcoA5hq46MDKdfwKm/+0ejLaYJAYgBMiwIQfeJKnSRNS+lkEKQSCNvGbRKtZcT7W9jBnr9j7DwaFDGgxtUvMME/WF4RZcw5f+Kzq8SpIBHpbLJ+2HnsARabUaLGqmWVUIuDuIaWOXGrpAPGnBGkL7yZb7zfsJ3v2iEle7A7OSJySJB6roVuQjWM1QJiGXmlPNErxBHnOEdCb0FTot+clxYgGmRdoQGG4l5+Z/vkXszciD/XNSjYHVt2qRkOkfgnf/iquUCvMqi+CitPJn+8xE0aJB+3mYvF1XvNo9Z5WuYQ1KiaAg7ppSEXYXCvc9nZ8lfmNHSkKQ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (20.179.245.213) by
	AM5PR0402MB2708.eurprd04.prod.outlook.com (10.175.41.139) with
	Microsoft SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4308.19; Sun, 11 Jul 2021 09:22:24 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa%6]) with mapi id 15.20.4308.026;
	Sun, 11 Jul 2021 09:22:24 +0000
From: Gang He <GHe@suse.com>
To: Wengang Wang <wen.gang.wang@oracle.com>, Joseph Qi <jiangqi903@gmail.com>
Thread-Topic: [Ocfs2-devel] Find one ocfs2 hang between reflink and
	ocfs2_complete_recovery
Thread-Index: AQHXbmbcfMC68VOsR0OBZt0+1Pe7Rqs2zhWAgADzwYCABc2NVw==
Date: Sun, 11 Jul 2021 09:22:24 +0000
Message-ID: <AM6PR04MB64885311DEFBFF83BEFB82C1CF169@AM6PR04MB6488.eurprd04.prod.outlook.com>
References: <AM6PR04MB64888A5193ED47F1E8081287CF009@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<2b642f36-e118-7bff-8115-3854ab4fbb7e@gmail.com>,
	<DAD97C28-EAAC-440D-97CA-85E38BAE6C84@oracle.com>
In-Reply-To: <DAD97C28-EAAC-440D-97CA-85E38BAE6C84@oracle.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
	header.d=none; oracle.com; dmarc=none action=none header.from=suse.com; 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 526bec7b-9aa2-457f-1dbf-08d9444d64ea
x-ms-traffictypediagnostic: AM5PR0402MB2708:
x-microsoft-antispam-prvs: <AM5PR0402MB27084C0924DA0441BD4CA12ECF169@AM5PR0402MB2708.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RWpY2JWz4YhhqM/7m/CHAN9azV8GgwKxab4FFij9Xly79TMyMQEL+SSDHOChe3LYlB8ETHAI/HYRDv87qhm6BPrWHv3UetZx+X3vISsfojDTPa4Rfpxlbcsx1ZtNA6XSKQZ8c0S6F7nql6KijBpNJwUzV65Ivg56vue+n4PBidSAFw2GoFMnwmERMspUndG03bmxxN/V+3w+nScMq9/QZQCPFA0jkyYnaY9fvUYCX+I/KjKhkoXg0EKXyos9rrIelFmjmZNt9VOMwvyMKAnx++0X5UypJLG2Wf0ZQAr22XPrEOK5sfm7pAayecgIiHlj5xQLT8ettJqKW/CypR/a9v0HXDfVsC6idCTc5t/UNMfAKnUJdz/G/K+YzPC0mRKZUfFDgbnuOmL6mIyBC0NCfIvuTUcJzpUvWxb/jXcX6otT9VS0NGH48Y7X2DfHqC9xIlVN5CPtwzn72ctTiUDnc2ckcZ4vzJdkCfz00xfKTOIefltH/L4y6aigtQBHGVfxILz3DOOm/Mzey19CQ5fdOlflRl40KoqLRyiagEckVEYTbhY7rHr1Nt/6fZUeSVswPp41/dAIhF5jl9sdS4gfckY3/VonTfM5roLmbqItbiIg3bKhE6/oWOUEPC5vWHgr9//enkbL/XuSlU0TKZAOez14Mo9ropJXWTRhj+XilAanEuif3wZFevG+pAlWpnok4aP3r00bS/BnTqZqkmhM2/ieyMIIepypfZJ23RNBQy0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(346002)(136003)(396003)(376002)(366004)(39850400004)(64756008)(66446008)(91956017)(2906002)(7696005)(478600001)(76116006)(71200400001)(5660300002)(9686003)(55016002)(66556008)(8936002)(122000001)(66476007)(66946007)(38100700002)(33656002)(186003)(8676002)(4326008)(6506007)(53546011)(966005)(52536014)(86362001)(316002)(26005)(83380400001)(110136005);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXFIUUo2bE1DcUs1ZXBsR1lVNFdTTU43RitobjJnRXpaaW1KeFQ0Kzl4NXVQ?=
	=?utf-8?B?eXdRRXBteHJnQklKVmpPam1rYjlOcGEvQTJRRWUvM0VYTGFaZ0g3QUh1Tjho?=
	=?utf-8?B?c2QxSDVlb0p4UytIWno4ME1jWk1OZUpVQWtBbFpyemhxNzgzMlh3eis2dHkw?=
	=?utf-8?B?OXYveVExb3FSOGpCMGJvZFpBNy9DZWZJRkZTYWhxRTczS1hqWlN6bHRNRXF6?=
	=?utf-8?B?cndoNzloN2I2RzNLY1lTTmszU1UwQUxXTWlQN3poQzF6VzRPVWRsV1ptMzVi?=
	=?utf-8?B?T0dabWZGbFdabG5FUCtLVzd2dGM3TEpFS0tnUTU1dm1RU1NEMHNZdTZzc3lB?=
	=?utf-8?B?MEV4eUhkbzBmYlRSWHJiVmsrWGUrN0ErQTZyc1ZpWEpLenR4OVVCZFBQUUNr?=
	=?utf-8?B?K0JYZitTWklpclhDZ3hsQUFtVVZFdlFOUW01cDJERXFsQjQrMzZHRFphM2F6?=
	=?utf-8?B?L1dIRnBuZS8xakkwL2ljdHY3a2Q5Ykc3Z2l6dWlJQTVCbVlJdDZ1dFo0VENt?=
	=?utf-8?B?SC9xc2M0V1phazRuSGVtUnIrRHFKVk5UMG92QXFwb0JvczNBbUw2VnQ5Nm1z?=
	=?utf-8?B?endabTRWdVFkMkt0YkdmWkRvb0ZQSm95Tmk5WXFmdXZQa3NBbTRuWjRyN3FZ?=
	=?utf-8?B?eXhRRUdEOG45bkFCSDhMM3JXa3N6cEN6VlQ5WXZ1ZUpNa0xNcGhiRU95dHlQ?=
	=?utf-8?B?NWFtUWRTMStBQ2dhS0JBdXlGMzlXU1hkNnpKa001RWkxZkYyTnhDVFczbFJJ?=
	=?utf-8?B?V0FIaGRlNG9URE8xenUwNjJTM2VOWkRSaWlIQVBGQ3pRQ3drOUJwZ3VveURz?=
	=?utf-8?B?a1dLd3dMRGpBUUs2aUxCdVhVcDdHVThqUmhXS1BRZEF6b0F6bHRHeXYrSGdF?=
	=?utf-8?B?T1kxZkdHdTlHdEE1NERDRjk3LzRNL25aUDkzV2hVMmRBZ1VhTkxQN1NnZnh6?=
	=?utf-8?B?cU55UG0vVWlueGRLRnhOVFJLUUN4SVZWT1RiUUhhQ2dUR3ZCakdYR01xQS9T?=
	=?utf-8?B?V1ZNWVh6cFNNREREbDNjVWRmMFBzemQzb003UEZPckdZMnU2QWZscXY0T1RE?=
	=?utf-8?B?QXhCUG55cy83MGRMVng3Smt1b1E5eHpwMTZBR2xodEdHVmRIdkc2b1Fta3RJ?=
	=?utf-8?B?SXBCRjlsR01pcHFsTHRja0lZUSttdTNHMGE3dlpBZThDOFRaU2doSXZVUXE1?=
	=?utf-8?B?Mml6NVBuemd4SkVadjdLdEJ6dUFCSXplN2RLTTBmMXA1SGJtaUFQUW5VbzBI?=
	=?utf-8?B?bkFFdGxqYitueC83UmVwTUMvbmNGaXc1SkhJQkJybWhBaFJxMEZBODBpdWY0?=
	=?utf-8?B?cks2M2VLNkJOSm1RelN3bjZlamMxVVhIRGFlVjMyTkdpLzJQeW5WZy9Tai9E?=
	=?utf-8?B?d0dJTDc3ZEFpWXZnREgvK21jNVAveVVVTFJNcUI4bU9VdVBkWkMvUUNPZ3VM?=
	=?utf-8?B?M1JHZnhQc05Fc2tVMXlKM2hWSGVnRGNIWEFBK1B3NG9oU2EycGpYWDhRQ1Rp?=
	=?utf-8?B?VGJPUHgvaWVFck80c3l5ay9nV1ZUbnlJaFdyd1FGT1c2NEVjK0FKb0FPQ0F3?=
	=?utf-8?B?bGRGTzhGdFMwbUk1ZmpuN05VeEdyanVXbWFnWG1ZU1NXK2ZGVkFOcHp1Z3ZG?=
	=?utf-8?B?REp5ZDQ0U0k1SUJYTDBadExHeGdydFFBcC9iV1NOeHpmbXlxUVNSWnozRENu?=
	=?utf-8?B?Z0UydTBwdFQ4cWlUejBVK0Q3dGNwUGFVY2F1ZXREbmd6aHNRQzllcG1NOXdU?=
	=?utf-8?Q?jr0J3wD0Qx7Y4cva3w=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526bec7b-9aa2-457f-1dbf-08d9444d64ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2021 09:22:24.5021 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FC7QUUAXgkP/9X2L4hP8ohP/KAsfw6rsQSVr0yP1VUaFVy1+0xgm4i+lH8Tkb0Pi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2708
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10041
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=172
	lowpriorityscore=0
	spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
	mlxlogscore=999 suspectscore=0 priorityscore=143 phishscore=0
	mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107110076
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10041
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0
	phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107110076
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] Find one ocfs2 hang between reflink and
 ocfs2_complete_recovery
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10041 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107110076
X-Proofpoint-GUID: q5mIbXC3XgmCibLMaJBWwK-vrVReC9_z
X-Proofpoint-ORIG-GUID: q5mIbXC3XgmCibLMaJBWwK-vrVReC9_z

SGVsbG8gV2VuZ2FuZywKClRoYW5rIGZvciB5b3VyIGluZm9ybWF0aW9uLgpUaGF0IHBhdGNoIGxv
b2tzIHZlcnkgc2ltaWxhciB3aXRoIHRoZSBwcm9ibGVtLgpJIHdpbGwgdmVyaWZ5IGl0IHdpdGgg
dGhlIHBhdGNoLgoKVGhhbmtzCkdhbmcKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KRnJvbTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+ClNl
bnQ6IFRodXJzZGF5LCBKdWx5IDgsIDIwMjEgMDo0NApUbzogSm9zZXBoIFFpCkNjOiBHYW5nIEhl
OyBvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpTdWJqZWN0OiBSZTogW09jZnMyLWRldmVsXSBG
aW5kIG9uZSBvY2ZzMiBoYW5nIGJldHdlZW4gcmVmbGluayBhbmQgb2NmczJfY29tcGxldGVfcmVj
b3ZlcnkKCgoKT24gSnVsIDYsIDIwMjEsIGF0IDc6MTEgUE0sIEpvc2VwaCBRaSA8amlhbmdxaTkw
M0BnbWFpbC5jb208bWFpbHRvOmppYW5ncWk5MDNAZ21haWwuY29tPj4gd3JvdGU6CgpIaSBHYW5n
LApDb3VsZCB5b3UgcGxlYXNlIGRlc2NyaWJlIHRoZSBpc3N1ZSBpbiB0aGUgZm9sbG93aW5nIHdh
eT8KCk5vZGUgMSBOb2RlIDIgTm9kZSAzCi4uLgouLi4KLi4uCgpUaGF0IHdvdWxkIGJlIG1vcmUg
Y2xlYXJseSBmb3IgZGlzY3Vzc2luZy4KClRoYW5rcywKSm9zZXBoCgpPbiA3LzEvMjEgNjo1NiBQ
TSwgR2FuZyBIZSB3cm90ZToKSGkgR3V5cywKClRoZXJlIGFyZSB0aHJlZSBub2RlIG9jZnMyIGNs
dXN0ZXIsIHdoZW4gdGhlIHVzZXIgcnVuIHJlZmxpbmsgY29tbWFuZCBkdXJpbmcgb2NmczIgbm9k
ZSBkb2VzIHJlY292ZXJ5KGUuZy4gb25lIG5vZGUgaXMgZmVuY2VkKS4KClRoZSBoYW5nIHByb2Js
ZW0gd2FzIGNhdXNlZCBkbG0gZGVhZCBsb2NrIGJldHdlZW4gcmtzYXBoMTggYW5kIHJrc2FwaDE5
LCB0aGUgZGV0YWlsZWQgcHJvY2Vzc2VzIGFyZSBhcyBiZWxvdywKCkp1biAwMSAxMjozMzoxMCBy
a3NhcGgxOCBrZXJuZWw6IHRhc2s6cmVmbGluayAgICAgICAgIHN0YXRlOkQgc3RhY2s6ICAgIDAg
cGlkOiA3NTE1IHBwaWQ6ICA3NDM5IGZsYWdzOjB4MDAwMDQwMDAKSnVuIDAxIDEyOjMzOjEwIHJr
c2FwaDE4IGtlcm5lbDogQ2FsbCBUcmFjZToKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5l
bDogIF9fc2NoZWR1bGUrMHgyZmQvMHg3NTAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5l
bDogIHNjaGVkdWxlKzB4MmYvMHhhMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAg
c2NoZWR1bGVfdGltZW91dCsweDFjYy8weDMxMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2Vy
bmVsOiAgPyBvY2ZzMl9jb250cm9sX2NmdSsweDUwLzB4NTAgW29jZnMyX3N0YWNrX3VzZXJdCkp1
biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICA/IDB4ZmZmZmZmZmZjMDhmNzAwMApKdW4g
MDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgd2FpdF9mb3JfY29tcGxldGlvbisweGJhLzB4
MTQwCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICA/IHdha2VfdXBfcSsweGEwLzB4
YTAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIF9fb2NmczJfY2x1c3Rlcl9sb2Nr
LmlzcmEuNDErMHgzYjUvMHg4MjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2Vy
bmVsOiAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0K
SnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIG9jZnMyX2lub2RlX2xvY2tfZnVsbF9u
ZXN0ZWQrMHgxZmMvMHg5NjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVs
OiAgb2NmczJfbXZfb3JwaGFuZWRfaW5vZGVfdG9fbmV3KzB4MzQ2LzB4N2UwIFtvY2ZzMl0KSnVu
IDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0
b3JlKzB4MTQvMHgyMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgb2NmczJfcmVm
bGluaysweDMzNS8weDRjMCBbb2NmczJdCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6
ICA/IG9jZnMyX3JlZmxpbmtfaW9jdGwrMHgyY2EvMHgzNjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6
MTAgcmtzYXBoMTgga2VybmVsOiAgb2NmczJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2MCBbb2Nm
czJdCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICBvY2ZzMl9pb2N0bCsweDI1ZS8w
eDY3MCBbb2NmczJdCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICBkb192ZnNfaW9j
dGwrMHhhMC8weDY4MApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAga3N5c19pb2N0
bCsweDcwLzB4ODAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIF9feDY0X3N5c19p
b2N0bCsweDE2LzB4MjAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIGRvX3N5c2Nh
bGxfNjQrMHg1Yi8weDFlMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgZW50cnlf
U1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBo
MTgga2VybmVsOiBSSVA6IDAwMzM6MHg3ZjFiYjJhYWY5ZTcKClRoZSByZWZsaW5rIHByb2Nlc3Mg
aXMgZ2V0aW5nIG9ycGhhbl9kaXJfaW5vZGUob2NmczIgc3lzdGVtIGZpbGUgcGVyIG5vZGUpIGRs
bSBsb2NrIGFmdGVyIGl0IGhhcyBhY3F1aXJlZCB0aGUgcmVmbGluayB0YXJnZXQgZmlsZSBpbm9k
ZSBkbG0gbG9jaywgdGhlIHJlZmxpbmsgdGFyZ2V0IGZpbGUgaXMgcHV0IGluIG9ycGhhbl9kaXJf
aW5vZGUgZGlyZWN0b3J5IGR1cmluZyB0aGUgcmVmbGluayBvcGVyYXRpb24uCgpKdW4gMDEgMTI6
MzM6MTcgcmtzYXBoMTkga2VybmVsOiBXb3JrcXVldWU6IG9jZnMyX3dxIG9jZnMyX2NvbXBsZXRl
X3JlY292ZXJ5IFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogQ2FsbCBU
cmFjZToKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIF9fc2NoZWR1bGUrMHgyZmQv
MHg3NTAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIHNjaGVkdWxlKzB4MmYvMHhh
MApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgc2NoZWR1bGVfdGltZW91dCsweDFj
Yy8weDMxMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9jb250cm9s
X2NmdSsweDUwLzB4NTAgW29jZnMyX3N0YWNrX3VzZXJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgx
OSBrZXJuZWw6ICA/IDB4ZmZmZmZmZmZjMDg2MjAwMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkg
a2VybmVsOiAgd2FpdF9mb3JfY29tcGxldGlvbisweGJhLzB4MTQwCkp1biAwMSAxMjozMzoxNyBy
a3NhcGgxOSBrZXJuZWw6ICA/IHdha2VfdXBfcSsweGEwLzB4YTAKSnVuIDAxIDEyOjMzOjE3IHJr
c2FwaDE5IGtlcm5lbDogIF9fb2NmczJfY2x1c3Rlcl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4MjAg
W29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9pbm9kZV9s
b2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjE3IHJrc2Fw
aDE5IGtlcm5lbDogIG9jZnMyX2lub2RlX2xvY2tfZnVsbF9uZXN0ZWQrMHgxZmMvMHg5NjAgW29j
ZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfZXZpY3RfaW5vZGUr
MHgxOGEvMHg4MTAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgZXZp
Y3QrMHhjYS8weDFiMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfb3Jw
aGFuX2ZpbGxkaXIrMHg5Mi8weDE0MCBbb2NmczJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBr
ZXJuZWw6ICBvY2ZzMl9kaXJfZm9yZWFjaF9ibGsrMHg0YjIvMHg1NzAgW29jZnMyXQpKdW4gMDEg
MTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVk
KzB4NDg3LzB4OTYwIFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIG9j
ZnMyX2Rpcl9mb3JlYWNoKzB4NTQvMHg4MCBbb2NmczJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgx
OSBrZXJuZWw6ICBvY2ZzMl9xdWV1ZV9vcnBoYW5zKzB4ZjIvMHgxZjAgW29jZnMyXQpKdW4gMDEg
MTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBfX29jZnMyX3JlY292ZXJ5X21hcF90ZXN0KzB4
NTAvMHg1MCBbb2NmczJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/IGNoYWNo
YV9ibG9ja19nZW5lcmljKzB4NmMvMHhiMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVs
OiAgPyBvY2ZzMl9yZWNvdmVyX29ycGhhbnMrMHgxMmQvMHg0ZjAgW29jZnMyXQpKdW4gMDEgMTI6
MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfcmVjb3Zlcl9vcnBoYW5zKzB4MTJkLzB4NGYw
IFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogID8gaW50ZXJuYWxfYWRk
X3RpbWVyKzB4NGUvMHg3MApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJf
Y29tcGxldGVfcmVjb3ZlcnkrMHgxOWEvMHg0NTAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtz
YXBoMTkga2VybmVsOiAgPyBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHgyYS8weDQwCkp1biAwMSAx
MjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/IG9jZnMyX29ycGhhbl9zY2FuX3dvcmsrMHgxMTAv
MHgyYzAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgcHJvY2Vzc19v
bmVfd29yaysweDFmNC8weDNlMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgd29y
a2VyX3RocmVhZCsweDJkLzB4M2UwCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/
IHByb2Nlc3Nfb25lX3dvcmsrMHgzZTAvMHgzZTAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtl
cm5lbDogIGt0aHJlYWQrMHgxMGQvMHgxMzAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5l
bDogID8ga3RocmVhZF9wYXJrKzB4YTAvMHhhMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2Vy
bmVsOiAgcmV0X2Zyb21fZm9yaysweDIyLzB4NDAKClRoZSBzdGFjayBvbiBya3NhcGgxOSBkb2Vz
buKAmXQgbG9vayByZWFzb25hYmxlLiAgVGhlIGlwdXQoKSBzaG91bGRu4oCZdCBkcm9wIHRoZSBs
YXN0IHJlZmVyZW5jZS4KSSBhbSB3b25kZXJpbmcgaWYgZjU3ODUyODNkZDY0ODY3YTcxMWNhMWZi
MWY1YmIxNzJmMjUyZWNkZiBmaXhlcyB5b3VyIHByb2JsZW0uCgp0aGFua3MsCndlbmdhbmcKCgpU
aGUgb2NmczJfY29tcGxldGVfcmVjb3Zlcnkgcm91dGluZSBpcyBnZXRpbmcgdGhhdCBvcnBoYW4g
ZmlsZSBpbm9kZSBkbG0gbG9jayBhZnRlciBpdCBoYXMgYWNxdWlyZWQgb3JwaGFuX2Rpcl9pbm9k
ZSBkbG0gbG9jay4g4oCLClRoZW4sIHRoZSBoYW5nIGxvb2tzIGxpa2UgQUJCQSBkZWFkIGxvY2su
CgpTbyBmYXIsIEkgY2Fubm90IHJlcHJvZHVjZSB0aGlzIHJhY2UgY29uZGl0aW9uLCBidXQgYWNj
b3JkaW5nIHRvIHRoZSBiYWNrdHJhY2VzIGFuZCB0aGUgcmVsYXRlZCBzb3VyY2UgY29kZSwgdGhp
cyBwcm9ibGVtIGRvZXMgZXhpc3QuClRoZSB0cmlnZ2VyaW5nIGNvbmRpdGlvbnMgYXJlIHJlbGF0
ZWQgdG8sIHRoZSBub2RlIGlzIHJ1bmluZyByZWZsaW5rIGNvbW1hbmQgd2hlbgpvbmUgbm9kZSBp
cyBmZW5jZWQvZG93biAodGhlIGRsbSByZWNvdmVyeSByb3V0aW5lIGlzIHRyaWdnZXJlZCkuCgpB
bnkgY29tbWVudHM/CgpUaGFua3MKR2FuZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb208bWFpbHRvOk9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tPgpodHRwczovL29z
cy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWwKCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxp
c3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb208bWFpbHRvOk9jZnMyLWRldmVsQG9zcy5vcmFj
bGUuY29tPgpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2
ZWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMy
LWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29z
cy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
