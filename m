Return-Path: <SRS0=/tXN=OR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6773BC433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:17:25 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F27CB611AE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F27CB611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6mpUE017678;
	Mon, 27 Sep 2021 07:17:24 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bap3eagxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Sep 2021 07:17:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18R7FqQq161068;
	Mon, 27 Sep 2021 07:17:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b9rvt8y5x-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 27 Sep 2021 07:17:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mUkt5-0003DS-Py; Mon, 27 Sep 2021 00:17:19 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mUksc-0003CX-5r
	for ocfs2-devel@oss.oracle.com; Mon, 27 Sep 2021 00:16:50 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18R7FFNK013824
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:16:50 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3b9stc42sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:16:49 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18R3UDvK024438
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:16:48 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3barr1rjja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:16:48 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-8-m1kizuK7OM2AdYxzZz-_Yg-1; Mon, 27 Sep 2021 09:16:44 +0200
X-MC-Unique: m1kizuK7OM2AdYxzZz-_Yg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=WlsGu2r7j7IWa9QrXJR3cC4NZg/SD4Ru1/cTzTDdRyyViKr3MZArSTbn7CpFrnvwbrDXOzjj8CYFPFAiCWwrGqfzS+3pJE4PcNdCRgJie4T7uhiGOeNFnEoQxr/sh8nKwPDeeQzVDAOsrrx4/LxHtTGdDVvpRaAQ/F9CkaQEq6CpJtOR4iX4XpTK4OG97CpNGXT4rmTji3BI1jQa8LevMBDiAFq9XXZVtsM9y82L1tW7Intz/E6gyZElujCEoR8iovtfT3zGPKyBHbH5xyhQD4CrV3uKHptdXi2iukrvIACh5sUzMCniBtw2A5JyHwnKnO78f12dd6cWHb6atU5rSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
	bh=mh72aoWzfcLxTo6cf5y8oodkSwthgJAXkCN7x8OeGKY=;
	b=X0Y0Fgez+q9PSAT+m4XzCi+1fwE045e7T1qvqQP5WkSLK+Ulfy1a7on5AYkJe8upL24RlDiUi41Py5B4edXgWL+Mjs103pbqQI4cPEsLQMS44KwyJG+O+pTlZdCMQLC0HbdirC7N7bveK/R696xdSGguSHgd/9gcBy7OS4dg0KKZkMYyuC7/pGsH0cbQAFQvWS1CHMNIuDtn5i1tHxIR5pCF2u7I1PuHepU7YH2ar0JTNAUTMBwQ4u4tnW7fjBMkC4Dtg2P+k5pPolA0IBH/pjop2PpAUCamAP836LuiuCsSf+IxaW15EcMFIt5ncwsJqQaoAdwXh8BIC6Y5ugs2MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM7PR04MB6967.eurprd04.prod.outlook.com (2603:10a6:20b:108::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15;
	Mon, 27 Sep 2021 07:16:43 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4544.015;
	Mon, 27 Sep 2021 07:16:43 +0000
From: Gang He <GHe@suse.com>
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Thread-Topic: The last part of the file is zeroed out when write N random bytes
Thread-Index: AQHXs2iMrNkkFCO9B0OBdziEEDWulQ==
Date: Mon, 27 Sep 2021 07:16:43 +0000
Message-ID: <AM6PR04MB6488C35E2103DFC0BF4AF896CFA79@AM6PR04MB6488.eurprd04.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 6a929bb3-f31b-f755-85f5-404b6f248573
authentication-results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04e06b3e-3b6a-4f5b-df09-08d98186c263
x-ms-traffictypediagnostic: AM7PR04MB6967:
x-microsoft-antispam-prvs: <AM7PR04MB6967689E321EB22D6091CD6BCFA79@AM7PR04MB6967.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7YkQiRht9q14qwcqZeWkmy+nfezR2kIqir5n0pMGecpnYkWb+OKoij3PWT4XJbsCfZbncwRJDwBvFBtREz4uP9wYutcVysl/0/ZldSsWRB8NaGcqiGMPSvWUEZNxOaGwjOnlDCAF4Y7+YPGBCnwlRrO1I6IVfYW192QwQfxxlL841ZFbP1nqwygJzS/IW9/dKVdHPeX+d4BN7Xv2QkxSI43P3lFzWt2a+JlWlJm7ZSrsI4omQsQUAsdzM8AiuX9JhMEKZBMYJ+G1wf0aQ+eG44c6kGTKK5+fXvj8DWHn1gtAcqAaWTnx2FKdZv5sw6hr1s9DdbuPWCCPYtsS6qvWp92ppZrAjdtLsWb3MsGU82fISfcRyNm4BKHifDyJD2B8g9D5R+BB3gNnP6F6QP83+rbCSb2qbSd40PA72BpcPff4MwwOETX/FuHsa9nsktiDvZ4o6qjPp5egLRiFCnUBFF1KyEpwmvr1YYftdroej+yfvkbM8+lYhRQPzUWP2J7na+LWNKWT0WAOItabNcQ5at+q/CEjn6qKkC52WYeQKKtdcBx0C+5prDOv82QX5HYvaiOXtTTHXEBhidbMRKkeJbmL4h6RCsR3xYBhtoBYTOMDJgdOMlZevPaWsgP0s78V3sWr67hJG4T913wHXdq+rCuH+iEOyr6ysCs8bUWVlwLle3TZcv8eXjAUFw46gHWPyh9A0Bqp6dzNoPE06+5WrqpgW0E83ANNvKR87KEu2Aj+bJVUdouUcm8TzrRTpwUE/AvRSYe9++3s9oVSjgJuEJV2gCUU8xIdKU9ab3KoeCIBBNT1XTn8Hn062pxJpOGooPI+0U6DL4g2EmTbFc8rvomuhWvPPZysol4Kz126kHA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(2906002)(6506007)(8936002)(91956017)(55236004)(66946007)(55016002)(38100700002)(7696005)(33656002)(6916009)(122000001)(5660300002)(83380400001)(38070700005)(76116006)(71200400001)(316002)(26005)(508600001)(52536014)(66476007)(66556008)(966005)(186003)(66446008)(64756008)(8676002)(86362001)(9686003)(10126625002);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Kjf/i5Hpi6SLzEPbw8J2Hy9Bjvykk3ZIFK7UNsyLfpsY4g0SGpNBMNPPmC?=
	=?iso-8859-1?Q?lBrGF0Rkqy+boNhLREzPwa0pOPQVfcReKhKjcE7zjPsQriM0/t55vZcDxR?=
	=?iso-8859-1?Q?vHbQYyPoEVOAouOQvxbl8EojNDt+1rznUpJzdMjG8b0AcjvdOZRVhgtqRJ?=
	=?iso-8859-1?Q?EbSZia8F7yvZGFetYaNYkBXKnJKmHOTMpYkqpNoMKav9aDxvFaud9FVFWJ?=
	=?iso-8859-1?Q?i7Nxt9iVHxQyAgwfxb1Wz00T+u3A98sHTFkOgFDO4xYCat3qWnb7OWgnEK?=
	=?iso-8859-1?Q?c8w2VU1Ie+LL8nOge4J2tdGd/TKRS6WxOnK3Lpw5ytahCnE8WWqccNxeoJ?=
	=?iso-8859-1?Q?pa4cyCiywCt+OK5xibD4tI4/n9tPbScoiDNmQD9IhfpD1snd72OyjM4TDX?=
	=?iso-8859-1?Q?JEsAWvApPiK0EvFaXrCFfiD1uZA0ZxEsTt37WSPpiyTH9IQbEl4GfK7TTC?=
	=?iso-8859-1?Q?T9TQl/XT6DWMpvlJG90hWjmhDL0+wj9qxxIBp7vHqLZ4MlL0Ij9ryh0/V7?=
	=?iso-8859-1?Q?+/UWxW11xpvAalEadKhj5VpAWtdXxlrBLFArMXAve137od1uod4paYD1rO?=
	=?iso-8859-1?Q?uO7njYpaHreAl2WmkNbPhhZjXhtfXItvc3l9SKEiXqQeezAF2vSNANjuvE?=
	=?iso-8859-1?Q?GKc/sOciMmadNEiTo+P6wC915ALMy4UzD6IRA5EhTkYoF+mvhLbY3TcM+r?=
	=?iso-8859-1?Q?CZ0XOoPaRNg/mrKmzuIJAAU0TUZX5r515/QJGoEPi7kBThIGWzq4HZt7mF?=
	=?iso-8859-1?Q?/do84JQr3POQQAYWvlqKBHLl4kajurcUhVuSj80kCB7M7vvX2/308IBgFs?=
	=?iso-8859-1?Q?uUDIu2jUVoOMAiDmjWtDjttDw3dyYguD216HiTshYmrLYMVy3k61osfq5o?=
	=?iso-8859-1?Q?jIfDMQkt5Usop+bSnOWgY0L7ebOik1euW6gHbQztavYGCp6ql85WXblqMm?=
	=?iso-8859-1?Q?yuhLf4/8HpGbtd+x9Hwq8fdTQXI8GffmugT1VjZ4HQFCeMqz0suMN7MKJL?=
	=?iso-8859-1?Q?O/lp5JIufpUj254mF/hN/BTGapkH06GANpcLafIvUC7N5xVe5nEsdKNE+E?=
	=?iso-8859-1?Q?I0P5CwaKnuonAYqYr/jrRXamd5xD757jqZ6RsVRp+ZxDKPDHoNKhzjMzM2?=
	=?iso-8859-1?Q?rmO2eNAMM5TtU9qbw/FtzQxWhrz/Yb0aC0X/rPt5UpXt+SIriloGLVsH7M?=
	=?iso-8859-1?Q?lVuzDwxA6FKv4LnjCXRH7z1yiVyRoUpONvEBIWySdvvqSfXwBMxHSnjbK2?=
	=?iso-8859-1?Q?RxYeNRdR+7yQvSoF6lRagdNcqkvjRhFOurB99SXY1cXg1NKiY5kSY1QOsl?=
	=?iso-8859-1?Q?W+O74GICZlp4YeqJwB4IDzdIi8w3ifhmd6TPzKY7M9nuEos=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e06b3e-3b6a-4f5b-df09-08d98186c263
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 07:16:43.5702 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7XzIK3DGaOJXrErAPAtDP9UXvRunc0YFne46FPkVMtGzMaJNC8sqDJEmtjSlap/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6967
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	mlxscore=0 priorityscore=78 impostorscore=0 bulkscore=0 mlxlogscore=701
	spamscore=0 adultscore=0 phishscore=0 clxscore=173 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109270048
X-Spam: Clean
Subject: [Ocfs2-devel] The last part of the file is zeroed out when write N
	random bytes
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270048
X-Proofpoint-GUID: JOJ4jRcFLYJuB5cXHZItUH7RhmgijQ-0
X-Proofpoint-ORIG-GUID: JOJ4jRcFLYJuB5cXHZItUH7RhmgijQ-0

Hi List,

I'd like to report a data loss bug when write N random bytes, since I saw there were some related commits in the past weeks.
I can reproduce this bug stably with the latest ocfs2 kernel module code as below,
1) Create a three node(e.g. ghe-tw-nd1, ghe-tw-nd2, ghe-tw-nd3) ocfs2 cluster, attach a shared disk(e.g. /dev/vdb).
2) Format the disk with the command "mkfs.ocfs2 -N 4 -b 4096 -C 1048576 /dev/vdb", and mount the disk to /mnt/shared on each node. The cluster size must be greater than 4K, this is the key to the problem.
3) Copy the file write/test scripts to /mnt/shared directory, then run test script on node1 to reproduce this bug. 
    file write script ocfs2_fallocate_bug_plain_write.py: https://pastebin.com/QsXcD8rq
    file test script ocfs2_loop.sh: https://pastebin.com/eTUe2hkW
4) Then, you can meet this bug, the file md5sum is different between from node1 and from node2.
    In fact, the last part of the file is zeroed out from node2.
    e.g.
    file dump from node1: https://pastebin.com/HB92TVS0
    file dump from node2: https://pastebin.com/jBG7HdSz

More information, 
this bug does not exist on some old kernels( e.g. linux-4.12.14-120), but it will happen on some new kernels, I feel this bug is probably NOT caused by ocfs2 commits, since I used old ocfs2 kernel module code on the new kernels, the problem also happened.
Anyway, if you have any comments, please reply this mail.
 
Thanks
Gang

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
