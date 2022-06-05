Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A47C43334
	for <ocfs2-devel@archiver.kernel.org>; Sun,  5 Jun 2022 01:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ekG+Nqaep4KgYNUKsxYUBdqlxFcmPhD55AIUGJ8BAXA=;
 b=yhqB7jcM+Iex/x7iWtIbHHymR2edRdY4bumsTPE9efqLq9DYu7Zr1slg1vdm6gkbjcXhr9F7Fx/M
   DB90p3ZrXRw7saiwkh1CMedl7qsO27ozAF8GShOE+nBDIB2sTBFBDcBfHTO2wNknmxBo1hqCm/3i
   pPQgT7Tdt1q8QUp/tK6RQ2Fgt5S3IZ+PoSbGGAhyDrghQPQmd2iUG4skQ0UffKkqMO/FjQOOEv9O
   5+x3LzFxqCO5amt0VG29kL4RLxS4YNcwOBo9a5+ZOwCoAvvqxFhYyIB8VkQ51F8t9gC5vKESaXjV
   M4nm6+EWY417rorP6uu6k6Oe6Q0Ywgu/ByLYFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ekG+Nqaep4KgYNUKsxYUBdqlxFcmPhD55AIUGJ8BAXA=;
 b=LWgblfDfhZRDmyNaJdtbarHKWJrF8uzSZFKP28FaZRuAKRBBCW8RzfKJZ/dD3Wu37Bnj8OcXtX57
   Uyf4vNZyaFK9UYfkKQHmf/UK/z1Z82105eMCavXPGnsn8Bdnqj4rIYdJeaLj2bDeA01D2lZvEMqT
   +0us6i/UDRQvjoOK6cgmMyyKmWuYwVgzYFF6o2bJoLxQ8GaJwD1b4Ih1PkDOuE/i4lQ/gr31SbmS
   4RbMMs3hrKjQEjrUdcGfJNjoTUeV+oXfIubiA++vhyxFAeTn2BKfWC0HSFWFnjueaj9mel3vlt9x
   aJtzKjM4qYsGwVIBHSy2BK2f0qeH18fNlmxZow==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ009AVED8ML80@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 05 Jun 2022 01:48:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654393710;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Dg7Se4WMMGy76kbmJMbhBxLWPniJsVhSHamgshO5RL4=;
 b=bifbU9a6s+edjSs0M2nW21JmHmEobrA3OzTdHcomM0RyDSN4YXbkOcfQbVkI++D2Fvw0yJ
 m3vrFsh6AzupN4wPb5Wc2cdpMKCjVy1d39BNA0kq9ZZ1pAzYgLvo0Jnw9/MBlhbjJ59hMc
 AoA8hLPugYWj1wt/1sprWez7EW2rfzg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8EpFZoViJ/Q2tSfuTJzSmSWTpIygCR0j3TVYVqjy7ZcLVg7qMDyeSGEEOQ90bS64UeTWV/jWoJzdCZcGO/BAiin/mIb8ILWgeSWBLORh3LARzIdJdqU6jLbAoII1VsUumP/lXms5obNiYLXbN7Y0bsbU2nJCLLXgvwZ1aB1Voto1JKmxHf+9eItbvHVu4sPii/8luWHIlUU/PsZbVL7fsdHatWcngSseW06kmXVTnlVKrluxlqX8tx+yHz4n+BRlqoCIVjU/vjJyNolZWkzmAckDKJJXBFL1kR8WS3uSb9lhoTpBS1IW4bCg5kbSID62g470POcR7aYi4XBaipWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRr0dlLf398OKfaesDX23vjqWverUbmEIGs7XlAqoRU=;
 b=DAUzRHsCiE4zbt7nZOQJTrD9T5euNLC8EqpqDMbk9MtcCCZd+SIyGnjhhTkiW7E6DLIXlm3A0pPa00UhCkg8a5INuqPhbW40uyh3wLKydBk2V8azOLCauHfmAJyFPB5bPxdbpaupT/g2q2vZeFYmH2fID51c8RkkV9jfCWRAmKaxM10bnBMvxTcpJI2UtiPkQuNk6Y2vFsf7VQxP56jmcSSWHnkazu5rt5idJcU+fc/IqPcyVD5Rfi+rj92aXTMgV0JARb87Pg1WMpOS+VwnGRaJFk3MQkhRgBZlDIRhsx4lkMiL1hRlYSlHK35UoN72Fq6cDDYSHBCETQm3oRo9Mw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Sun, 5 Jun 2022 09:48:17 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-id: <20220605014817.kussyrri5t2235gw@c73>
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
 <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
 <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
 <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
Content-disposition: inline
In-reply-to: <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(8676002)(4326008)(66556008)(53546011)(66476007)(5660300002)(6512007)(66946007)(9686003)(86362001)(33716001)(26005)(6486002)(2906002)(6666004)(6506007)(44832011)(8936002)(508600001)(316002)(38100700002)(186003)(6916009)(1076003)(83380400001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2022 01:48:27.1301 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10368
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=164 clxscore=169 bulkscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050004
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
X-MC-Unique: MkkbXsk9NYiHyI7RAYydmw-1
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a129acd-636d-4250-2643-08da46957beb
X-MS-TrafficTypeDiagnostic: PA4PR04MB7631:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB7631BEA05D3AA44FF70614EE97A39@PA4PR04MB7631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 M0T/Znzjk6wKg71uVLw+pBlHdJcURY49RlOqSJB1qcJ1A2Kl2Rdf7dUajPWJr/H+xExSPg4U+E5xoHF7fUJU8gF7sasM0T8EVA57pi0v8HP6Swy+2oyZ3Lxo042ZtF5wPsHg6gOFjqgu2PzP9nBjYZxAZa3Yt8hpvw4QAgiUf15COC9iFHJL0Ak24QrZ7SS8f7/HtUCglxCEerFFFOzpzTAj3yvvf2nLbA4qOd2cH8DBtOckyB1GkEuyNsUc+EaMS1hi3qeJ5/U4uHyW3zxIgqdcs/UAuIMVE62CYSp+ArbDwcTeiVZ/Rk8h60CTQ6SjrMLlM+Msc5UneljUE+gMkzK1TrAXJu2CZwL6NyL/rSM8UXe0dP0NeHp4/JjVrzVxxWT4E5UqTR/5tEE6dEonNJYFswXyP9yNYpGfRbOPZ/wYMRsVb/6L5j/ehbCEMGzobj8VLqu35uIMoCZZh4URdH/dfghpm1KIB3RPHMBsNTuhjAeeMsmYxmsQBe3bLpd4kIaQVLdwykWiP0ttViARO5DDtJX05YBerEjrCvP923sX0d9q/iqR/SKYOLyNxsMTjgqx52rsHQMUdnuSPHOfCGrMxl/lQ4sTACMTA6PJmVOApRvEkYYPeavxciXpFO24i06LqoJKb4fLoc/kAO1XuQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?50RWrb2S8Mna9yajzrPwA0Ga9wCI+DaZ/H+Bwpgaz2l8jHqZDeSMJuDQWge9?=
 =?us-ascii?Q?KIoKPFvvm+SEHfqDkgeCgjJKg5ZOwi/5gqJb4xavz7Cf2KOa9QrOWm9/cbt3?=
 =?us-ascii?Q?aSAdM8B9ML4GcKaC+q7i95W04BprTUiSeSQx0jUW39+hZObXjoN1nk2spoAP?=
 =?us-ascii?Q?u7KU3YI0qn0QwH8v08PAovSDn4ZbzoXXzeD/5uWhZvmA1wqt/xKLTwjHQRj3?=
 =?us-ascii?Q?ayH4u8H4uCJd39AjcrqWcO0GjX5ZASk2fYnSZ7NgLhZ7k/mp+0X4TT5OoA4J?=
 =?us-ascii?Q?vcYelNHAL4a7KXwrzTTlbw9T0KelLuZH+vjH6x2ajEQ51zIWVdzF+wBcNxZz?=
 =?us-ascii?Q?T6PG1YunuU30SUHFpLjJSWipYzAqmD6PxMMk9Mr1HLYkThY4iy6dj/YvjLi1?=
 =?us-ascii?Q?839hwIUYJS1j3Q9HzHhxntlJj3T5tQ6ZP3VtSZO+T2N8W/aQTtady41X8qV/?=
 =?us-ascii?Q?KGKKEu5OoLdxd4NveNvPSilpHxmltOE3iDeXXxbKOa9nSyamlIJ4+htyALdK?=
 =?us-ascii?Q?DCoG0mX5mUGRCouYkfclUP/it/Pfe9VP3/HRDsfiUFMAZ2c+i4cUQzvSY36j?=
 =?us-ascii?Q?Axvqp1ayc4vbycYdsz+1UM4WiCXINc2ctYBwkGN5e/mJrSitfE1l7Cf1hC5z?=
 =?us-ascii?Q?fNX+C+pwTdnlvU3e93LHMpS0v/EKXCnxfQKq8vf0GWM+4mgYiGURfqzpIzch?=
 =?us-ascii?Q?DbXv825aLMcBdmULaMNTiom3+L23HXCHEyM9Uthq0cgC8gAcFhO+mCZ1+xHN?=
 =?us-ascii?Q?L0MOR5mm5SQaIhUj6yKjbh3kjVbj73StZESDfswolDlbrrIQJb7oXs3DYCG3?=
 =?us-ascii?Q?vNoxkBWgPj4fFdXyMdps56Ud874pbXDiyqHd/6qZzT/h+UIALzeCHwYb06JX?=
 =?us-ascii?Q?hRiObSdf5PRdrwQ4WAyNa4QdZdU9bl9CYASOj4ve7aU2V2Elc5xRcPZ9vu55?=
 =?us-ascii?Q?PImCCDppWqGcuyItzupE3HqgpfIM31fbIevFpefx22zx/Csv+8gh+8xJ/e1v?=
 =?us-ascii?Q?hi3FOPmG/0IoiXB8j0IND9LkkqYL3GCzZUWM1051U0IqlHAdMbgHKxvxbkK6?=
 =?us-ascii?Q?gqOkb9opod4rfGmvFM98S6vfQ9c00HhhZcD8POJUTRDvT+KB4wHCLVI/ZUGs?=
 =?us-ascii?Q?UdtvtJaUNUKmYw3xsx6CwW31jTpMTIL1R6DCrfF20Ggn7bzzf07NU1ubozA7?=
 =?us-ascii?Q?xoRnJ0loIEXn/ul8BO7Temnx+DhwozRVZJ/pT5nQtPn0rEioDbmUT5I48SNh?=
 =?us-ascii?Q?m9sp4ySseJ7ApuKF06tyKX4tsLr+PBoUBWJ8/wcUsWDdL4mWjoLjZOyLVzfk?=
 =?us-ascii?Q?56BfW5UJm22HbVEhjNduStsZ+HCBZjflAYv/1uRWWGxwpGDzEenCiJ7PdsZk?=
 =?us-ascii?Q?qYnVvnotsaxV6eUXL/6/MSATSj+J+ltXIp+k1pMlakSB0+00qO99+bAEeGSD?=
 =?us-ascii?Q?T2mMliG9yieT8KFVAP6RbYj00yTzEywQMZJp+rgAH5G4idcsneh1bf4HnOT8?=
 =?us-ascii?Q?ZRAwyHn23kPpDuJe1YHUSYD47nOAyutZkY96mOZwHCJhbGHD4jAoEl8ZtDBd?=
 =?us-ascii?Q?0++VEjDMzn5NtGEAyzpraPgO6cSslYFSRptqS7ykUSzOTgYMuW6/1VcC0CHn?=
 =?us-ascii?Q?6LyK0lHHIc7rYZjC0oh8FWGvWkaMsYLR3erl0KvV0U8rJ1edpRV0hA03fO2v?=
 =?us-ascii?Q?FxQZ5FaRhAYQjXiKefXr6eg/TDVOi5DAkSzexpHVLb6Qui5/kbDG41yT4CJ+?=
 =?us-ascii?Q?CSsTXfVSdQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2a129acd-636d-4250-2643-08da46957beb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 XtDFDFa1kiQstei3kemkLPZM9lSBm3lYs7Y6pvmuW259a3Ha25T1D8BQqf9VVVaPAvT4paE2LDkFFMvS3Ji4RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7631
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 3euorm5Aely0dzenGHoOcDyTSejeuHw9
X-Proofpoint-GUID: 3euorm5Aely0dzenGHoOcDyTSejeuHw9
Reporting-Meta:
 AAE+1pheG7enU5mVsTUS5vuGo+jVc7/k7bA7IEYkcuXkGmPtQmDhDzYTqUclhY0v
 PRX+d95jGiaXETB4ZkKVRVdRuygeqeQgHuaIXONm9i0tfRwtnJds2GAeXGtagjwX
 nReRz/zJt3KOJUlCVh/8ymu04cv1H9Y1xEXwoSCvQRyEIDq9My4SgAfh9rpzoxIF
 sD98fHGo9qtJrcrLVYQ0ChE+p5iYn6mdrOdlkdnYgb8MVCC4z6oSJ5bk18WKZowe
 CyFJbNzE5erpe3KSYejfg7+hpbavG8Kr6Er9C4g8UY0Y+3Zx32bfF7yrBIG4H14o
 G9xnaoMRgMGvbwVou/g0jA3T0xplNNth5JUTvbGhQFYB3xmtGi2AhFT0onP9PkmL
 BLx8RPVoxkx9DmTd284Kkjp1vR97NfHtpWehYakyVI0TZwfjO+981Irx+O4asYZb
 MdG71PGAHXVYA29GSESy/v/T016aYADDhrW0TWQyFCIdojLiquSkZFbJgAUTROV9
 4WkZZuQKOn0tKsLjEqgW0C6WuFlU+6SS++CXCezdOOY=

c29ycnkgZm9yIG15IGxhc3QgcmVwbHkuIHRodW5kZXJiaXJkIG1lc3NlZCB1cCBmb3JtYXQuIEkg
cmVzZW5kIG15IHJlcGx5CndpdGggbmVvbXV0dCwgcGxlYXNlIGNoZWNrIGl0Lgoobm8gbmV3IGNo
YW5nZSBiZXR3ZWVuIHRoZSBsYXN0IG1lc3NlZC11cCBtYWlsIGFuZCB0aGlzIG1haWwuKQoKT24g
U3VuLCBKdW4gMDUsIDIwMjIgYXQgMTI6NDg6MThBTSArMDAwMCwgSnVueGlhbyBCaSB3cm90ZToK
PiAKPiAKPiA+IOWcqCAyMDIy5bm0NuaciDTml6XvvIzkuIvljYg0OjE377yMaGVtaW5nLnpoYW9A
c3VzZS5jb20g5YaZ6YGT77yaCj4gPiAKPiA+IO+7v09uIDYvNS8yMiAwNjoyNywgSnVueGlhbyBC
aSB3cm90ZToKPiA+Pj4gT24gNi80LzIyIDM6MTAgQU0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdy
b3RlOgo+ID4+PiBIZWxsbyBKdW54aWFvLAo+ID4+PiAKPiA+Pj4gT24gNi80LzIyIDA2OjMxLCBK
dW54aWFvIEJpIHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToKPiA+Pj4+IFdoZW4gdW5saW5rIGEgZGxt
ZnMsIGZpcnN0IGl0IHdpbGwgaW52b2tlIGRsbWZzX3VubGluaygpLCBhbmQgdGhlbiBpbnZva2UK
PiA+Pj4+IGRsbWZzX2V2aWN0X2lub2RlKCksIHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygpIGlzIGlu
dm9rZWQgaW4gYm90aCBwbGFjZXMsCj4gPj4+PiB0aGUgc2Vjb25kIG9uZSBmcm9tIGRsbWZzX2V2
aWN0X2lub2RlKCkgd2lsbCBnZXQgRUJVU1kgZXJyb3IgYmVjYXVzZQo+ID4+Pj4gVVNFUl9MT0NL
X0lOX1RFQVJET1dOIGlzIGFscmVhZHkgc2V0IGluIGxvY2tyZXMuIFRoaXMgZG9lc24ndCBhZmZl
Y3QKPiA+Pj4+IGFueSBmdW5jdGlvbiwganVzdCB0aGUgZXJyb3IgbG9nIGlzIGFub255aW5nLgo+
ID4+Pj4gCj4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNs
ZS5jb20+Cj4gPj4+PiAtLS0KPiA+Pj4+ICAgZnMvb2NmczIvZGxtZnMvZGxtZnMuYyB8IDE0ICsr
KysrKysrKysrLS0tCj4gPj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQo+ID4+Pj4gCj4gPj4+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZGxtZnMv
ZGxtZnMuYyBiL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMKPiA+Pj4+IGluZGV4IGUzNjA1NDNhZDdl
Ny4uYTEyMDYxMGRmZjdlIDEwMDY0NAo+ID4+Pj4gLS0tIGEvZnMvb2NmczIvZGxtZnMvZGxtZnMu
Ywo+ID4+Pj4gKysrIGIvZnMvb2NmczIvZGxtZnMvZGxtZnMuYwo+ID4+Pj4gQEAgLTI5NiwxNyAr
Mjk2LDI1IEBAIHN0YXRpYyB2b2lkIGRsbWZzX2V2aWN0X2lub2RlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUpCj4gPj4+PiAgIHsKPiA+Pj4+ICAgICAgIGludCBzdGF0dXM7Cj4gPj4+PiAgICAgICBzdHJ1
Y3QgZGxtZnNfaW5vZGVfcHJpdmF0ZSAqaXA7Cj4gPj4+PiArICAgIHN0cnVjdCB1c2VyX2xvY2tf
cmVzICpsb2NrcmVzOwo+ID4+Pj4gKyAgICBpbnQgZGVzdHJveWVkOwo+ID4+Pj4gICAgICAgICBj
bGVhcl9pbm9kZShpbm9kZSk7Cj4gPj4+PiAgICAgICAgIG1sb2coMCwgImlub2RlICVsdVxuIiwg
aW5vZGUtPmlfaW5vKTsKPiA+Pj4+ICAgICAgICAgaXAgPSBETE1GU19JKGlub2RlKTsKPiA+Pj4+
ICsgICAgbG9ja3JlcyA9ICZpcC0+aXBfbG9ja3JlczsKPiA+Pj4+ICAgICAgICAgaWYgKFNfSVNS
RUcoaW5vZGUtPmlfbW9kZSkpIHsKPiA+Pj4+IC0gICAgICAgIHN0YXR1cyA9IHVzZXJfZGxtX2Rl
c3Ryb3lfbG9jaygmaXAtPmlwX2xvY2tyZXMpOwo+ID4+Pj4gLSAgICAgICAgaWYgKHN0YXR1cyA8
IDApCj4gPj4+PiAtICAgICAgICAgICAgbWxvZ19lcnJubyhzdGF0dXMpOwo+ID4+Pj4gKyAgICAg
ICAgc3Bpbl9sb2NrKCZsb2NrcmVzLT5sX2xvY2spOwo+ID4+Pj4gKyAgICAgICAgZGVzdHJveWVk
ID0gISEobG9ja3Jlcy0+bF9mbGFncyAmIFVTRVJfTE9DS19JTl9URUFSRE9XTik7Cj4gPj4+PiAr
ICAgICAgICBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPiA+Pj4gCj4gPj4+IFRoaXMg
YXJlYSBjb2RlIGRvZXMgdGhlIHNhbWUgd29yayBpbiB1c2VyX2RsbV9kZXN0cm95X2xvY2soKS4g
V2h5IG5vdCB0byBnaXZlIGFub3RoZXIKPiA+Pj4gZXJybm8gKGUuZyAtRUFHQUlOKSBmb3IgdXNl
cl9kbG1fZGVzdHJveV9sb2NrIHdoZW4gbF9mbGFncyBjb250YWlucyBVU0VSX0xPQ0tfSU5fVEVB
UkRPV04uCj4gPj4+IHRoZW4gY2hhbmdlICdpZiAoc3RhdHVzIDwgMCknIHRvICdpZiAoc3RhdHVz
IDwgMCAmJiBzdGF0dXMgIT0gLUVBR0FJTiknCj4gPj4gSSBkb24ndCB0aGluayB3ZSBzaG91bGQg
ZG8gdGhhdC4gSXQncyByZWFzb25hYmxlIGZvciB1c2VyX2RsbV9kZXN0cm95X2xvY2soKSB0byBy
ZXR1cm4gRUJVU1kgaW4gdGhhdCBjYXNlLiBFQUdBSU4gaXMgZm9yIHRoZSBjYXNlLCB5b3UgaW52
b2tlIGl0IHNlY29uZCB0aW1lIHlvdSBtYXkgc3VjY2VlZC4gVGhhdCdzIG5vdCB0aGUgY2FzZSBo
ZXJlLgo+ID4gCj4gPiBJIGFncmVlIHRoZSBFQUdBSU4gaXMgbm90IGdvb2QsIGJ1dCBkbyB5b3Ug
dGhpbmsgdGhlIGVycm5vIGlkZWEgaXMgcmVhc29uYWJsZT8KPiA+IHVzZXJfZGxtX2Rlc3Ryb3lf
bG9jayBvbmx5IGhhcyB0d28gY2FsbGVyczogZGxtZnNfZXZpY3RfaW5vZGUgJiBkbG1mc191bmxp
bmsuCj4gPiB0aGUgY29kZSBsb2dpYyBpcyBjbGVhciwgd2UgY2FuIGNob29zZSBhbm90aGVyIGVy
cm5vLCBvciBldmVuIGNyZWF0ZSBhIG5ldyBvbmUuCj4gPiBpdCBjb3N0cyB0b28gbXVjaCB0byB1
c2Ugc3Bpbl9sb2NrIHRvIGF2b2lkIHByaW50IGFuIGVycm9yIGxvZy4KPiBSZWdhcmRpbmcgY29z
dCwgdGhlIHN1Z2dlc3RlZCB3YXkgaGFzIGV2ZW4gaGlnaGVyIGNvc3QsIHRoZSBzcGluIGxvY2sg
Y2Fu4oCZdCBiZSBhdm9pZGVkIHVubGVzcyB5b3UgZG9u4oCZdCBhY2Nlc3MgdGhlIGxvY2tyZXMg
YW5kIGFuIGV4dHJhIGZ1bmN0aW9uIGNhbGwgd2FzIGFsc28gYWRkZWQuCj4gQWN0dWFsbHkgdGhh
dCBmdW5jdGlvbiBzaG91bGRu4oCZdCBiZSBpbnZva2VkIGJlY2F1c2UgaXQgd2FzIGFscmVhZHkg
aW52b2tlZCBvbmNlIGluIHRoaXMgZmxvdy4gSSBkb27igJl0IHRoaW5rIHdlIHNob3VsZCBjaGFu
Z2UgcmV0dXJuIHZhbHVlIG9mIHRoYXQgZnVuY3Rpb24sIEVCVVNZIGxvb2tzIG1vc3QgcmVhc29u
YWJsZSByZXR1cm4gdmFsdWUgZm9yIG1lLgoKSSBjYW4ndCBzZWUgd2h5IG15IGlkZWEgY29zdCBt
b3JlLiAKVGhlIHBhdGNoICgnTkVXX0VSUk5PJyBzaG91bGQgYmUgY2hhbmdlZCkgd2l0aCBteSBp
ZGVhOgoKZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMgYi9mcy9vY2ZzMi9kbG1m
cy9kbG1mcy5jCmluZGV4IGUzNjA1NDNhZDdlNy4uZGQ0NzU1NmIwN2ZhIDEwMDY0NAotLS0gYS9m
cy9vY2ZzMi9kbG1mcy9kbG1mcy5jCisrKyBiL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMKQEAgLTMw
NSw3ICszMDUsNyBAQCBzdGF0aWMgdm9pZCBkbG1mc19ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUg
Kmlub2RlKQoKICAgICBpZiAoU19JU1JFRyhpbm9kZS0+aV9tb2RlKSkgewogICAgICAgICBzdGF0
dXMgPSB1c2VyX2RsbV9kZXN0cm95X2xvY2soJmlwLT5pcF9sb2NrcmVzKTsKLSAgICAgICAgaWYg
KHN0YXR1cyA8IDApCisgICAgICAgIGlmIChzdGF0dXMgPCAwICYmIHN0YXR1cyAhPSAtTkVXX0VS
Uk5PKQogICAgICAgICAgICAgbWxvZ19lcnJubyhzdGF0dXMpOwogICAgICAgICBpcHV0KGlwLT5p
cF9wYXJlbnQpOwogICAgICAgICBnb3RvIGNsZWFyX2ZpZWxkczsKZGlmZiAtLWdpdCBhL2ZzL29j
ZnMyL2RsbWZzL3VzZXJkbG0uYyBiL2ZzL29jZnMyL2RsbWZzL3VzZXJkbG0uYwppbmRleCA2MTdj
OTJlN2I5MjUuLjkzYjhkN2JhZDk2ZSAxMDA2NDQKLS0tIGEvZnMvb2NmczIvZGxtZnMvdXNlcmRs
bS5jCisrKyBiL2ZzL29jZnMyL2RsbWZzL3VzZXJkbG0uYwpAQCAtNjAwLDYgKzYwMCw3IEBAIGlu
dCB1c2VyX2RsbV9kZXN0cm95X2xvY2soc3RydWN0IHVzZXJfbG9ja19yZXMKKmxvY2tyZXMpCiAg
ICAgc3Bpbl9sb2NrKCZsb2NrcmVzLT5sX2xvY2spOwogICAgIGlmIChsb2NrcmVzLT5sX2ZsYWdz
ICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKSB7CiAgICAgICAgIHNwaW5fdW5sb2NrKCZsb2NrcmVz
LT5sX2xvY2spOworICAgICAgICBzdGF0dXMgPSAtTkVXX0VSUk5POwogICAgICAgICBnb3RvIGJh
aWw7CiAgICAgfSAKCnlvdXIgcGF0Y2ggYWRkZWQgbWFueSBjb2RlcyBhbmQgYWRkIGFub3RoZXIg
J2lmJyBicmFuY2guCi0gdGhlIG1hbnkgY29kZXM6IGNwdSB3aWxsIHNwZW5kIG1vcmUgdGltZSB0
byBjb21wbGV0ZSB0aGUgc2FtZSB3b3JrLgotIHRoZSBuZXcgYWRkZWQgJ2lmJyBicmFuY2ggd2ls
bCBicmVha3MgY3B1IHBpcGVsaW5lLgoKbXkgcGF0Y2ggb25seSBjaGFuZ2VzIDIgbGluZXMsIG1h
eWJlIGFkZCAyIGxpbmVzIGNwdSBpbnN0cnVjdCB3aXRob3V0IGFkZGluZwpuZXcgYnJlYWtpbmcg
Y3B1IHBpcGVsaW5lIGNhc2UuCgovSGVtaW5nCgo+ID4+PiAKPiA+Pj4+ICsgICAgICAgIGlmICgh
ZGVzdHJveWVkKSB7Cj4gPj4+PiArICAgICAgICAgICAgc3RhdHVzID0gdXNlcl9kbG1fZGVzdHJv
eV9sb2NrKGxvY2tyZXMpOwo+ID4+Pj4gKyAgICAgICAgICAgIGlmIChzdGF0dXMgPCAwKQo+ID4+
Pj4gKyAgICAgICAgICAgICAgICBtbG9nX2Vycm5vKHN0YXR1cyk7Cj4gPj4+PiArICAgICAgICB9
Cj4gPj4+PiAgICAgICAgICAgaXB1dChpcC0+aXBfcGFyZW50KTsKPiA+Pj4+ICAgICAgICAgICBn
b3RvIGNsZWFyX2ZpZWxkczsKPiA+Pj4+ICAgICAgIH0KPiA+Pj4gCj4gPiAKCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5n
IGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
