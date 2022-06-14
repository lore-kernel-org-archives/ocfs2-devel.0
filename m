Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E53C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Jun 2022 03:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E+xnF1oTFcDsTvYLVOcl1n4+UEV8wdhkI4MelOTMpyo=;
 b=DpSi0055XPtGo0okwx+bow4Zncx+3O7WxRLMq2Mg9Lq/WYHtnd44/TZaaa6mh8VZtf+ce11WOvL+
   mQf6g+qbUOvuf3ob7o59YQv/zjv5uOjtLigEAuO6r+PDBzZumsGTvjfPo+HemoE7Tl9x+8IlxzK0
   F+KvY99uFvB0YuiX2DtOqJDIh4dytZJcrI+6NnNPf1EbhdoRRDnG5bJ/vVEIdxT26VqBysvvibW4
   JMQlVxqy3t9lrOJmZ+JlRo3FrZB5JPppd9W72easEoeFmOaw0ELflLqnhD1CIQdZWu8lwsezdg1C
   GVt6YZj3xqEsDSzUtGsmIBLxYShdOBsC8fPiUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E+xnF1oTFcDsTvYLVOcl1n4+UEV8wdhkI4MelOTMpyo=;
 b=AilBwNVmfOAE9R8akHMrU2ZJ8cEWuegbRgMredoEKCwuq64ro2wRwJrO5Qq8JEAO6VaJsAti3uPQ
   JHclrlmzMyGJFwd+3kV7smmVPXuctgDrzIChEAc39nHGXbqRM778fVby1Rh7El4HG/3Pcw9cJtYs
   Izx8pJzQbOenbJHrwr8FTPXofY4y87QPenu+qIYhaVemtpccPayBihz5LEXVmp42H2rSIL7ZNsBe
   8893Eej9pJ4ZBCP93v8navPgDWs51Igb22uOlfDRj3xfNcYhluyrgQVFLQP2verunn599/TFxbi4
   CwXHa+aZkTyg4JAQK0y6JeIlerIloKZt2M0NAw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDG002485OK5U20@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Jun 2022 03:00:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9kYp4fLO80Fe1xJNEGAB+v46KOF5/JDrQQWUAUzHjXS+6oiyEwQ1nr9qMZr9EqdZvMsiclaXd/PhdIB4x4dRAyvNHCr1iA9hngIO2msmqfEYxQJDxPntXR+gmayRotFZcpLqZ7cdjR3JCJOhvF2rD+zc1bgCQKq1DroR6Cw67htYads4lHeIL3C0VD/TO5qb9sqlxwB1uWAQIj+p+QDeiwZvYiDL/74TJL+74NXsQVKDu7AUo7n0NNKdA7f9tHnODBHIr7Ermp2MKk31QtmJ2jSl/CvXQ1cXab8KQHck0ChFZm2GtY98e1QODTSegZXiIKWrRXlc6wZb8UvAMe9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGlVZz4CqIpGopr6tENZyBKLHdq9Caz9xbatym6l/YM=;
 b=hHwdXFuswSg7dhVLEznG/c+uIA3W2fbawZwDCh1sLmXWj1dfJtJCRAtvtMFj0e9AANjw/elqeN1xeCVCdGYqqS+FE+Lw1X4aa2cMS8Hiama4Q/AlSBpRYLlDkDcWQ9XpubcYY4mHc0ZU6fU3OVq9LqPr5deK/Ju18msKLQuMMhQ0XcSOqwUspM4BURrSzBJR1u2kR3B19dsgl+3MPxM7IP2Wb2zY/PlvS8hbGh9+uKRST+M0VpUvOM27FVU3sHqyV8HNbUjml5pqAvntJ54lBz7OiLa4uveSPhGHN99YcVxXKlfXCGx4VzFyCKSN9Pws2Kbmxs0f5pq7EKMhKg3OMg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGlVZz4CqIpGopr6tENZyBKLHdq9Caz9xbatym6l/YM=;
 b=mhSlRXkSwmr6XqDbprd29mw6JNhjFMQNa1wiobekf0fgJIdZDIo+SkV79lejt2zY95mPfwpYcni7u9AZUEL/WsG0x1+RP1fdXhQOVVSX7sXDuTiq3sqN4Dzc48H5tgW8m+1QAh6Oy4ogpeixEc1C0bX1Z/XJT3jjw74wI9iq8rn5UNRxZHGw2S5HSBAfVtZiDLx9iuIcuidMI0yHdpvOz4mzJZ6wO0SOIbEBK0m/ftq0oUJSNhrXbd+kDc8T/3WR78CIURgmjOT1fPM0Uo9+6/QSoxOVabaKwVB1kjKEvp4AiiWHuFDD6SSVrdV83mXNIlnAZep0TxPL+3DLqW7Ekg==
Message-id: <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
Date: Tue, 14 Jun 2022 10:59:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
In-reply-to: <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(508600001)(36756003)(2616005)(26005)(6916009)(54906003)(6486002)(31686004)(316002)(6512007)(186003)(83380400001)(6666004)(6506007)(53546011)(31696002)(66556008)(66476007)(86362001)(66946007)(4326008)(2906002)(8936002)(5660300002)(38100700002)(8676002)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 02:59:59.6742 (UTC)
X-Source-IP: 40.107.7.84
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10377
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 priorityscore=179 clxscore=174 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140010
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
X-ClientProxiedBy: SG2PR02CA0016.apcprd02.prod.outlook.com (2603:1096:3:17::28)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8f3cc3f-21eb-489b-d894-08da4db1f822
X-MS-TrafficTypeDiagnostic: DB7PR04MB4075:EE_
X-Microsoft-Antispam-PRVS:
 <DB7PR04MB40754E91DD02EF6F3DD1A9DD97AA9@DB7PR04MB4075.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 z4GYR+rmOhvha63MtZnw99A/1ZBVrBI58McbHvqEkPogTyn6VphTaslvMpa5ZgOEsWl6M6XeAzV+lHugxvFc9/chV/vWVN3bXs6OlX7hdqSFXGJN4Zn4O+LxoKuYDptCB8UPJI7pQbRvMmWcceji4rftjZBZGF+Ctj3GLCXt17+lBlCxHNCD1WH7hW/AXlx4SrthvposCpLxDL362CUIMoYPtqyBXo4HNhDhuSsQ65xxTbeU+lCgpc4NszpZk8uKin3YzddjLWG9mV7pQFDkBbwMLBjunSGwc/zA05+WxO8iNX3Z856+UX8svqD9cWY5uWioCAM/Klpnhahximor2TkC8FYZ04AlVSLlVrI3rOUCfuL6fjboAbiDN5NWfUykUwSfFfr0mjPV+/vYARIvlWmYBtMBA10mGn6Ew4X+HOcGAq6dRED219qkVMzXghzCtx0L11J/Sfd08lXV2Fhx4RKNk3tlpsORaLWfR4cGdRD1BSJeTZKIxiXqPo4cq9LZavzvqr/vR9HgypkvTa8CgGRj0pScj3EO0em2t3wRR3sXThs6G/k8sT2UnqwTd+o80tv+CmCuQaksLN5Sg2sNk6u7vqybLrob8tC877EUL554hysv+YxJXBR5AZ+j+iuFyFP0GnUmgya9qXBQyqanPhzycTrK23oESHdBWhpypfJW8/jLMSxL+SK+gGllTTin7U8LenaEUziFdyy6ixF2dvr83dp/0NNM6a9Pxx+3fHs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZjJLUXNMUnBJbk9vNDdIWFFXRkFzdERWRTZ6TUxtczJQcTNZNG9rV1VqRTR5?=
 =?utf-8?B?SGhUd2RsUndlWHlBRzAzVHVoVC95NjRuZ3hxUXdGc0xvWGNtN1M4Q25vdWND?=
 =?utf-8?B?YVRxSm5tY0U4VDRKMGgrVFVBMHgxYUVHdWlJWmc1cDlPZ24zdVNqK2pxYk9B?=
 =?utf-8?B?eUdqemJvdXZiU1hyb3hKTzBoeE4zYktwamYwOVN5a2c3VlovcHZLc0lFbFJr?=
 =?utf-8?B?QVdGU0hVNk0yQi9pWUdoME1GU1FROU9ETi90cStCazRHSEtXWmJLMjlVOTRV?=
 =?utf-8?B?OWhkYkpjZ3RtZjljMndweldaWDJIUGd4RFJIdmQ2aXZYMFZMVHdnMEZaNi80?=
 =?utf-8?B?ZE56d05UZ3RVWHMxVkU2SHZNTzZUSmxNUDNoZDdLL0xrN2dhRVZRVmI4Q2xh?=
 =?utf-8?B?U2VYUE5yTnlRWStraDlIelJjajNjSUJUem9kZm5rTGFvY3BGVGdGdjFwd0tO?=
 =?utf-8?B?a2dvM29DWHFDdE5OZDhic0hvTEtqUC9MTmdBRzBUeEc2OXNDMGdRSVJ6aDNM?=
 =?utf-8?B?QXY3N0NTV3p5SEJ5MjhBSHh4OFNDUjY2QU9jdW9zOUJlWlVBNjhta0Zic1pJ?=
 =?utf-8?B?V1VheEZFajhPenJMWWp1V0RtVE9WUytOYS9Oa0QxY2c0NDVxYmlGdjhVNXY1?=
 =?utf-8?B?eEdGc0JDbU1TaTBnMVYrOVpqWi9uWTlNRFVzbWg5cFB3K1FTUlJCd3pZQUU3?=
 =?utf-8?B?T1FyNktGS1J6Q1lDNXJINE5jMkVJT2xPeU5XeUNXaWFmaExtZW1GU3BQTWla?=
 =?utf-8?B?ZDBKNUZNMWhId3ZzMHJCRjZKQnJqaENINlRxOHZ1Zmgvc1NocjNYMUdVcHY3?=
 =?utf-8?B?RnVMaERLd0NlU1RlUEZDVGh3VnFlY1krU3ViNEtqZVR5eGNhcmJRVjFLZFk4?=
 =?utf-8?B?cXozY1dvaEY2blRoZ2NpUnFvUUsyVTA3VnBXNDVISUJUTS9WM0VCVUVtSC8y?=
 =?utf-8?B?dURRWisvdlRKb05tL2NUVjBtWlUveFpkY3pwQTdRS2V5c3FNdTNsVHJDMVdw?=
 =?utf-8?B?cnJIWUphRFZyVjFMTEtROW5KQ1RaaFJrc2x5ZjBRRFNaRDF4UUlIZ2R5UERz?=
 =?utf-8?B?T2Vvd2sxcXY1R1lFZGRsTG10b040SytKRzJyaVRLL2RjZVZTTGlRUUlidDRZ?=
 =?utf-8?B?WDQ5NjFvYTQrNjY1bmU0MENCekJ3S3lkSVluM3hGSEluTldERGpvUG9yWFU2?=
 =?utf-8?B?clltREVHeVNDdVRpbHFvTDhEdFJuTDhSZU5yajVGTFB5eC9uaFVQQVZhb1JQ?=
 =?utf-8?B?Mmw4RUNPc3J4Y05HT3I2eW90aHZoYWx5YWJFWk9vMHlCRmhkYjNPbS9nZDJa?=
 =?utf-8?B?aEsyNXdXNkhPTlgrZkJ6VkE2eHlTTGg0UDExZWFtTWNxb3R3anJMOEdsUnUz?=
 =?utf-8?B?TnIvcnBPUjltb09kNmJMbWJGa3ZWZSt1NVkxeUpkUzcrdHltc1RNdkNJaFMy?=
 =?utf-8?B?Y2xhSm1XT09EUHVuaktKOG5hSWRBMjVJTGlyY1JJbUsxUVJ2WE8xZndsVFIx?=
 =?utf-8?B?NFR4N3cxZUNxODNUVnlaeEJBQ083aUhDMnpyYWJVUVRKTVRIbTBCeDJmV2s4?=
 =?utf-8?B?SzdEOFpqTzB2Tkl1dEZEcjcvb211ZXJIaFc0Wnp4aDBkZFU5TkI1Z3A4R0Jp?=
 =?utf-8?B?Z25Ba25NS2VnNW1FclNYaVdWQ1p2UVdJYWxuZERuWEFMYisrdTFmYUlYL0d4?=
 =?utf-8?B?TmdncFZsZ1B1RUhwc1V3Q2ZEbXY5eUh0cllNaHAxK3JjSlViS0MyYklBRnlk?=
 =?utf-8?B?UTN6MXdCZ000MlZwQWpNNUxyY0oxN3BxYjNxN3hMSVJXblIxNFJHandEZkZ6?=
 =?utf-8?B?QmVUNnJzMUNkY0pFbUpBRE1kcUVuSGVRODNrNWU2RXRWMExmVHFzTWxKQk1K?=
 =?utf-8?B?TlAxSFpiQWswY3BncXBmZTd5QzJ4ZllCUlhIQUhFNmdwT0t2NEJydHZGQ3Ez?=
 =?utf-8?B?WTlHeEs0eFdERUN6TDhlcGdOMGJjcVpVSHh2Rk8zZzF5ZVlXaU11TUpKdGlX?=
 =?utf-8?B?U1NiaWluZ24vNlUrZFpDOUFjYnhYaStNKzFyNmdjUDhCS3pwN0NEUms0dHRl?=
 =?utf-8?B?YURQd1lDTHMvaG1oZ01GaE9xWUtMUTNvNmZTZit4SWhYdWgyVUZNa0xmNXB1?=
 =?utf-8?B?MGlzb0ZaWm5IWGppamMxWURaWWt6cDVrTE4zeENvWGVvYzlHSVVsblJvL1l3?=
 =?utf-8?B?TUoweXZXZjM1bE5pYlZKWVNKM2k3VkFobkY4M3JQQXp2TnNlWkZrREdGS1lD?=
 =?utf-8?B?bHU5RE1GUU4vbEMvQ01ndE5Zdm5hMzF0NTdzMFR4STJ4aWUrYUQvWDgrS2lr?=
 =?utf-8?B?K3Jrbk8rd0w0UldNbE12ZllFK1ovamtjU0Q0anhKb2h1ZjlYYjhzUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c8f3cc3f-21eb-489b-d894-08da4db1f822
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 PuxYFHJvQK6wTduesr8iNQ+2l9A/JORRDRXpqgFSwKf9QOR0fILa0MHEsPZ4r2XypmGZD4ByMJYF5HInAiZTaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4075
X-ServerName: mail-eopbgr70084.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: kpFhV3F1h1g2dFgggxvIyFPSCR3gdxGi
X-Proofpoint-ORIG-GUID: kpFhV3F1h1g2dFgggxvIyFPSCR3gdxGi
Reporting-Meta:
 AAGKJl5yI7v25xDuD0FT0Pm7pAEVR0AvQL8uqKda0OePtXeL8mT7EAfuano0ENWf
 tDggFV41hK+Nt7H0Oqw3N0WF8EBtrMA5Hn6M9VnFBnA0Q4WqaLm5sCiXB5lKm0gE
 v6aGMYqvg7wYxKKNuQGxOruGxGdRpuy1vbMAG0KG11zr0qTrBXIbmvweWzVriB3T
 +L0NFrPo7ld+yHHggWM525i9D9KD6sf6m6UWHCdR7KoMG2wu+xIhyIwtOW9PzDvG
 /3vg2+2Wu0TbyKl77MOvYurIQ5JSS9osWEyPCA7vYJ6q+kKuNZoHidEG/H3S8P0F
 k6PhawUyIaEcCWXbpKHY9TecggpNRhEPVMKxsvkayUsTGnl150tF/QT1AqwXueWO
 uY5BEVSVWOhHPwp1bwrAR7RkB4zq8V7KmfJT7d7Ri3ld0iQvaqw97rZNVE+iyqdp
 mzk0Z5ioO5NC/+OvLdcWwfrVAk9XObIYQ6CNfA5nKy1D+G26Pu9wAeRYVl6oN7LH
 JrFi4lP07811E5YSpanNkeeQG7i6xztR3oZlOzm2e/4=

T24gNi8xMy8yMiAyMzo0MywgSnVueGlhbyBCaSB3cm90ZToKPiAKPj4g5ZyoIDIwMjLlubQ25pyI
MTPml6XvvIzkuIrljYgxOjQ477yMaGVtaW5nLnpoYW9Ac3VzZS5jb20g5YaZ6YGT77yaCj4+Cj4+
IO+7v09uIDYvMTMvMjIgMTY6MjEsIEpvc2VwaCBRaSB3cm90ZToKPj4+PiBPbiA2LzEzLzIyIDM6
NTkgUE0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdyb3RlOgo+Pj4+IE9uIDYvMTIvMjIgMjI6MTYs
IEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4gSGksCj4+Pj4+Cj4+Pj4+IFdoeSBjYW4ndCB1c2UgbG9j
YWwgbW91bnQ/IEkgZG9uJ3QgcmVtZW1iZXIgaWYgd2UgZGlzY3VzcyBhYm91dCB0aGlzLgo+Pj4+
Pgo+Pj4+IFNvcnJ5LCBJIGNhbid0IGZvbGxvdyB5b3VyIHF1ZXN0aW9uLgo+Pj4+IERvIHlvdSBt
ZWFuIHdoeSByZXZlcnQgY29tbWl0IDkxMmY2NTVkNzhjNT8KPj4+Pgo+Pj4+IG9yIHlvdSBhcmUg
aW50ZXJlc3Qgd2l0aCB0aGUgZmVhdHVyZSBsb2NhbCBtb3VudD8KPj4+PiB0aGUgbG9jYWwgbW91
bnQgaXMgY3JlYXRlZCBieSBta2ZzLm9jZnMyLCB3aGljaCBjYW4ndCBiZSBjb252ZXJ0ZWQgdG8g
Y2x1c3RlcmVkLgo+Pj4+IHNlZSBta2ZzLm9jZnMyKDgpICctTScgb3B0aW9uLgo+Pj4+Cj4+PiBX
aGF0IEp1bnhpYW8ncyBtYWluIGNvbmNlcm4gaXMgZGF0YSBjb3JydXB0aW9uLCBzbyBJJ20gYWZy
YWlkIHdlIGhhdmUgdG8KPj4+IGludHJvZHVjZSBhbiBvbmRpc2sgZmVhdHVyZSBiaXQgdG8gcHJl
dmVudCBtaXhlZCBub2NsdXN0ZXIgYW5kIGNsdXN0ZXIKPj4+IG1vdW50LCBzaW1pbGFyIHRvIGxv
Y2FsIG1vdW50Lgo+Pgo+PiB0aGlzIHBhdGNoIGRlZmluZWQgdHdvIG5ldyB2YXJpYW50cy9mbGFn
czoKPj4gI2RlZmluZSBPQ0ZTMl9TTE9UTUFQX0NMVVNURVIgICAxCj4+ICNkZWZpbmUgT0NGUzJf
U0xPVE1BUF9OT0NMVVNURVIgMgo+Pgo+PiAoSSBleHBlY3QpIFVuZGVyIE9DRlMyX1NMT1RNQVBf
Q0xVU1RFUiwgZm9yIGNsdXN0ZXJlZCBtb3VudCBtb2RlIGFuZCBmb3IgY29tcGF0aWJpbGl0eSwK
Pj4gYW55dGhpbmcgZG9lc24ndCBuZWVkIHRvIGJlIGNoYW5nZWQuCj4+Cj4+IE9DRlMyX1NMT1RN
QVBfTk9DTFVTVEVSIHdpbGwgaW50cm9kdWNlIGEgbmV3IHZhbHVlIGZvciBzbG90bWFwIGFyZWEu
Cj4+IHRoaXMgbmV3IHZhbHVlIG9ubHkgdGFrZSBlZmZlY3QgYWZ0ZXIgYSBzdWNjZXNzZnVsbHkg
bm9jbHVzdGVyIG1vdW50Lgo+PiAocGxzIGZpeCBtZSksIGV4aXN0ZWQga2VybmVsL3VzZXIgc3Bh
Y2UgY29kZSBkb24ndCBkbyBhbnkgc3BlY2lhbCBoYW5kbGUgZm9yCj4+IG5vY2x1c3RlcmVkIG1v
dW50IG1vZGUgaW4gc2xvdG1hcCBhcmVhLiBTbyB0aGUgbmV3IHZhbHVlIGlzIGFsc28gY29tcGF0
aWJpbGl0eS4KPj4KPj4gQW5kIHRoZSBwYXRjaCBjYW4gYWxzbyBwcmV2ZW50IG1peGVkIG1vdW50
LCB0aGUgcmVsYXRlZCBjb2RlIGlzIGluIG9jZnMyX2ZpbmRfc2xvdCgpLgo+PiBjb2RlIGxvZ2lj
Ogo+PiAtIG5vY2x1c3RlcmVkIG1vdW50IGNvbmRpdGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBh
bHJlYWR5IG1vdW50ZWQgd2l0aCBub2NsdXN0ZXJlZAo+PiAtIGNsdXN0ZXJlZCBtb3VudCBjb25k
aXRpb246IHNsb3RtYXAgaXMgZW1wdHkgb3IgYWxyZWFkeSBtb3VudGVkIHdpdGggY2x1c3RlcmVk
Lgo+PiAtIGFsbCBvdGhlciBjb25kaXRpb25zIHdpbGwgYmUgZGVuaWVkLgo+IEZpbmRpbmcgc2xv
dCByZXF1aXJlZCByZWFkaW5nIHNsb3QgbWFwIGFuZCB0aGVuICB1cGRhdGUgc2xvdCBtYXAuIEl0
IGlzIG5vdCBhdG9taWMgLCB5b3UgY2Fu4oCZdCBwcmV2ZW50IG1peGVkIG1vdW50IHVudGlsIHlv
dSBoYXZlIGEgY2x1c3RlciBsb2NrLgoKQ291bGQgSSBzYXkgeW91ciBtZW50aW9uZWQgdXNlIGNh
c2UgaXMgaW52YWxpZC4KSSBiZWxpZXZlIGFsbCAoeWVzLCAqYWxsKikgdGhlIG9jZnMyIHVzZXJz
IHVzZSB0aGlzIGZzIHVuZGVyIGNsdXN0ZXIgbW9kZSBpbgp0aGVpciBwcm9kdWN0IGVudi4KVGhl
IG5vY2x1c3RlciBtb3VudCBpcyBvbmx5IHVzZWQgb24gbWFpbnRhaW5lZCBlbnYgKGVnLiBiYWNr
dXAsIGZzY2spLgoKV2Ugb25seSBjb25jZXJuIHR3byB3YXlzOgoxLiB1c2VyIGZvcmdldHMgdG8g
dW5tb3VudCAoZWcgY3Jhc2gpIGJlZm9yZSB1c2luZyBhbm90aGVyIG1vdW50IG1vZGUuCjIuIHdo
ZW4gb2NmczIgdm9sdW1lIGlzIHdvcmtpbmcsIHdoaWNoIHNob3VsZCBkZW55IHZvbHVtZSBpcyBt
b3VudGVkIGJ5IGFub3RoZXIgbW9kZS4KICAgIHRoaXMgbWF5IGhhcHBlbmVkIHVzZXIgbWlzdGFr
ZW5seSBydW5zIGNvbW1hbmQgb3Igc2NyaXB0LgoKQmFzZSBvbiBhYm92ZSAxICYgMiwgSnVueGlh
byBhYm92ZSBtZW50aW9uZWQgdXNlIGNhc2Ugb25seSBoYXBwZW5zIG9uIG9uZSBzY2VuYXJpbzoK
dGhlIHZvbHVtZSBkb2Vzbid0IGJlIG1vdW50ZWQgYnkgYW55IG5vZGUsIHRoZW4gdXNlciBtaXN0
YWtlbmx5IG1vdW50cyB2b2x1bWUKd2l0aCBbbm9dY2x1c3RlciBtb2RlIGF0IHNhbWUgdGltZS4g
SSBiZWxpZXZlIHRoaXMgdXNlIGNhc2UgaXMgaW52YWxpZC4gQW5kIEkgZ3Vlc3MKZ2ZzMiBtYXkg
YWxzbyBoYXMgdGhlIHNhbWUgaXNzdWUuCgpXaXRoIHRoaXMgcGF0Y2gsIG9jZnMyIGhhcyBtb3Jl
IHNhbml0eSBjaGVjayBhYmlsaXR5IHRoYW4gb3RoZXIgZnMsIGVnOiB4ZnMsIGV4dDQuClNVU0Ug
SEEgc3RhY2sgd2l0aCBjb3Jvc3luYytwYWNlbWFrZXIgYWxzbyBzdXBwb3J0cyBydW5uaW5nIHhm
cy9leHQ0IHdpdGggQS9QIG1vZGUuClRoZSB4ZnMvZXh0NCBuZXZlciBoYXZlIGRldGVjdGluZyBt
b3VudCBzdGF0dXMgY29kZSwgSnVueGlhbyBtZW50aW9uZWQgbWl4ZWQgbW91bnQKY2FuIGFsc28g
aGFwcGVucyBvbiB0aGVzZSBmcy4gSG93IGRvIHhmcy9leHQ0L0hBIG1haW50YWluZXJzIGhhbmRs
ZSBpdD8gVW5kZXIgdGhlc2UKZnMgbW91bnRpbmcgYmVoYXZpb3IsIHRoZXNlIGZpZWxkcyBtYWlu
dGFpbmVycyBhbHNvIHRyZWF0IHRoZSBtaXhlZCBtb3VudCBhcwppbnZhbGlkIHVzZSBjYXNlIGFu
ZCBpZ25vcmUgaGFuZGxlIGl0LgoKL0hlbWluZwoKPj4KPj4+IEFub3RoZXIgc2NlbmFyaW8gaXMg
am91cm5hbCByZXBsYXkgYWZ0ZXIgY3Jhc2guCj4+Cj4+IHRoaXMgcGF0Y2ggc2V0IGEgcnVsZToK
Pj4gSWYgbGFzdCBtb3VudCBkaWRuJ3QgZG8gdW1vdW50LCAoZWc6IGNyYXNoIGhhcHBlbmVkKSwg
dGhlIG5leHQgbW91bnQgTVVTVCBiZSBzYW1lIG1vdW50IHR5cGUuCj4+IChwbGVhc2UgYWxzbyBj
aGVjayBhYm92ZSBsaW5lcyBvZiAnY29kZSBsb2dpYycuKQo+Pgo+PiBJbiBteSB2aWV3LCB0aGlz
IHJ1bGUgaXMgZW5vdWdoIHRvIGhhbmRsZSBjcmFzaCBzY2VuYXJpby4KPj4gU28gbXkgcGF0Y2gg
c2hvdWxkIGJlIHBvbGlzaGVkIGluIHNvbWV3aGVyZSwgYnV0IGl0IGlzIHdvcmthYmxlLgo+Pgo+
PiBUaGFua3MsCj4+IEhlbWluZwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3Jh
Y2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2
ZWw=
