Return-Path: <SRS0=Eqrg=KA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C42C433ED
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 May 2021 15:56:01 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7727C60FF2
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 May 2021 15:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7727C60FF2
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 145FrxIL174232;
	Wed, 5 May 2021 15:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=lO+Ltr88e0m69Ul65NzMW9yFPj7P8X2tn/9RDhxosJg=;
 b=d+5rdG/NlDlXR3/i33Yogftr0aaebDBUctF/6PLsd3gA2++ooJlH379sFOIdOZYlM/H2
 PqboV+Nis/JwjXSbcFYHO3ZnrXlS0b/S5gSNwSs1t4Q+imylszKdKm7vkG5SGwWuy0Qe
 rxivHdWn1cc/JFq7XFV4Z7tBHtz0HQVCSFBbWJUjyu+PZxJarry0rbFJvmgTH8SMMF19
 MyMKcJ8SCiXHiVMhbManz43PDqnIg/tyHOjJcYdGD130uRTUaiBurAmv8ii7kBtGqs0T
 ScSjCkXuiDifEE0ZvmVwtVaGsuF9xieJPoaDm3SoWGXcdD6+JmOlrAD/sKDX4V6FxOWM lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 38beetjau7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 May 2021 15:55:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 145FtH9k175449;
	Wed, 5 May 2021 15:55:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38bebtphbv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 05 May 2021 15:55:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1leJsT-00046T-BC; Wed, 05 May 2021 08:55:57 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1leJsP-00045s-GQ
	for ocfs2-devel@oss.oracle.com; Wed, 05 May 2021 08:55:53 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	145FtHJ2175374
	for <ocfs2-devel@oss.oracle.com>; Wed, 5 May 2021 15:55:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by userp3030.oracle.com with ESMTP id 38bebtph7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 05 May 2021 15:55:52 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BY5PR10MB4002.namprd10.prod.outlook.com (2603:10b6:a03:1b0::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41;
	Wed, 5 May 2021 15:55:51 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4108.026;
	Wed, 5 May 2021 15:55:51 +0000
To: Jan Kara <jack@suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
	<20210430124756.GA5315@quack2.suse.cz>
	<a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
	<20210503102904.GC2994@quack2.suse.cz>
	<72cde802-bd8a-9ce5-84d7-57b34a6a8b03@oracle.com>
	<20210504090237.GC1355@quack2.suse.cz>
	<84794fdb-fb49-acf1-4949-eef856737698@oracle.com>
	<20210505114341.GB29867@quack2.suse.cz>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <3c04ff88-0139-86f2-aafd-f294c48b7303@oracle.com>
Date: Wed, 5 May 2021 08:54:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210505114341.GB29867@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN6PR08CA0034.namprd08.prod.outlook.com
	(2603:10b6:805:66::47) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-155-218.vpn.oracle.com (73.231.9.254) by
	SN6PR08CA0034.namprd08.prod.outlook.com (2603:10b6:805:66::47)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25
	via Frontend Transport; Wed, 5 May 2021 15:55:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb1afb3-1c46-4c7d-442c-08d90fde41d8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4002:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMslsvwcp1pFxfqD73Tm6XTpY1xmud+jakkk988l77L1PMKVCEx4zUsMwlGXOBZTZR44bKZXTTO+WHe9/IWDFcgb6bJUsN8oI068Mp2g9G+wV1Tc+brLKf/QQEXbxAOjJ5usQIhY6ZxRMyLhFzTRdDWb1rJOGuQTUV5dqpQhpxdAfgDpIg09/MYT8awUWnc1Nsle2vvi4ErLNBiUb6npeX7oe5P9etv19pQfu8qMrfHvLnZ1TjyE3nQhwuVqj4SPp62tDVPhanEToBtU1/6PGurEP1u8zQZcwh+YhsbAIA68t4Fy2KdIew8DDDtdRRvdxzBY81gvOLl5H5T0SSwJUKGamouJD/v3fYZQBiDkkZkJy65hdjsnDpogJ2fMb/iP99Lz1B7513l70mGDExocK8962v2r0XJP+Q4flWbW0g4sSSG7vSdvoARMcI+Gs4xQTmYWFVrn9HDHPBwe2ENomHmJGb2NmQD99TkMPy/TH/5VoyNVbnwikfo9RwRe4VUl0URJALUetKOYYRtog4/5NtY+cOe/6j1c/oprK9bUJOUht1MGDELSFsyoCdXH9obE
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVI4WUpTOW1QcGM5TXVEelVUeE1yOHdXWnJWTCtDMDFpWTlnTVo2NEozVnFC?=
	=?utf-8?B?ZVgxNFdURCtSZWdtNUxsV1l6alNWZWt5NDRrOTFKaEdzN2J2dXREZGJyWjIz?=
	=?utf-8?B?bGV0M3M2bkcvOFlWRUV6YXdRdEQ1Y2NNalpnSDh2bXJXeUZtdU9EekNpVnJw?=
	=?utf-8?B?UUlMQW5GYUY1WlU4VXdaTjE1RXlTWklPWTExYnY4ZEpKTFBSeEdHZUtaRHNC?=
	=?utf-8?B?c2ZXMG12SWZyYnNrbGdqSnRhTUNUMUk0c3pHK0JpbEhnWERVUzV1aHFFUVBv?=
	=?utf-8?B?UFFDMnVUSlZWcTJ4OHlqNUx2TnVmcnplMDluMHZzb1JUZlNoa0piNmVYY2Fl?=
	=?utf-8?B?K21ERUVDYlhkeEdRWmkvdjVDSUlUYTZmcFRkOXlOcUVrMWkyWU9hS2l6Znlw?=
	=?utf-8?B?V3dtSjVURWljRE81NTFwLzZYUnpKNTZBbmY2ajhXUEt1b2YzZ1VPbWV5Vy9O?=
	=?utf-8?B?Ty9XOEJXQzAvbjhGbTdReWtKWWR0WnEvR1JuNmZPUVVPbFlYN21mVXZFSEF4?=
	=?utf-8?B?YjB0UzA1Tm10clgzeGk0a1JENmsvemwrMXRrNFBoVE8xbnVmV1NRVWcrNVFz?=
	=?utf-8?B?bGdITUN4VHBacEhTNEl5VHloL1IzWHNqcFlsZjVwVWNXNmNuR0cvQkRiNG40?=
	=?utf-8?B?SVB0UmY3OTJ3UmdTSVBmN2w1d2xUZ3FHVEs1VGFwejViWGw0VzM5UW41dFFF?=
	=?utf-8?B?Q0FrYjJYcFRWWVNkK2p4Zm5ndmFJUzhpT3VnQWNoUHZxUWh6REhITmlaamlj?=
	=?utf-8?B?UnVlbXErRUZaUVVmMmxjTHFlektSemlGQng2NFVxT1V3Q1NEZHMyb0xwVlNs?=
	=?utf-8?B?ajlIQmV2MFVneCtKSmYzckErQnhJSEl2aklWNGJWOEthYkVrREZ3WkoybkVl?=
	=?utf-8?B?MlRQREJpa052OGRsR3Z6WnhSWXFabWovRWtmVCtDSk5mM0QycENoM25sUGRa?=
	=?utf-8?B?djBzVUh1UndoWldUYU1NNGtpME83anNwbElRV0VaZWZYd2RLdk8vcHRIZ3BW?=
	=?utf-8?B?R2xHUEFRYU9CTXhIN3lJTk1LUm5uWXdhTFVUY3M5N1dYN0dXSXNRN0NRbmdM?=
	=?utf-8?B?Wlp4VVpJWXlQV25GazAwWTJ3dWdtTDJBalozZWNSOWk1MG9CWTBCaDVkL2ph?=
	=?utf-8?B?R1BBK0tWQmxBOW9jZktNUGJ4M0VMQjdhQzR5NWpqaGdMQllYVDdOTlp4enFR?=
	=?utf-8?B?cEdHUEFLdmlKL0pKR1VpZ1R6Y09iYWdiTWRaU0hQUzAzYVBBWUJPRDNlSzF6?=
	=?utf-8?B?Y25kbE5OWlB4eFVlQXFzc1FMZERqamlBQ2hKY3o4QkRBcGlOcnIvRElrM1ha?=
	=?utf-8?B?Q1dzM1BTK283U2ViWDlMWU84azd6TUpsU3hRR05rUDB0ZFg3dFBGWjQ4TG1v?=
	=?utf-8?B?aDNsZWx4VG1ncTJXQUNEL3JBZVZ3TTFIUUxXQytPY244NFJxYUdCeGhoZnln?=
	=?utf-8?B?R2tDK24yUmIva0ZxOXRwTFU5WStiY2RIZlJSTkpNY29YVW9RbWVPTFk4WVBX?=
	=?utf-8?B?MTZPZHE0MTdieEkrZ3J1Y2pYSmpReUFsdUtISXRuc3BteWdsSEdVZ1B4WGs3?=
	=?utf-8?B?VjFxaUhmbFlzQnhhSWZXUVZDVHd4OW15bVkra1J4OGRZVXV0d0dKWjkvYVlr?=
	=?utf-8?B?cUx4ZllMV1E0dWJaUms5ZHc2VHlPL3VFaEErQWxCZmpCUXlUZll2RGRJZEw3?=
	=?utf-8?B?enNuUXIrUW1ZM2JaNVpPbHhnV0hxTHFESnhkRVlYOE9wRVArVXFBVWF5alVE?=
	=?utf-8?Q?u9jqaE5gjyZ7XAuXyIBmyPJzIWU0da1PVnydnJS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb1afb3-1c46-4c7d-442c-08d90fde41d8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 15:55:51.2559 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dfSIv+nuSTcFaNbgQCD7cS9lsrjYrusWcG49asCr01Y+T2DLBGrpj7NzGIsy9dEOrXvsJptC2B9CWPkf/BA3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4002
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BY5PR10MB4002.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0
	phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2105050113
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	145FtHJ2175374
Cc: cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH 1/3] fs/buffer.c: add new
 api to allow eof writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050113
X-Proofpoint-GUID: P6EY5UNRSJxyUGw0IqkSzwVoa-FRc2dH
X-Proofpoint-ORIG-GUID: P6EY5UNRSJxyUGw0IqkSzwVoa-FRc2dH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050113

Ck9uIDUvNS8yMSA0OjQzIEFNLCBKYW4gS2FyYSB3cm90ZToKPiBPbiBUdWUgMDQtMDUtMjEgMTY6
MzU6NTMsIEp1bnhpYW8gQmkgd3JvdGU6Cj4+IE9uIDUvNC8yMSAyOjAyIEFNLCBKYW4gS2FyYSB3
cm90ZToKPj4+IE9uIE1vbiAwMy0wNS0yMSAxMDoyNTozMSwgSnVueGlhbyBCaSB3cm90ZToKPj4+
PiBPbiA1LzMvMjEgMzoyOSBBTSwgSmFuIEthcmEgd3JvdGU6Cj4+Pj4+IE9uIEZyaSAzMC0wNC0y
MSAxNDoxODoxNSwgSnVueGlhbyBCaSB3cm90ZToKPj4+Pj4+IE9uIDQvMzAvMjEgNTo0NyBBTSwg
SmFuIEthcmEgd3JvdGU6Cj4+Pj4+Pgo+Pj4+Pj4+IE9uIFRodSAyOS0wNC0yMSAxMTowNzoxNSwg
SnVueGlhbyBCaSB3cm90ZToKPj4+Pj4+Pj4gT24gNC8yOS8yMSAxMDoxNCBBTSwgQW5kcmVhcyBH
cnVlbmJhY2hlciB3cm90ZToKPj4+Pj4+Pj4+IE9uIFR1ZSwgQXByIDI3LCAyMDIxIGF0IDQ6NDQg
QU0gSnVueGlhbyBCaSA8anVueGlhby5iaUBvcmFjbGUuY29tPiB3cm90ZToKPj4+Pj4+Pj4+PiBX
aGVuIGRvaW5nIHRydW5jYXRlL2ZhbGxvY2F0ZSBmb3Igc29tZSBmaWxlc3l0ZW0gbGlrZSBvY2Zz
MiwgaXQKPj4+Pj4+Pj4+PiB3aWxsIHplcm8gc29tZSBwYWdlcyB0aGF0IGFyZSBvdXQgb2YgaW5v
ZGUgc2l6ZSBhbmQgdGhlbiBsYXRlcgo+Pj4+Pj4+Pj4+IHVwZGF0ZSB0aGUgaW5vZGUgc2l6ZSwg
c28gaXQgbmVlZHMgdGhpcyBhcGkgdG8gd3JpdGViYWNrIGVvZgo+Pj4+Pj4+Pj4+IHBhZ2VzLgo+
Pj4+Pj4+Pj4gaXMgdGhpcyBpbiByZWFjdGlvbiB0byBKYW4ncyAiW1BBVENIIDAvMTIgdjRdIGZz
OiBIb2xlIHB1bmNoIHZzIHBhZ2UKPj4+Pj4+Pj4+IGNhY2hlIGZpbGxpbmcgcmFjZXMiIHBhdGNo
IHNldCBbKl0/IEl0IGRvZXNuJ3QgbG9vayBsaWtlIHRoZSBraW5kIG9mCj4+Pj4+Pj4+PiBwYXRj
aCBDaHJpc3RvcGggd291bGQgYmUgaGFwcHkgd2l0aC4KPj4+Pj4+Pj4gVGhhbmsgeW91IGZvciBw
b2ludGluZyB0aGUgcGF0Y2ggc2V0LiBJIHRoaW5rIHRoYXQgaXMgZml4aW5nIGEgZGlmZmVyZW50
Cj4+Pj4+Pj4+IGlzc3VlLgo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBUaGUgaXNzdWUgaGVyZSBpcyB3aGVu
IGV4dGVuZGluZyBmaWxlIHNpemUgd2l0aCBmYWxsb2NhdGUvdHJ1bmNhdGUsIGlmIHRoZQo+Pj4+
Pj4+PiBvcmlnaW5hbCBpbm9kZSBzaXplCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IGlzIGluIHRoZSBtaWRk
bGUgb2YgdGhlIGxhc3QgY2x1c3RlciBibG9jaygxTSksIGVvZiBwYXJ0IHdpbGwgYmUgemVyb2Vk
IHdpdGgKPj4+Pj4+Pj4gYnVmZmVyIHdyaXRlIGZpcnN0LAo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBhbmQg
dGhlbiBuZXcgaW5vZGUgc2l6ZSBpcyB1cGRhdGVkLCBzbyB0aGVyZSBpcyBhIHdpbmRvdyB0aGF0
IGRpcnR5IHBhZ2VzIGlzCj4+Pj4+Pj4+IG91dCBvZiBpbm9kZSBzaXplLAo+Pj4+Pj4+Pgo+Pj4+
Pj4+PiBpZiB3cml0ZWJhY2sgaXMga2lja2VkIGluLCBibG9ja193cml0ZV9mdWxsX3BhZ2Ugd2ls
bCBkcm9wIGFsbCB0aG9zZSBlb2YKPj4+Pj4+Pj4gcGFnZXMuCj4+Pj4+Pj4gSSBhZ3JlZSB0aGF0
IHRoZSBidWZmZXJzIGRlc2NyaWJpbmcgcGFydCBvZiB0aGUgY2x1c3RlciBiZXlvbmQgaV9zaXpl
IHdvbid0Cj4+Pj4+Pj4gYmUgd3JpdHRlbi4gQnV0IHBhZ2UgY2FjaGUgd2lsbCByZW1haW4gemVy
b2VkIG91dCBzbyB0aGF0IGlzIGZpbmUuIFNvIHlvdQo+Pj4+Pj4+IG9ubHkgbmVlZCB0byB6ZXJv
IG91dCB0aGUgb24gZGlzayBjb250ZW50cy4gU2luY2UgdGhpcyBpcyBhY3R1YWxseQo+Pj4+Pj4+
IHBoeXNpY2FsbHkgY29udGlndW91cyByYW5nZSBvZiBibG9ja3Mgd2h5IGRvbid0IHlvdSBqdXN0
IHVzZQo+Pj4+Pj4+IHNiX2lzc3VlX3plcm9vdXQoKSB0byB6ZXJvIG91dCB0aGUgdGFpbCBvZiB0
aGUgY2x1c3Rlcj8gSXQgd2lsbCBiZSBtb3JlCj4+Pj4+Pj4gZWZmaWNpZW50IHRoYW4gZ29pbmcg
dGhyb3VnaCB0aGUgcGFnZSBjYWNoZSBhbmQgeW91IGFsc28gd29uJ3QgaGF2ZSB0bwo+Pj4+Pj4+
IHR3ZWFrIGJsb2NrX3dyaXRlX2Z1bGxfcGFnZSgpLi4uCj4+Pj4+PiBUaGFua3MgZm9yIHRoZSBy
ZXZpZXcuCj4+Pj4+Pgo+Pj4+Pj4gVGhlIHBoeXNpY2FsIGJsb2NrcyB0byBiZSB6ZXJvZWQgd2Vy
ZSBjb250aW51b3VzIG9ubHkgd2hlbiBzcGFyc2UgbW9kZSBpcwo+Pj4+Pj4gZW5hYmxlZCwgaWYg
c3BhcnNlIG1vZGUgaXMgZGlzYWJsZWQsIHVud3JpdHRlbiBleHRlbnQgd2FzIG5vdCBzdXBwb3J0
ZWQgZm9yCj4+Pj4+PiBvY2ZzMiwgdGhlbiBhbGwgdGhlIGJsb2NrcyB0byB0aGUgbmV3IHNpemUg
d2lsbCBiZSB6ZXJvZWQgYnkgdGhlIGJ1ZmZlcgo+Pj4+Pj4gd3JpdGUsIHNpbmNlIHNiX2lzc3Vl
X3plcm9vdXQoKSB3aWxsIG5lZWQgd2FpdGluZyBpbyBkb25lLCB0aGVyZSB3aWxsIGJlIGEKPj4+
Pj4+IGxvdCBvZiBkZWxheSB3aGVuIGV4dGVuZGluZyBmaWxlIHNpemUuIFVzZSB3cml0ZWJhY2sg
dG8gZmx1c2ggYXN5bmMgc2VlbWVkCj4+Pj4+PiBtb3JlIGVmZmljaWVudD8KPj4+Pj4gSXQgZGVw
ZW5kcy4gSGlnaGVyIGVuZCBzdG9yYWdlIChlLmcuIE5WTUUgb3IgTkFTLCBtYXliZSBzb21lIGJl
dHRlciBTQVRBCj4+Pj4+IGZsYXNoIGRpc2tzIGFzIHdlbGwpIGRvIHN1cHBvcnQgV1JJVEVfWkVS
TyBjb21tYW5kIHNvIHlvdSBkb24ndCBhY3R1YWxseQo+Pj4+PiBoYXZlIHRvIHdyaXRlIGFsbCB0
aG9zZSB6ZXJvcy4gVGhlIHN0b3JhZ2Ugd2lsbCBqdXN0IGludGVybmFsbHkgbWFyayBhbGwKPj4+
Pj4gdGhvc2UgYmxvY2tzIGFzIGhhdmluZyB6ZXJvcy4gVGhpcyBpcyByYXRoZXIgZmFzdCBzbyBJ
J2QgZXhwZWN0IHRoZSBvdmVyYWxsCj4+Pj4+IHJlc3VsdCB0byBiZSBmYXN0ZXIgdGhhdCB6ZXJv
aW5nIHBhZ2UgY2FjaGUgYW5kIHRoZW4gd3JpdGluZyBhbGwgdGhvc2UKPj4+Pj4gcGFnZXMgd2l0
aCB6ZXJvZXMgb24gdHJhbnNhY3Rpb24gY29tbWl0LiBCdXQgSSBhZ3JlZSB0aGF0IGZvciBsb3dl
ciBlbmQKPj4+Pj4gc3RvcmFnZSB0aGlzIG1heSBiZSBzbG93ZXIgYmVjYXVzZSBvZiBzeW5jaHJv
bm91cyB3cml0aW5nIG9mIHplcm9lcy4gVGhhdAo+Pj4+PiBiZWluZyBzYWlkIHlvdXIgdHJhbnNh
Y3Rpb24gY29tbWl0IGhhcyB0byB3cml0ZSB0aG9zZSB6ZXJvZXMgYW55d2F5IHNvIHRoZQo+Pj4+
PiBjb3N0IGlzIG9ubHkgbW9zdGx5IHNoaWZ0ZWQgYnV0IGl0IGNvdWxkIHN0aWxsIG1ha2UgYSBk
aWZmZXJlbmNlIGZvciBzb21lCj4+Pj4+IHdvcmtsb2Fkcy4gTm90IHN1cmUgaWYgdGhhdCBtYXR0
ZXJzLCB0aGF0IGlzIHlvdXIgY2FsbCBJJ2Qgc2F5Lgo+Pj4+IE9jZnMyIGlzIG1vc3RseSB1c2Vk
IHdpdGggU0FOLCBpIGRvbid0IHRoaW5rIGl0J3MgY29tbW9uIGZvciBTQU4gc3RvcmFnZSB0bwo+
Pj4+IHN1cHBvcnQgV1JJVEVfWkVSTyBjb21tYW5kLgo+Pj4+Cj4+Pj4gQW55dGhpbmcgYmFkIHRv
IGFkZCBhIG5ldyBhcGkgdG8gc3VwcG9ydCBlb2Ygd3JpdGViYWNrPwo+Pj4gT0ssIG5vdyB0aGF0
IEkgcmVyZWFkIHRoZSB3aG9sZSBzZXJpZXMgeW91J3ZlIHBvc3RlZCBJIHRoaW5rIEkgc29tZXdo
YXQKPj4+IG1pc3VuZGVyc3Rvb2QgeW91ciBvcmlnaW5hbCBwcm9ibGVtIGFuZCBpbnRlbnRpb24u
IFNvIGxldCdzIGZpcnN0IHNldHRsZQo+Pj4gb24gdGhhdC4gQXMgZmFyIGFzIEkgdW5kZXJzdGFu
ZCB0aGUgcHJvYmxlbSBoYXBwZW5zIHdoZW4gZXh0ZW5kaW5nIGEgZmlsZQo+Pj4gKGVpdGhlciB0
aHJvdWdoIHRydW5jYXRlIG9yIHRocm91Z2ggd3JpdGUgYmV5b25kIGlfc2l6ZSkuIFdoZW4gdGhh
dAo+Pj4gaGFwcGVucywgd2UgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCBibG9ja3MgKG9yIHRoZWly
IHBhcnRzKSB0aGF0IHVzZWQgdG8gYmUKPj4+IGFib3ZlIGlfc2l6ZSBhbmQgYXJlIG5vdCBnb2lu
ZyB0byBiZSBhZnRlciBleHRlbnNpb24gYXJlIHplcm9lZCBvdXQuCj4+PiBVc3VhbGx5LCBmb3Ig
c2ltcGxlIGZpbGVzeXN0ZW1zIHN1Y2ggYXMgZXh0MiwgdGhlcmUgaXMgb25seSBvbmUgc3VjaCBi
bG9jawo+Pj4gLSB0aGUgb25lIHN0cmFkZGxpbmcgaV9zaXplIC0gd2hlcmUgd2UgbmVlZCB0byBt
YWtlIHN1cmUgdGhpcyBoYXBwZW5zLiBBbmQKPj4+IHdlIGFjaGlldmUgdGhhdCBieSB6ZXJvaW5n
IG91dCB0YWlsIG9mIHRoaXMgYmxvY2sgb24gd3JpdGVvdXQgKGluCj4+PiAtPndyaXRlcGFnZSgp
IGhhbmRsZXIpIGFuZCBhbHNvIGJ5IHplcm9pbmcgb3V0IHRhaWwgb2YgdGhlIGJsb2NrIHdoZW4K
Pj4+IHJlZHVjaW5nIGlfc2l6ZSAoYmxvY2tfdHJ1bmNhdGVfcGFnZSgpIHRha2VzIGNhcmUgb2Yg
dGhpcyBmb3IgZXh0MikuIFNvIHRoZQo+Pj4gdGFpbCBvZiB0aGlzIGJsb2NrIGlzIHplcm9lZCBv
dXQgb24gZGlzayBhdCBhbGwgdGltZXMgYW5kIHRodXMgd2UgaGF2ZSBubwo+Pj4gcHJvYmxlbSB3
aGVuIGV4dGVuZGluZyBpX3NpemUuCj4+Pgo+Pj4gTm93IHdoYXQgSSBkZXNjcmliZWQgZG9lc24n
dCB3b3JrIGZvciBPQ0ZTMi4gQXMgZmFyIGFzIEkgdW5kZXJzdGFuZCB0aGUKPj4+IHJlYXNvbiBp
cyB0aGF0IHdoZW4gYmxvY2sgc2l6ZSBpcyBzbWFsbGVyIHRoYW4gcGFnZSBzaXplIGFuZCBPQ0ZT
MiB1c2VzCj4+PiBjbHVzdGVyIHNpemUgbGFyZ2VyIHRoYW4gYmxvY2sgc2l6ZSwgdGhlIHBhZ2Ug
c3RyYWRkbGluZyBpX3NpemUgY2FuIGhhdmUKPj4+IGFsc28gc29tZSBidWZmZXJzIG1hcHBlZCAo
d2l0aCB1bmRlcmx5aW5nIGJsb2NrcyBhbGxvY2F0ZWQpIHRoYXQgYXJlIGZ1bGx5Cj4+PiBvdXRz
aWRlIG9mIGlfc2l6ZS4gVGhlc2UgYmxvY2tzIGFyZSBuZXZlciB3cml0dGVuIGJlY2F1c2Ugb2Yg
aG93Cj4+PiBfX2Jsb2NrX3dyaXRlX2Z1bGxfcGFnZSgpIGN1cnJlbnRseSBiZWhhdmVzIChuZXZl
ciB3cml0ZXMgYnVmZmVycyBmdWxseQo+Pj4gYmV5b25kIGlfc2l6ZSkgc28gZXZlbiBpZiB5b3Ug
emVybyBvdXQgcGFnZSBjYWNoZSBhbmQgZGlydHkgdGhlIHBhZ2UsCj4+PiByYWNpbmcgd3JpdGVi
YWNrIGNhbiBjbGVhciBkaXJ0eSBiaXRzIHdpdGhvdXQgd3JpdGluZyB0aG9zZSBibG9ja3MgYW5k
IHNvCj4+PiB0aGV5IGFyZSBub3QgemVyb2VkIG91dCBvbiBkaXNrIGFsdGhvdWdoIHdlIGFyZSBh
Ym91dCB0byBleHBhbmQgaV9zaXplLgo+PiBDb3JyZWN0Lgo+Pj4gRGlkIEkgdW5kZXJzdGFuZCB0
aGUgcHJvYmxlbSBjb3JyZWN0bHk/IEJ1dCB3aGF0IGNvbmZ1c2VzIG1lIGlzIHRoYXQKPj4+IG9j
ZnMyX3plcm9fZXh0ZW5kX3JhbmdlKCkgKG9jZnMyX3dyaXRlX3plcm9fcGFnZSgpIGluIGZhY3Qp
IGFjdHVhbGx5IGRvZXMKPj4+IGV4dGVuZCBpX3NpemUgdG8gY29udGFpbiB0aGUgcmFuZ2UgaXQg
emVyb2VzIG91dCB3aGlsZSBzdGlsbCBob2xkaW5nIHRoZQo+Pj4gcGFnZSBsb2NrIHNvIGl0IHNo
b3VsZCBiZSBwcm90ZWN0ZWQgYWdhaW5zdCB0aGUgcmFjZSB3aXRoIHdyaXRlYmFjayBJCj4+PiBv
dXRsaW5lZCBhYm92ZS4gV2hhdCBhbSBJIG1pc3Npbmc/Cj4+IFRoYW5rIHlvdSBmb3IgcG9pbnRp
bmcgdGhpcy4gSSBkaWRuJ3QgcmVhbGl6ZSBvY2ZzMl96ZXJvX2V4dGVuZCgpIHdpbGwKPj4gdXBk
YXRlIGlub2RlIHNpemUsCj4+Cj4+IHdpdGggaXQsIHRydW5jYXRlIHRvIGV4dGVuZCBmaWxlIHdp
bGwgbm90IHN1ZmZlciB0aGlzIGlzc3VlLiBUaGUgb3JpZ2luYWwKPj4gaXNzdWUgaGFwcGVuZWQg
d2l0aAo+Pgo+PiBxZW11IHRoYXQgdXNlZCB0aGUgZm9sbG93aW5nIGZhbGxvY2F0ZSB0byBleHRl
bmQgZmlsZSBzaXplLiBUaGUgZmlyc3QKPj4gZmFsbG9jYXRlIHB1bmNoZWQKPj4KPj4gaG9sZSBi
ZXlvbmQgdGhlIGlub2RlIHNpemUoMjI3NjE5NjM1MikgYnV0IG5vdCB1cGRhdGUgaXNpemUsIHRo
ZSBzZWNvbmQgb25lCj4+IHVwZGF0ZWQKPj4KPj4gaXNpemUsIHRoZSBmaXJzdCBvbmUgd2lsbCBk
byBzb21lIGJ1ZmZlciB3cml0ZSB0byB6ZXJvIGVvZiBibG9ja3MgaW4KPj4gb2NmczJfcmVtb3Zl
X2lub2RlX3JhbmdlCj4+Cj4+IC0+b2NmczJfemVyb19wYXJ0aWFsX2NsdXN0ZXJzLT5vY2ZzMl96
ZXJvX3JhbmdlX2Zvcl90cnVuY2F0ZS4KPj4KPj4gIMKgwqDCoCBmYWxsb2NhdGUoMTEsIEZBTExP
Q19GTF9LRUVQX1NJWkV8RkFMTE9DX0ZMX1BVTkNIX0hPTEUsIDIyNzYxOTYzNTIsCj4+IDY1NTM2
KSA9IDAKPj4gIMKgwqDCoCBmYWxsb2NhdGUoMTEsIDAsIDIyNzYxOTYzNTIsIDY1NTM2KSA9IDAK
PiBPSywgSSBzZWUuIEFuZCBBRkFJQ1QgaXQgaXMgbm90IGFib3V0IHdyaXRlYmFjayByYWNpbmcg
d2l0aCB0aGUgemVyb2luZyBpbgo+IG9jZnMyX3plcm9fcmFuZ2VfZm9yX3RydW5jYXRlKCkgYnV0
IHJhdGhlciB0aGUgZmlsZW1hcF9mZGF0YXdyaXRlX3JhbmdlKCkKPiB0aGVyZSBub3Qgd3JpdGlu
ZyBvdXQgemVyb2VkIHBhZ2VzIGlmIHRoZXkgYXJlIGJleW9uZCBpX3NpemUuIEFuZCBob25lc3Rs
eSwKPiByYXRoZXIgdGhhbiB0cnlpbmcgdG8gZXh0ZW5kIGJsb2NrX3dyaXRlX2Z1bGxfcGFnZSgp
IGZvciB0aGlzIG9kZCBjb3JuZXIKPiBjYXNlLCBJJ2QgdXNlIHNiX2lzc3VlX3plcm9vdXQoKSBv
ciBjb2RlIHNvbWV0aGluZyBzaW1pbGFyIHRvCj4gX19ibGtkZXZfaXNzdWVfemVyb19wYWdlcygp
IGluc2lkZSBPQ0ZTMi4gQmVjYXVzZSBtYWtpbmcgcGFnZXMgaW4gdGhlIHBhZ2UKPiBjYWNoZSBi
ZXlvbmQgaV9zaXplIHdvcmsgaXMgYWx3YXlzIGdvaW5nIHRvIGJlIGZyYWdpbGUuLi4KClRoYW5r
cyBmb3IgdGhlIHN1Z2dlc3Rpb24uIEkgd2lsbCBtYWtlIHYyIHVzaW5nIHplcm9vdXQuCgpUaGFu
a3MsCgpKdW54aWFvLgoKPgo+IAkJCQkJCQkJSG9uemEKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1k
ZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGlu
Zm8vb2NmczItZGV2ZWw=
