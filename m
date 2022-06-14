Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92626C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Jun 2022 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XKFvX87VRvxkCWXfj3IKxtS3OIMlhL7ux1RvM1K7UG8=;
 b=pY2yueHH/6zcwORqcNfHYldIUFAF1FrH+KQ7cGi8darWEOMrBGK/w316MP8V/TLNEUb705+6xDKc
   q3GMv+vhWWfYS/qTS0DBpettDJ6+OGJb7FZaYSaq5b/hKkn8qMhZSHGMwXKQBw734FI3NfjVaJ8T
   ARfZErKb2d4TdU+mV71oDelKXljSWpZESKoupoMUa896wL6lD5aRVccjl5uNEkGZRS1vGsYIpTos
   QxesFxdbyie+XEzfQhJtiWWN8BHqsCWXSfU6Y+YbRaOMD0+oYIZn31AsLuKO9I/vJshNQnSzC+Yf
   fmV9ucM11KQvdLUXcu+bDhjHpD/QT1j0SAlmOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XKFvX87VRvxkCWXfj3IKxtS3OIMlhL7ux1RvM1K7UG8=;
 b=ChhzxHQgK/cryZdlgtRNSkl2o2Ue3oSMtiv2vnBpak63svUyzl3lNnGk+6T3qWusbVdKRBv29mj3
   nJAKxvrGa6wCXDDJrtSODtjwR/fIaAjN0zfAwXY1pXgjcfgS+qVpjmHaaUVUqgBVLKrZMz1B6Icd
   Ww5meWCBjkf/1fTMIAaHexbvEgWIaNsV3YZwgDubq6S4DiwLvwxNUyQjHBYLjzcTLTWB+0rBlKNS
   +acP1O12UAiMD+zaLQNmaYVp4ElqjzHL/udeg8ZmpGh/qEqrKn/+RabskDq4rw93PagKuekWHCPe
   8PZAhifBMTknwrS1xn8PhR6dFWtM2oS143H7ZA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDG00NDDVBTQ640@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Jun 2022 12:14:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuSlfYFtMahris9037SNzoPGZItBXmiVHTkVUeYvJFUZL1M7bWIc52v/HexPsk/11amRUcSde9IybwWGpjXjoMUM1uEpeuPEuGewWTFFpo5s37Lt/ijdITfOR4hDWdl1f+F9me0P4Vy9oNFQiME/rCNUY5M4Xan59nOGU/m70YwPNV+gxDqeySUTvxOp6fVRhGIa6H/byhbjnZz1LXz1wVK0AOeeZtpY+YuTYt4w3irv1mdeUnfWc95lswqUDcuYhRxcbm2FsUXbGVbSAraomqYA2Ln/sW+FsOenTOBU2UN2rD4vpeBlNu/60N7iODLr/ynFb2TrX1aLTMhozL8V7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kywdsa2ta6Y+F3+GrYH1vSh/+v8W1M6YhArm38eJBFY=;
 b=UEldeIZAfq3qr2Hb6m+yG6dSLi22Ra0y1c3Z8oVfS9v3tMIEQzz/acFLJYlnO2jSUqqQTSxBDUI3OTjVHE+BA7BB1u1XztqQpZbD3GKi6kyknj9Mj3xJem37tEHqIUleEXkoK3pKz3G1tSLremvWBFnqo+JudYVSGJdyV6U1Kd4SYnIW9PdXv9xfaX+CKl0SRYLeHnmUKgkrvslwm0YyrA67N00TRvb/OH7jFjmX/EjSVLj624/KekinwJdrqByCNnpP3C41yu3zDlq/UGzQPdU4scHGRB7knVAV80EzX077TrXhzuGTGzNuZW5KV98nAVC1mhK3Ebs8LD7CK4+6yw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kywdsa2ta6Y+F3+GrYH1vSh/+v8W1M6YhArm38eJBFY=;
 b=3gnNN8Ez65rkMRTvxBNHJUxUFqei+TbZWTUMBT2MrNTmFiw3oV4CzUOdomxk2DnXfcg4bmAvD7XIQ4+2KLQRuXFcUqIhr8vc/09bmbu8MMIYq3Um5ZkHMdxmdaPq6HKGpePo0bnQCC8tjzqq5dZDDNFOiq9CLB0P0/Qnr28WjuOlQs5CkW1JZnAZZb7cmfLcLnjnF4PhY90eqXucl5PL3zmEv5zYocSbh0qB44T5YYoFd1kZPruMhnV+BgBr6fe/e+iqov3iujVeD403G3c7VelS3XlmipygwDQaVBQieHxFByjNcYlDnyS4Dbwhrhul83InAPFP0NjJfIYqyTfJew==
Message-id: <633910e3-83f0-23e1-0b85-78a1a2fbdb91@suse.com>
Date: Tue, 14 Jun 2022 20:13:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Junxiao Bi <junxiao.bi@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
 <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
 <ea848935-abf6-90d6-9313-852cf8344852@linux.alibaba.com>
In-reply-to: <ea848935-abf6-90d6-9313-852cf8344852@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(6666004)(6512007)(26005)(31696002)(6506007)(66556008)(316002)(110136005)(53546011)(16799955002)(6486002)(2616005)(966005)(508600001)(86362001)(66476007)(66946007)(38100700002)(83380400001)(5660300002)(8676002)(31686004)(2906002)(4326008)(186003)(36756003)(8936002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 12:13:55.0812 (UTC)
X-Source-IP: 40.107.14.45
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10377
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 clxscore=206 malwarescore=0 impostorscore=0
 bulkscore=0 mlxscore=0 adultscore=0 priorityscore=136 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140049
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75b440da-97ab-4af0-462d-08da4dff5a00
X-MS-TrafficTypeDiagnostic: AM9PR04MB8970:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB897093E86496597C10B3B86197AA9@AM9PR04MB8970.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 CgE4jlsIUgrWcr0YUyFajs8MPpap3iLKef91vbyT/1Jzlkf8/2xFS+F0WEZd8blIVLnZAoDxvYN4vevPdZ6rDBVQPVJFf0wGPL0mworrN1e9Pu9Br+xk+aelu3UO9cRHqIwSUmSN1FXCTV7I0kiqBjWnolVA7pmXIN86ppQi/Ui5kP59uGE/bimWdOu/m3XUgA9OwNSpJu/AVMB1/ayA5naDcxzmH4LELKLETLGG0qckO6UKfK5Iv2Yfo4+khWoPIj3y5HuKkqa/HfpfWyJ3eIWtlr9TIIHyfHXXUo+zFq5Hh22jKIQ4bZZUI72ijYEqIn7ICjVpD4uG2ltcIebWLX0fQ2UfEr/E1B+f7oRPaq5ys0f1ZOJfjrZokZrYXHdfD2mgHDzyZdnx3lRigj1P6pt3AimhK35X1qOBgI/dc7tEYtPiVPOF8SLOR1mnuUS+qodYyznfwtSDs5MzVQ5Xf/b4SMnQ2YHzUKd29XByBYMLTlzPjG7RzqY7+UZOUzUbRdmrZoTzAnwZ39Cv61mSgSTgQqVumEOwVzARLHVSi5IGhy2E+wiYH0UBukNr1X3szOEGUKw+wCOw8b7LGraZfNYRh2FwGzXa85gihXT+U7OogCHjX9qoSYfhDn+78E11Drw6AahWnZGzXGGLp2RQdJsJhP067xkJxE+3opDHTjEdsP6NmswcehaAXQ4EDWVlghkoxb1uufnlqRBCeCuEkjWvgFgUWpWDylHSGooaHgpsm/0n5OU8RxWCdhVFX6cm4DiT26LlywoBeIL4MPLoW1BU/youCjYpq2euDvFwEbmzvkIzxz3/iHfozbGncaHt
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZUJJMDh3UnQ5RGIyWDkvZlAvSFMzSndiQ0xEdzlWZm5nTElsQ0hoMjAwR3Yw?=
 =?utf-8?B?NlBaOGgxNG1iRG16YjVVa3FqQnhHRDhXa1N4a2RFc3ZGc0xzYWhYNkJTL1VT?=
 =?utf-8?B?NWxlbUlscTdoNm13SDcwM3QyNW9QZGI5dnBYcE80VWR4TkZlcTRRam1WbnZ3?=
 =?utf-8?B?NkxDdTFkSWFwWld5MThBT24xR0J5ZithSVpDM3RFUkNUZmdWVS9pOUR2K0JE?=
 =?utf-8?B?NWVRTVpDMUMrUEJUY3VFL2FKNVZzTG81Z2xzdHZDN3E2bkU4VlhSbmdCbXBQ?=
 =?utf-8?B?U0M4SUh2QmJhUXhMY05NblZzMEdady96MjVzMHZLY1VHUXd0Mk83bUJud1FG?=
 =?utf-8?B?Y01PaGc4UnVWcnJCcC96b09oOHUwT1pIQmNwcWtxNUZ2WlozWlkrTHhyeUtn?=
 =?utf-8?B?L05PdkQ3R3NoZHBNNk1pemFQTlU0VlU0VGtTMEd2OVBRc2RKd3U3U3d5dVRk?=
 =?utf-8?B?L2pLRzFxWHZielFiTE1xbUxRMXF4bkhvN0ZDZFVjTnBQNHRNdGE1SW5RWGRr?=
 =?utf-8?B?TkhzTHIzRXlvbFFaL29XY2U1Z3FRazFnQW5scG4yL2NUcEN1VUl4TFA1Wk1O?=
 =?utf-8?B?WWFjYlkwY0Q0N3BtT0VTcHJKTUZZaDBjU3BWUGJTdW16VGZzeTNaTUtiemZG?=
 =?utf-8?B?L0xJOC95RE9rK3RtL0lGb0g2RldMV3FUNTFjNG9vUC9Wd2V1VnR1T2ZqMENC?=
 =?utf-8?B?Tjd2UDcvUFZBa0lXTlV1Q09OT1FnUFFQbjJadnlCU1RpR0xIUmI5WE96aFNH?=
 =?utf-8?B?S3NySUk0am1OcjNxa1VLZkVXb2huTkhRdCtiZEplRVRZRi9iaXU5aUJKdXJr?=
 =?utf-8?B?UEFjdWNkZjllUmpJdGdGdDNIcDU2dVAxWlFKV2I2TUxqYWVwTUo2dkR3M0Va?=
 =?utf-8?B?NlU1RHBTcXR5QnVpdURCWUo3aFFET2Z5dmFYRStZaGRsdnBQeS94TUV5b3lK?=
 =?utf-8?B?dklQZ2NkenhsbTB6UGNtOTgyMFo4S2krc0dyamM1TEF3Mkl2akl1b0xLb2hC?=
 =?utf-8?B?QTBHbHFyMEN3U1VmcXFqNWVSck5jc05HMEE0WVIxenI0ZHZraGdWMU90dFNM?=
 =?utf-8?B?WTE0cHJZTFNqWndzYjhhdnlzcXBXTm1xWDYyalYzRHRFVkRNT2FieDgxRzk4?=
 =?utf-8?B?VE5kNTlCMklJd2h0OW15M1krSzBrSFBVdnY1NllUK0RhYlQ1a3FPc3d2dHVT?=
 =?utf-8?B?NytQWlFrUWtmdC9vbTFmWlJZTmF0OC9yeitjRHYvdGt6SUIvVTdhQk5od3E3?=
 =?utf-8?B?WlRocTZaVGd5bVNMTXBsTVc0eXNKSzN5QUJKTG5ZejgzNStoeitBVVhFWjNR?=
 =?utf-8?B?ei9ocExXYzd1ZFVoZm5XZUNRMFNkUVRoQUR2dEwwdG5ZalRmUTlLZ2g5eko3?=
 =?utf-8?B?RkNKVmVuQ0xRbWJibHN2aTJWM0dHMVpSSmkrUVhoZ1IzMUJvTnlIYWtrRURo?=
 =?utf-8?B?WVd2QUNtdEFhSVUrT3lENlJIbjRrWENmb0FYTFdGK3RtYURLMHE4OVNQbGJ4?=
 =?utf-8?B?ekIwTnBvWGpZdk92VTFyMEI2VHBMMEQvWW44Kzd3VjhaTEpGc3J6WE1LT3ZZ?=
 =?utf-8?B?bGZnb3J4R25DQVdHUUFKMkdmZmpYSE9DcnJsaFdwV2plTWZPeFBnYnZGZnpZ?=
 =?utf-8?B?ZDlEMUI0RU5ERTJVa000V0I5TytOVjdVdm1SM050bE5wOXBMZWlnemtiTmoz?=
 =?utf-8?B?QW1ZaEdHbHA3UDNvL05iYkJpdnhoZkF0NTVrNWdrZVdKeW5oM1EvdjZMdTVs?=
 =?utf-8?B?SEdaa2ZBZE1OdjROdkY3MWI0TW5KUytVdklBVThnV2tMZGRWZHZGeWw2Q3A1?=
 =?utf-8?B?NERhVk15dTBBNzhkVDc4eHpZOUkwSTFkZG1ZajE3elp1RzAreEZsek1wYno3?=
 =?utf-8?B?SnBYbFlYMnZHeERONXlKS1g2eXFSZTNGV2NRSkVkcDQyOENxb1VLSmdpY3RO?=
 =?utf-8?B?TC9tSkplNk9lUW9aaXRvcTNkWTc0N085eDFDT3VOUkRTNkJYRXVVRlpWTGls?=
 =?utf-8?B?NEg5SHlUMS9hLzJnNm9zcVF1ZkR2QjVaR1pqajhGYlY4Z0s4OElnYUxML2Zx?=
 =?utf-8?B?SnAvU1YvclFmVnByTjRFczg4WHZ3RnhRcmI3eU5CRzZjSzF4VXpqQTFoK1Jv?=
 =?utf-8?B?NDQ5dm1WY2Y3dUVyNkJmNitxYmRrUEZycTdKaHE0VVVDbEJIZXdDcXFWcGI2?=
 =?utf-8?B?aElVeCs1cXR0U0ROQml3aW1zK3JZSWUwcjJmUTFPTHFCNWRaSUpnaUcwRFpZ?=
 =?utf-8?B?YUJqSXpnc3JrZndGY2xucXlLUjU4MlpCSkczNUlFRHFKRnpqYStvMDJINWIy?=
 =?utf-8?B?SHIyTERXNEQ0bjdWdUhyaEdXK3VFUkZ6UlhRY0RKejdTdnBvN3Vxdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 75b440da-97ab-4af0-462d-08da4dff5a00
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 1J5JnTj5V5DQefaueD1BVw+MPXi4fXLE4VMA/1+/4ARjdF4lfXl/jJ50RKakW0PJWIjC/K9HUpPcvcOYuL/Y9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8970
X-ServerName: mail-eopbgr140045.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8OhGEw4vNSJTZ_YjblEoFw6IzAO6C2nb
X-Proofpoint-ORIG-GUID: 8OhGEw4vNSJTZ_YjblEoFw6IzAO6C2nb
Reporting-Meta:
 AAGddd2Oq12W47UudA11N8JCVGiWyZsX7qOJbL7QJWX0na3tyHwKt9gnd9ROZJtg
 5pd7RcQilbuhVLjttJp3fjpYSm62s33ONqAYRz+QDJay9CR8DGpwo+z72eS9v0kS
 2OR0fU4BHpaMGYHyxYqHCFcViwV1JMMFGuQ2eNaI/S1ZmOEomcgFF3cuyJaT7NcH
 OW3lfDyDL2MkgW2/520VQ6614l2MgeD0vfdFMdM/24G4SSr9J1pSxfEEYmUb/+4A
 IV9Ubm7TKbyVkAH4mAYTwJn0h4e161XGxH9EBkWImSo3X3xf/OADUBZUAes3rstu
 NoHQCnLeDQcXBrlnAIZavdgnK8AVzam7P5BoqS5EsJGmUl+7nUBnK41MCsvFC6OX
 YmHDFV4lhTT3Lr0bSTTSJiEu8J2BWyTjHAae5wJ7cbJhr8rA5Y0JP1Gyx805xlPO
 Qw9Bo/Shb8v4Eko+XpZbITURBKVh83khVGx/ctla132bYRkvB+BMcpkStRMrz50D
 B/EUYK98VUz/LzKJYWqHJ7dYIfK6rryOaFcygjKBXCU2

T24gNi8xNC8yMiAxMToyNywgSm9zZXBoIFFpIHdyb3RlOgo+IAo+IAo+IE9uIDYvMTQvMjIgMTA6
NTkgQU0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdyb3RlOgo+PiBPbiA2LzEzLzIyIDIzOjQzLCBK
dW54aWFvIEJpIHdyb3RlOgo+Pj4KPj4+PiDlnKggMjAyMuW5tDbmnIgxM+aXpe+8jOS4iuWNiDE6
NDjvvIxoZW1pbmcuemhhb0BzdXNlLmNvbSDlhpnpgZPvvJoKPj4+Pgo+Pj4+IO+7v09uIDYvMTMv
MjIgMTY6MjEsIEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4+IE9uIDYvMTMvMjIgMzo1OSBQTSwgaGVt
aW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6Cj4+Pj4+PiBPbiA2LzEyLzIyIDIyOjE2LCBKb3NlcGgg
UWkgd3JvdGU6Cj4+Pj4+Pj4gSGksCj4+Pj4+Pj4KPj4+Pj4+PiBXaHkgY2FuJ3QgdXNlIGxvY2Fs
IG1vdW50PyBJIGRvbid0IHJlbWVtYmVyIGlmIHdlIGRpc2N1c3MgYWJvdXQgdGhpcy4KPj4+Pj4+
Pgo+Pj4+Pj4gU29ycnksIEkgY2FuJ3QgZm9sbG93IHlvdXIgcXVlc3Rpb24uCj4+Pj4+PiBEbyB5
b3UgbWVhbiB3aHkgcmV2ZXJ0IGNvbW1pdCA5MTJmNjU1ZDc4YzU/Cj4+Pj4+Pgo+Pj4+Pj4gb3Ig
eW91IGFyZSBpbnRlcmVzdCB3aXRoIHRoZSBmZWF0dXJlIGxvY2FsIG1vdW50Pwo+Pj4+Pj4gdGhl
IGxvY2FsIG1vdW50IGlzIGNyZWF0ZWQgYnkgbWtmcy5vY2ZzMiwgd2hpY2ggY2FuJ3QgYmUgY29u
dmVydGVkIHRvIGNsdXN0ZXJlZC4KPj4+Pj4+IHNlZSBta2ZzLm9jZnMyKDgpICctTScgb3B0aW9u
Lgo+Pj4+Pj4KPj4+Pj4gV2hhdCBKdW54aWFvJ3MgbWFpbiBjb25jZXJuIGlzIGRhdGEgY29ycnVw
dGlvbiwgc28gSSdtIGFmcmFpZCB3ZSBoYXZlIHRvCj4+Pj4+IGludHJvZHVjZSBhbiBvbmRpc2sg
ZmVhdHVyZSBiaXQgdG8gcHJldmVudCBtaXhlZCBub2NsdXN0ZXIgYW5kIGNsdXN0ZXIKPj4+Pj4g
bW91bnQsIHNpbWlsYXIgdG8gbG9jYWwgbW91bnQuCj4+Pj4KPj4+PiB0aGlzIHBhdGNoIGRlZmlu
ZWQgdHdvIG5ldyB2YXJpYW50cy9mbGFnczoKPj4+PiAjZGVmaW5lIE9DRlMyX1NMT1RNQVBfQ0xV
U1RFUsKgwqAgMQo+Pj4+ICNkZWZpbmUgT0NGUzJfU0xPVE1BUF9OT0NMVVNURVIgMgo+Pj4+Cj4+
Pj4gKEkgZXhwZWN0KSBVbmRlciBPQ0ZTMl9TTE9UTUFQX0NMVVNURVIsIGZvciBjbHVzdGVyZWQg
bW91bnQgbW9kZSBhbmQgZm9yIGNvbXBhdGliaWxpdHksCj4+Pj4gYW55dGhpbmcgZG9lc24ndCBu
ZWVkIHRvIGJlIGNoYW5nZWQuCj4+Pj4KPj4+PiBPQ0ZTMl9TTE9UTUFQX05PQ0xVU1RFUiB3aWxs
IGludHJvZHVjZSBhIG5ldyB2YWx1ZSBmb3Igc2xvdG1hcCBhcmVhLgo+Pj4+IHRoaXMgbmV3IHZh
bHVlIG9ubHkgdGFrZSBlZmZlY3QgYWZ0ZXIgYSBzdWNjZXNzZnVsbHkgbm9jbHVzdGVyIG1vdW50
Lgo+Pj4+IChwbHMgZml4IG1lKSwgZXhpc3RlZCBrZXJuZWwvdXNlciBzcGFjZSBjb2RlIGRvbid0
IGRvIGFueSBzcGVjaWFsIGhhbmRsZSBmb3IKPj4+PiBub2NsdXN0ZXJlZCBtb3VudCBtb2RlIGlu
IHNsb3RtYXAgYXJlYS4gU28gdGhlIG5ldyB2YWx1ZSBpcyBhbHNvIGNvbXBhdGliaWxpdHkuCj4+
Pj4KPj4+PiBBbmQgdGhlIHBhdGNoIGNhbiBhbHNvIHByZXZlbnQgbWl4ZWQgbW91bnQsIHRoZSBy
ZWxhdGVkIGNvZGUgaXMgaW4gb2NmczJfZmluZF9zbG90KCkuCj4+Pj4gY29kZSBsb2dpYzoKPj4+
PiAtIG5vY2x1c3RlcmVkIG1vdW50IGNvbmRpdGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBhbHJl
YWR5IG1vdW50ZWQgd2l0aCBub2NsdXN0ZXJlZAo+Pj4+IC0gY2x1c3RlcmVkIG1vdW50IGNvbmRp
dGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBhbHJlYWR5IG1vdW50ZWQgd2l0aCBjbHVzdGVyZWQu
Cj4+Pj4gLSBhbGwgb3RoZXIgY29uZGl0aW9ucyB3aWxsIGJlIGRlbmllZC4KPj4+IEZpbmRpbmcg
c2xvdCByZXF1aXJlZCByZWFkaW5nIHNsb3QgbWFwIGFuZCB0aGVuwqAgdXBkYXRlIHNsb3QgbWFw
LiBJdCBpcyBub3QgYXRvbWljICwgeW91IGNhbuKAmXQgcHJldmVudCBtaXhlZCBtb3VudCB1bnRp
bCB5b3UgaGF2ZSBhIGNsdXN0ZXIgbG9jay4KPj4KPj4gQ291bGQgSSBzYXkgeW91ciBtZW50aW9u
ZWQgdXNlIGNhc2UgaXMgaW52YWxpZC4KPj4gSSBiZWxpZXZlIGFsbCAoeWVzLCAqYWxsKikgdGhl
IG9jZnMyIHVzZXJzIHVzZSB0aGlzIGZzIHVuZGVyIGNsdXN0ZXIgbW9kZSBpbgo+PiB0aGVpciBw
cm9kdWN0IGVudi4KPj4gVGhlIG5vY2x1c3RlciBtb3VudCBpcyBvbmx5IHVzZWQgb24gbWFpbnRh
aW5lZCBlbnYgKGVnLiBiYWNrdXAsIGZzY2spLgo+Pgo+PiBXZSBvbmx5IGNvbmNlcm4gdHdvIHdh
eXM6Cj4+IDEuIHVzZXIgZm9yZ2V0cyB0byB1bm1vdW50IChlZyBjcmFzaCkgYmVmb3JlIHVzaW5n
IGFub3RoZXIgbW91bnQgbW9kZS4KPj4gMi4gd2hlbiBvY2ZzMiB2b2x1bWUgaXMgd29ya2luZywg
d2hpY2ggc2hvdWxkIGRlbnkgdm9sdW1lIGlzIG1vdW50ZWQgYnkgYW5vdGhlciBtb2RlLgo+PiAg
wqDCoCB0aGlzIG1heSBoYXBwZW5lZCB1c2VyIG1pc3Rha2VubHkgcnVucyBjb21tYW5kIG9yIHNj
cmlwdC4KPj4KPj4gQmFzZSBvbiBhYm92ZSAxICYgMiwgSnVueGlhbyBhYm92ZSBtZW50aW9uZWQg
dXNlIGNhc2Ugb25seSBoYXBwZW5zIG9uIG9uZSBzY2VuYXJpbzoKPj4gdGhlIHZvbHVtZSBkb2Vz
bid0IGJlIG1vdW50ZWQgYnkgYW55IG5vZGUsIHRoZW4gdXNlciBtaXN0YWtlbmx5IG1vdW50cyB2
b2x1bWUKPj4gd2l0aCBbbm9dY2x1c3RlciBtb2RlIGF0IHNhbWUgdGltZS4gSSBiZWxpZXZlIHRo
aXMgdXNlIGNhc2UgaXMgaW52YWxpZC4gQW5kIEkgZ3Vlc3MKPj4gZ2ZzMiBtYXkgYWxzbyBoYXMg
dGhlIHNhbWUgaXNzdWUuCj4+Cj4+IFdpdGggdGhpcyBwYXRjaCwgb2NmczIgaGFzIG1vcmUgc2Fu
aXR5IGNoZWNrIGFiaWxpdHkgdGhhbiBvdGhlciBmcywgZWc6IHhmcywgZXh0NC4KPj4gU1VTRSBI
QSBzdGFjayB3aXRoIGNvcm9zeW5jK3BhY2VtYWtlciBhbHNvIHN1cHBvcnRzIHJ1bm5pbmcgeGZz
L2V4dDQgd2l0aCBBL1AgbW9kZS4KPj4gVGhlIHhmcy9leHQ0IG5ldmVyIGhhdmUgZGV0ZWN0aW5n
IG1vdW50IHN0YXR1cyBjb2RlLCBKdW54aWFvIG1lbnRpb25lZCBtaXhlZCBtb3VudAo+PiBjYW4g
YWxzbyBoYXBwZW5zIG9uIHRoZXNlIGZzLiBIb3cgZG8geGZzL2V4dDQvSEEgbWFpbnRhaW5lcnMg
aGFuZGxlIGl0PyBVbmRlciB0aGVzZQo+PiBmcyBtb3VudGluZyBiZWhhdmlvciwgdGhlc2UgZmll
bGRzIG1haW50YWluZXJzIGFsc28gdHJlYXQgdGhlIG1peGVkIG1vdW50IGFzCj4+IGludmFsaWQg
dXNlIGNhc2UgYW5kIGlnbm9yZSBoYW5kbGUgaXQuCj4gCj4gRXh0NCBoYXMgYSBmZWF0dXJlIG1t
cCAobXVsdGlwbGUgbW91bnQgcHJvdGVjdGlvbikgdG8gZG8gdGhpcy4KPiBNb3JlIGRldGFpbHMg
cGxlYXNlIHJlZmVyIHRvOgo+IGh0dHBzOi8vZXh0NC53aWtpLmtlcm5lbC5vcmcvaW5kZXgucGhw
L0V4dDRfRGlza19MYXlvdXQKPiAKCkhpIEpvc2VwaCwKCkkgY2hlY2tlZCBtbXAgZmVhdHVyZSBy
ZWxhdGVkIGNvZGUsIGl0IGNhbiBoZWxwIGV4dDQgdG8gYXZvaWQgbXVsdGlwbGUgbW91bnQgaXNz
dWUuCgogRnJvbSBteSBjb2RlIHJlYWRpbmc6Ci0gdGhlIG1tcCBmZWF0dXJlIGRpZCBtbXAgY2hl
Y2sgd2hlbiBtb3V0aW5nLgotIHRoZSBtbXAgZmVhdHVyZSB3aWxsIHN0YXJ0IGEga2VybmVsIHRo
cmVhZCAoa21tcGQpIHRvIG1vbml0b3IgbW91bnQgc3RhdHVzLgotIGttbXBkIGRvZXMgZGV0ZWN0
aW5nIHVuZGVybHlpbmcgZGV2IElPcyB0YXNrLgoKV2UgY291bGQgcmUtdXNlIG1tcCBmZWF0dXJl
IGlkZWEgZm9yIG9jZnMyLCBkbyB5b3UgcGxhbiB0byBhZGQgaXQ/CklmIHllcywgSSBjb3VsZCB0
YWtlIHRoaXMgZmVhdHVyZSBwb3J0aW5nIGpvYi4KClRoYW5rcywKSGVtaW5nCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5n
IGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
