Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D278CC4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Mar 2022 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e9RwIMxR7hPX9Utc5kcyCLwr47HHd6RAgIOdW9In+pc=;
 b=NYMs6saJAI53C0UF1q7TxQIAIBzC8sYtT59eo6GiUUi+A0R0PVp6RautAhRZZriP1Ksg1FaRbcET
   v2C4eWA18lIRsUsJFQTu4/uiAOliWa7Je95HN1xlSuK65t45GAux3Qgi167Uci4spMh1W/VK9vvu
   yrbWerR7P//UdxDSSNZH++oYthBNoD62UDzkGTaQQ50bK3ZOmbwlxOMFeqM3ADb5BISlAiucmc/c
   hh9NfQlds8hd0X8M+ze0wZ+o5q6S+M43jVr/qTx4FqVGpqZ4E1hYDPRzxP7w3K3pKxeGXjsl93R0
   ZqxgxKBJsh7wLFeCM4dbtKlAtBvTnoXy09+5/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e9RwIMxR7hPX9Utc5kcyCLwr47HHd6RAgIOdW9In+pc=;
 b=s2VJv/6P+oONiAzMwyAu9oKxNE3yvX1VCrGUH3TJlNBwaPAEedCdDnmBTkdVW4CTgsb/00wuWZSs
   PV1FRyB1hcgrxRQIvC5aKR8cW2HwMXMzRnC5vNgdc/6slm6KC/HqlBUc32EuLMAuBHRLnLk7r7AQ
   8ICu2S4MKBDBBobHySGnBY/70Y/x7iyrK38AfEhlZ/WTceH7hAycKlA+s9TXxfdF6sp5MfOE0ntO
   I4AOM8iMZ7oaWpa3lba54J3PXKo6h2+loU1ReSq8DJOWR8P4F1zXuZ50YI8oIOsrnWLCu311ftOw
   yIWjpdZvFeB0W/+ayVEFmq6gJV/u4Gl26LdE7w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9300520LBN7U60@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Mar 2022 13:54:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : references : content-type :
 in-reply-to : mime-version; s=corp-2021-07-09;
 bh=LojAHNHQAO2wcQ8UjhROsifyzn9vDUjoeJySsg8W6tA=;
 b=Tt22W1rifVaLx1x3OAsAABHITtxbe6bpdWkKNftHfqWpnuiTETDsmM+4p3hz1yHllt74
 RjLB9ooha9YjE4vYpJNmgeAghYDiz6Ryd48ieTbvQ+nfD4dGPH+m//WKlPzkOmtIBsKW
 qUFSdWPAXVaAc1+vWV+zimBi/AomWxzmyegLl5Mt3Sld/1pFGrWMFamIlTzH1Ya5+tKE
 K5Y6Pcvqr7Qa1qT36G5vqSz0COayDfCy18NDXIYfItEXHm/DSlBrmSuOaRJzHUjKB4rl
 3NFzPNUqQGk5CXMDHLwQdttdpOQBF9fhJiQFZ8Zl+s018PFU10wOE69fwKPjCQbKglVe jw==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+rJ3xJBZS7QO6TVPeEsV/RYCU1CsqNZ+d97E6icyL08PsSrcmzY8UxXxId3Rlr3GEc76vhC7i4IqXBp3rotMBXei8odTL6rO42zsIv03NRq6KBP9sfR2hhbV2dZr1D8bF98n4Hymx+ttPlcjOkJMF/L0SxyNrgSUMBWyRiUgi4vQ8wbf1fbyX3eUQhwlMyyce6zew3wr3twfQnHokoRTDvVJZVGuq82biKS33+TiY2dES6z4gjCobToKUEiaM61kboYZn72+/sRDiI4y2A8WtbpEKtx4pXwpvi19zRU1ewNBzAmEaHvEx1BYxE8NaZIkNxdt5Kc7VpRTyo37quLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LojAHNHQAO2wcQ8UjhROsifyzn9vDUjoeJySsg8W6tA=;
 b=jPyD+wm9q21HNZfkJZb5yZ0a6t1qMEwAyDAOh0vaU7iKCkfNCoiEFETWZsLMzXP3iCwPJhUP/ULU83McgewNYXmNYgeQGbxRJYKTVbXE6jmIEmVBpqSWJl0cDWB0chO+lgd2oDqSe6dq6W9l0V8E5RtnqWTqycT69YmoSNP1O/d7EOcV8jvHrsfiHObXj3R5S+gc9kRYqR6mhcpgXnZkHnIw13nggzsR3hkWpcmI4NCU8uqub2yEt0q3oP0R43MwRvBIJ6B6o46oARMQSvxBb1vYGCgd8ctmrp+R40Y7ebbtHfVU4Qt0ANQ/P0myPXkzodpV5I2qvwHsDYd4mGbd3Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LojAHNHQAO2wcQ8UjhROsifyzn9vDUjoeJySsg8W6tA=;
 b=e47sx14z65X0O518KcQL+3QI5FE1o8hzh2E/w6iR4BIDqIwgG1oeRWYvMlnoGG0ujX38d1Ag996ORzKAaHEU9Qrq8wOs/mJ5XCpU3dw0kpI8u2gtBh6XL1QvsWnJ8k1O01oU4ZDXYAKxDpNYMjgAZmUZzK/dOCcf0vzagLT3qO0=
Date: Mon, 21 Mar 2022 16:54:35 +0300
To: Jakob Koschel <jakobkoschel@gmail.com>
Message-id: <20220321135435.GL336@kadam>
References: <20220319203106.2541700-1-jakobkoschel@gmail.com>
 <abcbf5d2-c348-7dc0-cfd3-9bcc6431bc64@linux.alibaba.com>
 <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com>
Content-disposition: inline
In-reply-to: <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 13:54:46.9808 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292
 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210089
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix check if list iterator did	find
 an element
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: MR1P264CA0025.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1fb6d59-aebb-4dd0-59a8-08da0b425c15
X-MS-TrafficTypeDiagnostic: DM8PR10MB5462:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 xESGMhFcWSu4CZdjkuYjPRk3mADQ5mtFHTuGlgQNspc6nW6vH//p+g6KRUN2xyuT8jHojDgKRe4uUaTq53vOm52kdzrlZxeY0O1h8dWCb+PPOLBpYqMv/OBUVyXZt6UoqXDDgXKTqtJtwi1OiLmD6ClfAazTo4iTtC0QIBB4l0QOStuy91Wp5KprCTpLNyqwYD/KVGiGxEOLKL5YtZVRLFJqp14KSQkKDCMYKzRnMokebrHwn/VlfJXtgdfdRAUzy3+UbtG5Qiv6+wl+vhZuUjxTsST8rHCnmnJ9OfASPGmCt99q7zX+c3TK6bHRnuLixjpjLSI1dQdOvtvU4Mj3pEhnSBCt95GJGtx7QWOteR+CIxGybd5Ua9yKg3t71IFzf4afzHkh2If+H78ycvta2MUGaKH1E6iOeBOqXPV88E7laUhR/G/h0cs+XV3NpS9iPZ+BFTpdqDSYmE8RNDkA9FeAa2w1s/Qyt/+H2F67qupzj1r+Qd1ON7yC+aRZIfjWi/3dt9Z8qYyJfAFbY3NRgvCPzN13/B3z3XnsAqohUwYWAABUhs0KfDEnQ5qTQ/uqhRWZmk0CA+JXji3AOxBW3zv1+OqQ+ACLdaS9hi1BUYI=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 d1fb6d59-aebb-4dd0-59a8-08da0b425c15
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 fjg2nBujdSPc2GEU2wpI2lZ5dmc3VWxVTLTi+03MJkEsMDluitCL0caZF1tQIUOj0va+dH45xp2zfBvDF8OW7zLEmOh8Tm9kqINy1sl7x1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5462
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 62.8.65.185
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: DM8PR10MB5462.namprd10.prod.outlook.com
X-Proofpoint-GUID: 1M6XKkMJgA5oypUDWyAbEhUkXhTaFFUi
X-Proofpoint-ORIG-GUID: 1M6XKkMJgA5oypUDWyAbEhUkXhTaFFUi
Reporting-Meta:
 AAG5jAG3e6h7BS/gM1AJazPowO47eCr4o1djqIJRSOE/4x7pINhhuVSssosdlqdQ
 z9+/y9qDdL04I320jFEs7WEP1F7R/iY0wyidIiGI7Y8DfYMcj+xFhalUYs6+3ak7
 tloWRERY8Ej5ZOcXoslpaOkl16KwGn3RZPNJoI2ru2cZvJxoqs5Jmc6HjoeZc/6j
 1ImcTr5NdeDferm1zrJXx3zl/lpHePWqKTrmLvsfeMWKMHlA2OlSgg9XqYTMK/ze
 dpi93l67VhCzg3NMShdfFnmf6byqJF3A6E05KsNlAlOzIspwNqvqUHWGHX1TDti2
 Gda6GUTSwfMhKhzTjrFuKyMQRcLDdtP96ySN2BA99+Phv8z7I0ADrFXkqj2lSLT0
 vOLE7DyB7xq998ybKBsdsWjc0cPpCRdip1bW0YxnH9W7PGDM9hszGXosxtPZj/H7
 NftwxUh9yQ3+6R5oGGKF8RTlINduERKcgZPo2FcT+sGu0HA01opdXMHVWpnSmUE1
 weKmDLwJe4LajHgWmF3JT6bMQ3AcLBKW+gvjpdtZsrS7CA==

On Mon, Mar 21, 2022 at 02:34:34PM +0100, Jakob Koschel wrote:
> >> @@ -556,11 +556,11 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
> >> 		}
> >> 	}
> >> 
> >> -	list_for_each_entry(res, track_list, tracking) {
> >> -		if (&res->tracking == &dlm->tracking_list)
> >> -			res = NULL;
> >> -		else
> >> -			dlm_lockres_get(res);
> >> +	list_for_each_entry(iter, track_list, tracking) {
> >> +		if (&iter->tracking != &dlm->tracking_list) {

This is an open coded version of:

	if (!list_entry_is_head(iter, &dlm->tracking_list, tracking)) {

Ideally someone would come through with enough confidence to just delete
it but the second best option is to just make it readable...

regards,
dan carpenter

> >> +			dlm_lockres_get(iter);
> >> +			res = iter;
> >> +		}
> >> 		break;
> >> 	}


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
