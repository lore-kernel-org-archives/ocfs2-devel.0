Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BCAC00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Aug 2022 02:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EmJO89vQKyxY0MR6TWSXQRxEZ99UNjSLKDXJrookbO8=;
 b=QLYzG6jWQaAfKNOQVasNbLTfZ/94p40DIIYiAZ31GLDhk7OeN6wfosymh2B8do+oLgfDYoQJT29d
   zpLcjecnSH/DHcOVuV/sh5s2WLTAygDAhchcolZiQdDXOQORuvJnDAWuDhb0p/gT0L3ctLPi6hkU
   u/VIrDXlTMIbcNYXTYB4Z21oAG5O4XBnZzMHUgKvmX0vwvSLqlh4fnu2z+dbxPUjFXZdIEIlsX+U
   UNVClJSm5CRdQv8S5mR00Bv8/DLolyDgHUGeezqnqAtpBBWPYKFocIefQ90C+XpHBeAWhG+AzYLx
   dMFla9tv8kmxdAYdn4Tk0lZEFs/DG6o+HgGLpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EmJO89vQKyxY0MR6TWSXQRxEZ99UNjSLKDXJrookbO8=;
 b=iSmHmmV4KrMpThW9ZyInDQu0zhP7PRHlpgkGywnZ7/vRB2EhX6SPzt11p45InBsFivovla8BEMLC
   ltLG6rTgWLxPwqj1Z2flGUYaHX8mgv6R7AD08QWUEwYyfbhgndckA9O9l5cjmrAQ52U0GCYgCh5p
   Kz+4iUM2aVoAk/pp9hVHigZMyI8ZGhq6wzFKlt+TrIL4ICbeyRvsWb6q5TBNIC3a7QVjmGTGscKj
   /nNQtjJze+G4+Foc5ChqJzlGL8DM46V6C4tZ1tmbBSArwZe3UFS9VqxZXNsYVMTfN+kcxBdAofk6
   DvnQai1iVFm+3Ze8vba91sReYefo/GP9eOJA9Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFX00G5T03T2B50@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 Aug 2022 02:26:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBAjfsMVnzH5oOsOBRMUbGgDoHcVzAIoh6XPa7mteRL7ZbSZzONVOQfY85zxLIKzwK22YudIERhe9DNQ5W7z4pKFzvOGAYsZFB9MrLS6EsvxFDN2EIJp39ln+R6ee9Vmpfh7MMfYAER2rUavQGHZT83VuRdyfEaQrtvpcikHC7r52ktqqtv1C3lLzYF7ti6hoxtlDIlDgRy/A67jFLNm/44QXw/CLRnlFrFkSz2SZVzXf6+7/XhBhUfrcZPA2HCvGpFylNetnvmFi1tQ4ZGimwymOTR/O2xYMQkklAaFJIfScwQmgSJ1o5qElnA5zo0HtcJEx6uAn1e/XOv+9qR5jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMqzGwVP9AS0XZo4Q5EbhWjNW/8S8FgVjxuk1McOZOA=;
 b=POnWLPzo3KOO7k+5kWy0Lxa2fFKWVVSzQ1nRd2TM3PwDA90YRS9b6rY0mtLAm01PK8gGc0LtUoMLDZeyTXRfJjAqVHqBDC9gmUDpWvSpv/GMZCPPCs5tNQyQntr8InIjmy2Cf7WIhEmOGFJ/bf97vNNv+UmClnn2Eh4XxEdKYUgl73CwNhIqu5oFPwABa2Aas8ZrZFS8yE2mRElNIdOHgp6mB4J57CpORIt3YOz8T1e9DiZHkcx8MCqTngTBg1l7IftvtQl02gKLqhnmKfqSOwfUSOKG8uDcKr3P6j8+6kgKtTl1QnVV+RJXbqdY1vAPxE34+XHW69cha8s9b0/J6Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMqzGwVP9AS0XZo4Q5EbhWjNW/8S8FgVjxuk1McOZOA=;
 b=e9JCmVtXUMovxS/3uyeFzTUkRG12n/q3bDO2DkWmoIJ++7miG6KPvXjkp3A4kwXDIqEc31ZDuTlN9NroPfkFykvXxrChBpp52z6ocDEXZTs07VyzeV/7sscEWvV288fw8bAKFyZ4phOvro1aNa5tA6AFRcNRxmv/5flEeVxBFPMjahe1pcJJy93XhMSVGzz9QoDmJfRaGn57XTMIjpVKUyewm5pBkaD7xZ+GzXRx4nilas/FBMv8Bh6YXZm4pQCgIsnfW15RQS5QHiWHRt2NP2L3f3pWD8bo5+uUEi/UMZ7A9K6uFjB8RM/VbwRamiR1Mi+Kc4MjM+SkYa6bMhth7w==
Message-id: <1719804c-d52c-2015-bcd7-b649bdd56318@suse.com>
Date: Mon, 1 Aug 2022 10:25:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Mark Fasheh <mark@fasheh.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
In-reply-to: <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(396003)(346002)(366004)(39850400004)(376002)(38100700002)(186003)(8936002)(31686004)(5660300002)(83380400001)(2616005)(6506007)(6666004)(26005)(6512007)(41300700001)(6486002)(478600001)(36756003)(53546011)(316002)(6916009)(8676002)(4326008)(66946007)(66476007)(66556008)(31696002)(86362001)(2906002)(43740500002)(45980500001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 02:25:58.1027 (UTC)
X-Source-IP: 40.107.7.40
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10425
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=208 priorityscore=85 impostorscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010012
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21cd7bad-2e90-471b-88f9-08da73652b1c
X-MS-TrafficTypeDiagnostic: DB7PR04MB5372:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 K0CykxCn8PmfU+boQvdBDdmNiXt3bfz5vlfjN3YS8WbYwzmHJq2CW/D+L5sBjhwSJFqfl5J++k4LqTAgfc1bEIZUkUEVxYo0YVozgGQKO0yB6mlhYVl0kS6MQyXPp/JLz8myhm7W/EsR37qjZYc6F3B1uwjZCHlmcz8G3+L/izNQNxG2mOBLgZfmR0cGpQtErzma0uxksHfvS3VQpv7NqpMZ/qqttrX6NB6vhLh7Jaa6JsHzQ1EfVAMdMIjGeHOkkAHY1ZJbk4pI/5+19/+NfxLHZLGX6DtgfgFkgTinO679rh38g71Rsk0OkuQ2HYRx4liR8hXcVmvpVqFCP3Mk8Sl9HeHquvqtb5GdZdNGSiaNI6u3+cwkN+BYByN9421p3Uw4piP+gCzDdFcDS51Feq0+MSZhgtWyl/E+7TK4D+bW3BDORiEZp7pi0ALpK1gTzVwQYJbGEiYYwi2bwIeysz5oRTzjqqnO2xMuKTmrF/fnWsNnwdXDwhyX1GKjUO2S/0MFNT3/J/yYQsmfc1awPioyXwpJ0tKqH0Zes12Mb/Lyxjd6Fc2s4YqUUmDoQvFF9dTPAe+nlBRZOq+sg7qborOhd8y7T+z/WontgKnryUGkGTaTNZqTH+FCBlc+fxd4jDt5JRd2So6KJ3GRQhsmirJqLEL3Zl8X08rY2XpwYMRlIaaL24Jgwp7nspmpn5A2gIpLa+OTXUkSmJpLXfezLnAHHozlvhxvBaaf+28+1PPkG1hZMnt01yggF3ENgStrfFYQfJVrPkw3w2xZcjy0DYtRSb3VmCFY6hr09oaEFAMb0lUO06NxbssVUligpTeJ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YmErTTFpU05nY2xSOG5Pa205SkRJNjFZdkV1eXROclczdDZ6U1lUTnltTzZK?=
 =?utf-8?B?Y2pPUnlYMEx4Y2syeDMwS3cvdmRLY1VxSkhoL0w3NjJVdWtQamhKUXBSb3RZ?=
 =?utf-8?B?bTByQXZ2UkdpTEswQ2xTN3gzcXRiN3A5ZnlXQVQ1QWdtek1OQnJSWmtVbG0w?=
 =?utf-8?B?RXI0R0Z0TWFKa1pla044M0tENWJTSVRYdDFyelZnblZvTkJnQng4VU51ajQ5?=
 =?utf-8?B?Rnh1RldpTm5WZVRQM2pxS2J5K25lMU9hQUpFVkVnZDhyVDYvZjIrZ2FHckdP?=
 =?utf-8?B?aUhkNzFMNGJFdTVMbFpTSERNUGs3QWt5bXQ2Y3A0dG5hMVdOVWlzeUxlcEl3?=
 =?utf-8?B?NUdkNjJQL05YOE80YXVKMHNDaWp1cVBUY0Y2aGxVc0VsMjdlSU9ac1paQ01o?=
 =?utf-8?B?WkpHemE0QUJSNk42SG9aWlhaK1JnbG9MM2JGZ3g3bnpPOFpVSks1UGVlb2RI?=
 =?utf-8?B?ZkNpV1lhU3AyRW5tSFp4U1ZuRUZZNWtZeEFkT1NjaU1TZkYyRVNaMDhqUkxt?=
 =?utf-8?B?cXBTOG8wNmVzdTVaY2hod0F3eVJDMk1zbGc4Zy9RN21naCtEbkVPYlFvL2pq?=
 =?utf-8?B?QmFuVXFLcXRLY09zcXJNZWd1eHdFaTU3SFpUYmUraHk1QkZTeVJUcW1HVHpU?=
 =?utf-8?B?aDhiOUNvUFN0VTdwWUxPR0hHTnA1ajUzNUJ3SEN1VTFDQU05eUdxNVBFb1VD?=
 =?utf-8?B?NGFVemxkQm45aUY2MnFFSnh3NEpUeXZqbUsydFFDclI0TFdjR3JZSFArQUto?=
 =?utf-8?B?aGxoTkM0dXpJTTBnQzh5dGpLYW41RDZiZ0hkMURPRk5IVWJYUHpwYVQ4OUNB?=
 =?utf-8?B?VDVZMkIzV1NKeGhhc2VSWDE0UWRXNnhJOXJ0enRWZkNzSW1hNllDSHJUcUFB?=
 =?utf-8?B?Vm1PbFBVcnUzMmRYVTRWTVJrdzMyYk1iWGdaZElaQUdmcXMzZWpLQWF3aUtr?=
 =?utf-8?B?dDJLU1BJWjFtRXFwMGVrLzU3RnB6dllQTnB1ZmEzL2xOZlM4RW5zRVAweFRz?=
 =?utf-8?B?WGt6KzBwUVVUemh3OHZpWldUOCtxZE95Y0ZsV3N0d3paaU9lbmgxZmJLSDdL?=
 =?utf-8?B?cngrUlJMS3JDL3dTMUJRU2JPZC85R2lYWDBtQWxiL2t5Nm8vdnpyUHRkU0ds?=
 =?utf-8?B?VGJoMDJqVkVxMnpiK0hLREZTMXRQRzlJYktMUkxtei9FM2kreTJhYmYzZC9P?=
 =?utf-8?B?bnpXbktjWnkyeG9ZSEV5VllZZHFQZHh4TksrdFhUdEhWanN3bHBiQ3dXV0pM?=
 =?utf-8?B?bU11Q014ZHpicmt2dmlROFNxQytQRkpBNkJrd3ZMalAwSzY2TFhYR3JuZU9r?=
 =?utf-8?B?azRxTmZRVEtBNzkyZ0ZzbzRIdUpUMlhIbUtVYVMrejFuYXMyc2ExZzAxZGVk?=
 =?utf-8?B?U0VwdHFFZFp2eHRHWk5IbU9RaS93MFBRWExBOExBZXdCay9LQ1VZZ0VLODJs?=
 =?utf-8?B?Y0pndmttWUh4bmpHZ1REaDFhbXpWN0VQaERWbTJseUg2UGxHSmFDeWlGalJY?=
 =?utf-8?B?M0FwajM3UHpaM29YSnFvVEhVMS9DT000d1J3QTk1OU5zWDJNcmRLWHFGdmcz?=
 =?utf-8?B?NHZ0V1pqaUpLUXR1NTgrK2JhRk9XK1ZuYUtJUkt2Uk5aZHBsRzVkSkFQR3lF?=
 =?utf-8?B?d0dMQ0V0Z0dHRXBjVmh4SENPTlNYWVNlSFZBMVNNeGtMMU55VXpkSUgrOHMx?=
 =?utf-8?B?cjZHcW15Z2hHT2pFclk2NEdZUCtrOHB2ekRHbkVsNDZJc0VTWTBkcHc2TFBo?=
 =?utf-8?B?TWQ4N2xkUHJJcHYzaHlkczZ6NGJFbnhDWGtoczBRcjhXcldGZEFGVUVpWDFX?=
 =?utf-8?B?YldOT2k2bXlEU2pQUi9Yc0hHNU1OUHcvaCtiNVlXUzQvbWU0eWt1US9PekE3?=
 =?utf-8?B?aHFxNXBjaHd5MERWV09NNDFlcjVONTFFS1dOcWFsVHVveWI1c1FROStyRVFz?=
 =?utf-8?B?dVg2aFREQ2dyRGVSM0R4S1E5S0xUQVU1Y1g2cHdaNyt1L2xPdVlBckNac2k1?=
 =?utf-8?B?STFJVm0yRWMzZ1VrYzl0TFdMeDVtTXUzM014U2FCQzZSVjFnYXVTMHdOV0lx?=
 =?utf-8?B?cEhaekpBeCtzZFB2dGhKYXBhK3REZXh2RXViN1BWdVB6RFZEVWZMOEI2RmlI?=
 =?utf-8?Q?rcYfqwh8aYUhrwearUWzJxfQ8?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 21cd7bad-2e90-471b-88f9-08da73652b1c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ypZ9IqIYYvLF698GH4xWM8LXsri6xguYE3L73lzkqHzs79p2zx3e4nIq9L8yrqVIxK9VvQGAmEkn21Gaw1ai2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5372
X-ServerName: mail-eopbgr70040.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: tF3URk6qaovTLasIfD3uojixBIYm9V_z
X-Proofpoint-ORIG-GUID: tF3URk6qaovTLasIfD3uojixBIYm9V_z
Reporting-Meta:
 AAH0SPWP1LBa78h6A4xImyP4nKlr1XVQ1sjCeuvYmIAjJtvLhlUbizyHvy0ClyYv
 juMO5qKoFD/O8RIeZdd2sxrqHuW/pOLcFVDbGjo22KQ2dmQ01P325WdWYfreWvjj
 4xxUK8NOjtlTWMGCd2GeuYWGlmKmKda1SianLZVToir70EODrUPmnvf0++gSVAvE
 8BYXuP9nPoJzbUtSsdiqveyvpYuEXVSe+cCy0WIpoHnYEZFdEEaeEE+jmt4aQhi5
 DhtkYxY8/clWUFAcmlYTHtICOY3K2h6Z0WtUbmGKZnTn0oTQQRTpB5H+bz7dNanM
 xFw95z8MnY+7wCfCEmona4iA+2uWNFgBtKhdhfq5Lf9B8QGPoaLcQc+UDeR0Gkjo
 aZPsdf+7UPSQsUW65n4srJo8O0rL+mxqMvVSeFMQf4gHmHKef6dgqkeB8jsFdeg/
 DucibHMOt53Fn7eQpj2k5tDlzL8jbMhPVEJw5PRwrWTJFzh+8lGXFNsrH6+LBTpM
 /EdkvlWvlEIM4VgjUdQjztmOsLeWF6qbxLPXKjpSAk4=

I found I didn't include Joseph in previous mail.

On 8/1/22 09:01, heming.zhao--- via Ocfs2-devel wrote:
> Hello Mark,
> 
> On 8/1/22 01:42, Mark Fasheh wrote:
>> Hi Heming,
>>
>> On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
>> <ocfs2-devel@oss.oracle.com> wrote:
>>>
>>> the key different between local mount and non-clustered mount:
>>> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
>>> convert job without ha stack. non-clustered mount feature can run
>>> totally without ha stack.
>>
>> Can you please elaborate on this? Local mounts can run without a
>> cluster stack so I don't see the difference there. We have
> 
> I am using pacemaker cluster stack. In my env, the trouble of the converting between
> local and clustered mounts are only happening on cluster stack.
> 
> the non-clustered mount feature (Gang He commit: 912f655d78c5) gave ocfs2 the ability
> to mount volume at any env (with/without cluster stack).
> The 912f655d78c5 derived from SUSE customer complain: User wanted to fsck the backup
> ocfs2 volume in non-clustered env. They wanted to access the volume quickly and didn't
> want to take time/resource to set up HA stack. (by the way, pcmk stack at least needs
> two nodes to set up a cluster.)

Ooh, above "needs two nodes to set up a cluster" is wrong. User could use a special corosync.conf
to set up a single node cluster. But anyhow, the key is why we can't bypass the setup ha stack
step.

> 
>> tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
>> users data - that's a feature, not a bug. So what I'm seeing here is
>> just opening us to potential corruptions. Is there a specific use case
>> here that you're trying to account for? Are you fixing a particular
>> bug?
>>
> 
> Tunefs.ocfs2 still needs HA/dlm stack to protect joining action. commit 912f655d78c5
> works on non-clustered env, which needs other tech (eg. MMP) to protect corrupting.
> 
>  From my viewpoint, the non-clustered mount code is based on local mount code,
> which gives more flexible than local mount. non-clustered mount uses unify mount
> style align with clustered mount. I think users will like more to use non-clustered
> mount than using tunefs.ocfs2 to change mount type.
> 
> Thanks,
> Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
