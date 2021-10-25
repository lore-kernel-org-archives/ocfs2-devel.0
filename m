Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B464C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:56:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAABF60E75
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CAABF60E75
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PFadSx028447;
	Mon, 25 Oct 2021 15:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=daWF6jhrELn+b2ryDtV5Ji9QkxlSO1sKsZeCFMw5ims=;
 b=Pntt8dZJhR1dIhQ9Z54eJfIxdbna/5nwJ6E+6z14dgHAHIOKyvrK8qQ/Q4bvawZHKdpj
 MaeCbUDt8E2wwp7sWzubcyxjXAqViQ6NBbJ08hRGlWT0EASd8p8HknqEhLimBJKD1oBV
 8qiltzvf2cqriQJlY0vEWTVzHQS8iemENrzqnAFbi0T6fdpK1jYxChPLgzVU3SNqHez6
 9RJecZ5n/xbeSWpFMpMoM2SEWK9UOHENfqBnIY723hAvolOw9HoI+CL4cnoyyY2ek2uM
 jjbDaDo6GqfgUCxcucGTO37qz5TjlS1SzLCKizVyueHalOL7yArf20+DELBOPhU+82Rl jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bwx9k8kf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 15:56:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PFttWG142049;
	Mon, 25 Oct 2021 15:56:45 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bv7guumb6-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 15:56:45 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf2I3-0006ND-G4; Mon, 25 Oct 2021 08:53:35 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1mf2I0-0006Le-Fb
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 08:53:32 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PFLrU9023570
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:53:32 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
	by userp3020.oracle.com with ESMTP id 3bvv5s7ma3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=BI/xUuJH5RnowPErH3D1fJpxRqa0O+dlwgYn1Y3/2qzaHLTq4G18zBI6J3L+Q47ABwBnS8EZkngRBTvTZ3KYIxmlBljZEtNWpswBIQwCE+hIboxyEXMQu0GpJjsKTsh6zsPR/erj/8rZOariln8hXr7VycStlNiA6ytBEup+acg55zJAuZRsSxIcbrNr+6hPG8Dm3aH89edFAq1pzGBqT2oATRBx3Urwa1RBDgwL7KHuRlOH5Q727u1DBuYpztpQWURu1TdUQH7mU+bn/sitoApVT8y0Ffa6lNnDSDl9S1QLmpxerHAhba3FLoG2Rk4Hm7B2gABe9SxfnmlIVEC/6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=GSXQgJT96TXyDhsxw70QN263vdwIJO9qMSZWDmOJwZY=;
	b=F/WSSv8XJjaVV38Ui9rzp/DI1X+outIopSNTIyQCc8JiumX3pZE0nJSbaFxDlZBIyM4S1bBONX0n5TLxnz/17lKWQGqZ0fKeMstRg59Ylpx1zXcikcT0NjpiK2OzBJJ5hMIv0dxBaz5R3Auc/9LRAEjCbIEIqqLecTjmZ/VZi9x4zFeUtl7/p9TTkbTndrZFQPBI4roeTKkIo/4FH0Gt1mc6PtVlP4xHJgxVFaixynOGUeLx+mVzMOrWoo6AI0vqdVrs7xmZ/0PRNIn4tJVnOle6KVUfenzBmXov2HZ8YTKK5pYOdsGoftBYVSaobShmCnvxKRUe8KNkhMY1WpdpyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
	dkim=pass header.d=oracle.com; arc=none
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
	DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4628.16; Mon, 25 Oct 2021 15:53:30 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2]) by
	DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2%5]) with mapi id 15.20.4628.020;
	Mon, 25 Oct 2021 15:53:30 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andrew Morton
	<akpm@linux-foundation.org>
Thread-Topic: [PATCH V2 RFC 1/1] ocfs2: race between searching chunks and
	release journal_head from buffer_head
Thread-Index: AQHXxnp2x3VV1gw1nUWnZTq04wIQFqvePTeAgAAQLgCAAAGBgIAFlKng
Date: Mon, 25 Oct 2021 15:53:30 +0000
Message-ID: <DS7PR10MB4878C3D7E16CFE0ED412285EF7839@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <1634820718-6043-1-git-send-email-gautham.ananthakrishna@oracle.com>
	<47e7ddf7-8d0b-0101-69ca-eaecc5fa1813@linux.alibaba.com>
	<20211021193320.c27376a50d364c1a66a2a0f1@linux-foundation.org>
	<f0852834-69a1-dfe0-ecca-634ace3fbb0e@linux.alibaba.com>
In-Reply-To: <f0852834-69a1-dfe0-ecca-634ace3fbb0e@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15fbd988-b9ea-48b8-3fca-08d997cf974d
x-ms-traffictypediagnostic: DM6PR10MB4170:
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uimnL+xN8/whD7OnsU0sZUTqWPq4gQBkUDBlyONcPbVBfpWiFXZfsAPlYE0OrfbrkZxVhvWKfycBO1V7KOndViXxw3E/ukHfGYgY5JTFAUKyeyykL1MBmdG+ntpGIzDWItmmwHOK5BHthgX0lcnYuE+oR0qr26j8VMhu+rBLM1xEcQCsRX3DJQT9EaaDqNMJeIz4znd5GsPxaHOvjrLr4lghydT43rxIIRGGr/z3XTsDGiioNTBiZsbfn/tcd8J5PJbk4gVCJoFJW3xKgDMc/nYtHmWqSU+sSD5jb5hFvZa84lmyR8ZsMj4rWecF1XBEINyewFdWps3pEG3Jkj/xSIf4+4RX8zW9tlG4+7cGBhOmtU6RZIujsFoKdWSYcAeYvGabj2MqqlAOTrkj0dnPU+WtEN0PyXleR0plrfHkF3mtpSf1JWTzscKO5ae3cjf4XPhMqPLzNfYooEwRrODskYmzlnLFgJAMTKPnNqrq3LjBspf9Hq7Gv8mGP372MHmqiUGfg/vOPJ6/n/y0pHQpAaHqFrhigiqnOU+0gJz3MchLRaL4MdKXucireiJGrSNGdkA5ZLEh5NWWUc3wn+9/mWckD1ktZLIv19VX5ie4hqw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fbd988-b9ea-48b8-3fca-08d997cf974d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2021 15:53:30.1544 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xvJ8dorCdXHCWM80P8hVu9iPagdpYmCpxzGnWUJC2qb+9btvKeZ4qfmPe/5plXY2uqY0KGbPvi1slKkmstJm3rC+vE8rlipBbWtV/DQmbljgjWYiSXxwIhzq7FeRuXHf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 138.3.205.56
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM6PR10MB4170.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	mlxscore=0 spamscore=0
	phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110250093
Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH V2 RFC 1/1] ocfs2: race between searching
 chunks and release journal_head from buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250094
X-Proofpoint-GUID: _6lwM791QaY6zVSb80i2bUxg7s6x3MEo
X-Proofpoint-ORIG-GUID: _6lwM791QaY6zVSb80i2bUxg7s6x3MEo

Hi Joseph.

Sure.. I will add. I will send a V3 along with your "reviwed by".

Thanks,
Gautham.

-----Original Message-----
From: Joseph Qi <joseph.qi@linux.alibaba.com> 
Sent: Friday, October 22, 2021 8:09 AM
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; ocfs2-devel@oss.oracle.com; Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH V2 RFC 1/1] ocfs2: race between searching chunks and release journal_head from buffer_head



On 10/22/21 10:33 AM, Andrew Morton wrote:
> On Fri, 22 Oct 2021 09:35:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>
>>
>> On 10/21/21 8:51 PM, Gautham Ananthakrishna wrote:
>>> Encountered a race between ocfs2_test_bg_bit_allocatable() and
>>> jbd2_journal_put_journal_head() resulting in the below vmcore.
>>>
>>
>> ...
>>
>>>
>>> Signed-off-by: Gautham Ananthakrishna 
>>> <gautham.ananthakrishna@oracle.com>
>>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> I added a cc:stable to this to ensure backporting.
> 

Thanks for this.
And I suggest add 'fix' to the subject would be better:
ocfs2: fix race between searching chunks and release journal_head from buffer_head Sorry for your inconvenience, I would have pointed out earlier.
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
