Return-Path: <SRS0=G199=HA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C031C433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 03:03:02 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B12764DFA
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 03:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B12764DFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10T2uN9d107715;
	Fri, 29 Jan 2021 03:03:01 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 368brky0cu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Jan 2021 03:03:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10T2xtWG148267;
	Fri, 29 Jan 2021 03:03:00 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjux4dj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Jan 2021 03:02:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5K0j-0006ZZ-OJ; Thu, 28 Jan 2021 18:59:49 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1l5K0J-0006WS-H3
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 18:59:23 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10T2sfYI002202
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 02:59:23 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 368wq2h2cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 02:59:21 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10T2sgLB026817
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 02:59:21 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102])
	by userp2030.oracle.com with ESMTP id 36c990ghfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 02:59:20 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2052.outbound.protection.outlook.com [104.47.5.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-4-JKikKRrNPMK6oXbl6HH04Q-1; Fri, 29 Jan 2021 03:59:15 +0100
X-MC-Unique: JKikKRrNPMK6oXbl6HH04Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=F4ofPl8vvN3ybjUtWlrUUlPKzg1OcYLq2+6zzJYT3D7bmA80RMQwqusKq1mexYdlMqyzagb7GhGcnbJAloWqv1ZkLig4+weJ+3LG/dD452vCqEc89rGIBB4sgSpfrfg4oxPVsUnfcbz9acuLP7XVC2/VrF9sclxDizVhnOkpo9GOIjwVLwPmCj5Y5HcYZexN/58qhfuMIuaEJdCy26HRVe/9ZzEdcuVdU+FNKYWAYrNW4YMu3Ln3HEA0bToDSrVScfWemtKJDPIdsLEfi6d2nvFqvRdljJQxhp9wd9BNVPIaUNXe2tpXxiVWbkUFqSQHC+A2NgFrcZuDdF6JgLirYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=yD5Tt5ibR3QsDrXgK5OWxj0G+Ahf3o2oe4D0K3OnlDE=;
	b=WQPbHw3gD6AAl3ux1DnB4hhyQW/jT8bpaafhuW9acGKs0U0dwCqpJoH8Xhc6LI6p/535Hqp12b13H99JYf2PhC66YKE3as9Z/Cygqao7yWRuz9LK66nCWewl4mPbCvFPXwhiw4dAqvKuyzEQUe2wAAiDDviBJ4vq055X9h4NyO29mfJVTPKQyvMYHx1kwmo+eB9J4KQZg0aibgZci7ZySCMNoIT0TS/CoB8F9etT8h2onw/AKBXll7ZkYa2ksKMNQmG+WpmUTZQbul34iMGnTZzpwcYJwz0VMKEm4QVSSWyXUifiMnf21qVafQQfniuU+mk+q4lBFp8g7w22MEbY8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB6599.eurprd04.prod.outlook.com (2603:10a6:20b:fd::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Fri, 29 Jan 2021 02:59:13 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::6935:22c5:766a:a024%6]) with mapi id 15.20.3784.019;
	Fri, 29 Jan 2021 02:59:13 +0000
From: Gang He <GHe@suse.com>
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "ocfs2-tools@oss.oracle.com" <ocfs2-tools@oss.oracle.com>
Thread-Topic: About the status of reflink-tools
Thread-Index: AQHW9eoHk9vNPZLg6kys0MprgFWE8A==
Date: Fri, 29 Jan 2021 02:59:13 +0000
Message-ID: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
x-originating-ip: [111.205.14.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a5cdea6-71b3-42d5-6622-08d8c401dbc9
x-ms-traffictypediagnostic: AM6PR04MB6599:
x-microsoft-antispam-prvs: <AM6PR04MB6599DBA4A5FECFC98EE70095CFB99@AM6PR04MB6599.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NAonpuq8fyYbgDqQ2dNwjByiLWQJJ7pKMTgUoEdDTzI7FRo8ijwRkw8BVWUL9t7eCVSvaBpJoCCcT55Fr+w9u1akUHM9IfGkaRQpjN7qqyag5BgkVKAx/DCP64QI7nS8OoKoW70cJ6REjGMJYMntoI5sbYDJUBbOitLNcvT/baqZp5J+/Sx6vEM2X4WQm3uqeYspBKTdCIjotGibNCw9KeY6Zcl8mE3udIHqKIiGgPQCHuL/HiRolsWvLX+lTzFY+NiVGQlt7ZFzoF2aIMc3LIYg1NOxffqCsBcnJWQ0PFXhD3UOQd7wfYQZaaWvgInEEnKGTszKXOlOnEBmkqT0b0iMD0FWIX2K1Tu010jwhjUo0XwphCE4LYp64aZyDCNKZnv6VBv4Q1PF+PeP0kDq2sKrITTmTbcqb6JyVt4z5EwAODdSBle3dKC7MpVSCT0NyCnm+qfz/ugX+eY6V59EV5a+bTtG60F7jmHs+IvCLGKlVrDjkczUkWjwAJ8D/ZK2gTOOtnJ2VXDLaUowepSEmkA2/2EvS+rWEEMJOpY9aW8I3nI/vUwqNqG9iyupafFT
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(136003)(346002)(396003)(366004)(376002)(39860400002)(450100002)(110136005)(7696005)(478600001)(5660300002)(71200400001)(52536014)(91956017)(66946007)(76116006)(8676002)(316002)(83380400001)(66446008)(64756008)(66556008)(66476007)(26005)(6506007)(33656002)(55016002)(9686003)(86362001)(8936002)(558084003)(2906002)(186003)(13296008);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?Li1lbbClMw75T8EhQo1e5oEVA+niIf43klAJ6ln9SSUORidABgCYSZQHXO?=
	=?iso-8859-1?Q?YSRW4E5PYD7yT0jj6DCc+uamoESMzOUiImACAmca9SpNV0qees7S1b/Elq?=
	=?iso-8859-1?Q?JuxsNdv4HqxjCWTgclRBmK42MY2vemyTdvTblCkmojihU25ellljzQG26u?=
	=?iso-8859-1?Q?LYrXDScAwPK8mkzUVlmAL5Tx5SvZ8J+2EVFLqxp5fFWPQc6TODk8w+FkGR?=
	=?iso-8859-1?Q?yP1Kais2XsEVgBQPbyUhg2dj5rkLERLsH1oXEoWMRvcQ/ACoymHM38+iE/?=
	=?iso-8859-1?Q?ULNgXxdc24Yqmb5uwplHTTW84OdcSb1qaDMDd825V0nJCbNqskH+xt67gn?=
	=?iso-8859-1?Q?zxrH0PZLQFBYRNu9PG+XNkU+QFNTtusQOTMlCMbxvc1emzbB20L9pPag4u?=
	=?iso-8859-1?Q?1Rs6mdx20v/lJD6RyX0ltUHkOTLuqtvvbfksQjxlsXtB3la9L0YmYvAr+U?=
	=?iso-8859-1?Q?X7m8x2JOLcKJhoyaLWM4wVMtRg7FkFSNePYMwpR+z9Sxmn+SxNcfRQwflX?=
	=?iso-8859-1?Q?H1lVEaad4oBbYvFcSlUYyDzVp0YSFa9ZhGklKyu/BG/iLM2VyO0aVcunii?=
	=?iso-8859-1?Q?14xUgHP4mdpKsf9QDXlY3S2FSJJtZ2Pd5iKyBFr3kE5tkt3seDTBOht+RD?=
	=?iso-8859-1?Q?prhoVzUXgCwmzYNSUV70GoGkEHIBe30NziqThp4sMBUlEU7ME+0+j4K8ve?=
	=?iso-8859-1?Q?daUAvi96BnyUYDShOwUeafnks3eGhZg6Hldg77RnQIsbmINF8blRvw+ff2?=
	=?iso-8859-1?Q?T04Ff+zkN8qGADi/EqeM4MYc1ECUIiRU2OHoKmLia8nNIF1AP/F/3jsYho?=
	=?iso-8859-1?Q?eB7VMxTAJHkz+OdGveym1vCPKfA/gM9U36BDFMZ2E/4NHRXCfOdSo/Me9G?=
	=?iso-8859-1?Q?K7e3i6QophGbGXJLEbT9+0nXh3w6habKWz7FA57jNz5noy/lKJW52FWfiE?=
	=?iso-8859-1?Q?NTLkY9PxAay9AKhXoOEVzJ4O528ZTUTfGFbQ+BnTFYRe+Zmyo35EVBjosZ?=
	=?iso-8859-1?Q?owW8sGTCkWutJcdJaxR2X6uKAjrImHHpa5lkylDOknY9ODYufTUxBe6YYS?=
	=?iso-8859-1?Q?O1iaQGMUD48GgzWg6F/FX2w=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5cdea6-71b3-42d5-6622-08d8c401dbc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 02:59:13.3666 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGlbrWwGaGBBizLLaH6vjvV2/+G7cRWr116sveTsBjmKX/kiL8Gr+iS81dRbYSda
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6599
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
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxscore=0 malwarescore=0
	suspectscore=0 clxscore=200 impostorscore=0 lowpriorityscore=0
	mlxlogscore=617 priorityscore=0 bulkscore=0 spamscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101290014
X-Spam: Clean
Subject: [Ocfs2-devel] About the status of reflink-tools
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290014

Hi Guys,

You know, ocfs2 reflink related utilities were maintained by a seperated project reflink-tools,
What is this project's status? e.g. who is maintaining it, where can we download the latest source code?


Thanks
Gang

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
