Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0E2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Zo9RgDIrGx9xDWoColpOrjVMSZprbx7y6wx1zuK1DdE=;
 b=MJlxSRbluql3drlvo0vkVyfsy05Tr433gak8xZeKlo1bsM2SDhafpf2znO2pBh1HgIcfG+PSqSjP
   ZbRbYckS3QOjjdLTCm9/2dullY0fCTCWRGs1lkega8HcCZipIm4rMRU8nY9FwvdKhUeDJ5c8jP/2
   s0Qm6hj2mFyPsywahJ1fGcgx56RDeQon+PrNq1FBoyc7Wc7kp/DZV6qRIV7VUGBzGcNcCRZfizQi
   0ew0HNvVcMBhwxGQCFQsCRp7vRMuXan0tbLbhec0A7a3YK29V3ieiGNoqRZcZ8tOEyXreP437DcS
   BmEuN0oMUKDW77F3N3WHXfVaXUXFuIWYObcj0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Zo9RgDIrGx9xDWoColpOrjVMSZprbx7y6wx1zuK1DdE=;
 b=jVemo4Cz87A4LcaTKUAotqiX1XJptooIM+yi+INTsvgJj25dBryE8JR+3jjLIbM6Gwdq13+beXNR
   fIrBLA1xZiXrF1Au0KpOMiO6lqDHXppLx4JLcCVMljHfx3kywIBLdNLvkKoYJGtP4WCXAjJxup/7
   dec55Qr499Yax9VUQHZdhbPpsYb63mn3tpUwHBwGoAtlt1yrh6BRQMijayWzdGbwpMF3ddpZwvOq
   u+J/f/x5T5Mnn7jzT/enyrMKJZvyZEEfo3D/SCTxz+eTVV3fnDj36s0BLJqznEmpqBv3dMQcXHBo
   jjvcGVkBm3NrX8h1CCfKiTf4cmewRrSIXS2qAQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200OGWZ5IPH80@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 16:29:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649521767;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9BMXpoEZd5TNZ3qFBt68e8YdjJcPqZ+thVQCQ3USw8g=;
 b=dZFrCk2DGnKsHiLFzVe3blM6/tugfxEARynWRVd73HE10GAkLsPFsLchdtSrB+YUZOxTgo
 GvEN7js7TyvunFKLXET/eSbLFRn4gr9gDu2VHUS+g9S/bJV/lA1ZWuK8KHWMMqitDcBMBw
 GHlkzTo0lZ9W1+fFvF6ShQeznnWaqWc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArYryUBJYaqXVDgCzVNiJjZPAgE1nEkHsQSYMGvZdV7X7//siEWZ3NIaA21R/mCj7mgMSR8g06WksI5z5ypHXa8WPFwpNmt3I65JxQCvWsztj5lN0+V1yGvHTrz+I3uC94ye2pYNu/eGoCPYCWYUJ3zcOeRDVjXbIgpYSkaFSuJ009NZ1OVLhA+FftsCGEDa2eVxR8khnW7Smyop55RqKOYia+N4GMA2iok8QeOG/eXPqDcCKKFLfZ1/9149PWeV3tMDLz6OhJuEjdjAxG9zZZn6kOOWc0jBmOQTEzLKmUY3aZZRxX98wBw0lXt3FxZ2DQtF+X9hpWiYnMZfZJSPXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BMXpoEZd5TNZ3qFBt68e8YdjJcPqZ+thVQCQ3USw8g=;
 b=fyyVygjCjnC/PiKuDF1E5zIeT3AiV8/o84zdk0uS5o73NtQ8WTdE0E9OEFbubkVRZbszn2xsgQMKfTHi1QL/46w76H1D8TYa3CWApwrnnJBVGOu64ECeNjUJOlcTZiJO/Hfs+oTc8mSrLvFJ5MArMFYZRvwlmWonFvF0trUEI43vYXu6j2bpDhdmP1T7PeCL3ziopygsorU3AuOFxkUhgZJvFEKg0FA1XSAoWOmQMdikjEv5eFKSDhK8+SxvHeq2SrLCNOq4kZeA5HKJA184V840c3HH9exdtRd1FhvWvT0IZ++R/uEDCSQDQwQ+i0gJ76FCzewRXRRozcRqnNXVbg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <b9f06820-c624-1173-338c-9a881cc9c33b@suse.com>
Date: Sun, 10 Apr 2022 00:29:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-3-heming.zhao@suse.com>
 <d299dcf2-d160-9db0-acdf-201fe7be8089@linux.alibaba.com>
Content-language: en-US
In-reply-to: <d299dcf2-d160-9db0-acdf-201fe7be8089@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(31696002)(86362001)(36756003)(5660300002)(83380400001)(8936002)(66556008)(66476007)(66946007)(8676002)(31686004)(316002)(2906002)(26005)(186003)(6666004)(6512007)(6506007)(53546011)(2616005)(508600001)(6486002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 16:29:24.7212 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 mlxlogscore=999 clxscore=183 mlxscore=0 spamscore=0
 priorityscore=213 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090107
Subject: Re: [Ocfs2-devel] [PATCH v1 2/5] ocfs2: change return type of
	ocfs2_resmap_init
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: q0NR7BwaPo2GmwPYPUkTxg-1
X-ClientProxiedBy: HK2PR02CA0142.apcprd02.prod.outlook.com
 (2603:1096:202:16::26) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 811ca700-97f6-45d1-31c3-08da1a461bea
X-MS-TrafficTypeDiagnostic: VI1PR04MB6894:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB6894B4E978BC1002F7B4FE4697E89@VI1PR04MB6894.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 g77aEvJiu6XdJq9FYEMN80nsty+q1/TYwO4PwuCVbR2sKmoFXTza+7H/E0Lwd+vjTa8kxlyUPfM00yz19rI3/j+PIb5Xs2sE9XHNFr3XokGFaKlRk04L9XVvv57gsTxbZFhpKufHBM3haBaAR6mXZ4+bm4u57iwUvkNmfTnzAu3UaYGipPLG2o8BwCZZYjm+X9mfPqx+gtVhUd05CARUGu6lbqbGusclDQQ4hns6rRWT8Cru7dtZ835nzCscgfx0gDzYItvL+ogNlZ4OWuaLkzd27GQQX/iQqRZyImEQsqDU7SXkUmw2/lgpDHpSCu/6HsenXJ/RefWqtvMiw1WkLczWICP4darfekhr2MgIvQ24BPYeLEnjXUhkuuKGV++KPQc3REFjQ1GdpH2ejrd6K7gyTxX2avHj9hc4GorZorpFsN7fOqtZ2sCl28MZh6s5mZJz6vRTd/A8qcbaWZdzgG9g9mTwJOVwgh78rbme4U0yJfT4RHQgtvCPHeaOOXIu9Hn9bEFNNBDYiM22mtyjMzQnIJEx4Mjo0bvKN3cNhElGyQTabt2n6x9Ji41/a/zs7ELtZ3Zfkve2yW6M/1m+ZEMRdh4t1ReyIS3za/7xs/DXUTCvA5MeecBNZ7ErVZP8mCjAqbzh023iKfRgytRMIO4SIl0vBWq4c3QIruO+dB0o3hpqlTHkJmVmp96OIPYpGnBVyA/WcOnfOuKRBe55CyQDuaepcgiKwhz6PZ3uT/0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZUFnT0xLQnNZRnNETGNTbWNOUGhtSFo2NWFST09pa0svbDhHakZvRjNPQm1v?=
 =?utf-8?B?dDRtZzZUc1U2M2xQUjkyVUc5ZFplZWpLRms1QktsRm42d1c1V3lkZUZxWm9h?=
 =?utf-8?B?R0NlYVhEOXNrQW5NL0FsTU9MNEhZNjAzOWUwMStKKy94Y21SeVpwVVY2dzZD?=
 =?utf-8?B?QnJlLytpUnNKYnpZQjNIZ1paODZUNk5tdkJmZHBIa1JoeHBQZkhyNGQ5Tkp6?=
 =?utf-8?B?UFQ3ZXBLenE1MVM0TFkzSFdHa3A1Qzl4Y2dSaXVIbm1HL1BPV20zbnhYNXZU?=
 =?utf-8?B?N04ySS9QSExSbmN0Sjc0V0xCZFZYaUoxRWZwSW1KVWFTMDZzK3lZVUY0VnYz?=
 =?utf-8?B?K0lOaEx6MDVUeTBKcW4xZ091bVZ3dTZJUWdZa1JGcFpVOTlvSEhYVzR4anJ3?=
 =?utf-8?B?Y25kQ3NoK0NrSm1WdnZOczJVdk5xV3gyV2REeHZpUkczWnVXd3Vyd1FpVzhw?=
 =?utf-8?B?WklxamxxQnVVbUdjaGY3cVk5MFhzODRyTWF0eXZKZGdDN0RaZ3k3L2VEQnVk?=
 =?utf-8?B?aS9PdlFrcmlPaUlaazRFODRoZXlRWkFHL1NoWW9RMzZWZWxzSWlBV0RnN2k5?=
 =?utf-8?B?YmZrcjFrOU9ybGh4OVFkWjNCWnptaW82WnExQ3JDZkkvYitseE16U3IzOWIv?=
 =?utf-8?B?bUdvUENqcDJ5UXBVaEpMZzlSeFJwSk1aRksxSHd4TDBsbG1lTmE4Ukk5VExS?=
 =?utf-8?B?aDJJenJpSGZpWEpEdC9GcmZnOWlLaktsUzI1NTJnWXJpeVVJUkdxU2NFYW5S?=
 =?utf-8?B?S2Fjd0Q1dGt0bVpCcTdoVk1GK09QcHYzOWdhN2d2eWRGTE5xWVNPdFlJQjA5?=
 =?utf-8?B?VVF5Y21OQ0ZVT2QwUDdMbElYYVQ0YXBnVFZsUVFoTnk1U3JUKzZBZ0pFbFFa?=
 =?utf-8?B?NG0ra3NZWFMvWFZ3czMwbnc2eHNHVnJEY1FPdWVhaGZOK2YwWXpRSkhNVnBW?=
 =?utf-8?B?Z3oxSjVmQy9BTzNoUVB5OFRNbG0ySysyT1J4MVVyQnBrNktNSGJab0p6MlNX?=
 =?utf-8?B?TnhCdkhBYlRRclAzK1hNZis0YjRXNnVzeitJNldhbFkvZXNpWUhkZTR0Nmd5?=
 =?utf-8?B?YU55SU5IYWJoR1pMcUdaWkRPRUlPL2dHZ1NGc0xKeXZIMCs0eUw5YnlWQXlz?=
 =?utf-8?B?ZTZSaGxVZm5zMERtRDNReUJxTi9tN2RJOTlDZWhMQUt3VVdmaEM5dlNOaDNN?=
 =?utf-8?B?WlZsbkVaUEF5Vk5GZnlRVTZ3a0IrblBmWWVKMndvbWQwaE91L3BraVpsWlA0?=
 =?utf-8?B?LzR4TUhFSVYwWnppVU03QVVCZnhydjdnRG5aejZuUUQrK3NLbG1UM2VrUTlX?=
 =?utf-8?B?VVM0SlN3alpUTXlZa3F0akNPTFRCVGlYZGhMd1luMmhEUXEyN2lZbHh0Zmtm?=
 =?utf-8?B?dVdQd0tjZ3E0YmFvWmhDb1Q4aitreFNDMUxNc3M1dklFYlplV01DUFBJNUZk?=
 =?utf-8?B?RCtpc0hDd2kzK1JDVy83VmNCZEo5TE8xQmlWZ3ZKL2JiOVpjbXdUQ2dTa3lv?=
 =?utf-8?B?OTdMMldJVG4zemZXQ1Z6OXRQRmcyNXhhNmpQT3JmS2MzTkI4SFJIU2F1aUhl?=
 =?utf-8?B?eFR3VGk2Znd6a0xlcm9MaXVnajFsNG4rY2JNYXVOaDFWUHhhc3dBbU9pdlVv?=
 =?utf-8?B?WUJjNGhYcXQwem5ISkpYSFVZdFArTVFpL0NhU2ZwaUlJcUVLMkpwaWVSU2Yz?=
 =?utf-8?B?VmRZcG1uUklRUWZTcnF4Qlk5VUhiNzErV1RIUVhON0g4SkhIcnR1R0VHUjBC?=
 =?utf-8?B?RVlpNS9ETENKdXBVRTJPNWc5d1o2a25pL2E1bTQva0JYQnFOdWxEY2dBM0Ez?=
 =?utf-8?B?eTJkSWlJMmRzeGRrZ0tEVGZiTkd2VElZVXl3eFZ3bURsSGEzenF0WXZBaGRY?=
 =?utf-8?B?WEVVdHVSdVc5bkt3eUdkajByeWVKYjl3U2hWUlBvS01mUjBKME5GOTVnZ1ps?=
 =?utf-8?B?NVNxTmNxeWt0VXMwSThJNmVBZ2RlVFpndEQyR1dUNFN4eG9vNTE0Rk5IVkM4?=
 =?utf-8?B?Ti9MeEYzNUEzRURSK1RwYTRURVIzUjZyYlh6WGd0UVRCVjBOVWl1akNHU2lJ?=
 =?utf-8?B?cXMvbmZrdGxWclBoN0N1Y2NsUFN1UDJyVG9XNFlpQXRWdDRSdUs0N2ZMMndr?=
 =?utf-8?B?bS8vMExQUHJ3MWVNZ2VOVGcwdExVRUI0RE9WVFhsTXNKNXpXbmd0YmJHMlBn?=
 =?utf-8?B?UTVCdXNsdy9xS2tGbmY1VGZWWkMyYUowREZ2SHk5dmpDK1p5Ti9Bc3c1Mytv?=
 =?utf-8?B?b3ZCZ2hyaldTUFhoVVJMbkpTZU1yNkw3UitpaDhPa2czRER5cTI0SDdHdWUy?=
 =?utf-8?B?bTJhYmxqelFuVlhMeHFKd2lKRkRGTWJFL1ZDRkRxS3Vkb0hqVk9aUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 811ca700-97f6-45d1-31c3-08da1a461bea
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 rzLu3/XZZ2pxRhttdtUHYkPe7tVM25G3Ci1V6tNu8MWJLbA/5gtldeokmTOr7L/cpHCVscynpPVgtpRNUVLVdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6894
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: kNw0Z5vnxPmzR5jBJllNz68voFiMoep8
X-Proofpoint-GUID: kNw0Z5vnxPmzR5jBJllNz68voFiMoep8
Reporting-Meta:
 AAEDlDqv38FGx/jaGkIHiDIA/mRNWdvvlo4ZWQZmXScXdR7yeaNKK3UInCrgVSuC
 DzP4G9qO7YiRTzblgkQ7yLMkdZcXa/wCzUZKhKlFeUQd6NYspxe0uOKXx5E7WNcq
 Zxr4323JpbHb6Iqb647isIEzocVlvp3pBjqnN54arxomLM2JJ1QXUlFq+R31Mc9z
 f7Qlc0UTF6hc/Id7AB+vY/80KNodfzyJ7Q4h+KYiJGeLTMPojhBmipoJaZXMcjVD
 ydZRRXiMCjUMOyMOjkzbZdTp79i3CdR3Pac4574AsQ+xNLHPsWRJTZIlaMJvbZFC
 mAAnaQwu2L9elWa1K4BBk6CJuoOxpRg7iXH+4pMdemHCrnylFlPHYNLGEPT0HL6e
 +2oUspbCZJdOhJ5ltcTa4CsKQMeONPc/kLcY70vr3JIoo83gwP4XtYkazAuOt4CJ
 gtb3BofbQa2ju5d91dAsnvQlw3RmzJGA1gJB3pbT5DdACOSEsv8FC64albJ69TQb
 fA/+sohVV9ULhxonEUdHuspU7t/HjH3Y8pcxzSc2VrYl

On 4/9/22 21:14, Joseph Qi wrote:
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
>> For rewrite error handling of ocfs2_initialize_super, change this
>> function return type from int to void.
>>
> Since ocfs2_resmap_init() always return 0, change it to void.

OK.

> 
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/reservations.c | 4 +---
>>   fs/ocfs2/reservations.h | 5 ++---
>>   fs/ocfs2/super.c        | 6 +-----
>>   3 files changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
>> index 769e466887b0..a9d1296d736d 100644
>> --- a/fs/ocfs2/reservations.c
>> +++ b/fs/ocfs2/reservations.c
>> @@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
>>   	resv->r_flags |= flags;
>>   }
>>   
>> -int ocfs2_resmap_init(struct ocfs2_super *osb,
>> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>>   		      struct ocfs2_reservation_map *resmap)
>>   {
>>   	memset(resmap, 0, sizeof(*resmap));
>> @@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
>>   	resmap->m_reservations = RB_ROOT;
>>   	/* m_bitmap_len is initialized to zero by the above memset. */
>>   	INIT_LIST_HEAD(&resmap->m_lru);
>> -
>> -	return 0;
>>   }
>>   
>>   static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
>> diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
>> index 677c50663595..532d42eb6db7 100644
>> --- a/fs/ocfs2/reservations.h
>> +++ b/fs/ocfs2/reservations.h
>> @@ -78,10 +78,9 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
>>    * @ops: unused for now
>>    * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
>>    *
>> - * Only possible return value other than '0' is -ENOMEM for failure to
>> - * allocation mirror bitmap.
>> + * This function does initialize resmap job.
>>    */
> This comments is meaningless, so just remove it looks better.

OK.

- Heming

> 
>> -int ocfs2_resmap_init(struct ocfs2_super *osb,
>> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>>   		      struct ocfs2_reservation_map *resmap);
>>   
>>   /**
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 8391592817f8..f91c5510bc7e 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2111,11 +2111,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   
>>   	init_waitqueue_head(&osb->osb_mount_event);
>>   
>> -	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>> -	if (status) {
>> -		mlog_errno(status);
>> -		goto bail;
>> -	}
>> +	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>>   
>>   	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
>>   	if (!osb->vol_label) {
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
