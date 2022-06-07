Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A400C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 09:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HW76BJmWp58ghWQsCDe2tNJtsRDDeZWIq03Toao00yE=;
 b=ZJGpNQP1ZdvHxoWa+FRww9i2JrGzvXuNuNQeNXuifLzXdI4mlRzfutknbozbPsBpe7sXaN1Jb485
   NkhfZZ/yrOSJQgqhJaypINcW4sg98jzSo+/4dFv799WkqY/ldMKSpDLbopudJYXXVE3A9MYycx0s
   UrIV/LSf1/22Y0OCyQ+eA5Q4zBLJ+33bDCrI80zUd0g/Ez5AQL7IyZgAmQxeKNpk58TO/opQYdwf
   IQQSVXKmMZ/1GeOaluTwQjXhtEzEnLS4LwaUGGRjGnPJqbLl5y4kF++rfFTpvBYKFyQ83tPNjLaB
   xpqh7KsUhkjK1PhvFOkQYnoqNlD49VcxEFSSlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HW76BJmWp58ghWQsCDe2tNJtsRDDeZWIq03Toao00yE=;
 b=eyk0zrYAXoaVdI55/eJIY5hSAAePcTQSs1s/7yR95GLQhHnHc/cmmf0fG6R+T3EcxwreTxPm5xa2
   CIur9snsMQ6rKrds4TlZs3VpSeGro+Oa9kJSVNdyJPkEzqnxIgT4wKHmrJTPAogf09ltb4Fm9vDZ
   sr3OSktxg7iss1g646rp7mODytgjPsrp0kaqIXIAeG4stuV/tb+D+KYzZaibGnJzO55/JiXtkomt
   WViFwC1iCSRtms+TN/xjFF1yVHMWJpkkxHjgftZCL7WrxG454dNGe3HF5lT+7hjoceW7JQ1L2QqJ
   4HZAJRmIpgL0Ina2qt/CE3qaqAHci/G3qN0L5w==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300CEYPNXLSC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 09:43:09 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654594974;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=myKr76UdbzOdFbL71qnukKNMqn93ZJXheTrwQVhCTnQ=;
 b=XhWxixlua4aydqcVqZCcpqWtgF+J3bvX5VD+JMAQ0/9WsrEJsg/KK6XVnRjkc9SlqfbURw
 2bNzrZjdObvVoj+Iz4aj9vS/FPXVxyuHO8OCH4WfwWjbf//SQT4Y1rLyADiRIRpkVYi3Ly
 ES6tMQX4XOOrpByMXkGww97fGmZrZ7U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xzn5FXx+yY48jZ8F9jO6JHUgyiULygLhvbmWjCD6i7HnZHLMNaM7oKM5VcSOx5AUnSUkVrkmEuzggbipiQrD23/+NjKmC+BJQeGB9L5wghRJGmyDDvu+YotMRxwfNvRP7NZyXT3xRh+Loxo3i6Qz5u6hd+wv8bq3Efpoia/GK1QpaA8XSBGU1RsOMA5ZCPG+8xlqR4j6LTEJXBw5zS7lTic+y9DAwlAI+vLVp4yI7Td1eTRpAYtNizNza4ukArExTsFA3mljs8OdBtOIbh89e0LQZ3Fc0sYg2glQGMVA/DOYxX6RyfgxfyZ2k05Uk1ZzTo9JH+FdKEVSO7BFoVcKDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rw8fIX/d3C3dugGaMMZ0NVK2k+tfBJB5auDJsxQsTdU=;
 b=B+z/AJ8oh0Jl8d27iKN7Z9oF7IQ4I7hKovWBwROMSUIi+jeXwGQgWMmW8F8SmBoM25xav3/AymXObVZ64ultSgu0XwZmOPyVrmCp1uCPg1VgAon3s+svAeH/+TbBvVHY4ZQI3FJb+80RIullC5gWPDblXdf7gzKTQEzDOHpCT1TNs2EtbAtFbBFHuUfUx97/Aec0Yn4ue0KGJnfyg5lMoSVZaZuKXqLLT9pUBKwht1+UN5v+9c7yMXKiKVqGcRtLCrQhTMapG7HKeQuZQKsygS5n9yk+9w2VWmZ8rt6H+ExaT30GfTtEJG+kLhVmuvFJh0Uxaw+dQV+aBZ2kaBmOww==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysuse.onmicrosoft.com;
 s=selector1-mysuse-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rw8fIX/d3C3dugGaMMZ0NVK2k+tfBJB5auDJsxQsTdU=;
 b=TMmJJvApDcGNmhDerIyA6woVPw0z17sMgfOTi5EpzsAbWe8pkXDlHFs1gKJ17lgUmfgCzonK4sy83rI+eXVkqF3aXeR0i4hHpekQ20+/55R3vvUm4HIja8mHBsGblX/eDllUezSS2dGduFu2aqCl8Hmbym6Sx4BnzLAOM3Bf6OwcE1xvJeUcQBUB5mplRq14wCngpA68BpjGWjNk7kSp44SNg1WNITw/2EPueXuZxlP473nhi4rq1ZUCstCKLP6HYDfX8HbrQ27UXDHfJ2dRM59QYMiRPMn5Bmz79x8/kMQ3SG6IpR8CandY8c5RHha8cbfcPBD5Fea+3K3kISSirg==
Date: Tue, 7 Jun 2022 17:42:46 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20220607094158.nwu57ehslq4h2r4h@c73>
References: <20220606020853.alh64eunicx5sjgs@c73>
 <11b0492d-37e0-3061-6c79-81610ad0312c@oracle.com>
 <5286c029-f9bc-7945-94f3-e38cd5220329@suse.com>
 <edba6791-5088-50d3-f417-f9639f05d012@linux.alibaba.com>
 <4F248A4D-0075-4039-8A63-27FADFBE07F1@oracle.com>
 <b2b5227e-257d-7171-e5b3-fa378b5caf5d@suse.com>
 <41AD73F0-1692-4CCB-95FC-AC65272081D0@oracle.com>
 <6f72c61f-fae4-9fa3-bcd9-5aa3f03db6ac@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <6f72c61f-fae4-9fa3-bcd9-5aa3f03db6ac@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(83380400001)(508600001)(66556008)(66476007)(8676002)(4326008)(66946007)(2906002)(38100700002)(5660300002)(45080400002)(44832011)(966005)(6512007)(53546011)(9686003)(6666004)(6506007)(86362001)(6486002)(6916009)(54906003)(316002)(1076003)(33716001)(26005)(8936002)(186003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 09:42:51.8417 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=176 bulkscore=0 clxscore=244 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070040
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] Revert
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: u2gbwWfTPAS21K44vbiYwg-1
X-ClientProxiedBy: SG3P274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::30)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 344f3d59-95d0-4ecc-e2e1-08da486a16f5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4411:EE_
X-Microsoft-Antispam-PRVS:
 <DB7PR04MB44112D18E32CC8218F70B3D897A59@DB7PR04MB4411.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 S0OgJF3kIKBt2eWqF/tfd7zuX7kta12iw43/oXLstD70e0sBmGptzXKu6TtesUiUFSeKvIjUddISGiEbwN4HaiQJ1W6HV6R83kcRc5/ZgRy5Dcehuj7iwbu/DfVaTLnphgPG4uwyy1TqQRq/eDxHgblfb0tkeo+vu6CgMxTlz7gGu/8BDJeQFzgaponKs5Zusfe5pjNf3oIOlvfmszk7BoWVRCiOZJn55Ve5LilzsQu82Mzyf0ztIeieB5H98TSMEM2BmkyKkl1NAhqE60Yl7RIUEEkOkGtpJfSw/A+BeH8OGnjnYfjGmJYnYlMdmEXb7Orml2egEodEBKrM9Sdv9PILpJpj8GMcJovkcpRzFt225vJQOR2D7hq4bWirrd0mnGV4dtPmRmsqmjXMbWrPPOlKPvSO06i2y9sRB0H2AP67UfmUIo5xgtK7GdJ5gTsHflOEQnZIIY7UWv3yK9Ol1+ALi8gbTBRucd5CRm3EvOpYbUElAg6KM5GBa5tQEotAMgFd/p+XJOAbLK6UCKFDS2eVV1dYCP0/yLbT+U/5MSNndGpjmv/pG9I8kazggKMfzX9N5PvY+qUrMWSbPo/EEBxyxSgBb3G0LgRV0AYhNCb3GLeyvjkVpOO8NaIbkUKoLI5xileDlWUuWNnm7Q1Ih9Orrkgod8DlABBs7SUNTChQ6ScNZthst/TQW/kh0raN1wzaU22FIG90+vg112y6IwFWSg3u4wG35wFt0MlSuoc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?S4V/QpHQPRkEQOtE+62D2qc2OaLR0ccUsqBUE1MSrY39PtcjnM061Dtiy6Tl?=
 =?us-ascii?Q?jrQLS496fwAyHga7Sdn2uOIWs+j7VtP9ZVtR+1AECa5z5izNa/n0XS3f0DKZ?=
 =?us-ascii?Q?QegD/+drSMSGgYy0VrmJVkDXitHGBAgkdmbKvvH2xq739oXugAzzYrTbu+VH?=
 =?us-ascii?Q?iPeXtyGcvixxCvwZ4o2on1DtwnBeC3Mi6CXPCRjPxrvvcIAoiwSolHLdCx56?=
 =?us-ascii?Q?2C6cdlQi+Gj3BorsuDtk4RWJAQ7A9wqGBLDEgv69XG7F47K7uBjP9uDA4ZWF?=
 =?us-ascii?Q?FkK/89PJZPRrPKGz7Wp+XdCjOam2s3RA6NleC60jvrM+8JQX0nV6Za4KRSxQ?=
 =?us-ascii?Q?6OPWYjcA92tdfnc5o53zhrgQxK31NGrA5miuwaSUQAysItK6F7YqRR/sAtat?=
 =?us-ascii?Q?SnfR3W+K32spT7qgtDwERCFu2LkyFPqxclfM6TC0WtXVBHTy3RuumjpNf74B?=
 =?us-ascii?Q?ZTYUdMgo//MnDFeN0W6OBmFolAWhI7yxB0IlN14+8WET4r4rximhBwdrRIhc?=
 =?us-ascii?Q?BQwUZbQvdr5C9r1eo6ymQpXjqcombFG8M+5zr5CkBK2fWz2vgm07FCXXi4C8?=
 =?us-ascii?Q?vertdogRwxwobrbrlzeeN5CjMkiOssBHEY2q7me/x5T9YjvkO/5SxA/d+7k7?=
 =?us-ascii?Q?xqUGCTYpoSv+oWY8f98bWqDpLxPy/Ec5bzilJvSnXnB47OvhQOiH4id2LYUq?=
 =?us-ascii?Q?ULW6BdI8xWRsvO7NLxASMz/9rbgOrjTGvgEtDIIWjz9n0q0TwLKLJdOx//QK?=
 =?us-ascii?Q?gwqK7vJVJNL0MYRWHlMyqNtKqlgQ/UlEdEJn9Rv9gd0i7KoewSsCtZstLYWl?=
 =?us-ascii?Q?/kc5ZSJNoxOjTYAORkRY5tzMsi+eKe2lsl9Fcn0iElkWfCmCgnNxhQyQUJZc?=
 =?us-ascii?Q?w+HzxsEN8vh2oWnyXbCtPc4fAV9eFazeOHKcXoVNoOzDUrjjKpYrP4gfdPtd?=
 =?us-ascii?Q?r2eoEwS8fpA+yhSuDHcAkLedKCFDlx/Sypv7pce6uJGS/jclBpkWsw5T6BRQ?=
 =?us-ascii?Q?GqVHZP7u4IUc+oP+yzTxjajdN62SwWJQjvoX5Km8BndANLTkStsy8Sj3s+UI?=
 =?us-ascii?Q?DFcQwOmFkWbpye9XQvIr5u0ih3oRqcfLk2aaYbzhdurL54SpYwkp28JQZDMB?=
 =?us-ascii?Q?pq9xXK6tHwOUd2CVpYAOvUBue7NSGUyYR1L/mbKykKi5/WnCwh05l6H2ZGZZ?=
 =?us-ascii?Q?bF/WC0aMJ6YdTH5JvlhwclF92zAyI160ky7r7V74LDl288lYNKoXlCZmkq/f?=
 =?us-ascii?Q?ef5Ofv+IFxXSwC3WGoZcur3Xyt/oyu+1EHTAdNthdYfS4n8PaHmwop8SWEv/?=
 =?us-ascii?Q?RdLkwForblE48fb/1f/kN+8W0j8QN8KXjUbiBkEqUjE4yGJwZ4afp4CBJuWp?=
 =?us-ascii?Q?gAJacnrHe1GPG2SRqEBrkN6CvPRVRf3U6ABj6A36n67N5Da2/JNIYHiNBm+W?=
 =?us-ascii?Q?NXj7y/2iL0a8sFF524oQPzj13VyUcWNro8F+LpHVulwoGDB12dpF2uEB4xcZ?=
 =?us-ascii?Q?U+Rlw1oxIqtiRgRV5rb+oJ5QS1DrTmFigUxWINAMCHe2dHryD07IEd/G8GcD?=
 =?us-ascii?Q?du5bvvv0kxDtoHCdib5I/o2CswWr3Sd+T1td4WRN79nbXHGJqGlZTpXuemnk?=
 =?us-ascii?Q?rzIqRAqddnzjSjwZJjs/K2IqbPTmaTeOBNUuVqRGmpgoaWAu3bOAmlymD4u7?=
 =?us-ascii?Q?H6o6TylJSpxKMi9NJVaC6fYgJwV8MLLR9dSrbYAhwVlElGzcUw+sNyApToRW?=
 =?us-ascii?Q?CeWlKD2+vA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 344f3d59-95d0-4ecc-e2e1-08da486a16f5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 mT7jIYNI7ZPspoWndKuxbb4uQJ57/R7fhXDRlS8sdzkt9SUggV48Pvhnq+wx5QFD+juspDesiZwaQx93xI2Bow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4411
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8asV-QYTqEHcpbnT1PIYapLNKCAP92H9
X-Proofpoint-ORIG-GUID: 8asV-QYTqEHcpbnT1PIYapLNKCAP92H9
Reporting-Meta:
 AAEJ9/GjdivP2KowmX17yDYdsck74u+Plr+C3E1bgy1PRQ6XBrSTc31Jlpf1RAFB
 1zZ6EeFQhPFC0o4AFH8HZttG1agxpOgTG7h1SR2drj4AWcQC1qTq54O6qvEAIZa4
 ENd7Jr4RuufI0cGazJZhqOxMa8Lgn+nkMPT/RW9l3G7UtPInzw9xgVs7/E+daAt6
 4izjFXSI3h2SYNChAWwWRZemlPotzkqiyuFw98DIwSxHRNgoEHn30kI+cD+oPpLN
 gBEDHSKVP9e4z+6mVD26QvSDB2P0Lm81+jjznY5mam77Ild2o+Qcz2JYt763klBw
 1HGwPDwC46SvsUyMQh9vCrnb+FS4apUUpdEVzWGWg7y0mj/qy4oWhEdcXq0gVp0J
 vFlg0esul6HtFaT8ZxwgIjjiNGeYR11ph+EV/syQ3MDIDMMi6KS8P05/GH+HibDf
 XWhngx76y8YTD1bsrm0Fw8yv3q2rWtQhRytrLVZh3ghXTLSMYCe08Xp8YwDt7nM3
 7ogiAE/oJ7ylMQeb6Fp9NtXNUX40t52WoSh+uXLw/3JM6Q==

T24gVHVlLCBKdW4gMDcsIDIwMjIgYXQgMDI6MzE6MDFQTSArMDgwMCwgSm9zZXBoIFFpIHdyb3Rl
Ogo+IAo+IAo+IE9uIDYvNy8yMiAxMTowNiBBTSwgSnVueGlhbyBCaSB3cm90ZToKPiA+Pj4+IFNl
ZW1zIEkgYW0gbWlzc2luZyBzb21lIG1haWxzIGZvciB0aGlzIHRocmVhZC4KPiA+Pj4+IFRoZSAn
bm9jbHVzdGVyJyBtb3VudCBpcyBpbnRyb2R1Y2VkIGJ5IEdhbmcgYW5kIEkgdGhpbmsgaXQgaGFz
IHJlYWwKPiA+Pj4+IHVzZXIgc2NlbmFyaW9zLiBJIGFtIGN1cmlvdXMgYWJvdXQgc2luY2Ugbm9k
ZSAwIGlzIGNvbW1vbmx5IHVzZWQgaW4KPiA+Pj4+IG8yY2IsIHdoeSB0aGVyZSBpcyBubyBhbnkg
YnVnIHJlcG9ydCBiZWZvcmUuCj4gPj4+PiBTbyBsZXQncyB0cnkgdG8gZml4IHRoZSByZWdyZXNz
aW9uIGZpcnN0Lgo+ID4+PiBSZWFsIHVzZXIgY2FzZSBkb2VzbuKAmXQgbWVhbiB0aGlzIGhhcyB0
byBiZWVuIGRvbmUgdGhyb3VnaCBrZXJuZWw/IFRoaXMgc291bmRzIGxpa2UgZG9pbmcgc29tZXRo
aW5nIGluIGtlcm5lbCB0aGF0IGlzIHRvIHdvcmthcm91bmQgc29tZSBpc3N1ZSB0aGF0IGNhbiBi
ZSBkb25lIGZyb20gdXNlciBzcGFjZS4KPiA+Pj4gSSBkaWRu4oCZdCBzZWUgYSBSZXZpZXdlZC1i
eSBmb3IgdGhlIHBhdGNoLCBob3cgZGlkIGl0IGdldCBtZXJnZWQ/Cj4gPj4gR2FuZyBoYWQgbGVm
dCBTVVNFIGZvciBzb21lIHRpbWUsIGFuZCBidXN5IHdpdGggaGlzIG5ldyBqb2IuCj4gPj4gSSBo
YXZlIHZhZ3VlIG1lbW9yeSwgaGUgc2FpZCB0aGlzIGNvbW1pdCBhcHByb3ZlZCAmIG1lcmdlZCBk
aXJlY3RseSBieSBBbmRyZXcgTW9ydG9uLgo+ID4+IEdhbmcgZGVkaWNhdGVkIHRvIGNvbnRyaWJ1
dGUgb2NmczIgY29tbXVuaXR5IG1hbnkgeWVhcnMsIGFuZCBzZXQgdXAgaGlzIGNvbXBldGVuY2UK
PiA+PiB0byBvdGhlciBtYWludGFpbmVycyAmIHJldmlld2Vycy4KPiA+Pgo+ID4+IElmIEp1bnhp
YW8gZGlzbGlrZSB0aGlzIGZlYXR1cmUsIGFuZCBkb24ndCB3YW50IHRvIGZpeCBpdCBhcyBhIGJ1
Zy4KPiA+PiBJIGFtIHdpbGxpbmcgdG8gZmlsZSBhIHBhdGNoLgo+ID4gVG8gZml4LCBpdOKAmXMg
bm90IG9ubHkgdGhlIHJlZ3Jlc3Npb24gaXQgY2F1c2VzLCBidXQgYWxzbyBkbyBzb21ldGhpbmcg
aW4gbW91bnQub2NmczIgdG8gY2hlY2sgd2hldGhlciBhbnkgbm9kZSBpcyBtb3VudGluZyB0aGUg
dm9sdW1lIGJlZm9yZSBub2NsdXN0ZXIgbW91bnQgYW5kIGFsc28gc3RvcCBvdGhlciBub2RlcyBt
b3VudGluZyBiZWZvcmUgIG5vY2x1c3RlciBtb3VudCBpcyB1bm1vdW50ZWQuIFRoYXTigJlzIHRv
IHNpbXVsYXRlIHdoYXQgZnNjay5vY2ZzMi9ta2ZzLm9jZnMyIGRvLiBXaXRob3V0IHRoYXQgZ3Vh
cmQsIHRoaXMgZmVhdHVyZSBqdXN0IHByb3ZpZGVzIGEgbmV3IHdheSBmb3IgY3VzdG9tZXIgdG8g
Y29ycnVwdCB0aGVpciBkYXRhLiBJdOKAmXMganVzdCB0aW1lIHNvbWUgY3VzdG9tZXIgd291bGQg
ZG8gc29tZXRoaW5nIGJhZCBhbmQgbG9zdCB0aGVpciBkYXRhLiAKPiA+IEkgd2lsbCBsZWF2ZSBo
b3cgdG8gaGFuZGxlIHRoaXMgdG8geW91IGFuZCBKb3NlcGgsIHdlIGFscmVhZHkgcmV2ZXJ0ZWQg
dGhpcyBwYXRjaC4KPiAKPiBTZWFyY2hlZCB0aGUgbWFpbGxpc3QgYW5kIGZpbmQgdGhlIG9yaWdp
bmFsIHRocmVhZCBmb3IgcmVmZXJlbmNlOgo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29jZnMy
LWRldmVsL0NIMlBSMThNQjMyMDY0Q0NEODBGRTk4RjAzQjgyQTgxNkNGQUMwQENIMlBSMThNQjMy
MDYubmFtcHJkMTgucHJvZC5vdXRsb29rLmNvbS8KPiAKPiBJIHN1Z2dlc3Qgd2UgbGVhdmUgbm9j
bHVzdGVyIG1vdW50IGFzIGEgc3BlY2lhbCBtb2RlIGFuZCBtYWtlIGl0cyBsb2dpYwo+IHdvbid0
IGltcGFjdCBvdGhlciBtb2RlIGxpa2UgY2x1c3RlciBvciBsb2NhbCBtb3VudC4KPiBBZ3JlZSB3
aXRoIEp1bnhpYW8sIHdlIGhhdmUgdG8gdHJ5IG91ciBiZXN0IHRvIHByZXZlbnQgZGF0YSBjb3Jy
dXB0aW9uCj4gZXZlbiBtaXN0YWtlbmx5IHVzZWQgYnkgY3VzdG9tZXIuCj4gCgpJdCdzIGEgYmFk
IG5ld3MgZm9yIG9yYWNsZSBwZW9wbGUgdG8gcmV2ZXJ0IHRoaXMgZmVhdHVyZS4KQXMgSSBzYWlk
IHRoYXQgdGhlIGh1bmcgaXMgbm90IGEgYmlnIGJ1Zy4KClVuZGVyIEp1bnhpYW8ncyBjb21taXQg
bG9nIGluZm9ybWF0aW9uLCBjb21taXQgOTEyZjY1NWQ3OGM1ZCBpbnRyb2R1Y2VkIGJ1ZyBjb2Rl
CmluIGJlbG93IGFyZWEuCgpAQCAtMjU0LDE0ICsyNTQsMTYgQEAgc3RhdGljIGludCBfX29jZnMy
X2ZpbmRfZW1wdHlfc2xvdChzdHJ1Y3QKb2NmczJfc2xvdF9pbmZvICpzaSwKICAgICBpbnQgaSwg
cmV0ID0gLUVOT1NQQzsKIAogICAgIGlmICgocHJlZmVycmVkID49IDApICYmIChwcmVmZXJyZWQg
PCBzaS0+c2lfbnVtX3Nsb3RzKSkgewotICAgICAgICBpZiAoIXNpLT5zaV9zbG90c1twcmVmZXJy
ZWRdLnNsX3ZhbGlkKSB7CisgICAgICAgIGlmICghc2ktPnNpX3Nsb3RzW3ByZWZlcnJlZF0uc2xf
dmFsaWQgfHwKKyAgICAgICAgICAgICFzaS0+c2lfc2xvdHNbcHJlZmVycmVkXS5zbF9ub2RlX251
bSkgewogICAgICAgICAgICAgcmV0ID0gcHJlZmVycmVkOwogICAgICAgICAgICAgZ290byBvdXQ7
CiAgICAgICAgIH0KICAgICB9CiAKICAgICBmb3IoaSA9IDA7IGkgPCBzaS0+c2lfbnVtX3Nsb3Rz
OyBpKyspIHsKLSAgICAgICAgaWYgKCFzaS0+c2lfc2xvdHNbaV0uc2xfdmFsaWQpIHsKKyAgICAg
ICAgaWYgKCFzaS0+c2lfc2xvdHNbaV0uc2xfdmFsaWQgfHwKKyAgICAgICAgICAgICFzaS0+c2lf
c2xvdHNbaV0uc2xfbm9kZV9udW0pIHsKICAgICAgICAgICAgIHJldCA9IGk7CiAgICAgICAgICAg
ICBicmVhazsKICAgICAgICAgfQoKdGhlICdpZicgYWNjZXNzbWVudCBpcyB3cm9uZy4gc2xfbm9k
ZV9udW0gY291bGQgYmUgMCBhdCBvMmNiIGVudi4KCndpdGggY3VycmVudCBpbmZvcm1hdGlvbiwg
dGhlIHRyaWdnZXIgZmxvdyAobWF5KToKMT4Kbm9kZTEgd2l0aCAnbm9kZV9udW0gPSAwJyBmb3Ig
bW91bnRpbmcuIGl0IHdpbGwgc3VjY2VlZC4KYXQgdGhpcyB0aW1lLCBzbG90bWFwIGV4dGVudCBi
bG9jayB3aWxsIGNvbnRhaW5zIGVzX3ZhbGlkOjEgJiBlc19ub2RlX251bTowIGZvciBub2RlMQp0
aGVuIG9jZnMyX3VwZGF0ZV9kaXNrX3Nsb3QoKSB3aWxsIHdyaXRlIGJhY2sgc2xvdG1hcCBpbmZv
IHRvIGRpc2suCgoyPgp0aGVuLCBub2RlMiB3aXRoICdub2RlX251bSA9IDEnIGZvciBtb3VudGlu
ZwoKb2NmczJfZmluZF9zbG90CiArIG9jZnMyX3VwZGF0ZV9zbG90X2luZm8gLy9yZWFkIHNsb3Rt
YXAgaW5mbyBmcm9tIGRpc2sKIHwgICsgc2V0IHNpLT5zaV9zbG90c1swXS5lc192YWxpZCA9IDEg
JiBzaS0+c2lfc2xvdHNbMF0uc2xfbm9kZV9udW0gPSAwCiB8CiArIF9fb2NmczJfbm9kZV9udW1f
dG9fc2xvdCAvL3dpbGwgcmV0dXJuIC1FTk9FTlQuCiAgICBfX29jZnMyX2ZpbmRfZW1wdHlfc2xv
dAogICAgICsgc2VhcmNoIHByZWZlcnJlZCAobm9kZV9udW06MSkgZmFpbGVkCiAgICAgKyAnc2kt
PnNpX3Nsb3RzWzBdLnNsX25vZGVfbnVtJyBpcyBmYWxzZS4gdHJpZ2dlciAnYnJlYWsnIGNvbmRp
dGlvbi4KICAgICArIHJldHVybiBzbG90IDAgIC8vd2lsbCBjYXVzZSBub2RlMiBncmFiIG5vZGUx
IGpvdXJuYWwgZGxtIGxvY2ssIHRyaWdnZXIgaHVuZy4KCgpJIGNvcGllZCB0aGUgcmVsYXRlZCBj
b21tZW50cyBmcm9tIEpvc2VwaCBwcm92aWRlZCBVUkwuCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvb2NmczItZGV2ZWwvQ0gyUFIxOE1CMzIwNjRDQ0Q4MEZFOThGMDNCODJBODE2Q0ZBQzBAQ0gy
UFIxOE1CMzIwNi5uYW1wcmQxOC5wcm9kLm91dGxvb2suY29tLwoKYGBgCj4gPiBAQCAtMjU0LDE0
ICsyNTQsMTYgQEAgc3RhdGljIGludCBfX29jZnMyX2ZpbmRfZW1wdHlfc2xvdChzdHJ1Y3QKPiBv
Y2ZzMl9zbG90X2luZm8gKnNpLAo+ID4gIAlpbnQgaSwgcmV0ID0gLUVOT1NQQzsKPiA+Cj4gPiAg
CWlmICgocHJlZmVycmVkID49IDApICYmIChwcmVmZXJyZWQgPCBzaS0+c2lfbnVtX3Nsb3RzKSkg
ewo+ID4gLQkJaWYgKCFzaS0+c2lfc2xvdHNbcHJlZmVycmVkXS5zbF92YWxpZCkgewo+ID4gKwkJ
aWYgKCFzaS0+c2lfc2xvdHNbcHJlZmVycmVkXS5zbF92YWxpZCB8fAo+ID4gKwkJICAgICFzaS0+
c2lfc2xvdHNbcHJlZmVycmVkXS5zbF9ub2RlX251bSkgewo+IAo+IFdoeSBzcGVjaWFsbHkgaGFu
ZGxlIG5vZGUgbnVtIDAgaGVyZT8KPiBJdCBzZWVtcyBicmVha3Mgb3JpZ2luYWwgbG9naWMuClNp
bmNlIGluIGxvY2FsKG9yIG5vY2x1c3RlcikgbW9kZSwgdGhlIGNvZGUgd2lsbCBub3QgaW52b2tl
IGFueSBETE0vY2x1c3RlciByZWxhdGVkIGludGVyZmFjZXMuClRoZSBub2RlX251bSBpcyBzZXQg
dG8gMCBkaXJlY3RseS4KSW4gdGhlIHBhc3QsIGxvY2FsIG1vdW50L2NsdXN0ZXIgbW91bnQgd2ls
bCBub3QgaGFwcGVuIG9uIHRoZSBzYW1lIHZvbHVtZS4KQnV0LCBhZnRlciBub2NsdXN0ZXIgb3B0
aW9uIGlzIGludHJvZHVjZWQsIGxvY2FsKG5vY2x1c3RlcikgbW91bnQvY2x1c3RlciBtb3VudCB3
aWxsIHBvc3NpYmx5IGhhcHBlbihub3QgYXQgdGhlIHNhbWUgdGltZSkgb24gdGhlIHNhbWUgdm9s
dW1lLiAKSWYgd2UgbW91bnQgdGhlIHNoYXJlZCB2b2x1bWUgd2l0aCB0aGUgY2x1c3RlciBtb2Rl
IGFmdGVyIGEgbG9jYWwgKG5vY2x1c3RlciBtb2RlKSBtb3VudCBjcmFzaCwKV2UgaGF2ZSB0byB1
c2UgdGhhdCBzbG90KHNsb3QgMCwgd2hpY2ggd2FzIHVzZWQgYnkgdGhlIGxhc3QgbG9jYWwgbW91
bnQpLCBvdGhlcndpc2UsIHRoZXJlIGlzIHBvc3NpYmx5IG5vdCBtb3JlIHNsb3QgYXZhaWxhYmxl
LgpgYGAKCkdhbmcgY29tbWVudCBmbG93OiAoYmFzZWQgb24gcGF0Y2hlZCBjb2RlKQoxLiBkbyBu
b2NsdXN0ZXJlZCBtb3VudCwgdXNlIHNsb3QgMAoyLiBjcmFzaCwgcmVib290CjMuIGRvIGNsdXN0
ZXJlZCBtb3VudC4KNC4gaW4gc2xvdCAwLCBzbF92YWxpZDoxLCBsc19ub2RlX251bTowCiAgIG9j
ZnMyX2ZpbmRfc2xvdAogICAgKyBfX29jZnMyX25vZGVfbnVtX3RvX3Nsb3QoKQogICAgfCAgLy9m
YWlscyBmb3IgJ3NsX3ZhbGlkID09IDEnCiAgICB8CiAgICArIF9fb2NmczJfZmluZF9lbXB0eV9z
bG90KCkKICAgICAgIC8vc2hvdWxkIHJldXNlIHRoZSBub2NsdXN0ZXJlZCBtb3VudCBvY2N1cGll
ZCBzbG90IDAKICAgICAgIC8vc28gJ3NsX25vZGVfbnVtID09IDAnIHNob3VsZCBiZSB0cmVhdGVk
IGFzIGFuIGVtcHR5IHNsb3QgZm9yIHJldXNlLgogICAgICAgLy9pZiBub3QgcmV1c2UgdGhpcyBz
bG90LCB3aWxsIGRvbid0IGhhdmUgZW5vdWdoIHNsb3QgZm9yIG1vdW50IChvdGhlciBub2Rlcyku
CgphdCBsYXN0LCBJIG5lZWQgc29tZSB0aW1lIHRvIGZpbmQgYSBzb2x1dGlvbi4KClRoYW5rcywK
SGVtaW5nCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
T2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBz
Oi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
